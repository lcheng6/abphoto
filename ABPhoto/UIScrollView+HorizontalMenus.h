//
//  UIScrollView+HorizontalMenus.h
//  ABPhoto
//
//  Created by Liang Cheng on 2/4/14.
//  Copyright (c) 2014 Liang Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BaseImageFilterMenuViewController.h"
#import "DropShadowMenuViewController.h"
#import "OpacityMenuViewController.h"
#import "OverlayColorMenuViewController.h"
#import "OverlaySelectionMenuViewController.h"

@interface UIScrollView(HorizontalMenus) <UIScrollViewDelegate>

-(void) setPageControl:(UIPageControl *) pageControl;
-(void) setFilterMenuController:(BaseImageFilterMenuViewController*) baseImageFilterSelectionController;
-(void) setOpacityMenuController:(OpacityMenuViewController *)opacitySelectionController;

@end
