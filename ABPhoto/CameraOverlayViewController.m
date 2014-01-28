//
//  CameraOverlayViewController.m
//  ABPhoto
//
//  Created by Liang Cheng on 1/28/14.
//  Copyright (c) 2014 Liang Cheng. All rights reserved.
//

#import "CameraOverlayViewController.h"

@interface CameraOverlayViewController ()

@end

@implementation CameraOverlayViewController
@synthesize imagePickerController;

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)shutterButton:(id)sender {
    if (imagePickerController!= NULL) {
        [imagePickerController takePicture];
    }
    //TODO: need to set up the dismiss view routine in the 
}
- (IBAction)shutterButtonPressed:(id)sender {
}

- (IBAction)gridButtonPressed:(id)sender {
}
- (IBAction)cameraSelectionButtonPressed:(id)sender {
}

- (IBAction)flashSelectionButtonPressed:(id)sender {
}
@end
