//
//  DropShadowColorMenuViewController.m
//  ABPhoto
//
//  Created by Liang Cheng on 2/9/14.
//  Copyright (c) 2014 Liang Cheng. All rights reserved.
//

#import "DropShadowColorMenuViewController.h"

@interface DropShadowColorMenuViewController ()
{
    UITapGestureRecognizer * tapGestureRecognizer;
    int _selectedIconIndex;
    UIImage * _logoImage;
    UILabel * _title;
    CGSize _shadowOffset;
    CGFloat _shadowBlur;
    NSMutableArray * _shadowColors;
}

@property (nonatomic, strong) NSMutableArray * shadowColorIcons;
@property (nonatomic, strong) NSMutableArray * shadowColorIconViews;

@end

static int numIcons = 7;
@implementation DropShadowColorMenuViewController
@synthesize shadowColorIcons;
@synthesize shadowColorIconViews;

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
    _selectedIconIndex = 0;
    
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondToShadowColorSelection:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    [self buildColorArray];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) buildColorArray {
    _shadowColors = [NSMutableArray array];
    
    [_shadowColors addObject:[UIColor redColor]];
    [_shadowColors addObject:[UIColor blueColor]];
    [_shadowColors addObject:[UIColor greenColor]];
    [_shadowColors addObject:[UIColor yellowColor]];
    //hot pink
    [_shadowColors addObject:[UIColor colorWithRed:1.0f green:.4118f blue:.706 alpha:1.0f]];
    [_shadowColors addObject:[UIColor purpleColor]];
    [_shadowColors addObject:[UIColor blackColor]];
}
- (UIColor * ) getShadowColor {
    return [UIColor whiteColor];
}
- (void) setLogoImage:(UIImage *)logoImage
{
    _logoImage = logoImage;
    
    CGSize iconSize;
    CGRect roundSquareRect;
    iconSize.width = 65*2;
    iconSize.height = 65*2;
    roundSquareRect.size = CGSizeMake(60*2, 60*2);
    roundSquareRect.origin = CGPointMake(5, 5);
    
    float widthScale = iconSize.width / _logoImage.size.width;
    float heightScale = iconSize.height / _logoImage.size.height;
    
    shadowColorIcons = [NSMutableArray array];
    for (int i=0; i< [_shadowColors count]; i++) {
        UIGraphicsBeginImageContext(iconSize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        UIImage * newIcon= nil;
        
        UIBezierPath * roundSquare = [UIBezierPath bezierPathWithRoundedRect:roundSquareRect cornerRadius:20.0f];
        [[UIColor whiteColor] setFill];
        [roundSquare fill];
        CGContextScaleCTM(context, widthScale, heightScale);
        
        UIColor *shadowColor = [_shadowColors objectAtIndex:i];
        CGContextSetShadowWithColor(context, _shadowOffset, _shadowBlur, [shadowColor CGColor]);
        [logoImage drawInRect:CGRectMake(0, 0, logoImage.size.width, logoImage.size.height)];
        
        newIcon = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [shadowColorIcons addObject:newIcon];
    }
    
    shadowColorIconViews = [NSMutableArray array];
    for (int index = 0; index < [shadowColorIcons count]; index++) {
        UIImage * icon = [shadowColorIcons objectAtIndex:index];
        UIImageView * iconView = [[UIImageView alloc] initWithImage:icon];
        [shadowColorIconViews addObject:iconView];
    }
    
    CGRect imageFrameRect;
    imageFrameRect.size.width = 65;
    imageFrameRect.size.height = 65;
    for (int index = 0; index < [shadowColorIconViews count]; index++) {
        UIImageView * iconView = [shadowColorIconViews objectAtIndex:index];
        imageFrameRect.origin.x = 10 * (index+1) + 65 * index;
        imageFrameRect.origin.y = 0;
        
        iconView.frame = imageFrameRect;
        [self.view addSubview:iconView];
    }
    
    [self drawSquareAroundSelectedShadowColorIcon];
    
    
    CGRect titleRect;
    titleRect.origin.x = 0; titleRect.origin.y = 66;
    titleRect.size.width = [DropShadowColorMenuViewController recommendedSize].width;
    titleRect.size.height = 15;
    _title = [[UILabel alloc] initWithFrame:titleRect];
    _title.text = @"Shadow Color";
    _title.textColor = [UIColor whiteColor];
    _title.textAlignment = NSTextAlignmentCenter;
    _title.font = [UIFont systemFontOfSize:14.0f];
    [self.view addSubview:_title];
}

- (void) deSelectShadowColorIcon {
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
    UIColor * shadowColor = [_shadowColors objectAtIndex:_selectedIconIndex];
    
    CGContextScaleCTM(context, widthScale, heightScale);
    CGContextSetShadowWithColor(context, _shadowOffset, _shadowBlur, [shadowColor CGColor]);
    [_logoImage drawInRect:CGRectMake(0, 0, _logoImage.size.width, _logoImage.size.height)];
    
    iconWithSelectedDropShadow = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    [shadowColorIcons replaceObjectAtIndex:_selectedIconIndex withObject:iconWithSelectedDropShadow];
    
    UIImageView * iconView  = [shadowColorIconViews objectAtIndex:_selectedIconIndex];
    iconView.image = iconWithSelectedDropShadow;
    
}

- (void) drawSquareAroundSelectedShadowColorIcon {
    
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

    UIColor * shadowColor = [_shadowColors objectAtIndex:_selectedIconIndex];
    CGContextScaleCTM(context, widthScale, heightScale);
    CGContextSetShadowWithColor(context, _shadowOffset, _shadowBlur, [shadowColor CGColor]);
    [_logoImage drawInRect:CGRectMake(0, 0, _logoImage.size.width, _logoImage.size.height)];
    
    iconWithSelectedDropShadow = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    [shadowColorIcons replaceObjectAtIndex:_selectedIconIndex withObject:iconWithSelectedDropShadow];
    
    UIImageView * iconView  = [shadowColorIconViews objectAtIndex:_selectedIconIndex];
    iconView.image = iconWithSelectedDropShadow;
    
}
- (void) respondToShadowColorSelection:(UITapGestureRecognizer *) tap {
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
            [self deSelectShadowColorIcon];
            _selectedIconIndex = regionIndex;
            [self drawSquareAroundSelectedShadowColorIcon];
            
            [self.delegate modifyOverlayDropShadowColor:[_shadowColors objectAtIndex:_selectedIconIndex]];
        }
    }
}

- (void) redrawIconsWithShadow
{
    CGSize iconSize;
    CGRect roundSquareRect;
    iconSize.width = 65*2;
    iconSize.height = 65*2;
    roundSquareRect.size = CGSizeMake(60*2, 60*2);
    roundSquareRect.origin = CGPointMake(5, 5);
    
    float widthScale = iconSize.width / _logoImage.size.width;
    float heightScale = iconSize.height / _logoImage.size.height;
    
    for (int i=0; i< [_shadowColors count]; i++) {
        UIGraphicsBeginImageContext(iconSize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        UIImage * newIcon= nil;
        
        UIBezierPath * roundSquare = [UIBezierPath bezierPathWithRoundedRect:roundSquareRect cornerRadius:20.0f];
        [[UIColor whiteColor] setFill];
        [roundSquare fill];
        CGContextScaleCTM(context, widthScale, heightScale);
        
        UIColor *shadowColor = [_shadowColors objectAtIndex:i];
        CGContextSetShadowWithColor(context, _shadowOffset, _shadowBlur, [shadowColor CGColor]);
        [_logoImage drawInRect:CGRectMake(0, 0, _logoImage.size.width, _logoImage.size.height)];
        
        newIcon = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [shadowColorIcons replaceObjectAtIndex:i withObject:newIcon];
    }
    
    
    for (int index = 0; index < [shadowColorIconViews count]; index++) {
        UIImageView * iconView = [shadowColorIconViews objectAtIndex:index];
        UIImage * icon = [shadowColorIcons objectAtIndex:index];
        iconView.image = icon;
    }
    
    [self drawSquareAroundSelectedShadowColorIcon];
}
- (void) setShadowParam:(CGSize)offset blur:(CGFloat)blur
{
    _shadowOffset = offset;
    _shadowBlur = blur;
    
    if(_logoImage != nil) {
        //[self setLogoImage:_logoImage];
        [self redrawIconsWithShadow];
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
