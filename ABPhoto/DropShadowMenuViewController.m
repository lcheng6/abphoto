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
    int _selectedIconIndex;
    UIImage * _logoImage;
    UILabel * _title;
    NSMutableArray * _shadowOffsets;
    NSMutableArray * _shadowBlurValues;
    
}

@property (nonatomic, strong) NSMutableArray * shadowIcons;
@property (nonatomic, strong) NSMutableArray * shadowIconViews;
@end

static int numIcons = 7;
@implementation DropShadowMenuViewController
@synthesize shadowIcons;
@synthesize shadowIconViews;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _selectedIconIndex = 0;
    
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondToShadowSelection:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.numberOfTouchesRequired =1;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    [self buildOffsetAndBlurValuesArray];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) buildOffsetAndBlurValuesArray {
    _shadowOffsets = [NSMutableArray array];
    
    [_shadowOffsets addObject:[NSValue valueWithCGSize:CGSizeMake(0.0f, 0.0f)]];
    
    [_shadowOffsets addObject:[NSValue valueWithCGSize:CGSizeMake(0.0f, 0.0f)]];
    [_shadowOffsets addObject:[NSValue valueWithCGSize:CGSizeMake(0.0f, 0.0f)]];
    
    [_shadowOffsets addObject:[NSValue valueWithCGSize:CGSizeMake(0.0f, 4.0f)]];
    [_shadowOffsets addObject:[NSValue valueWithCGSize:CGSizeMake(0.0f, 5.0f)]];
    
    [_shadowOffsets addObject:[NSValue valueWithCGSize:CGSizeMake(4.0f, 4.0f)]];
    [_shadowOffsets addObject:[NSValue valueWithCGSize:CGSizeMake(5.0f, 5.0f)]];
    
    _shadowBlurValues = [NSMutableArray array];
    [_shadowBlurValues addObject:[NSNumber numberWithFloat:0.0f]];
    
    [_shadowBlurValues addObject:[NSNumber numberWithFloat:3.5f]];
    [_shadowBlurValues addObject:[NSNumber numberWithFloat:4.5f]];
    
    [_shadowBlurValues addObject:[NSNumber numberWithFloat:4.0f]];
    [_shadowBlurValues addObject:[NSNumber numberWithFloat:5.0f]];
    
    [_shadowBlurValues addObject:[NSNumber numberWithFloat:4.0f]];
    [_shadowBlurValues addObject:[NSNumber numberWithFloat:5.0f]];
    
}

- (void) setShadowColor:(UIColor *)shadowColor
{
    //TODO: need to fix this
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
    for (int i=0; i< [_shadowOffsets count]; i++) {
        UIGraphicsBeginImageContext(iconSize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        UIImage * newIcon= nil;
        
        CGSize shadowOffset = [[_shadowOffsets objectAtIndex:i] CGSizeValue];
        CGFloat blurRadius = [[_shadowBlurValues objectAtIndex:i] floatValue];
        
        UIBezierPath * roundSquare = [UIBezierPath bezierPathWithRoundedRect:roundSquareRect cornerRadius:20.0f];
        [[UIColor whiteColor] setFill];
        [roundSquare fill];
        CGContextScaleCTM(context, widthScale, heightScale);
        
        if (i != 0) {
            CGContextSetShadowWithColor(context, shadowOffset, blurRadius, [[UIColor redColor] CGColor]);
        }
        [logoImage drawInRect:CGRectMake(0, 0, logoImage.size.width, logoImage.size.height)];
        
        //CGContextDrawImage(context, roundSquareRect, logoImage.CGImage);
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
    
    _selectedIconIndex = 0;
    [self drawSquareAroundSelectedShadowIcon];

    
    CGRect titleRect;
    titleRect.origin.x = 0; titleRect.origin.y = 66;
    titleRect.size.width = [DropShadowMenuViewController recommendedSize].width;
    titleRect.size.height = 15;
    _title = [[UILabel alloc] initWithFrame:titleRect];
    _title.text = @"Drop Shadow";
    _title.textColor = [UIColor whiteColor];
    _title.textAlignment = NSTextAlignmentCenter;
    _title.font = [UIFont systemFontOfSize:14.0f];
    [self.view addSubview:_title];

}
- (float)getShadowRadius {
    NSNumber * shadowRadiusNum = [_shadowBlurValues objectAtIndex:_selectedIconIndex];
    return [shadowRadiusNum floatValue];
}

- (CGSize) getShadowOffset {
    NSValue * shadowOffsetValue = [_shadowOffsets objectAtIndex:_selectedIconIndex];

    return [shadowOffsetValue CGSizeValue];
}


- (void) deSelectShadowIcon {
    UIImage * iconWithSelectedDropShadow = nil;
    CGSize iconSize;
    CGRect logoRect;
    CGRect roundSquareRect;
    
    iconSize.width = 65*2;
    iconSize.height = 65*2;
    
    logoRect.size = iconSize;
    logoRect.origin = CGPointMake(0.0f, 0.0f);
    
    roundSquareRect.size = CGSizeMake(60*2, 60*2);
    roundSquareRect.origin = CGPointMake(5, 5);
    
    float widthScale = iconSize.width / _logoImage.size.width;
    float heightScale = iconSize.height / _logoImage.size.height;
    
    UIGraphicsBeginImageContext(iconSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    context = UIGraphicsGetCurrentContext();
    
    //draw white rounded icon
    UIBezierPath * roundSquare = [UIBezierPath bezierPathWithRoundedRect:roundSquareRect cornerRadius:20.0f];
    [[UIColor whiteColor] setFill];
    [roundSquare fill];
    
    //draw the logo image with drop shadow.
    CGSize shadowOffset = [[_shadowOffsets objectAtIndex:_selectedIconIndex] CGSizeValue];
    CGFloat blurRadius = [[_shadowBlurValues objectAtIndex:_selectedIconIndex] floatValue];
    CGContextScaleCTM(context, widthScale, heightScale);
    if(_selectedIconIndex != 0) {
        CGContextSetShadowWithColor(context, shadowOffset, blurRadius, [[UIColor redColor] CGColor]);
    }
    [_logoImage drawInRect:CGRectMake(0, 0, _logoImage.size.width, _logoImage.size.height)];
    
    iconWithSelectedDropShadow = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    [shadowIcons replaceObjectAtIndex:_selectedIconIndex withObject:iconWithSelectedDropShadow];
    
    UIImageView * iconView  = [shadowIconViews objectAtIndex:_selectedIconIndex];
    iconView.image = iconWithSelectedDropShadow;
    
}

- (void) drawSquareAroundSelectedShadowIcon {
    
    UIImage * iconWithSelectedDropShadow = nil;
    CGSize iconSize;
    CGRect logoRect;
    CGRect roundSquareRect;
    
    iconSize.width = 65*2;
    iconSize.height = 65*2;
    
    logoRect.size = iconSize;
    logoRect.origin = CGPointMake(0.0f, 0.0f);
    
    roundSquareRect.size = CGSizeMake(60*2, 60*2);
    roundSquareRect.origin = CGPointMake(5, 5);
    
    float widthScale = iconSize.width / _logoImage.size.width;
    float heightScale = iconSize.height / _logoImage.size.height;
    
    UIGraphicsBeginImageContext(iconSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    context = UIGraphicsGetCurrentContext();
    
    //draw the corner with rounded corner
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:logoRect cornerRadius:2.0f];
    path.lineWidth = 4.0f;
    [[[[[UIApplication sharedApplication] delegate] window] tintColor] setStroke];
    [path stroke];
    
    //draw white rounded icon
    UIBezierPath * roundSquare = [UIBezierPath bezierPathWithRoundedRect:roundSquareRect cornerRadius:20.0f];
    [[UIColor whiteColor] setFill];
    [roundSquare fill];
    
    //draw the logo image with drop shadow.
    CGSize shadowOffset = [[_shadowOffsets objectAtIndex:_selectedIconIndex] CGSizeValue];
    CGFloat blurRadius = [[_shadowBlurValues objectAtIndex:_selectedIconIndex] floatValue];
    CGContextScaleCTM(context, widthScale, heightScale);
    if (_selectedIconIndex != 0) {
        CGContextSetShadowWithColor(context, shadowOffset, blurRadius, [[UIColor redColor] CGColor]);
    }
    [_logoImage drawInRect:CGRectMake(0, 0, _logoImage.size.width, _logoImage.size.height)];
    
    iconWithSelectedDropShadow = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    [shadowIcons replaceObjectAtIndex:_selectedIconIndex withObject:iconWithSelectedDropShadow];
    
    UIImageView * iconView  = [shadowIconViews objectAtIndex:_selectedIconIndex];
    iconView.image = iconWithSelectedDropShadow;
    
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
    if (regionIndex > numIcons) {
        return;
    }else {
        if(regionOffset <10) {
            return;
        }else {
            [self deSelectShadowIcon];
            _selectedIconIndex = regionIndex;
            [self drawSquareAroundSelectedShadowIcon];
            
            [self.delegate modifyOverlayDropShadowParameter:[self getShadowOffset] shadowOpacity:[self getShadowRadius]];
        }
    }
}
+ (CGSize) recommendedSize
{
    CGSize size;
    size.height = 80;
    //5 images and 6 gaps of 10 units between each
    size.width = 65 * numIcons + 10 * numIcons;
    
    return size;
}


@end
