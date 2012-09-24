//
//  PSPDFStoreManager.m
//  PSPDFCatalog
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import "PSCStoreManager.h"
#import "PSCMagazine.h"
#import "PSCMagazineFolder.h"
#import "PSCDownload.h"
#import "NSObject+BlockObservation.h"
#import "AFJSONRequestOperation.h"
#include <sys/xattr.h>
#include <objc/runtime.h>

#if !__has_feature(objc_arc)
#error "Compile this file with ARC"
#endif

@interface PSCStoreManager()
@property (nonatomic, strong) NSMutableArray *magazineFolders;
@property (nonatomic, strong) NSMutableArray *downloadQueue;
- (void)updateNewsstandIcon:(PSCMagazine *)magazine;
@end

@implementation PSCStoreManager

static char kvoToken; // we need a static address for the kvo token

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Static

+ (id)sharedStoreManager {
    static dispatch_once_t pred = 0;
    __strong static PSCStoreManager *_sharedStoreManager = nil;
    dispatch_once(&pred, ^{
        _sharedStoreManager = [self new];

        // allow plain text in JSON downloader class, fixes servers that don't know about JSON.
        [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/plain"]];
    });
    return _sharedStoreManager;
}

+ (NSOperationQueue *)sharedOperationQueue {
    static __strong NSOperationQueue *_sharedOperationQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedOperationQueue = [NSOperationQueue new];
        [_sharedOperationQueue setMaxConcurrentOperationCount:2];
    });
    return _sharedOperationQueue;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private 

// helper for folder search
- (NSMutableArray *)searchFolder:(NSString *)sampleFolder {
    NSError *error = nil;
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSArray *documentContents = [fileManager contentsOfDirectoryAtPath:sampleFolder error:&error];
    NSMutableArray *folders = [NSMutableArray array];
    PSCMagazineFolder *rootFolder = [PSCMagazineFolder folderWithTitle:[[NSURL fileURLWithPath:sampleFolder] lastPathComponent]];
    
    for (NSString *folder in documentContents) {
        // check if target path is a directory (all magazines are in directories)
        NSString *fullPath = [sampleFolder stringByAppendingPathComponent:folder];
        BOOL isDir;
        if ([fileManager fileExistsAtPath:fullPath isDirectory:&isDir]) {
            if (isDir) {
                PSCMagazineFolder *contentFolder = [PSCMagazineFolder folderWithTitle:[fullPath lastPathComponent]];
                NSArray *subDocumentContents = [fileManager contentsOfDirectoryAtPath:fullPath error:&error];
                for (NSString *afolder in subDocumentContents) {
                    if ([[afolder lowercaseString] hasSuffix:@"pdf"]) {
                        PSCMagazine *magazine = [PSCMagazine magazineWithPath:[fullPath stringByAppendingPathComponent:afolder]];
                        [contentFolder addMagazine:magazine];
                    }
                }
                
                if ([contentFolder.magazines count]) {
                    [folders addObject:contentFolder];
                }
            }else if([[fullPath lowercaseString] hasSuffix:@"pdf"]) {
                @autoreleasepool {
                    PSCMagazine *magazine = [PSCMagazine magazineWithPath:fullPath];
                    [rootFolder addMagazine:magazine];
                }
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
    
    NSString *dirPath = [[PSCStoreManager storagePath] stringByAppendingPathComponent:@"downloads"];
    [folders addObjectsFromArray:[self searchFolder:dirPath]];
    
    // flatten hierarchy
    if (kPSPDFStoreManagerPlain) {
        // if we don't have any folders, create one
        if ([folders count] == 0) {
            PSCMagazineFolder *aFolder = [PSCMagazineFolder folderWithTitle:@""];
            [folders addObject:aFolder];
        }

        NSMutableArray *foldersCopy = [folders mutableCopy];
        PSCMagazineFolder *firstFolder = foldersCopy[0];
        [foldersCopy removeObject:firstFolder];
        NSMutableArray *magazineArray = [firstFolder.magazines mutableCopy];
        
        for (PSCMagazineFolder *folder in foldersCopy) {
            [magazineArray addObjectsFromArray:folder.magazines];
            [folders removeObject:folder];
        }
        
        firstFolder.magazines = magazineArray;
    }
    
    return folders;
}

// add a magazine to folder, then re-sort it
- (PSCMagazineFolder *)addMagazineToFolder:(PSCMagazine *)magazine {
    PSCMagazineFolder *folder = [self.magazineFolders lastObject];
    [folder addMagazine:magazine];
    NSAssert([folder isKindOfClass:[PSCMagazineFolder class]], @"incorrect type");
    return folder;
}

- (PSCMagazine *)magazineForUID:(NSString *)uid {
    for (PSCMagazineFolder *folder in self.magazineFolders) {
        for (PSCMagazine *magazine in folder.magazines) {
            if ([magazine.UID isEqualToString:uid]) {
                return magazine;
            }
        }
    }
    
    return nil;
}

- (PSCMagazine *)magazineForFileName:(NSString *)fileName {
    for (PSCMagazineFolder *folder in self.magazineFolders) {
        for (PSCMagazine *magazine in folder.magazines) {
            if ([magazine.files count] && [(magazine.files)[0] isEqualToString:fileName]) {
                return magazine;
            }
        }
    }
    
    return nil;
}

- (void)loadMagazinesAvailableFromWeb {
    NSURLRequest *loadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:kPSPDFMagazineJSONURL] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.f];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:loadRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSArray *dlMagazines = (NSArray *)JSON;
        NSMutableArray *newMagazines = [NSMutableArray array];
        for (NSDictionary *dlMagazine in dlMagazines) {
            if (![dlMagazine isKindOfClass:[NSDictionary class]]) {
                PSCLog(@"Error while parsing magazine JSON - Dictionary expected. Got this instead: %@", dlMagazine);
            }else {
                // create and fill PSPDFMagazine
                NSString *title = dlMagazine[@"name"];
                NSString *urlString = dlMagazine[@"url"];
                NSString *imageURLString = dlMagazine[@"image"];
                if ([imageURLString length] == 0) {
                    // if no image key is set, try same location as the pdf, but with jpg ending.
                    imageURLString = [urlString stringByReplacingOccurrencesOfString:@".pdf" withString:@".jpg" options:NSCaseInsensitiveSearch | NSBackwardsSearch range:NSMakeRange(0, [urlString length])];
                }
                NSString *fileName = [urlString lastPathComponent]; // we use fileName as our way to map files to files on disk - be sure to make it unique!
                
                PSCMagazine *magazine = [self magazineForFileName:fileName];
                if (!magazine) {
                    // no magazine found on-disk, create new container
                    magazine = [PSCMagazine magazineWithPath:nil];                
                    magazine.available = NO; // not yet available
                    [newMagazines addObject:magazine];
                }
                
                // TODO: this is not optimal. The title from used in the web is saved nowhere.
                // After a restart, the title within the pdf document's metadata is used, or if no title set there, the filename.
                magazine.title = title;
                magazine.URL = [urlString length] ? [NSURL URLWithString:urlString] : nil;
                magazine.imageURL = [imageURLString length] ? [NSURL URLWithString:imageURLString] : nil;
            }
        }
        [self addMagazinesToStore:newMagazines];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        PSCLog(@"Failed to download JSON: %@", error);
    }];
    
    [[[self class] sharedOperationQueue] addOperation:operation];
}

- (void)didReceiveMemoryWarning {} // NOP

// load magazines from disk
- (void)loadMagazinesFromDisk {
    NSMutableArray *magazineFolders = [self searchForMagazineFolders];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        pspdf_dispatch_sync_reentrant(_magazineFolderQueue, ^{
            self.magazineFolders = magazineFolders;
            [[NSNotificationCenter defaultCenter] postNotificationName:kPSPDFStoreDiskLoadFinishedNotification object:magazineFolders];

            /*
            // ensure we have thumbnails for all magazines (else they would be lazy-loaded)
            // must run on the main thread, as magazines/magazineFolder can be mutated while running
            dispatch_async(dispatch_get_main_queue(), ^{
                [magazineFolders enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id folder, NSUInteger idx, BOOL *stop) {
                    [[folder magazines] enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id magazine, NSUInteger idx2, BOOL *stop2) {
                        [[PSPDFCache sharedCache] cachedImageForDocument:magazine page:0 size:PSPDFSizeThumbnail];
                    }];
                }];
            });
             */
            
            // now start web-request
            [self loadMagazinesAvailableFromWeb];
        });
    });
}

- (NSMutableArray *)magazineFolders {
    __block NSMutableArray *magazineFolders;
    pspdf_dispatch_sync_reentrant(_magazineFolderQueue, ^{
        magazineFolders = _magazineFolders;
    });
    
    return magazineFolders;
}

- (void)finishDownload:(PSCDownload *)storeDownload {
    AMBlockToken *blockToken = (AMBlockToken *)objc_getAssociatedObject(storeDownload, &kvoToken);
    [storeDownload removeObserverWithBlockToken:blockToken];
    [_downloadQueue removeObject:storeDownload];
}

+ (NSString *)storagePath {
    static NSString *storagePath = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        storagePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    });
    return storagePath;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)init {
    if ((self = [super init])) {
        _magazineFolderQueue = dispatch_queue_create("com.PSPDFKit.store.magazineFolderQueue", NULL);
        _downloadQueue = [[NSMutableArray alloc] init];
        
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
    _delegate = nil;
    PSPDFDispatchRelease(_magazineFolderQueue);
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

- (void)deleteMagazineFolder:(PSCMagazineFolder *)magazineFolder {
    [_delegate magazineStoreBeginUpdate];
    
    for (PSCMagazine *magazine in magazineFolder.magazines) {
        [_delegate magazineStoreMagazineDeleted:magazine];
        
        // cancel eventual download!
        if (magazine.isDownloading) {
            PSCDownload *downloadObject = [self downloadObjectForMagazine:magazine];
            [downloadObject cancelDownload];
        }
        
        [[PSPDFCache sharedCache] removeCacheForDocument:magazine deleteDocument:YES waitUntilDone:NO];
    }
    
    [_delegate magazineStoreFolderDeleted:magazineFolder];
    dispatch_barrier_sync(_magazineFolderQueue, ^{
        [_magazineFolders removeObject:magazineFolder];
    });
    
    [_delegate magazineStoreEndUpdate];  
    
    // ensure set icon is not deleted
    [self updateNewsstandIcon:nil];
}

- (void)deleteMagazine:(PSCMagazine *)magazine {
    [_delegate magazineStoreBeginUpdate];

    PSCMagazineFolder *folder = magazine.folder;
    
    // first notify, then delete from the backing store
    if (!magazine.URL) {
        [_delegate magazineStoreMagazineDeleted:magazine];

        if ([folder.magazines count] == 1) {
            [_delegate magazineStoreFolderDeleted:folder];
        }
    }
    
    // cancel eventual download!
    if (magazine.isDownloading) {
        PSCDownload *downloadObject = [self downloadObjectForMagazine:magazine];
        [downloadObject cancelDownload];
    }
    
    // clear everything
    [[PSPDFCache sharedCache] removeCacheForDocument:magazine deleteDocument:YES waitUntilDone:NO];

    // if magazine has no url - delete
    if (!magazine.URL) {
        [folder removeMagazine:magazine];
        
        if([folder.magazines count] > 0) {
            [_delegate magazineStoreFolderModified:folder]; // was just modified
        }else {
            dispatch_barrier_sync(_magazineFolderQueue, ^{
                [_magazineFolders removeObject:folder]; // remove!
            });
        }
    }else {
        // just set availability to now - needs redownloading!
        magazine.available = NO;
        [_delegate magazineStoreMagazineModified:magazine];
    }
    
    [_delegate magazineStoreEndUpdate];
    
    // ensure set icon is not deleted
    [self updateNewsstandIcon:nil];
}

- (void)downloadMagazine:(PSCMagazine *)magazine {
    PSCDownload *storeDownload = [PSCDownload PDFDownloadWithURL:magazine.URL];
    storeDownload.magazine = magazine;
    
    // use kvo to track status
    __ps_weak PSCDownload *storeDownloadWeak = storeDownload;
    AMBlockToken *token = [storeDownload addObserverForKeyPath:@"status" task:^(id obj, NSDictionary *change) {
        if (storeDownloadWeak.status == PSPDFStoreDownloadFinished) {
            [self finishDownload:storeDownloadWeak];

            /*
            [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:NSLocalizedString(@"Download for %@ finished!", @""), storeDownloadWeak.magazine.title]
                                         message:nil
                                        delegate:nil
                               cancelButtonTitle:NSLocalizedString(@"OK", @"")
                               otherButtonTitles:nil] show];
             */
            
        }else if (storeDownloadWeak.status == PSPDFStoreDownloadFailed) {
            if (!storeDownloadWeak.isCancelled) {
                NSString *magazineTitle = [storeDownloadWeak.magazine.title length] ? storeDownloadWeak.magazine.title : NSLocalizedString(@"Magazine", @"");
                NSString *message = [NSString stringWithFormat:NSLocalizedString(@"%@ could not be downloaded. Please try again.", @""), magazineTitle];
                
                NSString *messageWithError = message;
                if (storeDownloadWeak.error) {
                    messageWithError = [NSString stringWithFormat:@"%@\n(%@)", message, [storeDownloadWeak.error localizedDescription]];
                }
                
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", @"")
                                             message:messageWithError
                                            delegate:nil
                                   cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                   otherButtonTitles:nil] show];
                
            }
            [self finishDownload:storeDownloadWeak];
            
            // delete unfinished magazine
            //[self deleteMagazine:storeDownload.magazine];
        }
    }];

    objc_setAssociatedObject(storeDownload, &kvoToken, token, OBJC_ASSOCIATION_RETAIN);
    [_downloadQueue addObject:storeDownload];  
    [storeDownload startDownload];
    magazine.downloading = YES;
}

#define kNewsstandIconUID @"kNewsstandIconUID"
- (void)updateNewsstandIcon:(PSCMagazine *)magazine {
    
    // if no magazine is given, find the current
    if (!magazine) {
        NSString *UID = [[NSUserDefaults standardUserDefaults] objectForKey:kNewsstandIconUID];
        if (UID) {
            magazine = [self magazineForUID:UID];
        }
        
        // if magazine doesn't exist anymore, choose the first magazine in the list
        if (!magazine && [self.magazineFolders count]) {
            magazine = [(self.magazineFolders)[0] firstMagazine];
        }
    }
    
    // set new icon for newsstand, if newsstand exists
    if (NSClassFromString(@"NKLibrary") != nil) {
        UIImage *newsstandCoverImage = nil;
        
        // if magazine or coverImage don't exist, the default newsstand icon is used (with sending nil)
        if ([magazine coverImageForSize:CGSizeZero]) {
            
            // example how to create blended cover + overlay
            /*
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(362, 512), YES, 0.0f);
            [magazine.coverImage drawInRect:CGRectMake(0, 0, 362, 512)];
            [[UIImage imageNamed:@"newsstand-template"] drawAtPoint:CGPointMake(0, 0)];
            newsstandCoverImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
             */
            newsstandCoverImage = [magazine coverImageForSize:[PSPDFCache sharedCache].thumbnailSize];
        }
        
        [[UIApplication sharedApplication] setNewsstandIconImage:newsstandCoverImage];
        
        // update user defaults
        if (magazine.UID) {
            [[NSUserDefaults standardUserDefaults] setObject:magazine.UID forKey:kNewsstandIconUID];
        }else {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kNewsstandIconUID];
        }
    } 
}

- (void)addMagazinesToStore:(NSArray *)magazines {
    
    // filter out magazines that are already in array
    NSMutableArray *newMagazines = [NSMutableArray arrayWithArray:magazines];
    for (PSCMagazine *newMagazine in magazines) {
        for (PSCMagazineFolder *folder in self.magazineFolders) {
            NSArray *foundMagazines = [folder.magazines filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.UID == %@", newMagazine.UID]];
            [newMagazines removeObjectsInArray:foundMagazines];
        }
    }
    
    if ([newMagazines count] > 0) {
        [_delegate magazineStoreBeginUpdate];
        
        for (PSCMagazine *magazine in magazines) {
            PSCMagazineFolder *folder = [self addMagazineToFolder:magazine];
            

            // folder fresh or updated?
            if ([folder.magazines count] == 1) {
                [_delegate magazineStoreFolderAdded:folder];
            }else {
                [_delegate magazineStoreFolderModified:folder]; 
            }
            
            [_delegate magazineStoreMagazineAdded:magazine];    
        }
        
        [_delegate magazineStoreEndUpdate];
        
        // update newsstand icon
        [self updateNewsstandIcon:[newMagazines lastObject]];
    }
}

- (PSCDownload *)downloadObjectForMagazine:(PSCMagazine *)magazine {
    for (PSCDownload *aDownload in _downloadQueue) {
        if(aDownload.magazine == magazine) {
            return aDownload;
        }
    }
    return nil;
}

@end
