//
//  OverlaySelectionMenuViewController.h
//  ABPhoto
//
//  Created by Liang Cheng on 2/1/14.
//  Copyright (c) 2014 Liang Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectedPhotoViewController.h"

@interface OverlaySelectionMenuViewController : UIViewController
{
    
}

- (CGPoint) getShadowParameter;
- (void)setLogoImage:(UIImage*) logoImage;
@property (nonatomic, weak) id<OverlayParameterModificationDelegate> delegate;
+ (CGSize) recommendedSize;

@end
