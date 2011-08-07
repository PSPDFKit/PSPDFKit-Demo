//
//  PSPDFStoreManager.h
//  PSPDFKitExample
//
//  Created by Peter Steinberger on 8/7/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>

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
    id<PSPDFStoreManagerDelegate> delegate_;
    NSMutableArray *magazines_;
    NSMutableArray *magazineFolders_;  
    NSMutableArray *downloadQueue_;
}

+ (PSPDFStoreManager *)sharedPSPDFStoreManager;

@property(nonatomic, assign) id<PSPDFStoreManagerDelegate> delegate;

- (void)downloadMagazineWithUrl:(NSURL *)url;
- (PSPDFDownload *)downloadObjectForMagazine:(PSPDFMagazine *)magazine;
- (void)downloadLoadedData:(PSPDFDownload *)storeDownload;

// delete
- (void)deleteMagazine:(PSPDFMagazine *)magazine;
- (void)deleteMagazineFolder:(PSPDFMagazineFolder *)magazineFolder;

@property (nonatomic, retain, readonly) NSMutableArray *magazines;
@property (nonatomic, retain, readonly) NSMutableArray *magazineFolders;
@property (nonatomic, retain, readonly) NSMutableArray *downloadQueue;

@end
