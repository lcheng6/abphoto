//
//  UIImage+Filters.h
//  ImageFilter
//
//  Created by dasmer on 1/11/14.
//  Copyright (c) 2014 Columbia University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Filters)
typedef enum {
    UIImageFilterTypeSepia,
    UIImageFilterTypeVignette,
    UIImageFilterTypeTemperature,
    UIImageFilterTypeColorInvert,
    UIImageFilterTypeHue,
    UIImageFilterTypeExposure,
    UIImageFilterTypeHighlightShadow,
    UIImageFilterTypeColorControl

} UIImageFilterType;

- (UIImage *) imageWithFilter: (UIImageFilterType) kFilterType;

@end
