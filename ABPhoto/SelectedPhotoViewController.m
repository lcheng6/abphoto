//
//  SelectedPhotoViewController.m
//  ABPhoto
//
//  Created by Liang Cheng on 1/28/14.
//  Copyright (c) 2014 Liang Cheng. All rights reserved.
//

#import "SelectedPhotoViewController.h"
#import "CameraOverlayViewController.h"
#import "CameraParameter.h"
#import "SharePhotoViewController.h"
#import "BaseImageFilterMenuViewController.h"
#import "OpacityMenuViewController.h"
#import "DropShadowMenuViewController.h"
#import "DropShadowColorMenuViewController.h"


@interface SelectedPhotoViewController ()
{
    UIImageOrientation baseImageOriginalOrientation;
    UIImage * logoImage;
    UIImage * baseImage; //the reference to the original taken picture

    CameraOverlayViewController * cameraOverlayController;
    
    LogoTransform logoTransformInfo;
    LogoTransform localTransformInfo;
    
    OverlayParameter overlayParameter;
    BaseImageParameter baseImageParameter;
    
    UIPanGestureRecognizer * panRecog;
    UIPinchGestureRecognizer * pinchRecog;
    UIRotationGestureRecognizer * rotateRecog;
    
    NSMutableSet * _activeRecognizers;
    
    BaseImageFilterMenuViewController * baseImageFilterMenuController;
    OpacityMenuViewController * opacityMenuController;
    DropShadowMenuViewController * dropShadowMenuController;
    DropShadowColorMenuViewController * dropShadowColorMenuController;
    
    
    NSMutableArray * _menuControllerOffsetsInX;
}

@end

@implementation SelectedPhotoViewController

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
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    if (cameraOverlayController == nil) {
        cameraOverlayController = [[CameraOverlayViewController alloc] init];
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        
        imagePicker.showsCameraControls = NO;
        imagePicker.cameraOverlayView = cameraOverlayController.view;
        imagePicker.allowsEditing = NO;
        cameraOverlayController.imagePickerController = imagePicker;
        
    }
    else if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    [imagePicker setDelegate:self];
    [self presentViewController:imagePicker animated:NO completion:nil];
    
    logoTransformInfo.scale = 1;
    logoTransformInfo.translation = baseImageView.center;
    logoTransformInfo.rotation = 0;
    logoTransformInfo.logoTransform = CGAffineTransformIdentity;

    localTransformInfo = logoTransformInfo;
    
    panRecog = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(respondToPinchRotateAndPan:)];
    pinchRecog = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(respondToPinchRotateAndPan:)];
    rotateRecog = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(respondToPinchRotateAndPan:)];
    
    
    [overlayImageView addGestureRecognizer:panRecog];
    [overlayImageView addGestureRecognizer:pinchRecog];
    [overlayImageView addGestureRecognizer:rotateRecog];
    
    
    _activeRecognizers = [NSMutableSet set];
    
    [self setupMenusInScrollView];
    
}

- (void) setupMenusInScrollView
{
    int xOffset = 0;
    CGRect baseImageFilterFrame;
    
    _menuControllerOffsetsInX = [NSMutableArray array];
    
    scrollMenuView.delegate = self;
    
    [_menuControllerOffsetsInX addObject:[NSNumber numberWithFloat:xOffset]];
    
    baseImageFilterFrame.size = [BaseImageFilterMenuViewController recommendedSize];
    baseImageFilterFrame.origin.x = 0;
    baseImageFilterFrame.origin.y = 0;
    baseImageFilterMenuController = [[BaseImageFilterMenuViewController alloc] init];
    baseImageFilterMenuController.delegate = self;
    baseImageFilterMenuController.view.frame = baseImageFilterFrame;
    overlayParameter.overlaySelectionIndex = 0;
    overlayParameter.overlayColor = [[UIColor redColor] CGColor];
    overlayParameter.alpha = 1.0f;
    overlayParameter.dropShadowOffset = CGSizeMake(0.0f, 0.0f);
    overlayParameter.dropShadowBlurRadius = 0.0f;
    overlayParameter.dropShadowAlpha = 1.0f;
    overlayParameter.dropShadowColor = [[UIColor redColor] CGColor];
    
    xOffset += baseImageFilterFrame.size.width;
    [_menuControllerOffsetsInX addObject:[NSNumber numberWithFloat:xOffset]];
    
    CGRect opacityMenuFrame;
    opacityMenuFrame.size = [OpacityMenuViewController recommendedSize];
    opacityMenuFrame.origin.x = xOffset;
    opacityMenuFrame.origin.y = 0;
    opacityMenuController = [[OpacityMenuViewController alloc] init];
    opacityMenuController.delegate = self;
    opacityMenuController.view.frame = opacityMenuFrame;
    xOffset += opacityMenuFrame.size.width;
    [_menuControllerOffsetsInX addObject:[NSNumber numberWithFloat:xOffset]];
    
    CGRect dropShadowMenuFrame;
    dropShadowMenuFrame.size = [DropShadowMenuViewController recommendedSize];
    dropShadowMenuFrame.origin.x = xOffset;
    dropShadowMenuFrame.origin.y = 0;
    dropShadowMenuController = [[DropShadowMenuViewController alloc] init];
    dropShadowMenuController.delegate = self;
    dropShadowMenuController.view.frame = dropShadowMenuFrame;
    xOffset += dropShadowMenuFrame.size.width;
    [_menuControllerOffsetsInX addObject:[NSNumber numberWithFloat:xOffset]];
    
    CGRect dropShadowColorMenuFrame;
    dropShadowColorMenuFrame.size = [DropShadowColorMenuViewController recommendedSize];
    dropShadowColorMenuFrame.origin.x = xOffset;
    dropShadowColorMenuFrame.origin.y = 0;
    dropShadowColorMenuController = [[DropShadowColorMenuViewController alloc] init];
    dropShadowColorMenuController.delegate = self;
    dropShadowColorMenuController.view.frame = dropShadowColorMenuFrame;
    xOffset += dropShadowColorMenuFrame.size.width;
    [_menuControllerOffsetsInX addObject:[NSNumber numberWithFloat:xOffset]];
    
    if (logoImage == nil) {
        logoImage = [UIImage imageNamed:@"AmericanBoxingOverlay.png"];
    }
    [opacityMenuController setLogoImage:logoImage];
    [dropShadowMenuController setLogoImage:logoImage];
    [dropShadowColorMenuController setShadowParam:CGSizeMake(0.0f, 0.0f) blur:0];
    [dropShadowColorMenuController setLogoImage:logoImage];
    
    [scrollMenuView addSubview:baseImageFilterMenuController.view];
    [scrollMenuView addSubview:opacityMenuController.view];
    [scrollMenuView addSubview:dropShadowMenuController.view];
    [scrollMenuView addSubview:dropShadowColorMenuController.view];
    
    [scrollMenuView setScrollEnabled:YES];
    [scrollMenuView setShowsHorizontalScrollIndicator:NO];
    [pageControl setNumberOfPages:4];
    //[scrollMenuView setPagingEnabled:YES];
    
    CGSize totalSize;
    totalSize.height = baseImageFilterFrame.size.height;
    totalSize.width = baseImageFilterFrame.size.width + opacityMenuFrame.size.width + dropShadowMenuFrame.size.width + dropShadowColorMenuFrame.size.width;
    [scrollMenuView setContentSize:totalSize];
    
    [pageControl addTarget:self
                    action:@selector(pageControlTapped:)
          forControlEvents:UIControlEventValueChanged];

}
- (void)respondToPan:(UIPanGestureRecognizer *) recognizer {
    UIPanGestureRecognizer * pan = (UIPanGestureRecognizer *) recognizer;
    
    
    CGPoint translation ;
    translation = [pan translationInView:overlayImageView];
    
    //NSLog(@"translation in logoImageView: (%f, %f)", translation.x, translation.y);
    translation = CGPointApplyAffineTransform(translation, logoTransformInfo.logoTransform);
    //NSLog(@"translation in translated logoImageView: (%f, %f)", translation.x, translation.y);
    
}

- (void)respondToPinchRotateAndPan:(UIGestureRecognizer *) recognizer
{
    //Upon entering this function, this function will sure to have 2 fingers.
    
    switch(recognizer.state) {
        case UIGestureRecognizerStateBegan:
            if(_activeRecognizers.count == 0) {
                overlayImageView.transform = logoTransformInfo.logoTransform;
                [_activeRecognizers addObject:recognizer];
                localTransformInfo.scale = 1;
                localTransformInfo.translation = logoTransformInfo.translation;
                localTransformInfo.rotation = 0;
                //localTransform = logoTransform;
            }
            break;
        case UIGestureRecognizerStateEnded:
            [_activeRecognizers removeObject:recognizer];
            if (_activeRecognizers.count == 0) {
                [self endRecognizer:recognizer];
            }
            
            break;
            
        case UIGestureRecognizerStateChanged: {
            //NSLog(@"Number of recognizers: %d", _activeRecognizers.count);
            for (UIGestureRecognizer *recognizer in _activeRecognizers)
                [self applyRecognizer:recognizer];
            //imageView.transform = logoTransform;
            break;
        }
            
        default:
            break;
    }
    
}


- (void) applyRecognizer:(UIGestureRecognizer *) recognizer
{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    if([recognizer isKindOfClass:[UIRotationGestureRecognizer class]]) {
        UIRotationGestureRecognizer * rotation = (UIRotationGestureRecognizer *) recognizer;
        localTransformInfo.rotation = [rotation rotation];
        localTransformInfo.logoTransform = CGAffineTransformRotate(logoTransformInfo.logoTransform, localTransformInfo.rotation);
        overlayImageView.transform = localTransformInfo.logoTransform;
    }
    if ([recognizer isKindOfClass:[UIPinchGestureRecognizer class]]) {
        //NSLog(@"Pinching");
        UIPinchGestureRecognizer * pinch = (UIPinchGestureRecognizer *) recognizer;
        localTransformInfo.scale = [pinch scale];
        localTransformInfo.logoTransform = CGAffineTransformScale(logoTransformInfo.logoTransform, localTransformInfo.scale, localTransformInfo.scale);
        overlayImageView.transform = localTransformInfo.logoTransform;
    }
    if ([recognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer * pan = (UIPanGestureRecognizer *) recognizer;
        localTransformInfo.translation = [pan translationInView:overlayImageView];
        localTransformInfo.translation = CGPointApplyAffineTransform(localTransformInfo.translation, localTransformInfo.logoTransform);
        localTransformInfo.translation.x = localTransformInfo.translation.x + logoTransformInfo.translation.x;
        localTransformInfo.translation.y = localTransformInfo.translation.y + logoTransformInfo.translation.y;
        overlayImageView.center = localTransformInfo.translation;
        
    }
    
    
    NSLog(@"scale %f rotation %f translation (%f, %f)", localTransformInfo.scale, localTransformInfo.rotation, localTransformInfo.translation.x, localTransformInfo.translation.y);
    
    
    
    [CATransaction commit];
    
    //return CGAffineTransformIdentity;
}

- (void) endRecognizer:(UIGestureRecognizer *) recognizer
{
    if([recognizer isKindOfClass:[UIRotationGestureRecognizer class]]) {
        UIRotationGestureRecognizer * rotation = (UIRotationGestureRecognizer *) recognizer;
        localTransformInfo.rotation = [rotation rotation];
        
    }
    else if ([recognizer isKindOfClass:[UIPinchGestureRecognizer class]]) {
        //NSLog(@"Pinching");
        UIPinchGestureRecognizer * pinch = (UIPinchGestureRecognizer *) recognizer;
        localTransformInfo.scale = [pinch scale];
    }
    else if ([recognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer * pan = (UIPanGestureRecognizer *) recognizer;
        localTransformInfo.translation = [pan translationInView:overlayImageView];
        localTransformInfo.translation = CGPointApplyAffineTransform(localTransformInfo.translation, localTransformInfo.logoTransform);
        localTransformInfo.translation.x = localTransformInfo.translation.x + logoTransformInfo.translation.x;
        localTransformInfo.translation.y = localTransformInfo.translation.y + logoTransformInfo.translation.y;
        
    }
    
    logoTransformInfo.logoTransform = CGAffineTransformScale(logoTransformInfo.logoTransform, localTransformInfo.scale,localTransformInfo.scale);
    logoTransformInfo.scale = logoTransformInfo.scale * localTransformInfo.scale;
    
    logoTransformInfo.logoTransform = CGAffineTransformRotate(logoTransformInfo.logoTransform, localTransformInfo.rotation);
    logoTransformInfo.rotation = logoTransformInfo.rotation + localTransformInfo.rotation;
    
    logoTransformInfo.translation = localTransformInfo.translation;
    
    NSLog(@"end recognizer scale %f rotate %f translation (%f, %f)", localTransformInfo.scale, localTransformInfo.rotation, localTransformInfo.translation.x, localTransformInfo.translation.y);
    
    overlayImageView.transform = logoTransformInfo.logoTransform;
    //logoImageView.center = localTransformInfo.translation;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //Get picked image from info dictionary
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    baseImageOriginalOrientation = image.imageOrientation;
    
    UIImage * correctedImage = [self fixImageOrientation:image];
    baseImageView.image = correctedImage;
    baseImage = correctedImage;
    
    logoImage = [UIImage imageNamed:@"AmericanBoxingOverlay.png"];
    overlayImageView.image = [self fixOverlayImageOrientation:logoImage orientation:baseImageOriginalOrientation];;
    
    [baseImageFilterMenuController setBaseImage:correctedImage];
    
}

- (UIImage *)fixOverlayImageOrientation:(UIImage*)originalOverlayImage orientation:(UIImageOrientation)baseImageOriginalOrientation
{
    return originalOverlayImage;
}

- (UIImage *)fixImageOrientation:(UIImage*)originalImage {
    
    // No-op if the orientation is already correct
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    //if (originalImage.imageOrientation == UIImageOrientationRight) return originalImage;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGContextRef ctx;
    switch (originalImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
        
            transform = CGAffineTransformTranslate(transform, 0, originalImage.size.width);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            ctx = CGBitmapContextCreate(NULL, originalImage.size.height, originalImage.size.width,
                                        CGImageGetBitsPerComponent(originalImage.CGImage), 0,
                                        CGImageGetColorSpace(originalImage.CGImage),
                                        CGImageGetBitmapInfo(originalImage.CGImage));
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, originalImage.size.width, originalImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            ctx = CGBitmapContextCreate(NULL, originalImage.size.width, originalImage.size.height,
                                        CGImageGetBitsPerComponent(originalImage.CGImage), 0,
                                        CGImageGetColorSpace(originalImage.CGImage),
                                        CGImageGetBitmapInfo(originalImage.CGImage));
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, originalImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            ctx = CGBitmapContextCreate(NULL, originalImage.size.width, originalImage.size.height,
                                        CGImageGetBitsPerComponent(originalImage.CGImage), 0,
                                        CGImageGetColorSpace(originalImage.CGImage),
                                        CGImageGetBitmapInfo(originalImage.CGImage));
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            transform = CGAffineTransformTranslate(transform, 0, originalImage.size.width);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            ctx = CGBitmapContextCreate(NULL, originalImage.size.height, originalImage.size.width,
                                        CGImageGetBitsPerComponent(originalImage.CGImage), 0,
                                        CGImageGetColorSpace(originalImage.CGImage),
                                        CGImageGetBitmapInfo(originalImage.CGImage));
            break;

    }
    
    switch (originalImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, originalImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, originalImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    
    CGContextConcatCTM(ctx, transform);
    switch (originalImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,originalImage.size.height,originalImage.size.width), originalImage.CGImage);
            break;
            
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,originalImage.size.width,originalImage.size.height), originalImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


- (NSUInteger) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


- (IBAction)cameraButtonPressed:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if (cameraOverlayController == nil) {
        cameraOverlayController = [[CameraOverlayViewController alloc] init];
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        
        imagePicker.showsCameraControls = NO;
        imagePicker.cameraOverlayView = cameraOverlayController.view;
        imagePicker.allowsEditing = NO;
        cameraOverlayController.imagePickerController = imagePicker;
        //imagePicker.cameraViewTransform = CGAffineTransformMakeScale(.9375f, .9375f);
        
    }
    else if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    [imagePicker setDelegate:self];
    [self presentViewController:imagePicker animated:NO completion:nil];
}

- (UIImage *)generateCombinedImage {
    CGContextRef context;
    
    //CGAffineTransform transform = CGAffineTransformIdentity;
    
    UIGraphicsBeginImageContext(baseImageView.image.size);
    context = UIGraphicsGetCurrentContext();
    
    [baseImageView.image drawInRect:CGRectMake(0, 0, baseImageView.image.size.width, baseImageView.image.size.height)];
    
    context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    context = UIGraphicsGetCurrentContext();
    [self scaleAndRotateLogoContext:context];
    
    CGSize adjustedOffset = overlayParameter.dropShadowOffset;
    CGPoint adjustedOffsetPoint;
    adjustedOffsetPoint.x = adjustedOffset.width;
    adjustedOffsetPoint.y = adjustedOffset.height;
    
    //TODO: figure out the ratio;
    adjustedOffsetPoint.x *= (logoImage.size.width/144.0f);
    adjustedOffsetPoint.y *= (logoImage.size.height/144.0f);
    adjustedOffsetPoint = CGPointApplyAffineTransform(adjustedOffsetPoint, logoTransformInfo.logoTransform);
    
    adjustedOffset.width = adjustedOffsetPoint.x;
    adjustedOffset.height = adjustedOffsetPoint.y;
    
    CGFloat adjustedBlurRadius = overlayParameter.dropShadowBlurRadius;
    adjustedBlurRadius *= (logoImage.size.width/144.0f * 2.0f);
    CGContextSetShadowWithColor(context, adjustedOffset, adjustedBlurRadius, overlayParameter.dropShadowColor);
    [logoImage drawInRect:CGRectMake(0, 0, logoImage.size.width, logoImage.size.height) blendMode:kCGBlendModeNormal alpha:overlayParameter.alpha];
    CGContextRestoreGState(context);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageOrientation newOrientation;
    switch (baseImageOriginalOrientation) {
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            newOrientation = UIImageOrientationLeft;
            break;
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            newOrientation = UIImageOrientationUp;
            break;
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            newOrientation = UIImageOrientationRight;
            break;
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            newOrientation = UIImageOrientationLeft;
            break;
    }
    UIImage * rotatedImage = [UIImage imageWithCGImage:[newImage CGImage] scale:1.0 orientation:newOrientation];
    
    return rotatedImage;
}

- (void) scaleAndRotateLogoContext:(CGContextRef) context {
    //TODO: need to #define all of these constants.
    float scale;
    //first need to scale the logo to the porportional size of its appearance
    UIImage *image = baseImageView.image;
    
    scale = (144.0f/320.0f) * logoTransformInfo.scale * image.size.width/logoImage.size.width; //144 is the number of points of overlay image's width, and 320 is the width of screen in points.
    CGPoint translationOfLogoCenterInLogoCoordinate = CGPointMake(logoImage.size.width/2, logoImage.size.width/2);
    CGPoint translationOfLogoCenterInBaseImageCoorindate = overlayImageView.center;
    
    translationOfLogoCenterInBaseImageCoorindate.y = translationOfLogoCenterInBaseImageCoorindate.y - baseImageView.frame.origin.y;
    
    CGPoint translationOfLogoCenterFromLogoZeroInBaseImageCoordinate = CGPointApplyAffineTransform(translationOfLogoCenterInLogoCoordinate, logoTransformInfo.logoTransform);
    CGPoint translationOfLogoZeroInBaseImageCoordinate = CGPointMake(
     (translationOfLogoCenterInBaseImageCoorindate.x * image.size.width/320.f - translationOfLogoCenterFromLogoZeroInBaseImageCoordinate.x / (logoImage.size.width/144.0f * 320.0f / image.size.width)),
     (translationOfLogoCenterInBaseImageCoorindate.y * image.size.width/320.f - translationOfLogoCenterFromLogoZeroInBaseImageCoordinate.y / (logoImage.size.width/144.0f * 320.0f / image.size.width)));
    
    CGContextTranslateCTM(context, translationOfLogoZeroInBaseImageCoordinate.x, translationOfLogoZeroInBaseImageCoordinate.y);
    CGContextScaleCTM(context, scale, scale);
    CGContextRotateCTM(context, logoTransformInfo.rotation);
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ToShare"]) {
        SharePhotoViewController *sharePhotoVC = [segue destinationViewController];
        
        sharePhotoVC.originalPhotoForShare = [self generateCombinedImage];
    }
}

- (void) overlayParamChanged {
    overlayImageView.alpha = overlayParameter.alpha;
    overlayImageView.layer.shadowColor = overlayParameter.dropShadowColor;
    overlayImageView.layer.shadowOffset = overlayParameter.dropShadowOffset;
    overlayImageView.layer.shadowRadius = overlayParameter.dropShadowBlurRadius;
    overlayImageView.layer.shadowOpacity = overlayParameter.dropShadowAlpha;
    [dropShadowMenuController setShadowColor:(__bridge UIColor *)(overlayParameter.dropShadowColor)];
}

- (void) baseImageParamChanged {
    UIImage * filteredBaseImage = [baseImage imageWithFilter:baseImageParameter.filterType];
    baseImageView.image = filteredBaseImage;
}


-(void) modifyOverlayFilterIndexParameter:(int)overlaySelectionIndex
{
    baseImageParameter.filterType = (UIImageFilterType) overlaySelectionIndex;
    [self baseImageParamChanged];
}
-(void) modifyOverlayColorParameter:(UIColor*) color
{
    overlayParameter.overlayColor = [color CGColor];
}
-(void) modifyOverlayOpacityParameter:(float) alpha
{
    overlayParameter.alpha = alpha;
    [self overlayParamChanged];
}
-(void) modifyOverlayDropShadowParameter:(CGSize) dropShadowParam shadowOpacity:(CGFloat) dropShadowBlur
{
    overlayParameter.dropShadowOffset = dropShadowParam;
    overlayParameter.dropShadowBlurRadius = dropShadowBlur;
    overlayParameter.dropShadowAlpha = 1.0f;
    if (dropShadowColorMenuController != nil) {
        [dropShadowColorMenuController setShadowParam:dropShadowParam blur:dropShadowBlur];
    }
    [self overlayParamChanged];
}

-(void) modifyOverlayDropShadowColor:(UIColor *)shadowColor
{
    overlayParameter.dropShadowColor = [shadowColor CGColor];
    [self overlayParamChanged];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset;
    offset = scrollView.contentOffset;
    int pageIndex;
    for (pageIndex =0; pageIndex < [_menuControllerOffsetsInX count]; pageIndex++) {
        NSNumber * offsetNum = [_menuControllerOffsetsInX objectAtIndex:pageIndex];
        if (offset.x <= [offsetNum floatValue]) {
            break;
        }
    }
    pageIndex = pageIndex - 1;
    [pageControl setCurrentPage: pageIndex];
}

- (void) pageControlTapped:(UIPageControl *) ctrl {
    
    int pageIndex = (int)[pageControl currentPage];
    NSNumber * pageOffset = [_menuControllerOffsetsInX objectAtIndex:pageIndex];
    CGFloat pageOffsetInX = [pageOffset floatValue];
    CGPoint pageOffsetPoint = CGPointMake(pageOffsetInX, 0);
    NSLog(@"pageIndex: %d Offset %@", pageIndex, NSStringFromCGPoint(pageOffsetPoint));
    [scrollMenuView setContentOffset:pageOffsetPoint];
    [pageControl setCurrentPage:pageIndex];
}

@end
