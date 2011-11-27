//
//  PSPDFStoreManager.m
//  PSPDFKitExample
//
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
@property (nonatomic, strong) NSMutableArray *magazineFolders;
@property (nonatomic, strong) NSMutableArray *downloadQueue;
- (void)updateNewsstandIcon:(PSPDFMagazine *)magazine;
@end

@implementation PSPDFStoreManager

@synthesize magazineFolders = magazineFolders_;
@synthesize downloadQueue = downloadQueue_;
@synthesize delegate = delegate_;

static char kvoToken; // we need a static address for the kvo token

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - static

+ (id)sharedPSPDFStoreManager {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private 

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
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSArray *documentContents = [fileManager contentsOfDirectoryAtPath:sampleFolder error:&error];
    NSMutableArray *folders = [NSMutableArray array];
    PSPDFMagazineFolder *rootFolder = [PSPDFMagazineFolder folderWithTitle:[[NSURL fileURLWithPath:sampleFolder] lastPathComponent]];
    
    for (NSString *folder in documentContents) {
        // check if target path is a directory (all magazines are in directories)
        NSString *fullPath = [sampleFolder stringByAppendingPathComponent:folder];
        BOOL isDir;
        if ([fileManager fileExistsAtPath:fullPath isDirectory:&isDir]) {
            if (isDir) {
                PSPDFMagazineFolder *contentFolder = [PSPDFMagazineFolder folderWithTitle:[fullPath lastPathComponent]];
                NSArray *subDocumentContents = [fileManager contentsOfDirectoryAtPath:folder error:&error];
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
        // if we don't have any folders, create one
        if ([folders count] == 0) {
            PSPDFMagazineFolder *aFolder = [PSPDFMagazineFolder folderWithTitle:@""];
            [folders addObject:aFolder];
        }

        NSMutableArray *foldersCopy = [folders mutableCopy];
        PSPDFMagazineFolder *firstFolder = [foldersCopy objectAtIndex:0];
        [foldersCopy removeObject:firstFolder];
        NSMutableArray *magazineArray = [firstFolder.magazines mutableCopy];
        
        for (PSPDFMagazineFolder *folder in foldersCopy) {
            [magazineArray addObjectsFromArray:folder.magazines];
            [folders removeObject:folder];
        }
        
        firstFolder.magazines = magazineArray;
    }
    
    return folders;
}

// add a magazine to folder, then re-sort it
- (PSPDFMagazineFolder *)addMagazineToFolder:(PSPDFMagazine *)magazine {
    PSPDFMagazineFolder *folder = [self.magazineFolders lastObject];
    [folder addMagazine:magazine];
    NSAssert([folder isKindOfClass:[PSPDFMagazineFolder class]], @"incorrect type");
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
    NSURLRequest *loadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:kPSPDFMagazineJSONURL]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:loadRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSArray *dlMagazines = (NSArray *)JSON;
        NSMutableArray *newMagazines = [NSMutableArray array];
        for (NSDictionary *dlMagazine in dlMagazines) {
            if (![dlMagazine isKindOfClass:[NSDictionary class]]) {
                PSELog(@"Error while parsing magazine JSON - Dictionary expected. Got this instead: %@", dlMagazine);
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
                    magazine.uid = uid;
                    [newMagazines addObject:magazine];
                }
                
                // TODO: this is not optimal. The title from used in the web is saved nowhere.
                // After a restart, the title within the pdf document's metadata is used, or if no title set there, the filename.
                magazine.title = title;
                magazine.url = [urlString length] ? [NSURL URLWithString:urlString] : nil;
                magazine.imageUrl = [imageUrlString length] ? [NSURL URLWithString:imageUrlString] : nil;
            }
        }
        [self addMagazinesToStore:newMagazines];
    } failure:nil];
    
    [[NSOperationQueue sharedOperationQueue] addOperation:operation];
}

// load magazines from disk
- (void)loadMagazinesFromDisk {
    NSMutableArray *magazineFolders = [self searchForMagazineFolders];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        dispatch_sync([self magazineFolderQueue], ^{
            self.magazineFolders = magazineFolders;
            [[NSNotificationCenter defaultCenter] postNotificationName:kPSPDFStoreDiskLoadFinishedNotification object:magazineFolders];
            
            // ensure we have thumbnails for all magazines (else they would be lazy-loaded)
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                for (PSPDFMagazineFolder *folder in magazineFolders) {
                    for (PSPDFMagazine *magazine in folder.magazines) {
                        [[PSPDFCache sharedPSPDFCache] cachedImageForDocument:magazine page:0 size:PSPDFSizeThumbnail];
                    }
                }
            });
            
            // now start web-request
            [self loadMagazinesAvailableFromWeb];
        });
    });
}

- (NSMutableArray *)magazineFolders {
    __block NSMutableArray *magazineFolders;
    dispatch_sync_reentrant([self magazineFolderQueue], ^{
        magazineFolders = magazineFolders_;
    });
    
    return magazineFolders;
}

// forward memory warning to magazines
- (void)didReceiveMemoryWarning {
    PSELog(@"memory warning");
    for (PSPDFMagazineFolder *folder in self.magazineFolders) {
        [folder.magazines makeObjectsPerformSelector:@selector(clearCache)];
    }
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
    }
    
    [delegate_ magazineStoreFolderDeleted:magazineFolder];
    dispatch_sync_reentrant([self magazineFolderQueue], ^{
        [magazineFolders_ removeObject:magazineFolder];
    });
    
    [delegate_ magazineStoreEndUpdate];  
    
    // ensure set icon is not deleted
    [self updateNewsstandIcon:nil];
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
    
    // ensure set icon is not deleted
    [self updateNewsstandIcon:nil];
}

- (void)downloadMagazine:(PSPDFMagazine *)magazine; {
    PSPDFDownload *storeDownload = [PSPDFDownload PDFDownloadWithURL:magazine.url];
    storeDownload.magazine = magazine;
    
    // use kvo to track status
    __ps_weak PSPDFDownload *storeDownloadWeak = storeDownload;
    AMBlockToken *token = [storeDownload addObserverForKeyPath:@"status" task:^(id obj, NSDictionary *change) {
        if (storeDownloadWeak.status == PSPDFStoreDownloadFinished) {
            [self finishDownload:storeDownloadWeak];
            
            [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:PSPDFLocalize(@"Download for %@ finished!"), storeDownloadWeak.magazine.title]
                                         message:nil
                                        delegate:nil
                               cancelButtonTitle:PSPDFLocalize(@"OK")
                               otherButtonTitles:nil] show];
            
        }else if (storeDownloadWeak.status == PSPDFStoreDownloadFailed) {
            if (!storeDownloadWeak.isCancelled) {
                NSString *magazineTitle = [storeDownloadWeak.magazine.title length] ? storeDownloadWeak.magazine.title : NSLocalizedString(@"Magazine", @"");
                NSString *message = [NSString stringWithFormat:PSPDFLocalize(@"%@ could not be downloaded. Please try again."), magazineTitle];
                
                NSString *messageWithError = message;
                if (storeDownloadWeak.error) {
                    messageWithError = [NSString stringWithFormat:@"%@\n(%@)", message, [storeDownloadWeak.error localizedDescription]];
                }
                
                [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:PSPDFLocalize(@"Warning")]
                                             message:messageWithError
                                            delegate:nil
                                   cancelButtonTitle:PSPDFLocalize(@"OK")
                                   otherButtonTitles:nil] show];
                
            }
            [self finishDownload:storeDownloadWeak];
            
            // delete unfinished magazine
            //[self deleteMagazine:storeDownload.magazine];
        }
    }];
    
    [storeDownload associateValue:token withKey:&kvoToken];
    [downloadQueue_ addObject:storeDownload];  
    [storeDownload startDownload];
    magazine.downloading = YES;
}

#define kNewsstandIconUID @"kNewsstandIconUID"
- (void)updateNewsstandIcon:(PSPDFMagazine *)magazine {
    
    // if no magazine is given, find the current
    if (!magazine) {
        NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:kNewsstandIconUID];
        if (uid) {
            magazine = [self magazineForUid:uid];
        }
        
        // if magazine doesn't exist anymore, choose the first magazine in the list
        if (!magazine && [self.magazineFolders count]) {
            magazine = [[self.magazineFolders objectAtIndex:0] firstMagazine];
        }
    }
    
    // set new icon for newsstand, if newsstand exists
    if (NSClassFromString(@"NKLibrary") != nil) {
        UIImage *newsstandCoverImage = nil;
        
        // if magazine or coverImage don't exist, the default newsstand icon is used (with sending nil)
        if (magazine.coverImage) {
            
            // example how to create blended cover + overlay
            /*
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(362, 512), YES, 0.0);
            [magazine.coverImage drawInRect:CGRectMake(0, 0, 362, 512)];
            [[UIImage imageNamed:@"newsstand-template"] drawAtPoint:CGPointMake(0, 0)];
            newsstandCoverImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
             */
            newsstandCoverImage = magazine.coverImage;
        }
        
        [[UIApplication sharedApplication] setNewsstandIconImage:newsstandCoverImage];
        
        // update user defaults
        if (magazine.uid) {
            [[NSUserDefaults standardUserDefaults] setObject:magazine.uid forKey:kNewsstandIconUID];
        }else {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kNewsstandIconUID];
        }
    } 
}

- (void)addMagazinesToStore:(NSArray *)magazines {
    
    // filter out magazines that are already in array
    NSMutableArray *newMagazines = [NSMutableArray arrayWithArray:magazines];
    for (PSPDFMagazine *newMagazine in magazines) {
        for (PSPDFMagazineFolder *folder in self.magazineFolders) {
            NSArray *foundMagazines = [folder.magazines filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.uid == %@", newMagazine.uid]];
            [newMagazines removeObjectsInArray:foundMagazines];
        }
    }
    
    if ([newMagazines count] > 0) {
        [delegate_ magazineStoreBeginUpdate];
        
        for (PSPDFMagazine *magazine in magazines) {
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
        
        // update newsstand icon
        [self updateNewsstandIcon:[newMagazines lastObject]];
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
