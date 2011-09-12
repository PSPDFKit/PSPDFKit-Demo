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
#import "NSOperationQueue+CWSharedQueue.h"
#import "AFJSONRequestOperation.h"

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

- (dispatch_queue_t)magazineFolderQueue {
    static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		magazineFolderQueue_ = dispatch_queue_create("com.pspdfkit.store.magazineFolderQueue", NULL);
	});
	return magazineFolderQueue_;
}

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
                for (NSString *afolder in subDocumentContents) {
                    if ([afolder hasSuffix:@"pdf"]) {
                        PSPDFMagazine *magazine = [PSPDFMagazine magazineWithPath:[folder stringByAppendingPathComponent:afolder]];
                        [contentFolder addMagazine:magazine];
                    }
                }
                
                if ([contentFolder.magazines count]) {
                    [folders addObject:contentFolder];
                }
            }else if([fullPath hasSuffix:@"pdf"]) {
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
    
    // flatten hierarchy
    if (kPSPDFStoreManagerPlain) {
        NSMutableArray *foldersCopy = [[folders mutableCopy] autorelease];
        PSPDFMagazineFolder *firstFolder = [foldersCopy objectAtIndex:0];
        [foldersCopy removeObject:firstFolder];
        NSMutableArray *magazineArray = [[firstFolder.magazines mutableCopy] autorelease];
        
        for (PSPDFMagazineFolder *folder in foldersCopy) {
            [magazineArray addObjectsFromArray:folder.magazines];
            [folders removeObject:folder];
        }
        
        firstFolder.magazines = magazineArray;
    }
    
    return folders;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

// add a magazine to folder, then re-sort it
- (PSPDFMagazineFolder *)addMagazineToFolder:(PSPDFMagazine *)magazine {
    PSPDFMagazineFolder *folder = [self.magazineFolders lastObject];
    
    [folder addMagazine:magazine];
    NSAssert([folder isKindOfClass:[PSPDFMagazineFolder class]], @"incorrect type");
    dispatch_sync_reentrant([self magazineFolderQueue], ^{
        [magazineFolders_ addObject:folder];
        [magazineFolders_ sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]]];
    });
    
    return folder;
}

- (PSPDFMagazine *)magazineForUid:(NSString *)uid {
    for (PSPDFMagazineFolder *folder in self.magazineFolders) {
        for (PSPDFMagazine *magazine in folder.magazines) {
            if ([magazine.uid isEqualToString:uid]) {
                return magazine;
            }
        }
    }
    
    return nil;
}



- (void)loadMagazinesAvailableFromWeb {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:kPSPDFMagazineJSONURL]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation operationWithRequest:request success:^(id JSON) {
        NSArray *dlMagazines = (NSArray *)JSON;
        NSMutableArray *newMagazines = [NSMutableArray array];
        for (NSDictionary *dlMagazine in dlMagazines) {
            if (![dlMagazine isKindOfClass:[NSDictionary class]]) {
                PSPDFLogError(@"Error while parsing magazine JSON!");
            }else {
                // create and fill PSPDFMagazine
                NSString *title = [dlMagazine objectForKey:@"name"];
                NSString *urlString = [dlMagazine objectForKey:@"url"];
                NSString *imageUrlString = [dlMagazine objectForKey:@"image"];
                NSString *uid = [urlString lastPathComponent]; // we use fileName as uid - be sure to make it unique!
                
                PSPDFMagazine *magazine = [self magazineForUid:uid];
                if (!magazine) {
                    // no magazine found on-disk, create new container
                    magazine = [PSPDFMagazine magazineWithPath:nil];                
                    magazine.available = NO; // not yet available
                    [newMagazines addObject:magazine];
                }
                magazine.title = title;
                magazine.url = [urlString length] ? [NSURL URLWithString:urlString] : nil;
                magazine.imageUrl = [imageUrlString length] ? [NSURL URLWithString:imageUrlString] : nil;
                magazine.uid = uid;
            }
        }
        [self addMagazinesToStore:newMagazines];
    }];
    
    [[NSOperationQueue sharedOperationQueue] addOperation:operation];
}

// load magazines from disk
- (void)loadMagazinesFromDisk {
    NSMutableArray *magazineFolders = [self searchForMagazineFolders];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        dispatch_sync([self magazineFolderQueue], ^{
            self.magazineFolders = magazineFolders;
            [[NSNotificationCenter defaultCenter] postNotificationName:kPSPDFStoreDiskLoadFinishedNotification object:magazineFolders];
            
            // now start web-request
            [self loadMagazinesAvailableFromWeb];
        });
    });
}

- (NSMutableArray *)magazineFolders {
    __block NSMutableArray *magazineFolders;
    dispatch_sync_reentrant([self magazineFolderQueue], ^{
        magazineFolders = [[magazineFolders_ retain] autorelease];
    });
    
    return magazineFolders;
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
        
        // register for memory notifications
        NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
        [dnc addObserver:self selector:@selector(didReceiveMemoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        
        // load magazines from disk async
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [self loadMagazinesFromDisk];
        });
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    delegate_ = nil;
    dispatch_release(magazineFolderQueue_);
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
    dispatch_sync_reentrant([self magazineFolderQueue], ^{
        [magazineFolders_ removeObject:magazineFolder];
    });
    
    [delegate_ magazineStoreEndUpdate];  
}

- (void)deleteMagazine:(PSPDFMagazine *)magazine {
    [delegate_ magazineStoreBeginUpdate];

    PSPDFMagazineFolder *folder = magazine.folder;
    
    // first notify, then delete from the backing store
    if (!magazine.url) {
        [delegate_ magazineStoreMagazineDeleted:magazine];

        if ([folder.magazines count] == 1) {
            [delegate_ magazineStoreFolderDeleted:folder];
        }
    }
    
    // cancel eventual download!
    if (magazine.isDownloading) {
        PSPDFDownload *downloadObject = [self downloadObjectForMagazine:magazine];
        [downloadObject cancelDownload];
    }
    
    // clear everything
    [[PSPDFCache sharedPSPDFCache] removeCacheForDocument:magazine deleteDocument:YES];

    // if magazine has no url - delete
    if (!magazine.url) {
        [magazines_ removeObject:magazine];
        [folder removeMagazine:magazine];
        
        if([folder.magazines count] > 0) {
            [delegate_ magazineStoreFolderModified:folder]; // was just modified
        }else {
            dispatch_sync_reentrant([self magazineFolderQueue], ^{
                [magazineFolders_ removeObject:folder]; // remove!
            });
        }
    }else {
        // just set availability to now - needs redownloading!
        magazine.available = NO;
        [delegate_ magazineStoreMagazineModified:magazine];
    }
    
    [delegate_ magazineStoreEndUpdate];
}

- (void)downloadMagazine:(PSPDFMagazine *)magazine; {
    PSPDFDownload *storeDownload = [PSPDFDownload PDFDownloadWithURL:magazine.url];
    storeDownload.magazine = magazine;
    
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
            //[self deleteMagazine:storeDownload.magazine];
        }
    }];
    
    [storeDownload associateValue:token withKey:&kvoToken];
    [downloadQueue_ addObject:storeDownload];  
    [storeDownload startDownload];
    magazine.downloading = YES;
}

- (void)addMagazinesToStore:(NSArray *)magazines {
    
    // filter out magazines that are already in array
    NSMutableArray *newMagazines = [NSMutableArray array];
    for (PSPDFMagazine *newMagazine in magazines) {
        NSArray *newMagazineArray = [self.magazines filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self == %@", newMagazine]];
        if ([newMagazineArray count] == 0) {
            [newMagazines addObject:newMagazine];
        }        
    }    
    
    if ([newMagazines count] > 0) {
        [delegate_ magazineStoreBeginUpdate];
        
        for (PSPDFMagazine *magazine in magazines) {
            [self.magazines addObject:magazine]; // add magazine to store!
            PSPDFMagazineFolder *folder = [self addMagazineToFolder:magazine];
            
            
            // folder fresh or updated?
            if ([folder.magazines count] == 1) {
                [delegate_ magazineStoreFolderAdded:folder];
            }else {
                [delegate_ magazineStoreFolderModified:folder]; 
            }
            
            [delegate_ magazineStoreMagazineAdded:magazine];    
        }
        
        [delegate_ magazineStoreEndUpdate];
    }
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
