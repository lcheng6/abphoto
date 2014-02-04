//
//  BaseImageFilterMenuViewController.h
//  ABPhoto
//
//  Created by Liang Cheng on 2/3/14.
//  Copyright (c) 2014 Liang Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectedPhotoViewController.h"

@interface BaseImageFilterMenuViewController : UIViewController
{
}


@property (nonatomic, weak) id<OverlayParameterModificationDelegate> delegate;
- (int) getSelectedFilterIndex;
- (void) setBaseImage:(UIImage*) baseImage;
+(CGSize) recommendedSize;

@end


