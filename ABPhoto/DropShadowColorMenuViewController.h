//
//  DropShadowColorMenuViewController.h
//  ABPhoto
//
//  Created by Liang Cheng on 2/9/14.
//  Copyright (c) 2014 Liang Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectedPhotoViewController.h"

@interface DropShadowColorMenuViewController : UIViewController
{
    
}

- (UIColor * ) getShadowColor;
@property(nonatomic, weak) id<OverlayParameterModificationDelegate> delegate;
+ (CGSize) recommededSize;
@end
