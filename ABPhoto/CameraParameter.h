//
//  CameraParameter.h
//  ABPhoto
//
//  Created by Liang Cheng on 1/28/14.
//  Copyright (c) 2014 Liang Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kGridOn,
    kGridOff
} CameraGridParam;

typedef enum {
    kBackCamera,
    kFrontCamera
} CameraSelectionParam;

typedef enum {
    kFlashNotAvailable,
    kFlashAuto,
    kFlashOn,
    KFlashOff
} CameraFlashParam;

typedef enum {
    kCameraNotAvailable,
    kCameraBackOnly,
    kCameraBackAndFront
} CameraCapability;

typedef struct {
    CameraCapability capability;
    CameraGridParam gridParam;
    CameraSelectionParam selectionParam;
    CameraFlashParam flashParam;
}CameraParams;