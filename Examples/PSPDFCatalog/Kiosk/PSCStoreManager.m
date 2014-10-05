//
//  PSPDFStoreManager.m
//  PSPDFCatalog
//
//  Copyright (c) 2011-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCStoreManager.h"
#import "PSCMagazine.h"
#import "PSCMagazineFolder.h"
#import "PSCDownload.h"
#import "AFHTTPRequestOperation.h"
#import <objc/runtime.h>

@interface PSCStoreManager() {
    NSMutableArray *_magazineFolders;
    NSMutableArray *_downloadQueue;
    dispatch_queue_t _magazineFolderQueue;
}
@property (nonatomic, strong) NSMutableArray *magazineFolders;
@property (nonatomic, strong) NSMutableArray *downloadQueue;
@property (nonatomic, assign, getter = isDiskDataLoaded) BOOL diskDataLoaded;
@end

@implementation PSCStoreManager

NSString *const PSCStoreDiskLoadFinishedNotification =  @"PSCStoreDiskLoadFinishedNotification";
static char PSCKVOToken; // we need a static address for the KVO token

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Static

+ (PSCStoreManager*)sharedStoreManager {
    static dispatch_once_t onceToken = 0;
    static __strong PSCStoreManager *_sharedStoreManager = nil;
    dispatch_once(&onceToken, ^{
        _sharedStoreManager = [self new];
    });
    return _sharedStoreManager;
}

+ (NSString *)storagePath {
    static __strong NSString *storagePath = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        storagePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    });
    return storagePath;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (instancetype)init {
    if ((self = [super init])) {
        _magazineFolderQueue = dispatch_queue_create([[NSString stringWithFormat:@"com.PSPDFCatalog.%@", self] UTF8String], DISPATCH_QUEUE_CONCURRENT);
        _downloadQueue = [NSMutableArray new];

        // Load magazines from disk, async.
        _diskDataLoaded = YES;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [self loadMagazinesFromDisk];
        });
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == &PSCKVOToken) {
        if ([keyPath isEqualToString:PROPERTY(status)]) {
            [self processStatusChangeForMagazineDownload:object];
        }else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

- (void)deleteMagazineFolder:(PSCMagazineFolder *)magazineFolder {
    id<PSCStoreManagerDelegate> delegate = self.delegate;
    [delegate magazineStoreBeginUpdate];

    for (PSCMagazine *magazine in magazineFolder.magazines) {
        [delegate magazineStoreMagazineDeleted:magazine];

        // cancel eventual download!
        if (magazine.isDownloading) {
            PSCDownload *downloadObject = [self downloadObjectForMagazine:magazine];
            [downloadObject cancelDownload];
        }

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [PSPDFCache.sharedCache removeCacheForDocument:magazine deleteDocument:YES error:NULL];
        });
    }

    [delegate magazineStoreFolderDeleted:magazineFolder];
    dispatch_barrier_sync(_magazineFolderQueue, ^{
        [_magazineFolders removeObject:magazineFolder];
    });

    [delegate magazineStoreEndUpdate];

    // ensure set icon is not deleted.
    [self updateNewsstandIcon:nil];
}

- (void)deleteMagazine:(PSCMagazine *)magazine {
    id<PSCStoreManagerDelegate> delegate = self.delegate;
    [delegate magazineStoreBeginUpdate];

    PSCMagazineFolder *folder = magazine.folder;

    // First notify, then delete from the backing store.
    if (!magazine.URL) {
        [delegate magazineStoreMagazineDeleted:magazine];

        if (folder.magazines.count == 1) {
            [delegate magazineStoreFolderDeleted:folder];
        }
    }

    // Cancel eventual download!
    if (magazine.isDownloading) {
        PSCDownload *downloadObject = [self downloadObjectForMagazine:magazine];
        [downloadObject cancelDownload];
    }

    // Clear everything
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [PSPDFCache.sharedCache removeCacheForDocument:magazine deleteDocument:YES error:NULL];
    });

    // if magazine has no URL - delete.
    if (!magazine.URL) {
        [folder removeMagazine:magazine];

        if (folder.magazines.count > 0) {
            [delegate magazineStoreFolderModified:folder]; // was just modified
        }else {
            dispatch_barrier_sync(_magazineFolderQueue, ^{
                [_magazineFolders removeObject:folder]; // remove!
            });
        }
    }else {
        // just set availability to now - needs redownloading!
        magazine.available = NO;
        [delegate magazineStoreMagazineModified:magazine];
    }

    [delegate magazineStoreEndUpdate];

    // Ensure set icon is not deleted.
    [self updateNewsstandIcon:nil];
}

- (void)downloadMagazine:(PSCMagazine *)magazine {
    PSCDownload *storeDownload = [[PSCDownload alloc] initWithURL:magazine.URL];
    storeDownload.magazine = magazine;

    // Use KVO to track status.
    [storeDownload addObserver:self forKeyPath:PROPERTY(status) options:0 context:&PSCKVOToken];

    [_downloadQueue addObject:storeDownload];
    [storeDownload startDownload];
    magazine.downloading = YES;
}

- (BOOL)cancelDownloadForMagazine:(PSCMagazine *)magazine {
    PSCDownload *download = [self downloadObjectForMagazine:magazine];
    if (download) {
        [download cancelDownload];
        [_downloadQueue removeObject:download];
        magazine.downloading = NO;
        return YES;
    }
    return NO;
}

- (void)processStatusChangeForMagazineDownload:(PSCDownload *)download {
    if (download.status == PSCStoreDownloadStatusFinished) {
        [self finishDownload:download];
    }else if (download.status == PSCStoreDownloadStatusFailed) {
        if (!download.isCancelled) {
            NSString *magazineTitle = download.magazine.title.length ? download.magazine.title : NSLocalizedString(@"Magazine", @"");
            NSString *message = [NSString stringWithFormat:NSLocalizedString(@"%@ could not be downloaded. Please try again.", @""), magazineTitle];

            NSString *messageWithError = message;
            if (download.error) {
                messageWithError = [NSString stringWithFormat:@"%@\n(%@)", message, download.error.localizedDescription];
            }

            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", @"")
                                        message:messageWithError
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK", @"")
                              otherButtonTitles:nil] show];

        }
        [self finishDownload:download];
    }
}

#define kNewsstandIconUID @"kNewsstandIconUID"
- (void)updateNewsstandIcon:(PSCMagazine *)magazine {

    // If no magazine is given, find the current.
    if (!magazine) {
        NSString *UID = [NSUserDefaults.standardUserDefaults objectForKey:kNewsstandIconUID];
        if (UID) {
            magazine = [self magazineForUID:UID];
        }

        // if magazine doesn't exist anymore, choose the first magazine in the list
        if (!magazine) {
            magazine = [self.magazineFolders.firstObject firstMagazine];
        }
    }

    // Set new icon for newsstand.
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
        newsstandCoverImage = [magazine coverImageForSize:CGSizeMake(170.f, 220.f)];
    }

    [UIApplication.sharedApplication setNewsstandIconImage:newsstandCoverImage];

    // update user defaults
    if (magazine.UID) {
        [NSUserDefaults.standardUserDefaults setObject:magazine.UID forKey:kNewsstandIconUID];
    }else {
        [NSUserDefaults.standardUserDefaults removeObjectForKey:kNewsstandIconUID];
    }
}

- (void)addMagazinesToStore:(NSArray *)magazines {
    // Filter out magazines that are already in array.
    NSMutableArray *newMagazines = [NSMutableArray arrayWithArray:magazines];
    for (PSCMagazine *newMagazine in magazines) {
        for (PSCMagazineFolder *folder in self.magazineFolders) {
            NSArray *foundMagazines = [folder.magazines filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.UID == %@", newMagazine.UID]];
            [newMagazines removeObjectsInArray:foundMagazines];
        }
    }

    if (newMagazines.count > 0) {
        id<PSCStoreManagerDelegate> delegate = self.delegate;

        [delegate magazineStoreBeginUpdate];

        for (PSCMagazine *magazine in magazines) {
            PSCMagazineFolder *folder = [self addMagazineToFolder:magazine];

            // folder fresh or updated?
            if (folder.magazines.count == 1) {
                [delegate magazineStoreFolderAdded:folder];
            }else {
                [delegate magazineStoreFolderModified:folder];
            }

            [delegate magazineStoreMagazineAdded:magazine];
        }
        [delegate magazineStoreEndUpdate];

        // update newsstand icon
        [self updateNewsstandIcon:newMagazines.lastObject];
    }
}

- (PSCDownload *)downloadObjectForMagazine:(PSCMagazine *)magazine {
    for (PSCDownload *aDownload in _downloadQueue) {
        if (aDownload.magazine == magazine) {
            return aDownload;
        }
    }
    return nil;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

// Helper for folder search.
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

                if (contentFolder.magazines.count) {
                    [folders addObject:contentFolder];
                }
            }else if ([fullPath.lowercaseString hasSuffix:@"pdf"]) {
                @autoreleasepool {
                    PSCMagazine *magazine = [PSCMagazine magazineWithPath:fullPath];
                    [rootFolder addMagazine:magazine];
                }
            }
        }
    }
    if (rootFolder.magazines.count > 0) [folders addObject:rootFolder];

    return folders;
}

// doesn't support deep hierarchies. Just root or a folder.
- (NSMutableArray *)searchForMagazineFolders {
    NSMutableArray *folders = [NSMutableArray array];

    // Add Samples
    NSString *sampleFolder = [NSBundle.mainBundle.resourcePath stringByAppendingPathComponent:@"Samples"];
    [folders addObjectsFromArray:[self searchFolder:sampleFolder]];

    // Add downloaded files
    NSString *dirPath = [PSCStoreManager.storagePath stringByAppendingPathComponent:@"downloads"];
    [folders addObjectsFromArray:[self searchFolder:dirPath]];

    // Add files from Open In...
    NSString *documentsFolder = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    [folders addObjectsFromArray:[self searchFolder:documentsFolder]];

    // flatten hierarchy
    if (PSPDFStoreManagerPlain) {
        // if we don't have any folders, create one
        if (folders.count == 0) {
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

    [folders sortUsingComparator:^NSComparisonResult(PSCMagazineFolder *folder1, PSCMagazineFolder *folder2) {
        return [folder1.title compare:folder2.title];
    }];

    return folders;
}

// Add a magazine to folder, then re-sort it.
- (PSCMagazineFolder *)addMagazineToFolder:(PSCMagazine *)magazine {
    PSCMagazineFolder *folder = self.magazineFolders.lastObject;
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
            if ([magazine.files.firstObject isEqualToString:fileName]) {
                return magazine;
            }
        }
    }
    return nil;
}

- (void)loadMagazinesAvailableFromWeb {
    NSURLRequest *loadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:PSCMagazineJSONURL] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.f];
    AFHTTPRequestOperation *loadMagazineOperation = [[AFHTTPRequestOperation alloc] initWithRequest:loadRequest];
    loadMagazineOperation.responseSerializer = AFJSONResponseSerializer.serializer;

    [loadMagazineOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (![responseObject isKindOfClass:NSArray.class]) {
            PSCLog(@"Unexpected response: %@", responseObject);
            return;
        }

        NSArray *dlMagazines = (NSArray *)responseObject;
        NSMutableArray *newMagazines = [NSMutableArray array];
        for (NSDictionary *dlMagazine in dlMagazines) {
            if (![dlMagazine isKindOfClass:NSDictionary.class]) {
                PSCLog(@"Error while parsing magazine JSON - Dictionary expected. Got this instead: %@", dlMagazine);
            }else {
                // create and fill PSPDFMagazine
                NSString *title = dlMagazine[@"name"];
                NSString *URLString = dlMagazine[@"url"];
                NSString *imageURLString = dlMagazine[@"image"];
                if ([imageURLString length] == 0) {
                    // if no image key is set, try same location as the pdf, but with jpg ending.
                    imageURLString = [URLString stringByReplacingOccurrencesOfString:@".pdf" withString:@".jpg" options:NSCaseInsensitiveSearch | NSBackwardsSearch range:NSMakeRange(0, URLString.length)];
                }
                NSString *fileName = URLString.lastPathComponent; // we use fileName as our way to map files to files on disk - be sure to make it unique!

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
                magazine.URL = URLString.length ? [NSURL URLWithString:URLString] : nil;
                magazine.imageURL = imageURLString.length ? [NSURL URLWithString:imageURLString] : nil;
            }
        }
        [self addMagazinesToStore:newMagazines];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        PSCLog(@"Failed to download JSON: %@", error.localizedDescription);
    }];
    [loadMagazineOperation start];
}

- (void)clearCache {
    dispatch_barrier_sync(_magazineFolderQueue, ^{
        self.magazineFolders = nil;
    });
}

// load magazines from disk
- (void)loadMagazinesFromDisk {
    NSMutableArray *magazineFolders = [self searchForMagazineFolders];

    dispatch_async(dispatch_get_main_queue(), ^{
        dispatch_barrier_sync(_magazineFolderQueue, ^{
            self.magazineFolders = magazineFolders;
            self.diskDataLoaded = NO;

            // now start web-request.
            [self loadMagazinesAvailableFromWeb];
        });

        [[NSNotificationCenter defaultCenter] postNotificationName:PSCStoreDiskLoadFinishedNotification object:magazineFolders];
    });
}

- (NSMutableArray *)magazineFolders {
    __block NSMutableArray *magazineFolders;
    dispatch_sync(_magazineFolderQueue, ^{
        magazineFolders = _magazineFolders;
    });

    return magazineFolders;
}

- (void)finishDownload:(PSCDownload *)storeDownload {
    [storeDownload removeObserver:self forKeyPath:PROPERTY(status)];
    [_downloadQueue removeObject:storeDownload];
}

@end
