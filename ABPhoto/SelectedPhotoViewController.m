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

@interface SelectedPhotoViewController ()
{
    UIImageOrientation baseImageOriginalOrientation;
    UIImage * logoImage;

    CameraOverlayViewController * cameraOverlayController;
    
    LogoTransform logoTransformInfo;
    LogoTransform localTransformInfo;
    
    UIPanGestureRecognizer * panRecog;
    UIPinchGestureRecognizer * pinchRecog;
    UIRotationGestureRecognizer * rotateRecog;
    
    NSMutableSet * _activeRecognizers;
    
    
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
        //imagePicker.cameraViewTransform = CGAffineTransformMakeScale(.9375f, .9375f);
        
    }
    else if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    [imagePicker setDelegate:self];
    [self presentViewController:imagePicker animated:NO completion:nil];
    
    logoTransformInfo.scale = 1;
    logoTransformInfo.translation = baseImage.center;
    logoTransformInfo.rotation = 0;
    logoTransformInfo.logoTransform = CGAffineTransformIdentity;

    localTransformInfo = logoTransformInfo;
    
    panRecog = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(respondToPinchRotateAndPan:)];
    pinchRecog = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(respondToPinchRotateAndPan:)];
    rotateRecog = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(respondToPinchRotateAndPan:)];
    
    
    [overlayImage addGestureRecognizer:panRecog];
    [overlayImage addGestureRecognizer:pinchRecog];
    [overlayImage addGestureRecognizer:rotateRecog];
    
    
    _activeRecognizers = [NSMutableSet set];

}
- (void)respondToPan:(UIPanGestureRecognizer *) recognizer {
    UIPanGestureRecognizer * pan = (UIPanGestureRecognizer *) recognizer;
    
    
    CGPoint translation ;
    translation = [pan translationInView:overlayImage];
    
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
                overlayImage.transform = logoTransformInfo.logoTransform;
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
        overlayImage.transform = localTransformInfo.logoTransform;
    }
    if ([recognizer isKindOfClass:[UIPinchGestureRecognizer class]]) {
        //NSLog(@"Pinching");
        UIPinchGestureRecognizer * pinch = (UIPinchGestureRecognizer *) recognizer;
        localTransformInfo.scale = [pinch scale];
        localTransformInfo.logoTransform = CGAffineTransformScale(logoTransformInfo.logoTransform, localTransformInfo.scale, localTransformInfo.scale);
        overlayImage.transform = localTransformInfo.logoTransform;
    }
    if ([recognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer * pan = (UIPanGestureRecognizer *) recognizer;
        localTransformInfo.translation = [pan translationInView:overlayImage];
        localTransformInfo.translation = CGPointApplyAffineTransform(localTransformInfo.translation, localTransformInfo.logoTransform);
        localTransformInfo.translation.x = localTransformInfo.translation.x + logoTransformInfo.translation.x;
        localTransformInfo.translation.y = localTransformInfo.translation.y + logoTransformInfo.translation.y;
        overlayImage.center = localTransformInfo.translation;
        
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
        localTransformInfo.translation = [pan translationInView:overlayImage];
        localTransformInfo.translation = CGPointApplyAffineTransform(localTransformInfo.translation, localTransformInfo.logoTransform);
        localTransformInfo.translation.x = localTransformInfo.translation.x + logoTransformInfo.translation.x;
        localTransformInfo.translation.y = localTransformInfo.translation.y + logoTransformInfo.translation.y;
        
    }
    
    logoTransformInfo.logoTransform = CGAffineTransformScale(logoTransformInfo.logoTransform, localTransformInfo.scale,localTransformInfo.scale);
    logoTransformInfo.logoTransform = CGAffineTransformRotate(logoTransformInfo.logoTransform, localTransformInfo.rotation);
    logoTransformInfo.translation = localTransformInfo.translation;
    
    NSLog(@"end recognizer scale %f rotate %f translation (%f, %f)", localTransformInfo.scale, localTransformInfo.rotation, localTransformInfo.translation.x, localTransformInfo.translation.y);
    
    overlayImage.transform = logoTransformInfo.logoTransform;
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
    baseImage.image = correctedImage;
    
    logoImage = [UIImage imageNamed:@"AmericanBoxingOverlay.png"];
    overlayImage.image = [self fixOverlayImageOrientation:logoImage orientation:baseImageOriginalOrientation];
    
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
@end
