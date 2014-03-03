//
//  SharePhotoViewController.m
//  ABPhoto
//
//  Created by Liang Cheng on 1/30/14.
//  Copyright (c) 2014 Liang Cheng. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import <FacebookSDK/FBLoginView.h>
#import <FacebookSDK/FBDialogs.h>
#import "SharePhotoViewController.h"

@interface SharePhotoViewController ()
{
    UIActionSheet * actionSheet;
    Boolean fbLoggedIn;
}
@property (weak, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;
@end

NSString * const boxingURL = @"http://americanboxing.net/boxing";
NSString * const muayThaiURL = @"http://americanboxing.net/muay-thai";
NSString * const jiuJitsuiURL= @"http://americanboxing.net/jiu-jitsu";
NSString * const gymURL = @"http://americanboxing.net/";

NSString * const gymLogoURL = @"http://i.imgur.com/3qxV03c.png";
NSString * const boxingTitle = @"Kicking Ass";
NSString * const muayThaiTitle = @"Sweating like a Champ";
NSString * const jiuJitsuiTitle = @"Rolling";
NSString * const gymTitle = @"American Boxing and Fitness";

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
    [FBProfilePictureView class];
    fbLoggedIn = false;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    self.profilePictureView.profileID = user.id;
    //self.nameLabel.text = user.name;
}

// Implement the loginViewShowingLoggedInUser: delegate method to modify your app's UI for a logged-in user experience
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    // If the user is logged in, they can post to Facebook using API calls, so we show the buttons
    fbLoggedIn = TRUE;
}

// Implement the loginViewShowingLoggedOutUser: delegate method to modify your app's UI for a logged-out user experience
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    // If the user is NOT logged in, they can't post to Facebook using API calls, so we show the button
    self.profilePictureView.profileID = nil;
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
    actionSheet = [[UIActionSheet alloc] initWithTitle:@"Facebook Post" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: @"Boxing", @"Muay Thai", @"Jiu Jitsu", @"General", Nil];
    actionSheet.delegate = self;
}
- (IBAction)shareButtonPressed:(id)sender {
    //In this function, need to use presentOSIntegratedShareDialogModallyFrom with FBDialog
    NSLog(@"Share Button Pressed");
    
    if (actionSheet != nil && fbLoggedIn) {
        [actionSheet showInView:self.view];
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger) selectionIndex
{
    NSString * linkedPage = @"";
    NSString * classTitle = @"";
    NSLog(@"Selected Index: %d", selectionIndex);
    switch(selectionIndex) {
        case 0:
            linkedPage = boxingURL;
            break;
        case 1:
            linkedPage = muayThaiURL;
            break;
        case 2:
            linkedPage = jiuJitsuiURL;
            break;
        case 3:
            linkedPage = gymURL;
            break;
        default:
            return;
    }
    
    switch (selectionIndex) {
        case 0:
            classTitle = boxingTitle;
            break;
        case 1:
            classTitle = muayThaiTitle;
            break;
        case 2:
            classTitle = jiuJitsuiTitle;
            break;
        case 3:
            classTitle = gymTitle;
            break;
    }
    
    
    [FBRequestConnection startForUploadStagingResourceWithImage:originalPhotoForShare completionHandler: ^(FBRequestConnection *connection, id result, NSError *error) {
        if(!error) {
            // Log the uri of the staged image
            NSLog(@"Successfuly staged image with staged URI: %@", [result objectForKey:@"uri"]);
            
            // Further code to post the OG story goes here
            
            // instantiate a Facebook Open Graph object
            NSMutableDictionary<FBOpenGraphObject> *object = [FBGraphObject openGraphObjectForPost];
            
            // specify that this Open Graph object will be posted to Facebook
            object.provisionedForPost = YES;
            
            // for og:title
            object[@"title"] = classTitle;
            
            // for og:type, this corresponds to the Namespace you've set for your app and the object type name
            object[@"type"] = @"com_liang_abphoto:dish";
            
            // for og:description
            object[@"description"] = @"Test Description, sweating and cramping";
            
            // for og:url, we cover how this is used in the "Deep Linking" section below
            object[@"url"] = linkedPage;
            
            object[@"locale"] = @"en_US";
            //object[@"start_time"] = @"2014-03-03T02:20:20-0000";
            //object[@"end_time"] =   @"2014-03-03T02:30:30-0000";
            
            // for og:image we assign the image that we just staged, using the uri we got as a response
            // the image has to be packed in a dictionary like this:
            object[@"image"] = @"http://i.imgur.com/3qxV03c.png";
            //object[@"image"] = @[@{@"url": [result objectForKey:@"uri"], @"user_generated" : @"false" }];
            //object[@"image"] = @"http://i.imgur.com/VVCDPlm.jpg";
            
            
            // Post custom object
            [FBRequestConnection startForPostOpenGraphObject:object completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if(!error) {
                    // get the object ID for the Open Graph object that is now stored in the Object API
                    NSString *objectId = [result objectForKey:@"id"];
                    NSLog(@"object id: %@", objectId);
                    
                    // Further code to post the OG story goes here
                    
                } else {
                    // An error occurred
                    NSLog(@"Error posting the Open Graph object to the Object API: %@", error);
                }
            }];
            
            id<FBGraphPlace> place = (id<FBGraphPlace>)[FBGraphObject graphObject];
            [place setId:@"189738577724062"]; // American Boxing

            // create an Open Graph action
            id<FBOpenGraphAction> action = (id<FBOpenGraphAction>)[FBGraphObject graphObject];
            [action setObject:object forKey:@"eat"];
            [action setPlace:place];
            //[action setImage:@"http://i.imgur.com/3qxV03c.png"];
            [action setImage:@[@{@"url": [result objectForKey:@"uri"], @"user_generated" : @"false" }]];
            
            //[action set]
            
            // create action referencing user owned object
            [FBRequestConnection startForPostWithGraphPath:@"/me/com_liang_abphoto:eat" graphObject:action completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if(!error) {
                    NSLog(@"OG story posted, story id: %@", [result objectForKey:@"id"]);
                    [[[UIAlertView alloc] initWithTitle:@"OG story posted"
                                                message:@"Check your Facebook profile or activity log to see the story."
                                               delegate:self
                                      cancelButtonTitle:@"OK!"
                                      otherButtonTitles:nil] show];
                } else {
                    // An error occurred
                    NSLog(@"Encountered an error posting to Open Graph: %@", error);
                }
            }];
            
        } else {
            // An error occurred
            NSLog(@"Error staging an image: %@", error);
        }
    }];
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
