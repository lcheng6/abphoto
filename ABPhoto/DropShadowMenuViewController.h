//
//  DropShadowMenuViewController.h
//  ABPhoto
//
//  Created by Liang Cheng on 2/3/14.
//  Copyright (c) 2014 Liang Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectedPhotoViewController.h"

@interface DropShadowMenuViewController : UIViewController
{
    
}

- (void) setLogoImage:(UIImage*) logoImage;
- (void) setShadowColor: (UIColor*) shadowColor;
- (float) getShadowRadius;
- (CGSize) getShadowOffset;

@property(nonatomic, weak) id<OverlayParameterModificationDelegate> delegate;
+ (CGSize) recommendedSize;

@end
