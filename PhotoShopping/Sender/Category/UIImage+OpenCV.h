//
//  UIImage+OpenCV.h
//  opencvtest
//
//  Created by Engin Kurutepe on 26/01/15.
//  Copyright (c) 2015 Fifteen Jugglers Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMedia/CMTime.h>
#import <AVFoundation/AVFoundation.h>
#ifdef __cplusplus
#import <opencv2/opencv.hpp>



#endif


@interface UIImage (OpenCV)

+ (UIImage *)imageFromCVMat:(cv::Mat)mat;
+ (UIImage *)imageFromPixelBuffer:(CMSampleBufferRef)p;

- (cv::Mat)cvMatRepresentationColor;
- (cv::Mat)cvMatRepresentationGray;

@end
