//
//  OpacityMenuViewController.h
//  ABPhoto
//
//  Created by Liang Cheng on 1/31/14.
//  Copyright (c) 2014 Liang Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectedPhotoViewController.h"

@interface OpacityMenuViewController : UIViewController
{
    
}

-(void) setLogoImage:(UIImage *) logoImage;
-(float) getSelectedOpacity;
@property (nonatomic, assign) id<OverlayParameterModificationDelegate> delegate;
+(CGSize) recommendedSize;

@end
