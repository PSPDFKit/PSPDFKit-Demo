//
//  PSPDFStoreManager.h
//  PSPDFKitExample
//
//  Created by Peter Steinberger on 8/7/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>

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
    id<PSPDFStoreManagerDelegate> __ps_weak delegate_;
    NSMutableArray *magazineFolders_;  
    NSMutableArray *downloadQueue_;
}

+ (PSPDFStoreManager *)sharedPSPDFStoreManager;

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
