//
//  SelectedPhotoViewController.h
//  ABPhoto
//
//  Created by Liang Cheng on 1/28/14.
//  Copyright (c) 2014 Liang Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct {
    float scale;
    CGPoint translation;
    float rotation;
    CGAffineTransform logoTransform;
} LogoTransform;

@interface SelectedPhotoViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    __weak IBOutlet UIImageView *baseImage;
    __weak IBOutlet UIImageView *overlayImage;
    __weak IBOutlet UIScrollView *scrollMenuView;
    
}
- (IBAction)cameraButtonPressed:(id)sender;
- (UIImage *)generateCombinedImage;

@end
