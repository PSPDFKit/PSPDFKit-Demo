//
//  PSCCoreDataAnnotation.h
//  PSPDFCatalog
//
//  Copyright (c) 2013-2015 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface PSCCoreDataAnnotation : NSManagedObject

@property (nonatomic, strong) NSData *annotationData;
@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, copy)   NSString *uuid;

@end
