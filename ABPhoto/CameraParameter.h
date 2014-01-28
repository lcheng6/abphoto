//
//  CameraParameter.h
//  ABPhoto
//
//  Created by Liang Cheng on 1/28/14.
//  Copyright (c) 2014 Liang Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kGridAvailable,
    kGridOn,
    kGridOff
} CameraGridParam;

typedef enum {
    kCameraNotAvailable,
    kBackCamera,
    kFrontCamera
} CameraSelectionParam;

typedef enum {
    kFlashNotAvailable,
    kFlashAuto,
    kFlashOn,
    KFlashOff
} CameraFlashParam;

typedef struct {
    CameraGridParam gridParam;
    CameraSelectionParam selectionParam;
    CameraFlashParam flashParam;
}CameraParams;