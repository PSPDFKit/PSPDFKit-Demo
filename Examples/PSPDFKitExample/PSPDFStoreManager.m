//
//  PSPDFStoreManager.m
//  PSPDFKitExample
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
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
#include <sys/xattr.h>

@interface PSPDFStoreManager()
@property (nonatomic, strong) NSMutableArray *magazineFolders;
@property (nonatomic, strong) NSMutableArray *downloadQueue;
- (void)updateNewsstandIcon:(PSPDFMagazine *)magazine;
@end

@implementation PSPDFStoreManager

static char kvoToken; // we need a static address for the kvo token

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - static

+ (id)sharedPSPDFStoreManager {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];

        // allow plain text in JSON downloader class, fixes servers that don't know about JSON.
        [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/plain"]];
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
                NSArray *subDocumentContents = [fileManager contentsOfDirectoryAtPath:fullPath error:&error];
                for (NSString *afolder in subDocumentContents) {
                    if ([[afolder lowercaseString] hasSuffix:@"pdf"]) {
                        PSPDFMagazine *magazine = [PSPDFMagazine magazineWithPath:[fullPath stringByAppendingPathComponent:afolder]];
                        [contentFolder addMagazine:magazine];
                    }
                }
                
                if ([contentFolder.magazines count]) {
                    [folders addObject:contentFolder];
                }
            }else if([[fullPath lowercaseString] hasSuffix:@"pdf"]) {
                @autoreleasepool {
                    PSPDFMagazine *magazine = [PSPDFMagazine magazineWithPath:fullPath];
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
    
    NSString *dirPath = [[PSPDFStoreManager storagePath] stringByAppendingPathComponent:@"downloads"];
    [folders addObjectsFromArray:[self searchFolder:dirPath]];
    
    // flatten hierarchy
    if (kPSPDFStoreManagerPlain) {
        // if we don't have any folders, create one
        if ([folders count] == 0) {
            PSPDFMagazineFolder *aFolder = [PSPDFMagazineFolder folderWithTitle:@""];
            [folders addObject:aFolder];
        }

        NSMutableArray *foldersCopy = [folders mutableCopy];
        PSPDFMagazineFolder *firstFolder = foldersCopy[0];
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

- (PSPDFMagazine *)magazineForFileName:(NSString *)fileName {
    for (PSPDFMagazineFolder *folder in self.magazineFolders) {
        for (PSPDFMagazine *magazine in folder.magazines) {
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
                PSELog(@"Error while parsing magazine JSON - Dictionary expected. Got this instead: %@", dlMagazine);
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
                
                PSPDFMagazine *magazine = [self magazineForFileName:fileName];
                if (!magazine) {
                    // no magazine found on-disk, create new container
                    magazine = [PSPDFMagazine magazineWithPath:nil];                
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
        PSELog(@"Failed to download JSON: %@", error);
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
            
            // ensure we have thumbnails for all magazines (else they would be lazy-loaded)
            // must run on the main thread, as magazines/magazineFolder can be mutated while running
            dispatch_async(dispatch_get_main_queue(), ^{
                [magazineFolders enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id folder, NSUInteger idx, BOOL *stop) {
                    [[folder magazines] enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id magazine, NSUInteger idx2, BOOL *stop2) {
                        [[PSPDFCache sharedPSPDFCache] cachedImageForDocument:magazine page:0 size:PSPDFSizeThumbnail];
                    }];
                }];
            });
            
            // now start web-request
            [self loadMagazinesAvailableFromWeb];
        });
    });
}

- (NSMutableArray *)magazineFolders {
    __block NSMutableArray *magazineFolders;
    pspdf_dispatch_sync_reentrant([self magazineFolderQueue], ^{
        magazineFolders = _magazineFolders;
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
    [_downloadQueue removeObject:storeDownload];
}

/// Set a flag that the files shouldn't be backuped to iCloud.
+ (void)addSkipBackupAttributeToFile:(NSString *)filePath {
    u_int8_t b = 1;
    setxattr([filePath fileSystemRepresentation], "com.apple.MobileBackup", &b, 1, 0, 0);
}

/// Returns the legacy storage path, used when the com.apple.MobileBackup file attribute is not available.
+ (NSString *)legacyStoragePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return paths[0];
}

/// Returns YES if system supports com.apple.MobileBackup file attribute, marks files/folders as not iCloud-backupable.
+ (BOOL)isBackupXAttributeAvailable {
    static BOOL isModern;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // since there is no kCFCoreFoundationVersionNumber_iOS_5_0_1, we have to do it the ugly way
        NSString *version = [[UIDevice currentDevice] systemVersion];
        isModern = ![version isEqualToString:@"5.0.0"] && [version intValue] >= 5;
        //isModern = NO; // To test migration, enable this to "fake" an old system.
        //NSLog(@"Modern OS detected, com.apple.MobileBackup is allowed. Using Documents folder."); // log optionally
    });
    return isModern;
}

/// Storage Path is Documents for iOS >= 5.0.1, and Caches for iOS <= 5.0.
/// This must be done to fully comply with the iCloud storage guidelines.
/// Don't forget to set the xattr on iOS >= 5.0.1!
/// http://developer.apple.com/library/ios/#qa/qa1719/_index.html
/// https://developer.apple.com/icloud/documentation/data-storage/
/// 
/// The result is cached for faster future access. Can be invoked from any thread.
#define kPSLegacyStoragePathUsed @"PSLegacyStoragePathUsed"
+ (NSString *)storagePath {
    static NSString *storagePath = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ([self isBackupXAttributeAvailable]) {
            storagePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        }else {
            storagePath = [self legacyStoragePath];
            // mark that we use the legazy storage.
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kPSLegacyStoragePathUsed];
            // No need for manual synchronize, we assume that our app is running long enough for the automatic sweep.
        }
    });
    return storagePath;
}

/// Invoke this in the AppDelegate - moves your documents around.
/// Note: we only support *upgrading* - not OS downgrades.
/// Can be invoked from any thread.
/// Returns YES if a migration was done.
+ (BOOL)checkAndIfNeededMigrateStoragePathBlocking:(BOOL)blocking completionBlock:(void(^)(void))completionBlock {
    __block BOOL migrationNeeded = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        BOOL wasUsingLegacyPath = [[NSUserDefaults standardUserDefaults] boolForKey:kPSLegacyStoragePathUsed];
        if (wasUsingLegacyPath && [self isBackupXAttributeAvailable]) {
            void (^moveBlock)(void) = ^{
                NSFileManager *fileManager = [[NSFileManager alloc] init];
                NSString *legacyPath = [self legacyStoragePath];
                NSString *modernPath = [self storagePath];
                NSError *error = nil;
                NSArray *directoryContents = [fileManager contentsOfDirectoryAtPath:legacyPath error:&error];
                if (!directoryContents) {
                    PSPDFLogWarning(@"Error while getting contents of directory: %@.", [error localizedDescription]);
                }
                for (NSString *file in directoryContents) {
                    NSString *targetPath = [modernPath stringByAppendingPathComponent:file];
                    if(![fileManager moveItemAtPath:[legacyPath stringByAppendingPathComponent:file]
                                             toPath:targetPath error:&error]) {
                        PSPDFLogWarning(@"Error while moving %@ from path %@ to %@.", file, legacyPath, modernPath);
                        // just continue with next file - can't do much about this.
                    }else {
                        // apply the new attribute to the file/folder (no need to put it on every file, a parent folder will do)
                        [self addSkipBackupAttributeToFile:targetPath];
                    }
                }
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPSLegacyStoragePathUsed];
            };
            if(blocking) {
                moveBlock();
                if (completionBlock) completionBlock();
            }else {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    moveBlock();
                    if (completionBlock) completionBlock();
                });
            }
            migrationNeeded = YES;
        }
    });
    return migrationNeeded;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)init {
    if ((self = [super init])) {
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
    dispatch_release(magazineFolderQueue_);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

- (void)deleteMagazineFolder:(PSPDFMagazineFolder *)magazineFolder {
    [_delegate magazineStoreBeginUpdate];
    
    for (PSPDFMagazine *magazine in magazineFolder.magazines) {
        [_delegate magazineStoreMagazineDeleted:magazine];
        
        // cancel eventual download!
        if (magazine.isDownloading) {
            PSPDFDownload *downloadObject = [self downloadObjectForMagazine:magazine];
            [downloadObject cancelDownload];
        }
        
        [[PSPDFCache sharedPSPDFCache] removeCacheForDocument:magazine deleteDocument:YES waitUntilDone:NO];
    }
    
    [_delegate magazineStoreFolderDeleted:magazineFolder];
    pspdf_dispatch_sync_reentrant([self magazineFolderQueue], ^{
        [_magazineFolders removeObject:magazineFolder];
    });
    
    [_delegate magazineStoreEndUpdate];  
    
    // ensure set icon is not deleted
    [self updateNewsstandIcon:nil];
}

- (void)deleteMagazine:(PSPDFMagazine *)magazine {
    [_delegate magazineStoreBeginUpdate];

    PSPDFMagazineFolder *folder = magazine.folder;
    
    // first notify, then delete from the backing store
    if (!magazine.URL) {
        [_delegate magazineStoreMagazineDeleted:magazine];

        if ([folder.magazines count] == 1) {
            [_delegate magazineStoreFolderDeleted:folder];
        }
    }
    
    // cancel eventual download!
    if (magazine.isDownloading) {
        PSPDFDownload *downloadObject = [self downloadObjectForMagazine:magazine];
        [downloadObject cancelDownload];
    }
    
    // clear everything
    [[PSPDFCache sharedPSPDFCache] removeCacheForDocument:magazine deleteDocument:YES waitUntilDone:NO];

    // if magazine has no url - delete
    if (!magazine.URL) {
        [folder removeMagazine:magazine];
        
        if([folder.magazines count] > 0) {
            [_delegate magazineStoreFolderModified:folder]; // was just modified
        }else {
            pspdf_dispatch_sync_reentrant([self magazineFolderQueue], ^{
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

- (void)downloadMagazine:(PSPDFMagazine *)magazine {
    PSPDFDownload *storeDownload = [PSPDFDownload PDFDownloadWithURL:magazine.URL];
    storeDownload.magazine = magazine;
    
    // use kvo to track status
    __ps_weak PSPDFDownload *storeDownloadWeak = storeDownload;
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
    
    [storeDownload associateValue:token withKey:&kvoToken];
    [_downloadQueue addObject:storeDownload];  
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
            newsstandCoverImage = [magazine coverImageForSize:[PSPDFCache sharedPSPDFCache].thumbnailSize];
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
        [_delegate magazineStoreBeginUpdate];
        
        for (PSPDFMagazine *magazine in magazines) {
            PSPDFMagazineFolder *folder = [self addMagazineToFolder:magazine];
            
            
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

- (PSPDFDownload *)downloadObjectForMagazine:(PSPDFMagazine *)magazine {
    for (PSPDFDownload *aDownload in _downloadQueue) {
        if(aDownload.magazine == magazine) {
            return aDownload;
        }
    }
    return nil;
}

@end
