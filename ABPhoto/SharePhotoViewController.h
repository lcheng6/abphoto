//
//  SharePhotoViewController.h
//  ABPhoto
//
//  Created by Liang Cheng on 1/30/14.
//  Copyright (c) 2014 Liang Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SharePhotoViewController : UIViewController
{
    __weak IBOutlet UIImageView *photoForShareImageView;
    
}
@property (nonatomic, strong) UIImage * photoForShare;

@end
