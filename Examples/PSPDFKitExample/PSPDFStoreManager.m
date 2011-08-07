//
//  PSPDFStoreManager.m
//  PSPDFKitExample
//
//  Created by Peter Steinberger on 8/7/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import "PSPDFStoreManager.h"
#import "PSPDFMagazine.h"
#import "PSPDFMagazineFolder.h"
#import "PSPDFDownload.h"
#import "AppDelegate.h"
#import "NSObject+BlockObservation.h"
#import "NSObject+AssociatedObjects.h"

@interface PSPDFStoreManager()
@property (nonatomic, retain) NSMutableArray *magazines;
@property (nonatomic, retain) NSMutableArray *magazineFolders;
@property (nonatomic, retain) NSMutableArray *downloadQueue;
@end

@implementation PSPDFStoreManager

@synthesize magazines = magazines_;
@synthesize magazineFolders = magazineFolders_;
@synthesize downloadQueue = downloadQueue_;
@synthesize delegate = delegate_;

SYNTHESIZE_SINGLETON_FOR_CLASS(PSPDFStoreManager);

static char kvoToken; // we need a static address for the kvo token

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private - Folder Search

// helper for folder search
- (NSMutableArray *)searchFolder:(NSString *)sampleFolder {
    NSError *error = nil;
    NSArray *documentContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:sampleFolder error:&error];
    NSMutableArray *folders = [NSMutableArray array];
    PSPDFMagazineFolder *rootFolder = [PSPDFMagazineFolder folderWithTitle:[[NSURL fileURLWithPath:sampleFolder] lastPathComponent]];
    
    for (NSString *folder in documentContents) {
        // check if target path is a directory (all magazines are in directories)
        NSString *fullPath = [sampleFolder stringByAppendingPathComponent:folder];
        BOOL isDir;
        if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDir]) {
            if (isDir) {
                PSPDFMagazineFolder *contentFolder = [PSPDFMagazineFolder folderWithTitle:[fullPath lastPathComponent]];
                NSArray *subDocumentContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folder error:&error];
                for (NSString *folder in subDocumentContents) {
                    PSPDFMagazine *magazine = [PSPDFMagazine magazineWithPath:fullPath];
                    [contentFolder addMagazine:magazine];
                }

                if ([contentFolder.magazines count]) {
                    [folders addObject:contentFolder];
                }
            }else {
                PSPDFMagazine *magazine = [PSPDFMagazine magazineWithPath:fullPath];
                [rootFolder addMagazine:magazine];
            }
        }
    }
    if ([rootFolder.magazines count]) {
        [folders addObject:rootFolder];
    }
    
    return folders;
}

// doesn't support deep hierarchies. Just root or a folder
- (NSMutableArray *)searchForMagazineFolders {
    NSMutableArray *folders = [NSMutableArray array];
    
    NSString *sampleFolder = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Samples"];
    [folders addObjectsFromArray:[self searchFolder:sampleFolder]];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);    
    NSString *dirPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"downloads"];
    [folders addObjectsFromArray:[self searchFolder:dirPath]];
        
    return folders;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

// add a magazine to folder, then re-sort it
- (PSPDFMagazineFolder *)addMagazineToFolder:(PSPDFMagazine *)magazine {
    PSPDFMagazineFolder *folder = nil;
    for (PSPDFMagazineFolder *aFolder in self.magazineFolders) {
        if ([aFolder.title isEqualToString:magazine.title]) {
            [aFolder addMagazine:magazine];
            folder = aFolder;
            break;
        }
    }
    
    if (!folder) {
        folder = [PSPDFMagazineFolder folderWithTitle:magazine.title];
        [folder addMagazine:magazine];
        NSAssert([folder isKindOfClass:[PSPDFMagazineFolder class]], @"incorrect type");
        [magazineFolders_ addObject:folder];
        [magazineFolders_ sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]]];
    }
    
    return folder;
}

// load magazines from disk
- (void)loadMagazinesFromDisk {
    self.magazineFolders = [self searchForMagazineFolders];
}

// forward memory warning to magazines
- (void)didReceiveMemoryWarning {
    PSELog(@"memory warning");
    [magazines_ makeObjectsPerformSelector:@selector(clearCache)];
}

- (void)finishDownload:(PSPDFDownload *)storeDownload {
    [storeDownload removeObserverWithBlockToken:[storeDownload associatedValueForKey:&kvoToken]];
    [downloadQueue_ removeObject:storeDownload];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSObject

- (id)init {
    if ((self = [super init])) {
        downloadQueue_ = [[NSMutableArray alloc] init];
        magazines_ = [[NSMutableArray alloc] init];
        magazineFolders_ = [[NSMutableArray alloc] init];
        
        // register for memory notifications
        NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
        [dnc addObserver:self selector:@selector(didReceiveMemoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        
        // load magazines from disk
        [self loadMagazinesFromDisk];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    delegate_ = nil;
    [magazines_ release];
    [magazineFolders_ release];
    [downloadQueue_ release];
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

- (void)deleteMagazineFolder:(PSPDFMagazineFolder *)magazineFolder {
    [delegate_ magazineStoreBeginUpdate];
    
    for (PSPDFMagazine *magazine in magazineFolder.magazines) {
        [delegate_ magazineStoreMagazineDeleted:magazine];
        
        // cancel eventual download!
        if (magazine.isDownloading) {
            PSPDFDownload *downloadObject = [self downloadObjectForMagazine:magazine];
            [downloadObject cancelDownload];
        }
        
        [[PSPDFCache sharedPSPDFCache] removeCacheForDocument:magazine deleteDocument:YES];
        [magazines_ removeObject:magazine];
    }
    
    [delegate_ magazineStoreFolderDeleted:magazineFolder];  
    [magazineFolders_ removeObject:magazineFolder];
    
    [delegate_ magazineStoreEndUpdate];  
}

- (void)deleteMagazine:(PSPDFMagazine *)magazine {
    [delegate_ magazineStoreBeginUpdate];
    
    // first notify, then delete from the backing store
    [delegate_ magazineStoreMagazineDeleted:magazine];
    PSPDFMagazineFolder *folder = magazine.folder;
    if ([folder.magazines count] == 1) {
        [delegate_ magazineStoreFolderDeleted:folder];
    }
    
    // cancel eventual download!
    if (magazine.isDownloading) {
        PSPDFDownload *downloadObject = [self downloadObjectForMagazine:magazine];
        [downloadObject cancelDownload];
    }
    
    // clear everything
    [[PSPDFCache sharedPSPDFCache] removeCacheForDocument:magazine deleteDocument:YES];
    [magazines_ removeObject:magazine];
    [folder removeMagazine:magazine];
    
    if([folder.magazines count] > 0) {
        [delegate_ magazineStoreFolderModified:folder]; // was just modified
    }else {
        [magazineFolders_ removeObject:folder]; // remove!
    }
    
    [delegate_ magazineStoreEndUpdate];
}

- (void)downloadMagazineWithUrl:(NSURL *)url; {
    PSPDFDownload *storeDownload = [PSPDFDownload PDFDownloadWithURL:url];
    
    // use kvo to track status
    AMBlockToken *token = [storeDownload addObserverForKeyPath:@"status" task:^(id obj, NSDictionary *change) {
        if (storeDownload.status == PSPDFStoreDownloadFinished) {
            [self finishDownload:storeDownload];
            
            [[[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Download for %@ finished!", storeDownload.magazine.title]
                                         message:nil
                                        delegate:nil
                               cancelButtonTitle:NSLocalizedString(@"OK", @"")
                               otherButtonTitles:nil] autorelease] show];
            
        }else if (storeDownload.status == PSPDFStoreDownloadFailed) {
            if (!storeDownload.isCancelled) {
                NSString *magazineTitle = [storeDownload.magazine.title length] ? storeDownload.magazine.title : NSLocalizedString(@"Magazine", @"");
                NSString *message = [NSString stringWithFormat:NSLocalizedString(@"%@ could not be downloaded. Please try again.", @""), magazineTitle];
                
                NSString *messageWithError = message;
                if (storeDownload.error) {
                    messageWithError = [NSString stringWithFormat:@"%@\n(%@)", message, [storeDownload.error localizedDescription]];
                }
                
                [[[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Warning"]
                                             message:messageWithError
                                            delegate:nil
                                   cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                   otherButtonTitles:nil] autorelease] show];
                
            }
            [self finishDownload:storeDownload];
            
            // delete unfinished magazine
            [self deleteMagazine:storeDownload.magazine];
        }
    }];
    
    [storeDownload associateValue:token withKey:&kvoToken];
    [downloadQueue_ addObject:storeDownload];  
    [storeDownload startDownload];
}

- (void)downloadLoadedData:(PSPDFDownload *)storeDownload {
    PSPDFMagazine *magazine = storeDownload.magazine;
    [self.magazines addObject:magazine]; // add magazine to store!
    PSPDFMagazineFolder *folder = [self addMagazineToFolder:magazine];
    
    [delegate_ magazineStoreBeginUpdate];
    
    // folder fresh or updated?
    if ([folder.magazines count] == 1) {
        [delegate_ magazineStoreFolderAdded:folder];
    }else {
        [delegate_ magazineStoreFolderModified:folder]; 
    }
    
    [delegate_ magazineStoreMagazineAdded:magazine];    
    [delegate_ magazineStoreEndUpdate];
}

- (PSPDFDownload *)downloadObjectForMagazine:(PSPDFMagazine *)magazine; {
    for (PSPDFDownload *aDownload in downloadQueue_) {
        if(aDownload.magazine == magazine) {
            return aDownload;
        }
    }
    return nil;
}

@end
