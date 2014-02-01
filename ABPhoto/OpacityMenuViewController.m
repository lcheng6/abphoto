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
    UITapGestureRecognizer * tapGesture;
    float _selectedOpacity;
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
*/

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
        [self addSubview:iconView];
    }
    
    _selectedOpacity = 1.0f;
    [self drawSquareAroundSelectedOpacityIcon:logoImage];
}

- (void) drawSquareAroundSelectedOpacityIcon:(UIImage*) logoImage {
    int iconIndex = 5 - (_selectedOpacity / .2f);
    UIImage * iconWithRoundedSquare = nil;
    CGSize iconSize;
    CGRect logoRect;
    
    iconSize.width = 65*2;
    iconSize.height = 65*2;
    
    logoRect.size = iconSize;
    logoRect.origin = CGPointMake(0.0f, 0.0f);
    
    float widthScale = iconSize.width / logoImage.size.width;
    float heightScale = iconSize.height / logoImage.size.height;
    
    UIGraphicsBeginImageContext(iconSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    context = UIGraphicsGetCurrentContext();
    
    //draw the corner with rounded corner
    [UIBezierPath bezierPathWithRoundedRect:logoRect cornerRadius:3.0f];
    
    CGContextScaleCTM(context, widthScale, heightScale);
    [logoImage drawInRect:CGRectMake(0, 0, logoImage.size.width, logoImage.size.height) blendMode:kCGBlendModeNormal alpha:_selectedOpacity];
    
    iconWithRoundedSquare = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    [opaqueIcons replaceObjectAtIndex:iconIndex withObject:iconWithRoundedSquare];
   

    
}
- (float) getSelectedOpacity {
    return 0.0;
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
