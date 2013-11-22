//
//  PSCAlternativeNoteAnnotationInterfaceExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2011-2013 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCAlternativeNoteAnnotationInterfaceExample.h"
#import "PSCAssetLoader.h"
#import <QuartzCore/QuartzCore.h>

// This example was only written for iOS 7 (but could be changed to work on iOS 5+)
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000

// Custom classes required
@interface PSCNoteInvisibleResizableView : PSPDFResizableView @end
@interface PSCCustomNoteViewPageView : PSPDFPageView @end
@interface PSCCustomNoteAnnotationView : PSPDFNoteAnnotationView @end
@interface PSCCustomNoteAnnotationViewController : PSPDFNoteAnnotationViewController
@property (nonatomic, assign) CGRect sourceRect;
@end

@interface PSCAlternativeNoteAnnotationInterfaceExample () <PSPDFViewControllerDelegate> @end

#define PSCCustomNewTintColor [UIColor colorWithRed:0.863f green:0.325f blue:0.169f alpha:1.f]
#define PSCCustomCreatedTintColor [UIColor colorWithWhite:0.4f alpha:1.f]

@implementation PSCAlternativeNoteAnnotationInterfaceExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Alternative Note Interface Example";
        self.category = PSCExampleCategoryAnnotations;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunner>)delegate {
    // Set up the document.
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];
    document.editableAnnotationTypes = [NSOrderedSet orderedSetWithObjects:PSPDFAnnotationStringHighlight, PSPDFAnnotationStringNote, nil];
    document.allowsCopying = NO;

    // And also the controller.
    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
    pdfController.delegate = self;
    [pdfController overrideClass:PSPDFPageView.class withClass:PSCCustomNoteViewPageView.class];
    [pdfController overrideClass:PSPDFResizableView.class withClass:PSCNoteInvisibleResizableView.class];
    [pdfController overrideClass:PSPDFNoteAnnotationViewController.class withClass:PSCCustomNoteAnnotationViewController.class];
    [pdfController overrideClass:PSPDFNoteAnnotationView.class withClass:PSCCustomNoteAnnotationView.class];

    // Set some default colors.
    [[PSPDFStyleManager sharedStyleManager] setLastUsedValue:PSCCustomNewTintColor forProperty:@"color" forKey:PSPDFAnnotationStringHighlight];
    [[PSPDFStyleManager sharedStyleManager] setLastUsedValue:PSCCustomNewTintColor forProperty:@"color" forKey:PSPDFAnnotationStringNote];

    return pdfController;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewControllerDelegate

- (NSArray *)pdfViewController:(PSPDFViewController *)pdfController shouldShowMenuItems:(NSArray *)menuItems atSuggestedTargetRect:(CGRect)rect forSelectedText:(NSString *)selectedText inRect:(CGRect)textRect onPageView:(PSPDFPageView *)pageView {

    // Simplifty menu, remove image.
    NSMutableArray *allowedMenuItems = [NSMutableArray array];
    for (PSPDFMenuItem *menuItem in menuItems) {
        if ([menuItem.identifier isEqualToString:@"Highlight"]) {
            menuItem.ps_image = nil; // clear image
            [allowedMenuItems addObject:menuItem];
        }
    }
    return allowedMenuItems;
}

- (NSArray *)pdfViewController:(PSPDFViewController *)pdfController shouldShowMenuItems:(NSArray *)menuItems atSuggestedTargetRect:(CGRect)rect forAnnotations:(NSArray *)annotations inRect:(CGRect)annotationRect onPageView:(PSPDFPageView *)pageView {
    if (!annotations) return menuItems; // Menu for new annotations

    // Simplifty menu, remove image.
    NSMutableArray *allowedMenuItems = [NSMutableArray array];
    for (PSPDFMenuItem *menuItem in menuItems) {
        if ([menuItem.identifier isEqualToString:@"Remove"]) {
            menuItem.ps_image = nil; // clear image
            [allowedMenuItems addObject:menuItem];
        }
    }
    return allowedMenuItems;
}

@end

// Figures out what number the annotation is.
static NSUInteger PSCNumberOfAnnotationOfType(PSPDFAnnotation *annotation) {
    NSArray *annotations = [annotation.document annotationsForPage:annotation.absolutePage type:annotation.type];
    return [annotations indexOfObject:annotation] + 1;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCCustomNoteViewPageView

@implementation PSCCustomNoteViewPageView {
    CGPoint _startPoint;
}

- (CGRect)psc_rectForAnnotationInPDFView:(PSPDFAnnotation *)annotation {
    return [self convertRect:[self rectForAnnotations:@[annotation]] toView:self.pdfController.view];
}

- (PSPDFNoteAnnotationViewController *)showNoteControllerForAnnotation:(PSPDFAnnotation *)annotation showKeyboard:(BOOL)showKeyboard animated:(BOOL)animated {

    // Check if we're already open and return the attached controller.
    for (UIView *noteView in self.annotationContainerView.subviews) {
        id nextResponder = [noteView nextResponder];
        if ([nextResponder isKindOfClass:PSCCustomNoteAnnotationViewController.class] && [((PSCCustomNoteAnnotationViewController *)nextResponder).annotation isEqual:annotation]) {
            return nextResponder;
        }
    }

    // make sure annotation is selected.
    if (![self.selectedAnnotations containsObject:annotation]) {
        self.selectedAnnotations = @[annotation];
    }

    // Prepare the controller
    PSCCustomNoteAnnotationViewController *noteController = [[PSCCustomNoteAnnotationViewController alloc] initWithAnnotation:annotation];
    noteController.delegate = self;

    CGRect targetRect = [self psc_rectForAnnotationInPDFView:annotation];

    // Calculate the optimum note frame and set it.
    CGRect noteRect = CGRectInset(CGRectMake(CGRectGetMidX(targetRect), CGRectGetMidY(targetRect), 0.f, 0.f), -150.f, -100.f);
    if (CGRectGetMinX(noteRect) < 0) noteRect.origin.x = 0;
    if (CGRectGetMaxX(noteRect) > self.bounds.size.width) noteRect.origin.x -= CGRectGetMaxX(noteRect) - self.bounds.size.width;
    if (CGRectGetMinY(noteRect) < 0) noteRect.origin.y = 0;
    if (CGRectGetMaxY(noteRect) > self.bounds.size.height) noteRect.origin.y -= CGRectGetMaxY(noteRect) - self.bounds.size.height;
    noteController.view.frame = noteRect;

    // Use child view containment to add the note view to the page.
    UIViewController *parentViewController = self.parentViewController;
    [parentViewController addChildViewController:noteController];
    [self.annotationContainerView addSubview:noteController.view];
    [noteController didMoveToParentViewController:parentViewController];

    noteController.sourceRect = targetRect;
    noteController.view.frame = targetRect;
    noteController.view.clipsToBounds = YES;

    [UIView animateWithDuration:0.7f delay:0.f usingSpringWithDamping:0.8f initialSpringVelocity:0.f options:kNilOptions animations:^{
        noteController.view.frame = noteRect;
    } completion:NULL];

    // show keyboard if set.
    dispatch_block_t showKeyboardBlock = ^{
        if (noteController.view.window && showKeyboard) {
            [noteController.textView becomeFirstResponder];
        }
    };

    // TODO: Seems as if iOS7 needs some more time, window is nil right after we present the controller.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), showKeyboardBlock);

    return noteController;
}

- (BOOL)longPress:(UILongPressGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _startPoint = [recognizer locationInView:self];
    }
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        // Calculate distance from starting point.
        CGPoint endPoint = [recognizer locationInView:self];
        CGFloat distance = (CGFloat)fmax(fabs(_startPoint.x - endPoint.x), fabs(_startPoint.y - endPoint.y));
        if (distance > 5) {
            // Deselect annotation after dragging, so we don't auto-popup the menu.
            self.selectedAnnotations = nil;
        }
    }
    return [super longPress:recognizer];
}

static NSArray *PSCNoteAnnotationsAtPoint(PSPDFPageView *pageView, CGPoint viewPoint) {
    NSCParameterAssert(pageView);
    NSMutableArray *noteAnnotations = [NSMutableArray array];
    for (PSPDFAnnotation *annotation in [pageView tappableAnnotationsAtPoint:viewPoint]) {
        if (annotation.type == PSPDFAnnotationTypeNote) {
            [noteAnnotations addObject:annotation];
        }
    }
    return noteAnnotations;
}

- (BOOL)pressRecognizerShouldHandlePressImmediately:(PSPDFLongPressGestureRecognizer *)recognizer {
    // Select a note annotation as soon as we start touching it, making dragging instant.
    NSArray *noteAnnotations = PSCNoteAnnotationsAtPoint(self, [recognizer locationInView:self]);
    if (noteAnnotations.count > 0) {
        self.selectedAnnotations = @[noteAnnotations.firstObject];
    }
    return [super pressRecognizerShouldHandlePressImmediately:recognizer];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Notification Processing

- (void)updateNoteAnnotationImages {
    for (UIView *annotationView in self.annotationContainerView.subviews) {
        if ([annotationView isKindOfClass:PSPDFNoteAnnotationView.class]) {
            [(PSPDFNoteAnnotationView *)annotationView updateImage];
        }
    }
}

- (void)annotationsAddedNotification:(NSNotification *)notification {
    [super annotationsAddedNotification:notification];
    [self updateNoteAnnotationImages];
}

// Especially when we delete notes, we need to re-number them!
- (void)annotationsRemovedNotification:(NSNotification *)notification {
    [super annotationsRemovedNotification:notification];
    [self updateNoteAnnotationImages];
}

- (void)annotationChangedNotification:(NSNotification *)notification {
    [super annotationChangedNotification:notification];
    [self updateNoteAnnotationImages];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFNoteAnnotationViewControllerDelegate

- (void)noteAnnotationController:(PSPDFNoteAnnotationViewController *)noteAnnotationController didDeleteAnnotation:(PSPDFAnnotation *)annotation {
    // NOP
}

- (void)noteAnnotationController:(PSPDFNoteAnnotationViewController *)noteAnnotationController didClearContentsForAnnotation:(PSPDFAnnotation *)annotation {
    // NOP
}

@end

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCCustomNoteAnnotationViewController

@implementation PSCCustomNoteAnnotationViewController {
    UIToolbar *_noteToolbar;
    UIToolbar *_bottomToolbar;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    BOOL isNewlyCreatedAnnotation = self.annotation.contents.length == 0;

    // Create the top control toolbar.
    _noteToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44.f)];
    _noteToolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _noteToolbar.barTintColor = isNewlyCreatedAnnotation ? PSCCustomNewTintColor : PSCCustomCreatedTintColor;
    _noteToolbar.tintColor = UIColor.whiteColor;
    _noteToolbar.translucent = NO;
    _noteToolbar.clipsToBounds = YES;
    [self.view addSubview:_noteToolbar];

    // Set up the buttons.
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
    if (isNewlyCreatedAnnotation) {
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:PSPDFLocalize(@"Cancel") style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonPressed:)];
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:PSPDFLocalize(@"Save") style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonPressed:)];
        _noteToolbar.items = @[cancelButton, spacer, saveButton];
    }else {
        NSUInteger noteNumber = PSCNumberOfAnnotationOfType(self.annotation);
        // Use custom view to make this non-clickable.
        UIBarButtonItem *titleButton = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:PSPDFLocalize(@"Note %d"), noteNumber] style:UIBarButtonItemStylePlain target:nil action:NULL];
        // TODO: add any other buttons here (clock button...)
        _noteToolbar.items = @[titleButton, spacer];
        _noteToolbar.userInteractionEnabled = NO; // So title isn't clickable.

        // Also add bottom toolbar.
        _bottomToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 44.f, self.view.bounds.size.width, 44.f)];
        _bottomToolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
        _bottomToolbar.clipsToBounds = YES;
        [self.view addSubview:_bottomToolbar];

        // Populate bottom toolbar
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:PSPDFLocalize(@"Delete") style:UIBarButtonItemStylePlain target:self action:@selector(deleteAnnotation:)];
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:PSPDFLocalize(@"Close") style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonPressed:)];
        _bottomToolbar.items = @[cancelButton, spacer, saveButton];
        _bottomToolbar.tintColor = PSCCustomCreatedTintColor;
    }

    // Style the view controller.
    self.view.layer.borderColor = (isNewlyCreatedAnnotation ? PSCCustomNewTintColor : PSCCustomCreatedTintColor).CGColor;
    self.view.layer.borderWidth = 1.f;

    // Better animation.
    self.textView.clipsToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // Clear previous items, make sure text menu and other menu isn't mixed.
    [UIMenuController.sharedMenuController setMenuItems:nil];
}

- (void)updateTextView {
    [super updateTextView];

    // Position the text view slightly below so we have space for the toolbar.
    CGFloat bottomOffset = _bottomToolbar ? _bottomToolbar.frame.size.height : 0.f;
    self.textView.frame = CGRectMake(0, 44.f, self.view.bounds.size.width, self.view.bounds.size.height - (_noteToolbar.bounds.size.height + bottomOffset));

    self.textView.font = [UIFont systemFontOfSize:20.f];

    // Update colors (override, by default we would use the note annotation color)
    self.backgroundView.colors = @[[UIColor colorWithWhite:0.922 alpha:1.000]];
}

// Simply delete the annotation without confirmation.
- (void)cancelButtonPressed:(id)sender {
    [self deleteOrClearAnnotationWithoutConfirmation];
}

- (void)deleteOrClearAnnotationWithoutConfirmation {
    [super deleteOrClearAnnotationWithoutConfirmation];
    [self closeNoteController];
}

- (void)saveButtonPressed:(id)sender {
    [self.textView resignFirstResponder]; // hide keyboard
    [UIView animateWithDuration:0.7f delay:0.f usingSpringWithDamping:0.8f initialSpringVelocity:0.f options:kNilOptions animations:^{
        self.view.frame = self.sourceRect;
        self.view.alpha = 0.f;
        self.textView.textColor = UIColor.clearColor;
        _noteToolbar.items = nil;
        _bottomToolbar.items = nil;
    } completion:^(BOOL finished) {
        [self closeNoteController];
    }];
}

- (void)closeNoteController {
    [self.textView resignFirstResponder]; // hide keyboard
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];

    // Deselect note annotation.
    ((PSPDFPageView *)self.delegate).selectedAnnotations = nil;
}

@end

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCInvisibleResizableView

@implementation PSCNoteInvisibleResizableView

- (void)layoutSubviews {
    [super layoutSubviews];
    // Always hide view - don't show any selection state.
    self.alpha = 0.f;
}

@end

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCCustomNoteAnnotationView

@implementation PSCCustomNoteAnnotationView

- (UIImage *)renderNoteImage {
    NSUInteger noteNumber = PSCNumberOfAnnotationOfType(self.annotation);
    UIImage *noteImage = [UIImage imageNamed:@"alternative_note_image"];

    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.f);
    [noteImage drawAtPoint:CGPointZero];

    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:20.f],
                                 NSForegroundColorAttributeName : PSCCustomNewTintColor,
                                 NSParagraphStyleAttributeName : style};
    [[NSString stringWithFormat:@"%tu", noteNumber] drawInRect:CGRectMake(-2.f, 2.f, self.bounds.size.width, self.bounds.size.height) withAttributes:attributes];

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsGetCurrentContext();
    return image;
}

@end

#endif
