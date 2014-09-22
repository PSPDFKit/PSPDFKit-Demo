//
//  PSCExampleManager.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCExampleManager.h"
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

- (instancetype)init {
    if ((self = [super init])) {
        _allExamples = [self loadAllExamples];
    }
    return self;
}

- (NSArray *)loadAllExamples {
    // Get all subclasses and instantiate them.
    NSArray *exampleSubclasses = PSCGetAllExampleSubclasses();
    NSMutableArray *examples = [NSMutableArray array];
    PSCExampleTargetDeviceMask currentDevice = PSCIsIPad() ? PSCExampleTargetDeviceMaskPad : PSCExampleTargetDeviceMaskPhone;
    for (Class exampleObj in exampleSubclasses) {
        PSCExample *example = [exampleObj new];
        if ((example.targetDevice & currentDevice) > 0) {
            [examples addObject:example];
        }
    }

    // Sort all examples depending on category.
    [examples sortUsingComparator:^NSComparisonResult(PSCExample *example1, PSCExample *example2) {
        // sort via category
        if (example1.category < example2.category) return (NSComparisonResult)NSOrderedAscending;
        else if (example1.category > example2.category) return (NSComparisonResult)NSOrderedDescending;
        // then priority
        else if (example1.priority < example2.priority) return (NSComparisonResult)NSOrderedAscending;
        else if (example1.priority > example2.priority) return (NSComparisonResult)NSOrderedDescending;
        // then title
        else return [example1.title compare:example2.title];
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

static NSArray *PSCGetAllExampleSubclasses(void) {
    NSMutableArray *annotations = [NSMutableArray array];
    unsigned int count = 0;
    Class *classList = objc_copyClassList(&count);
    for (NSUInteger idx = 0; idx < count; ++idx) {
        Class class = classList[idx];
        if (PSCIsSubclassOfClass(class, PSCExample.class)) {
            [annotations addObject:class];
        }
    }
    free(classList);
    return annotations;
}

@end
