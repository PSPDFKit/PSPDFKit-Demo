//
//  PSPDFStoreManager.h
//  PSPDFCatalog
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

/// enable to make the view plain, no folders supported
#define kPSPDFStoreManagerPlain YES

/// notification emitted when magazines were successfully loaded form disk
#define kPSPDFStoreDiskLoadFinishedNotification @"kPSPDFStoreDiskLoadFinishedNotification"

@class PSCMagazine;
@class PSCMagazineFolder;
@class PSCDownload;

@protocol PSCStoreManagerDelegate <NSObject>

- (void)magazineStoreBeginUpdate;
- (void)magazineStoreEndUpdate;

// folder
- (void)magazineStoreFolderDeleted:(PSCMagazineFolder *)magazineFolder;
- (void)magazineStoreFolderAdded:(PSCMagazineFolder *)magazineFolder;
- (void)magazineStoreFolderModified:(PSCMagazineFolder *)magazineFolder;

// magazine
- (void)magazineStoreMagazineDeleted:(PSCMagazine *)magazine;
- (void)magazineStoreMagazineAdded:(PSCMagazine *)magazine;
- (void)magazineStoreMagazineModified:(PSCMagazine *)magazine;

- (void)openMagazine:(PSCMagazine *)magazine;

@end

/// Store manager, hold magazines and folders
@interface PSCStoreManager : NSObject {
    dispatch_queue_t _magazineFolderQueue;
}

/// Shared Instance.
+ (PSCStoreManager *)sharedStoreManager;

/// Storage path currently used. (depends on iOS version)
+ (NSString *)storagePath;

/// Clears all magazineFolders. Will not send delegate events.
- (void)clearCache;

/// Reload all magazines from disk.
- (void)loadMagazinesFromDisk;

@property (nonatomic, ps_weak) id<PSCStoreManagerDelegate> delegate;

- (void)downloadMagazine:(PSCMagazine *)magazine;
- (PSCDownload *)downloadObjectForMagazine:(PSCMagazine *)magazine;

- (void)addMagazinesToStore:(NSArray *)magazines;

// Delete
- (void)deleteMagazine:(PSCMagazine *)magazine;
- (void)deleteMagazineFolder:(PSCMagazineFolder *)magazineFolder;

@property (nonatomic, strong, readonly) NSMutableArray *magazineFolders;
@property (nonatomic, strong, readonly) NSMutableArray *downloadQueue;

@end
