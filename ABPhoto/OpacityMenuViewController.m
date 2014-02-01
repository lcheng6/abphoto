//
//  OpacityMenuViewController.m
//  ABPhoto
//
//  Created by Liang Cheng on 1/31/14.
//  Copyright (c) 2014 Liang Cheng. All rights reserved.
//

#import "OpacityMenuViewController.h"

@interface OpacityMenuViewController ()
{
    UITapGestureRecognizer * tapGestureRecognizer;
    float _selectedOpacity;
    UIImage * _logoImage;
}
@property (nonatomic, strong) NSMutableArray * opaqueIcons;
@property (nonatomic, strong) NSMutableArray * opaqueIconViews;
@end

@implementation OpacityMenuViewController
@synthesize opaqueIcons;
@synthesize opaqueIconViews;


/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
}
*/

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondToOpacitySelection:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.numberOfTouchesRequired =1;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) setLogoImage:(UIImage*) logoImage
{
    opaqueIcons = [NSMutableArray array];
    CGSize iconSize;
    iconSize.width = 65*2;
    iconSize.height = 65*2;
    
    float widthScale = iconSize.width / logoImage.size.width;
    float heightScale = iconSize.height / logoImage.size.height;
    
    for (float alpha=1; alpha > 0; alpha -=.2) {
        UIGraphicsBeginImageContext(iconSize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        UIImage * newIcon= nil;
        context = UIGraphicsGetCurrentContext();
        //CGContextSetBlendMode(context, kCGBlendModeLuminosity);
        //CGcontextDrawImage(context, rect, newIcon.CGImage)
        //CGContextSetFillColorWithColor(context, (__bridge CGColorRef)([UIColor blackColor]));
        //CGContextFillRect(context, logRect);
        //CGContextSetBlendMode(context, kCGBlendModeLuminosity);
        CGContextScaleCTM(context, widthScale, heightScale);
        [logoImage drawInRect:CGRectMake(0, 0, logoImage.size.width, logoImage.size.height) blendMode:kCGBlendModeNormal alpha:alpha];
        newIcon = UIGraphicsGetImageFromCurrentImageContext();
        [opaqueIcons addObject:newIcon];
        UIGraphicsEndImageContext();
    }
    
    opaqueIconViews = [NSMutableArray array];
    for (int index = 0; index < [opaqueIcons count]; index++) {
        UIImage * icon = [opaqueIcons objectAtIndex:index];
        UIImageView * iconView = [[UIImageView alloc] initWithImage:icon];
        [opaqueIconViews addObject:iconView];
    }
    
    CGRect imageFrameRect;
    imageFrameRect.size.width = 65;
    imageFrameRect.size.height = 65;
    for (int index = 0; index < [opaqueIconViews count]; index++) {
        UIImageView * iconView = [opaqueIconViews objectAtIndex:index];
        imageFrameRect.origin.x = 10 * (index+1) + 65 * index;
        imageFrameRect.origin.y = 0;
        
        iconView.frame = imageFrameRect;
        [self.view addSubview:iconView];
    }
    
    _selectedOpacity = .8f;
    _logoImage = logoImage;
    [self drawSquareAroundSelectedOpacityIcon];
}

- (void) deSelectOpacityIcon{
    int iconIndex = 5 - (_selectedOpacity / .2f);
    UIImage * iconWithoutRoundedSquare = nil;
    CGSize iconSize;
    CGRect logoRect;
    
    iconSize.width = 65*2;
    iconSize.height = 65*2;
    
    logoRect.size = iconSize;
    logoRect.origin = CGPointMake(0.0f, 0.0f);
    
    float widthScale = iconSize.width / _logoImage.size.width;
    float heightScale = iconSize.height / _logoImage.size.height;
    
    UIGraphicsBeginImageContext(iconSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    context = UIGraphicsGetCurrentContext();
    
    
    //draw the logo image.
    CGContextScaleCTM(context, widthScale, heightScale);
    [_logoImage drawInRect:CGRectMake(0, 0, _logoImage.size.width, _logoImage.size.height) blendMode:kCGBlendModeNormal alpha:_selectedOpacity];
    
    iconWithoutRoundedSquare = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    [opaqueIcons replaceObjectAtIndex:iconIndex withObject:iconWithoutRoundedSquare];
    
    UIImageView * iconView  = [opaqueIconViews objectAtIndex:iconIndex];
    iconView.image = iconWithoutRoundedSquare;
}

- (void) drawSquareAroundSelectedOpacityIcon {
    int iconIndex = 5 - (_selectedOpacity / .2f);
    UIImage * iconWithRoundedSquare = nil;
    CGSize iconSize;
    CGRect logoRect;
    
    iconSize.width = 65*2;
    iconSize.height = 65*2;
    
    logoRect.size = iconSize;
    logoRect.origin = CGPointMake(0.0f, 0.0f);
    
    float widthScale = iconSize.width / _logoImage.size.width;
    float heightScale = iconSize.height / _logoImage.size.height;
    
    UIGraphicsBeginImageContext(iconSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    context = UIGraphicsGetCurrentContext();
    
    //draw the corner with rounded corner
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:logoRect cornerRadius:25.0f];
    path.lineWidth = 4.0f;
    [[[[[UIApplication sharedApplication] delegate] window] tintColor] setStroke];
    [path stroke];
    
    //draw the logo image.
    CGContextScaleCTM(context, widthScale, heightScale);
    [_logoImage drawInRect:CGRectMake(0, 0, _logoImage.size.width, _logoImage.size.height) blendMode:kCGBlendModeNormal alpha:_selectedOpacity];
    
    iconWithRoundedSquare = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    [opaqueIcons replaceObjectAtIndex:iconIndex withObject:iconWithRoundedSquare];
   
    UIImageView * iconView  = [opaqueIconViews objectAtIndex:iconIndex];
    iconView.image = iconWithRoundedSquare;
    
}
- (float) getSelectedOpacity {
    return _selectedOpacity;
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
            [self deSelectOpacityIcon];
            _selectedOpacity = 1.0f - (float)regionIndex * .2f;
            [self drawSquareAroundSelectedOpacityIcon];
        }
    }
}
+ (CGSize) recommendedSize
{
    CGSize size;
    size.height = 65;
    //5 images and 6 gaps of 10 units between each
    size.width = 65 * 5 + 10 * 5;
    
    return size;
}


@end
