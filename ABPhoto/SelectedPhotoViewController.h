//
//  SelectedPhotoViewController.h
//  ABPhoto
//
//  Created by Liang Cheng on 1/28/14.
//  Copyright (c) 2014 Liang Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectedPhotoViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    __weak IBOutlet UIImageView *baseImage;
    
    __weak IBOutlet UIImageView *overlayImage;
}

@end
