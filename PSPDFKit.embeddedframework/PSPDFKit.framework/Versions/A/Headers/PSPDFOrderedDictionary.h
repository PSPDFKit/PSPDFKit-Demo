//
//  PSPDFOrderedDictionary.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//
//  Based on code by Matt Gallagher on 19/12/08.
//  Copyright 2008 Matt Gallagher. All rights reserved.
//
//  This software is provided 'as-is', without any express or implied
//  warranty. In no event will the authors be held liable for any damages
//  arising from the use of this software. Permission is granted to anyone to
//  use this software for any purpose, including commercial applications, and to
//  alter it and redistribute it freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//     claim that you wrote the original software. If you use this software
//     in a product, an acknowledgment in the product documentation would be
//     appreciated but is not required.
//  2. Altered source versions must be plainly marked as such, and must not be
//     misrepresented as being the original software.
//  3. This notice may not be removed or altered from any source
//     distribution.
//

#import "PSPDFKitGlobal.h"

/// Ordered dictionary.
@interface PSPDFOrderedDictionary : NSMutableDictionary

/// Internal array for ordering. Only move, do not add/remove items here,
/// or the dictionary will get into an inconsistent state.
/// Can be used for sorting.
@property (nonatomic, strong, readonly) NSMutableArray *keyArray;

/// Insert key for object at index.
- (void)insertObject:(id)anObject forKey:(id)aKey atIndex:(NSUInteger)anIndex;

/// Get key at index.
- (id)keyAtIndex:(NSUInteger)anIndex;

/// Get object at index.
- (id)objectAtIndex:(NSUInteger)anIndex;

/// Reverse object enumerator.
- (NSEnumerator *)reverseKeyEnumerator;

@end
