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
@synthesize cameraParams;

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
    
    //Default camera choice is the back camera, of course.
    cameraParams.selectionParam = kBackCamera;
    [self loadCameraCapabilities];
    if (cameraParams.capability == kCameraNotAvailable) {
        [gridButton setEnabled:NO];
        [cameraSelectionButton setEnabled:NO];
        [flashSelectionButton setEnabled:NO];
    } else if (cameraParams.capability == kCameraBackOnly) {
        [cameraSelectionButton setEnabled:NO];
    }
    
    if(cameraParams.flashParam == kFlashNotAvailable) {
        [flashSelectionButton setEnabled:NO];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)shutterButtonPressed:(id)sender {
    if (imagePickerController != nil) {
        [imagePickerController takePicture];
    }
}

- (IBAction)gridButtonPressed:(id)sender {
}
- (IBAction)cameraSelectionButtonPressed:(id)sender {
    
}

- (IBAction)flashSelectionButtonPressed:(id)sender {
}

- (void)loadCameraCapabilities {
    if(imagePickerController != nil) {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            Boolean front;
            Boolean back;
            front = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
            back = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
            if(front && back) {
                cameraParams.capability = kCameraBackAndFront;
            }else if (back) {
                cameraParams.capability = kCameraBackOnly;
            }
        } else {
            cameraParams.capability = kCameraNotAvailable;
        }
    }
    Boolean flash;
    if(cameraParams.selectionParam == kFrontCamera) {
        flash = [UIImagePickerController isFlashAvailableForCameraDevice:UIImagePickerControllerCameraDeviceFront];
        
    }else {
        flash = [UIImagePickerController isFlashAvailableForCameraDevice:UIImagePickerControllerCameraDeviceRear];
    }
    if (flash) {
        cameraParams.flashParam = kFlashAuto;
    }
    
}


@end
