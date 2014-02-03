//
//  OverlaySelectionMenuViewController.m
//  ABPhoto
//
//  Created by Liang Cheng on 2/1/14.
//  Copyright (c) 2014 Liang Cheng. All rights reserved.
//

#import "OverlaySelectionMenuViewController.h"

@interface OverlaySelectionMenuViewController ()
{
    UITapGestureRecognizer * tapGestureRecognizer;
    float _selectedOpacity;
    UILabel * _title;
}
@end

@implementation OverlaySelectionMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setLogoImage:(UIImage *) logoImage
{
    
}
- (CGPoint) getShadowParameter
{
    CGPoint param = CGPointMake(0, 0);
    return param;
}

- (void) respondToOpacitySelection:(UITapGestureRecognizer*)tap {
    //the layout of the icons in the x direction: 10 pts border 65 pts of image 10pts border 65 pts of image...
    
    CGPoint tapPoint = [tap locationInView:self.view];
    if(tapPoint.y>65) {
        //This is outside of the touch area of the icons in the layout, do nothing.
        return;
    }
    
    int regionIndex = (int)tapPoint.x / (65+10);
    int regionOffset = (int)tapPoint.x % (int)(65 + 10);
    if (regionIndex > 5) {
        return;
    }else {
        if(regionOffset <10) {
            return;
        }else {
            //[self deSelectOpacityIcon];
            //_selectedOpacity = 1.0f - (float)regionIndex * .2f;
            //[self drawSquareAroundSelectedOpacityIcon];
            //[self.delegate modifyOverlayDropShadowParameter:_selectedOpacity];
        }
    }
}

+ (CGSize) recommendedSize
{
    CGSize size;
    int numImages = 6;
    size.height = 80;
    //5 images and 6 gaps of 10 units between each
    size.width = 65 * numImages + 10 * numImages;
    
    return size;
}


@end
