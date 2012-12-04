//
//  GSDropboxActivity.m
//
//  Created by Simon Whitaker on 19/11/2012.
//  Copyright (c) 2012 Goo Software Ltd. All rights reserved.
//

#import "GSDropboxActivity.h"
#import "GSDropboxDestinationSelectionViewController.h"
#import "GSDropboxUploader.h"
#import <DropboxSDK/DropboxSDK.h>

@interface GSDropboxActivity() <GSDropboxDestinationSelectionViewControllerDelegate>

@property (nonatomic, copy) NSArray *activityItems;
@property (nonatomic, retain) GSDropboxDestinationSelectionViewController *dropboxDestinationViewController;
@end

@implementation GSDropboxActivity

+ (NSString *)activityTypeString
{
    return @"uk.co.goosoftware.DropboxActivity";
}

- (NSString *)activityType {
    return [GSDropboxActivity activityTypeString];
}

- (NSString *)activityTitle {
    return NSLocalizedString(@"Dropbox", @"Name of the service at www.dropbox.com");
}
- (UIImage *)activityImage {
    return [UIImage imageNamed:@"GSDropboxActivityIcon"];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    for (id obj in activityItems) {
        if ([obj isKindOfClass:[NSURL class]] || [obj isKindOfClass:[UIImage class]]) {
            return YES;
        }
    }
    return NO;
};

- (void)prepareWithActivityItems:(NSArray *)activityItems {
    self.activityItems = activityItems;
}

- (UIViewController *)activityViewController {
    GSDropboxDestinationSelectionViewController *vc = [[GSDropboxDestinationSelectionViewController alloc] initWithStyle:UITableViewStylePlain];
    vc.delegate = self;

    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    nc.modalPresentationStyle = UIModalPresentationFormSheet;
    
    return nc;
}

#pragma mark - GSDropboxDestinationSelectionViewController delegate methods

- (void)dropboxDestinationSelectionViewController:(GSDropboxDestinationSelectionViewController *)viewController
                         didSelectDestinationPath:(NSString *)destinationPath
{
    for (__strong NSURL *fileURL in self.activityItems) {
        // only allow NSURL
        if ([fileURL isKindOfClass:[NSURL class]]) {
            [[GSDropboxUploader sharedUploader] uploadFileWithURL:fileURL toPath:destinationPath];
        }
    }
    self.activityItems = nil;
    [self activityDidFinish:YES];
}

- (void)dropboxDestinationSelectionViewControllerDidCancel:(GSDropboxDestinationSelectionViewController *)viewController
{
    self.activityItems = nil;
    [self activityDidFinish:NO];
}

@end
