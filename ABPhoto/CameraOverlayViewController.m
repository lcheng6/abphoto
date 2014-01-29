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
    cameraParams.selectionParam = kRearCamera;
    cameraParams.gridParam = kGridOn;
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
    if(cameraParams.gridParam == kGridOn)
    {
        cameraParams.gridParam = kGridOff;
        gridImageView.alpha = .0f;
        [gridButton setTitle:@"N" forState:UIControlStateNormal];
    }else if (cameraParams.gridParam == kGridOff)
    {
        cameraParams.gridParam = kGridOn;
        gridImageView.alpha = .7f;
        [gridButton setTitle:@"Y" forState:UIControlStateNormal];
    }
}
- (IBAction)cameraSelectionButtonPressed:(id)sender {
    assert(imagePickerController != nil);
    if (cameraParams.selectionParam == kFrontCamera)
    {
        cameraParams.selectionParam = kRearCamera;
        [cameraSelectionButton setTitle:@"R" forState:UIControlStateNormal]; //R for front
        imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
    else if(cameraParams.selectionParam == kRearCamera) {
        cameraParams.selectionParam = kFrontCamera;
        [cameraSelectionButton setTitle:@"F" forState:UIControlStateNormal]; //F for rear
        imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }
    [self loadCameraCapabilities];
}

- (IBAction)flashSelectionButtonPressed:(id)sender {
    assert(imagePickerController != nil);
    if (cameraParams.flashParam == kFlashAuto)
    {
        cameraParams.flashParam = kFlashOn;
        [flashSelectionButton setTitle:@"O" forState:UIControlStateNormal];
        imagePickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;
        
    }else if (cameraParams.flashParam == kFlashOn) {
        cameraParams.flashParam = kFlashOff;
        [flashSelectionButton setTitle:@"F" forState:UIControlStateNormal];
        imagePickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
        
    }else if (cameraParams.flashParam == kFlashOff) {
        cameraParams.flashParam = kFlashAuto;
        [flashSelectionButton setTitle:@"A" forState:UIControlStateNormal];
        imagePickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
    }
}

- (void)loadCameraCapabilities {
    
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
    if (cameraParams.capability != kCameraBackAndFront) {
        [cameraSelectionButton setEnabled:NO];
    }
    
    Boolean flash = false;
    if(cameraParams.selectionParam == kFrontCamera) {
        flash = [UIImagePickerController isFlashAvailableForCameraDevice:UIImagePickerControllerCameraDeviceFront];
        
    }else if(cameraParams.selectionParam == kRearCamera) {
        flash = [UIImagePickerController isFlashAvailableForCameraDevice:UIImagePickerControllerCameraDeviceRear];
    }
    if (flash) {
        cameraParams.flashParam = kFlashAuto;
        [flashSelectionButton setTitle:@"A" forState:UIControlStateNormal];
        [flashSelectionButton setEnabled:YES];
    } else {
        cameraParams.flashParam = kFlashNotAvailable;
        [flashSelectionButton setEnabled:NO];
    }
    
}


@end
