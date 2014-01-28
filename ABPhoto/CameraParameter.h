//
//  CameraParameter.h
//  ABPhoto
//
//  Created by Liang Cheng on 1/28/14.
//  Copyright (c) 2014 Liang Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kNotAvailable,
    kGridOn,
    kGridOff
} CameraGridParam;

typedef enum {
    kNotAvailable,
    kBackCamera,
    kFrontCamera
} CameraSelectionParam;

typedef enum {
    kNotAvailable,
    kFlashAuto,
    kFlashOn,
    KFlashOff
} CameraFlashParam;