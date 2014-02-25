//
//  SharePhotoViewController.h
//  ABPhoto
//
//  Created by Liang Cheng on 1/30/14.
//  Copyright (c) 2014 Liang Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>

@interface SharePhotoViewController : UIViewController <UIActionSheetDelegate>
{
    __weak IBOutlet UIImageView *photoForShareImageView;
    __weak IBOutlet UIBarButtonItem *sharePhotoButton;
    
}
@property (nonatomic, strong) UIImage * originalPhotoForShare;
- (IBAction)shareButtonPressed:(id)sender;
- (IBAction)updownMirrorButtonPressed:(id)sender;
- (IBAction)leftrightMirrorButtonPressed:(id)sender;
- (IBAction)leftRotateButtonPressed:(id)sender;
- (IBAction)rightRotateButtonPressed:(id)sender;



@end
