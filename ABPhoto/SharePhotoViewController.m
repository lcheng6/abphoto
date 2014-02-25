//
//  SharePhotoViewController.m
//  ABPhoto
//
//  Created by Liang Cheng on 1/30/14.
//  Copyright (c) 2014 Liang Cheng. All rights reserved.
//

#import "SharePhotoViewController.h"
#import <Social/Social.h>

@interface SharePhotoViewController ()
{
    UIActionSheet * actionSheet;
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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)shareButtonPressed:(id)sender {
    NSLog(@"Share Button Pressed");
    NSString *shareTest = @"@American Boxing and Fitness";
    UIImage * imageToShare = originalPhotoForShare;
    NSMutableArray * shareArray = [[NSMutableArray alloc] initWithObjects:shareTest, imageToShare, nil];
    
    UIActivityViewController * activityController = [[UIActivityViewController alloc] initWithActivityItems:shareArray applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
}
@end
