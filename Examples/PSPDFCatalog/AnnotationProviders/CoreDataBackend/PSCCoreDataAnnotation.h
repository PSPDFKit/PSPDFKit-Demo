//
//  PSCCoreDataAnnotation.h
//  PSPDFCatalog
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface PSCCoreDataAnnotation : NSManagedObject

@property (nonatomic, strong) NSData *annotationData;
@property (nonatomic, assign) NSUInteger page;

@end
