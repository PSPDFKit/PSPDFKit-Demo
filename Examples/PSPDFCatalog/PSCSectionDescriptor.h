//
//  PSCSectionDescriptor.h
//  PSPDFCatalog
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

typedef UIViewController* (^PSControllerBlock)();
@class PSContent;

// Simple model class to describe static section.
@interface PSCSectionDescriptor : NSObject

+ (instancetype)sectionWithTitle:(NSString *)title footer:(NSString *)footer;
- (void)addContent:(PSContent *)contentDescriptor;

@property (nonatomic, copy) NSArray *contentDescriptors;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *footer;

@end

// Simple model class to describe static content.
@interface PSContent : NSObject

+ (instancetype)contentWithTitle:(NSString *)title block:(PSControllerBlock)block;
+ (instancetype)contentWithTitle:(NSString *)title description:(NSString *)description block:(PSControllerBlock)block;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *contentDescription;
@property (nonatomic, copy) PSControllerBlock block;

@end
