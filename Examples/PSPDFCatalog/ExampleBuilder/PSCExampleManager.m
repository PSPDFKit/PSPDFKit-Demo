//
//  PSCExampleManager.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCExampleManager.h"
#import "PSCExample.h"
#import <objc/runtime.h>

@interface PSCExampleManager ()
@property (nonatomic, copy) NSArray *allExamples;
@end

@implementation PSCExampleManager

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Static

+ (instancetype)defaultManager {
    static __strong PSCExampleManager *_manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[self class] new];
    });
    return _manager;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)init {
    if (self = [super init]) {
        _allExamples = [self loadAllExamples];
    }
    return self;
}

- (NSArray *)loadAllExamples {
    // Get all subclasses and instantiate them.
    NSArray *exampleSubclasses = PSCGetAllExampleSubclasses();
    NSMutableArray *examples = [NSMutableArray array];
    for (Class exampleObj in exampleSubclasses) {
        [examples addObject:[exampleObj new]];
    }

    // Sort all examples depending on category.
    [examples sortUsingComparator:^NSComparisonResult(PSCExample *example1, PSCExample *example2) {
        NSUInteger value1 = example1.category, value2 = example2.category;
        if (value1 < value2) return (NSComparisonResult)NSOrderedAscending;
        else if (value1 > value2) return (NSComparisonResult)NSOrderedDescending;
        else return (NSComparisonResult)NSOrderedSame;
    }];

    return examples;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Annotation Type runtime builder

// Do not use -[NSObject isSubclassOfClass:] in order to avoid calling +initialize on all classes.
NS_INLINE BOOL PSCIsSubclassOfClass(Class subclass, Class superclass) {
    for (Class class = class_getSuperclass(subclass); class != Nil; class = class_getSuperclass(class)) {
        if (class == superclass) return YES;
    }
    return NO;
}

static inline NSArray *PSCGetAllExampleSubclasses(void) {
    NSMutableArray *annotations = [NSMutableArray array];
    unsigned int count = 0;
    Class *classList = objc_copyClassList(&count);
    for (int index = 0; index < count; ++index) {
        Class class = classList[index];
        if (class != PSCExample.class && PSCIsSubclassOfClass(class, PSCExample.class)) {
            [annotations addObject:class];
        }
    }
    free(classList);
    return annotations;
}

@end
