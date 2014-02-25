//
//  SharePhotoViewController.m
//  ABPhoto
//
//  Created by Liang Cheng on 1/30/14.
//  Copyright (c) 2014 Liang Cheng. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import <FacebookSDK/FBLoginView.h>
#import "SharePhotoViewController.h"

@interface SharePhotoViewController ()
{
    UIActionSheet * actionSheet;
    Boolean fbLoggedIn;
}
@end

@implementation SharePhotoViewController
@synthesize originalPhotoForShare;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    photoForShareImageView.image = originalPhotoForShare;
    
    [self setupShareSheet];
    [FBLoginView class];
    fbLoggedIn = false;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Implement the loginViewShowingLoggedInUser: delegate method to modify your app's UI for a logged-in user experience
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    // If the user is logged in, they can post to Facebook using API calls, so we show the buttons
    fbLoggedIn = TRUE;
}

// Implement the loginViewShowingLoggedOutUser: delegate method to modify your app's UI for a logged-out user experience
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    // If the user is NOT logged in, they can't post to Facebook using API calls, so we show the button
    fbLoggedIn = FALSE;
}


/*
- (IBAction)shareButtonPressed:(id)sender {
    NSLog(@"Share Button Pressed");
    NSString *shareTest = @"@American Boxing and Fitness";
    UIImage * imageToShare = originalPhotoForShare;
    NSMutableArray * shareArray = [[NSMutableArray alloc] initWithObjects:shareTest, imageToShare, nil];
    
    UIActivityViewController * activityController = [[UIActivityViewController alloc] initWithActivityItems:shareArray applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
}
 */

- (void) setupShareSheet{
    actionSheet = [[UIActionSheet alloc] initWithTitle:@"Sharing" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: nil];
    
}
- (IBAction)shareButtonPressed:(id)sender {
    //In this function, need to use presentOSIntegratedShareDialogModallyFrom with FBDialog
    NSLog(@"Share Button Pressed");
    
    if (actionSheet != nil) {
        [actionSheet showInView:self.view];
    }
}

- (IBAction)updownMirrorButtonPressed:(id)sender {
}

- (IBAction)leftrightMirrorButtonPressed:(id)sender {
}

- (IBAction)leftRotateButtonPressed:(id)sender {
}

- (IBAction)rightRotateButtonPressed:(id)sender {
}

- (IBAction)leftrightMirrorbuttonPressed:(id)sender {
}


@end
