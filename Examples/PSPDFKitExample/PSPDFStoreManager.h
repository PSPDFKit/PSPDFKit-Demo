//
//  PSPDFStoreManager.h
//  PSPDFKitExample
//
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

/// enable to make the view plain, no folders supported
#define kPSPDFStoreManagerPlain YES

/// notification emitted when magazines were successfully loaded form disk
#define kPSPDFStoreDiskLoadFinishedNotification @"kPSPDFStoreDiskLoadFinishedNotification"

@class PSPDFMagazine;
@class PSPDFMagazineFolder;
@class PSPDFDownload;

@protocol PSPDFStoreManagerDelegate <NSObject>

- (void)magazineStoreBeginUpdate;
- (void)magazineStoreEndUpdate;

// folder
- (void)magazineStoreFolderDeleted:(PSPDFMagazineFolder *)magazineFolder;
- (void)magazineStoreFolderAdded:(PSPDFMagazineFolder *)magazineFolder;
- (void)magazineStoreFolderModified:(PSPDFMagazineFolder *)magazineFolder;

// magazine
- (void)magazineStoreMagazineDeleted:(PSPDFMagazine *)magazine;
- (void)magazineStoreMagazineAdded:(PSPDFMagazine *)magazine;
- (void)magazineStoreMagazineModified:(PSPDFMagazine *)magazine;

- (void)openMagazine:(PSPDFMagazine *)magazine;

@end

/// store manager, hold magazines and folders
@interface PSPDFStoreManager : NSObject {
    dispatch_queue_t magazineFolderQueue_;
}

/// Shared Instance.
+ (PSPDFStoreManager *)sharedPSPDFStoreManager;

/// Helper to migrate data. Use in AppDelegate.
+ (BOOL)checkAndIfNeededMigrateStoragePathBlocking:(BOOL)blocking completionBlock:(void(^)(void))completionBlock;

/// Storage path currently used. (depends on iOS version)
+ (NSString *)storagePath;

@property(nonatomic, ps_weak) id<PSPDFStoreManagerDelegate> delegate;

- (void)downloadMagazine:(PSPDFMagazine *)magazine;
- (PSPDFDownload *)downloadObjectForMagazine:(PSPDFMagazine *)magazine;

- (void)addMagazinesToStore:(NSArray *)magazines;

// delete
- (void)deleteMagazine:(PSPDFMagazine *)magazine;
- (void)deleteMagazineFolder:(PSPDFMagazineFolder *)magazineFolder;

@property (nonatomic, strong, readonly) NSMutableArray *magazineFolders;
@property (nonatomic, strong, readonly) NSMutableArray *downloadQueue;

@end
