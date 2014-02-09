//
//  DropShadowMenuViewController.m
//  ABPhoto
//
//  Created by Liang Cheng on 2/3/14.
//  Copyright (c) 2014 Liang Cheng. All rights reserved.
//

#import "DropShadowMenuViewController.h"

@interface DropShadowMenuViewController ()
{
    UITapGestureRecognizer * tapGestureRecognizer;
    float _logoOpacity;
    float _selectedShadowOpacity;
    CGPoint _selectedShadowOffset;
    UIImage * _logoImage;
    UILabel * _title;
    NSMutableArray * _shadowOffsets;
    
}

@property (nonatomic, strong) NSMutableArray * shadowIcons;
@property (nonatomic, strong) NSMutableArray * shadowIconViews;
@end

@implementation DropShadowMenuViewController
@synthesize shadowIcons;
@synthesize shadowIconViews;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _selectedShadowOpacity = 1.0f;
    _logoOpacity = 1.0f;
    _selectedShadowOffset = CGPointMake(0.0f, 0.0f);
    
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondToShadowSelection:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) buildOffsetArray {
    _shadowOffsets = [NSMutableArray array];
    
    [_shadowOffsets addObject:[NSValue valueWithCGPoint:CGPointMake(3.0f, 3.0f)]];
    [_shadowOffsets addObject:[NSValue valueWithCGPoint:CGPointMake(6.0f, 6.0f)]];
    [_shadowOffsets addObject:[NSValue valueWithCGPoint:CGPointMake(9.0f, 9.0f)]];
    [_shadowOffsets addObject:[NSValue valueWithCGPoint:CGPointMake(12.0f, 12.0f)]];
    [_shadowOffsets addObject:[NSValue valueWithCGPoint:CGPointMake(15.0f, 15.0f)]];
}
- (void) setOpacityOfLogoImage:(float)logoOpacity {
    _logoOpacity = logoOpacity;
}

- (void) setLogoImage:(UIImage *)logoImage {
    _logoImage = logoImage;
    
    CGSize iconSize;
    CGRect roundSquareRect;
    iconSize.width = 65*2;
    iconSize.height = 65*2;
    roundSquareRect.size = CGSizeMake(60*2, 60*2);
    roundSquareRect.origin = CGPointMake(5, 5);
    
    float widthScale = iconSize.width / _logoImage.size.width;
    float heightScale = iconSize.height / _logoImage.size.height;
    
    shadowIcons = [NSMutableArray array];
    for (int i=0; i< 5; i++) {
        UIGraphicsBeginImageContext(iconSize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        UIImage * newIcon= nil;
        
        //UIBezierPath * roundSquare = [UIBezierPath bezierPathWithRoundedRect:roundSquareRect cornerRadius:20.0f];
        //[[UIColor whiteColor] setFill];
        //[roundSquare fill];
        CGContextScaleCTM(context, widthScale, heightScale);
        [logoImage drawInRect:CGRectMake(0, 0, logoImage.size.width, logoImage.size.height)];
        newIcon = UIGraphicsGetImageFromCurrentImageContext();
        [shadowIcons addObject:newIcon];
        UIGraphicsEndImageContext();
    }

    shadowIconViews = [NSMutableArray array];
    for (int index = 0; index < [shadowIcons count]; index++) {
        UIImage * icon = [shadowIcons objectAtIndex:index];
        UIImageView * iconView = [[UIImageView alloc] initWithImage:icon];
        [shadowIconViews addObject:iconView];
    }

    CGRect imageFrameRect;
    imageFrameRect.size.width = 65;
    imageFrameRect.size.height = 65;
    for (int index = 0; index < [shadowIconViews count]; index++) {
        UIImageView * iconView = [shadowIconViews objectAtIndex:index];
        imageFrameRect.origin.x = 10 * (index+1) + 65 * index;
        imageFrameRect.origin.y = 0;
        
        iconView.frame = imageFrameRect;
        [self.view addSubview:iconView];
    }

    
    CGRect titleRect;
    titleRect.origin.x = 0; titleRect.origin.y = 66;
    titleRect.size.width = [DropShadowMenuViewController recommendedSize].width;
    titleRect.size.height = 15;
    _title = [[UILabel alloc] initWithFrame:titleRect];
    _title.text = @"DropShadow";
    _title.textColor = [UIColor whiteColor];
    _title.textAlignment = NSTextAlignmentCenter;
    _title.font = [UIFont systemFontOfSize:14.0f];
    [self.view addSubview:_title];

}
- (float)getShadowOpacity {
    return 0.0f;
}

- (CGPoint) getShadowOffset {
    return CGPointMake(0.0f, 0.0f);
}


- (void) deSelectShadowIcon {
    
}

- (void) drawSquareAroundSelectedShadowIcon {
    
}
- (void) respondToShadowSelection:(UITapGestureRecognizer *) tap {
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
            [self deSelectShadowIcon];
            _selectedShadowOpacity = 0.0f;
            _selectedShadowOffset = CGPointMake(0.0f, 0.0f);
            [self drawSquareAroundSelectedShadowIcon];
            [self.delegate modifyOverlayDropShadowParameter:_selectedShadowOffset shadowOpacity:_selectedShadowOpacity];
        }
    }
}
+ (CGSize) recommendedSize
{
    CGSize size;
    size.height = 80;
    //5 images and 6 gaps of 10 units between each
    size.width = 65 * 5 + 10 * 5;
    
    return size;
}


@end
