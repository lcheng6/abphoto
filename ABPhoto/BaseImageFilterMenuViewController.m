//
//  BaseImageFilterMenuViewController.m
//  ABPhoto
//
//  Created by Liang Cheng on 2/3/14.
//  Copyright (c) 2014 Liang Cheng. All rights reserved.
//

#import "BaseImageFilterMenuViewController.h"
#import "UIImage+Filters.h"

@interface BaseImageFilterMenuViewController ()
{
    UITapGestureRecognizer * tapGestureRecognizer;
    int _selectedImageIndex;
    UIImage * _baseImage;
    UILabel * _title;
}
@property (nonatomic, strong) NSMutableArray * baseFilteredImageIcons;
@property (nonatomic, strong) NSMutableArray * baseFilteredImageIconViews;
@end

@implementation BaseImageFilterMenuViewController
@synthesize baseFilteredImageIcons;
@synthesize baseFilteredImageIconViews;

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
    CGSize punchOutSize;
    CGRect punchOutRect;
    CGContextRef context;
    
    punchOutSize.width = 65*2;
    punchOutSize.height = 65*2;
    
    iconSize.width = 65 * 2;
    iconSize.height = 65 * 2;
    
    //Make a punchout for the the 6 images
    punchOutRect.size = CGSizeMake(60*2, 60*2);
    punchOutRect.origin = CGPointMake(5, 5);
    UIBezierPath* punchOutPath = [UIBezierPath bezierPathWithRoundedRect:punchOutRect cornerRadius:20.0f];
    UIImage * punchOut = nil;
    UIGraphicsBeginImageContext(punchOutSize);
    [[UIColor blackColor] setFill];
    context = UIGraphicsGetCurrentContext();
    CGContextFillRect(context, CGRectMake(0, 0, 65*2, 65*2));
    [[UIColor whiteColor] setFill];
    [punchOutPath fill];
    punchOut = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    //Make a small rectangle sub image of the main image
    
    CGSize subImageSize;
    CGRect subImageRect;
    subImageSize = CGSizeMake(65*2, 65*2*4/3);
    subImageRect.origin = CGPointMake(0,0);
    subImageRect.size = subImageSize;
    
    float widthScale = subImageSize.width/_baseImage.size.width;
    UIGraphicsBeginImageContext(subImageSize);
    CGContextScaleCTM(context, widthScale, widthScale);
    [baseImage drawInRect:CGRectMake(0, 0, baseImage.size.width, baseImage.size.height)];
    UIImage * subImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //Make 6 small icons for the images.
    baseFilteredImageIcons = [NSMutableArray array];
    
    for (int i=0; i<[BaseImageFilterMenuViewController getNumberOfFilters]; i++) {
        UIImageFilterType filterType = [BaseImageFilterMenuViewController convertIntToFilterType:i];
        UIImage * filteredSubImage = [subImage imageWithFilter:filterType];
        
        CGRect toRect = CGRectMake(0, (filteredSubImage.size.width-filteredSubImage.size.height)/2, filteredSubImage.size.width, filteredSubImage.size.height);
        UIGraphicsBeginImageContext(iconSize);
        [filteredSubImage drawInRect:toRect];
        UIImage * filteredSquaredSubImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
        //punch out icons
        UIGraphicsBeginImageContext(iconSize);
        [filteredSquaredSubImage drawAtPoint:CGPointZero];
        [punchOut drawAtPoint:CGPointZero blendMode:kCGBlendModeMultiply alpha:1];
        UIImage * filteredSquareIcon = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [baseFilteredImageIcons addObject:filteredSquareIcon];
        
        
    }
    
    baseFilteredImageIconViews = [NSMutableArray array];
    for (int index = 0; index < [baseFilteredImageIcons count]; index ++) {
        UIImage * icon = [baseFilteredImageIcons objectAtIndex:index];
        UIImageView * iconView = [[UIImageView alloc] initWithImage:icon];
        [baseFilteredImageIconViews addObject:iconView];
    }
    
    CGRect imageFrameRect;
    imageFrameRect.size.width = 65;
    imageFrameRect.size.height = 65;
    for (int index = 0; index < [baseFilteredImageIconViews count]; index++) {
        UIImageView * iconView = [baseFilteredImageIconViews objectAtIndex:index];
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

+ (UIImageFilterType) convertIntToFilterType:(int) filterInt{
    return (UIImageFilterType) (filterInt % [BaseImageFilterMenuViewController getNumberOfFilters]);
}

+ (int) getNumberOfFilters {
    return 8;
}

+ (CGSize) recommendedSize
{
    int numImages = [BaseImageFilterMenuViewController getNumberOfFilters];
    CGSize size;
    size.height = 80;
    size.width = 65 * numImages + 10 * numImages;
    
    return size;
}


@end
