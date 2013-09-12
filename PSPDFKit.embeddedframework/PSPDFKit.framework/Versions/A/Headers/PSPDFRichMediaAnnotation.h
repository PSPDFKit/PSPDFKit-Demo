//
//  PSPDFRichMediaAnnotation.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFLinkAnnotation.h"

/// RichMedia annotations are defined in the ISO32000 Adobe Supplement and are the modern way of embedding video content. PSPDFKit also supports the matching RichMediaExecute action to control video state.
@interface PSPDFRichMediaAnnotation : PSPDFLinkAnnotation

@end
