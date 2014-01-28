//
//  CameraOverlayViewController.h
//  ABPhoto
//
//  Created by Liang Cheng on 1/28/14.
//  Copyright (c) 2014 Liang Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraParameter.h"


@interface CameraOverlayViewController : UIViewController
{
    __weak IBOutlet UIButton *gridButton;
    __weak IBOutlet UIButton *cameraSelectionButton;
    __weak IBOutlet UIButton *flashSelectionButton;
    __weak IBOutlet UIImageView *gridImageView;
    
}

- (IBAction)shutterButtonPressed:(id)sender;
- (IBAction)gridButtonPressed:(id)sender;
- (IBAction)cameraSelectionButtonPressed:(id)sender;
- (IBAction)flashSelectionButtonPressed:(id)sender;
@property(nonatomic, weak) UIImagePickerController * imagePickerController;
@property(nonatomic, assign) CameraParams cameraParams;


@end
