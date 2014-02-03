//
//  BaseImageFilterMenuViewController.m
//  ABPhoto
//
//  Created by Liang Cheng on 2/3/14.
//  Copyright (c) 2014 Liang Cheng. All rights reserved.
//

#import "BaseImageFilterMenuViewController.h"

@interface BaseImageFilterMenuViewController ()
{
    UITapGestureRecognizer * tapGestureRecognizer;
    int _selectedImageIndex;
    UIImage * _baseImage;
    UILabel * _title;
}
@property (nonatomic, strong) NSMutableArray * baseImageIcons;
@property (nonatomic, strong) NSMutableArray * baseImageIconViews;
@end

@implementation BaseImageFilterMenuViewController
@synthesize baseImageIcons;
@synthesize baseImageIconViews;

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
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondToBaseFilterImageSelection:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.numberOfTouchesRequired =1;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            //[self.delegate modifyOverlayOpacityParameter:_selectedOpacity];
            _selectedImageIndex = regionIndex;
        }
    }
}

- (void) setBaseImage:(UIImage*) baseImage
{
    _baseImage = baseImage;
    CGSize iconSize;
    iconSize.width = 65 * 2;
    iconSize.height = 65 * 2;
    
    float widthScale = iconSize.width/_baseImage.size.width;
    float heightScale = widthScale;//iconSize.height/baseImage.size.height;
    
    //Make 6 small icons for the images.
    baseImageIcons = [NSMutableArray array];
    for (int i=0; i<6; i++) {
        UIGraphicsBeginImageContext(iconSize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        UIImage * newIcon = nil;
        
        CGContextScaleCTM(context, widthScale, heightScale);
        
        CGRect centerSquareRect;
        centerSquareRect.size.height = baseImage.size.height;
        centerSquareRect.size.width = baseImage.size.width;
        centerSquareRect.origin.x = 0;
        centerSquareRect.origin.y = -1*(baseImage.size.height - baseImage.size.width)/2;
        [baseImage drawInRect:centerSquareRect];
        
        newIcon = UIGraphicsGetImageFromCurrentImageContext();
        [baseImageIcons addObject:newIcon];
        UIGraphicsEndImageContext();
    }
    
    baseImageIconViews = [NSMutableArray array];
    for (int index = 0; index < [baseImageIcons count]; index ++) {
        UIImage * icon = [baseImageIcons objectAtIndex:index];
        UIImageView * iconView = [[UIImageView alloc] initWithImage:icon];
        [baseImageIconViews addObject:iconView];
    }
    
    CGRect imageFrameRect;
    imageFrameRect.size.width = 65;
    imageFrameRect.size.height = 65;
    for (int index = 0; index < [baseImageIconViews count]; index++) {
        UIImageView * iconView = [baseImageIconViews objectAtIndex:index];
        imageFrameRect.origin.x = 10 * (index+1) + 65 * index;
        imageFrameRect.origin.y = 0;
        
        iconView.frame = imageFrameRect;
        //iconView.contentMode = UIViewContentModeCenter;
        [self.view addSubview:iconView];
    }
    
    _selectedImageIndex = 0;
    
    CGRect titleRect;
    titleRect.origin.x = 0; titleRect.origin.y = 66;
    titleRect.size.width = [BaseImageFilterMenuViewController recommendedSize].width;
    titleRect.size.height = 15;
    _title = [[UILabel alloc] initWithFrame:titleRect];
    _title.text = @"Filter";
    _title.textColor = [UIColor whiteColor];
    _title.textAlignment = NSTextAlignmentCenter;
    _title.font = [UIFont systemFontOfSize:14.0f];
    [self.view addSubview:_title];
}
- (int) getSelectedImageIndex {
    return _selectedImageIndex;
}

- (void)respondToBaseFilterImageSelection:(UITapGestureRecognizer *) tapRecog
{
    
}

+ (CGSize) recommendedSize
{
    int numImages = 6;
    CGSize size;
    size.height = 80;
    size.width = 65 * numImages + 10 * numImages;
    
    return size;
}


@end
