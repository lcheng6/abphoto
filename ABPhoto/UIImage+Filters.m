//
//  UIImage+Filters.m
//  ImageFilter
//
//  Created by dasmer on 1/11/14.
//  Copyright (c) 2014 Columbia University. All rights reserved.
//

#import "UIImage+Filters.h"

@implementation UIImage (Filters)
//CGFloat Constants Below are Fully Customizable to Change Preset Filter Defaults

const CGFloat SepiaPresetInputIntensity = 0.8f;

const CGFloat VignettePresetInputIntensity = 2.0f;
const CGFloat VignettePresetInputRadius = 50.0f;

const CGFloat TemperaturePresetInputNeutralX = 6500.0f;
const CGFloat TemperaturePresetInputNeutralY = 500.0f;
const CGFloat TemperaturePresetInputTargetNeutralX = 1000.0f;
const CGFloat TemperaturePresetInputTargetNeutralY = 630.0f;

const CGFloat HuePresetInputAngle = 3.0f;

const CGFloat ExposurePresetInputEV = 2.0f;

const CGFloat HighlightShadowPresetInputHighlight = 3.0f;
const CGFloat HighlightShadowPresetInputShadow = 1.5f;

const CGFloat ColorControlPresetInputBrightness = 0.5f;
const CGFloat ColorControlPresetInputContrast = 2.0f;
const CGFloat ColorControlPresetInputSaturation = 1.0f;


- (UIImage *) imageWithFilter: (UIImageFilterType) kFilterType{
    //underlying Core Image data of the image
    CIImage *ciImage = self.CIImage;
    //if ciImage is null this means the underlying data was a CGImage, which must be converted to a CIImage
    if (!ciImage){
        ciImage = [[CIImage alloc] initWithCGImage:self.CGImage];
    }
    //the filter that will be applied to the ciImage
    CIFilter *filter;
    switch (kFilterType) {
        case UIImageFilterTypeSepia:{
            filter = [CIFilter filterWithName:@"CISepiaTone" keysAndValues: kCIInputImageKey, ciImage, kCIInputIntensityKey, @(SepiaPresetInputIntensity), nil];
            break;
        }
        case UIImageFilterTypeVignette:{
            filter = [CIFilter filterWithName:@"CIVignette" keysAndValues: kCIInputImageKey, ciImage, kCIInputIntensityKey, @(VignettePresetInputIntensity), kCIInputRadiusKey, @(VignettePresetInputRadius), nil];
            break;
        }
        case UIImageFilterTypeTemperature:{
            filter = [CIFilter filterWithName:@"CITemperatureAndTint" keysAndValues: kCIInputImageKey, ciImage, @"inputNeutral", [CIVector vectorWithX:TemperaturePresetInputNeutralX Y:TemperaturePresetInputNeutralY], @"inputTargetNeutral", [CIVector vectorWithX:TemperaturePresetInputTargetNeutralX Y:TemperaturePresetInputTargetNeutralY] , nil];
            break;
        }
        case UIImageFilterTypeColorInvert:{
            filter = [CIFilter filterWithName:@"CIColorInvert" keysAndValues: kCIInputImageKey, ciImage, nil];
            break;
        }
        case UIImageFilterTypeHue:{
            filter = [CIFilter filterWithName:@"CIHueAdjust" keysAndValues: kCIInputImageKey, ciImage, kCIInputAngleKey, @(HuePresetInputAngle), nil];
            break;
        }
        case UIImageFilterTypeExposure:{
            filter = [CIFilter filterWithName:@"CIExposureAdjust" keysAndValues: kCIInputImageKey, ciImage, kCIInputEVKey, @(ExposurePresetInputEV), nil];
            break;
        }
        case UIImageFilterTypeHighlightShadow:{
            filter = [CIFilter filterWithName:@"CIHighlightShadowAdjust" keysAndValues: kCIInputImageKey, ciImage, @"inputHighlightAmount", @(HighlightShadowPresetInputHighlight), @"inputShadowAmount", @(HighlightShadowPresetInputShadow), nil];
            break;
        }
        case UIImageFilterTypeColorControl:{
            filter = [CIFilter filterWithName:@"CIColorControls" keysAndValues: kCIInputImageKey, ciImage, kCIInputBrightnessKey, @(ColorControlPresetInputBrightness), kCIInputContrastKey, @(ColorControlPresetInputContrast),kCIInputSaturationKey, @(ColorControlPresetInputSaturation), nil];
            break;
        }
        default:
            break;
    }
    return [UIImage imageWithCIImage:[filter outputImage]];
}

@end
