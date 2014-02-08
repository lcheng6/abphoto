//
//  SharePhotoViewController.m
//  ABPhoto
//
//  Created by Liang Cheng on 1/30/14.
//  Copyright (c) 2014 Liang Cheng. All rights reserved.
//

#import "SharePhotoViewController.h"

@interface SharePhotoViewController ()
{
    UIActionSheet * shareSheet;
}
@end

@implementation SharePhotoViewController
@synthesize photoForShare;

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
    photoForShareImageView.image = photoForShare;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)shareButtonPressed:(id)sender {
    shareSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: @"Fuck", @"Ass", @"Damn it", nil];
    //shareSheet.visible = YES;
    [shareSheet showFromBarButtonItem:sharePhotoButton animated:YES];
}
@end
