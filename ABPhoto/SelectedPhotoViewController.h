//
//  SelectedPhotoViewController.h
//  ABPhoto
//
//  Created by Liang Cheng on 1/28/14.
//  Copyright (c) 2014 Liang Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+Filters.h"

@protocol OverlayParameterModificationDelegate <NSObject>
@required
-(void) modifyOverlayFilterIndexParameter:(int)overlaySelectionIndex;
-(void) modifyOverlayColorParameter:(CGColorRef) color;
-(void) modifyOverlayOpacityParameter:(float) alpha;
-(void) modifyOverlayDropShadowParameter:(CGPoint) dropShadowParam;

@end

typedef struct {
    float scale;
    CGPoint translation;
    float rotation;
    CGAffineTransform logoTransform;
} LogoTransform;

typedef struct {
    int overlaySelectionIndex;
    CGColorRef color;
    float alpha;
    CGPoint dropShadowParam;
} OverlayParameter;

typedef struct {
    UIImageFilterType filterType;
}BaseImageParameter;

@interface SelectedPhotoViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, OverlayParameterModificationDelegate, UIScrollViewDelegate>
{
    __weak IBOutlet UIImageView *baseImageView;
    __weak IBOutlet UIImageView *overlayImageView;
    __weak IBOutlet UIScrollView *scrollMenuView;
    __weak IBOutlet UIPageControl *pageControl;
    
}
- (IBAction)cameraButtonPressed:(id)sender;
- (UIImage *)generateCombinedImage;

@end
