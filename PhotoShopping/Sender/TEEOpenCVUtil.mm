//
//  TEEOpenCVUtil.m
//  PhotoShopping
//
//  Created by TEE on 2019/2/25.
//  Copyright © 2019 TEE. All rights reserved.
//

#import "TEEOpenCVUtil.h"
#import <UIKit/UIKit.h>
#import <CoreMedia/CMTime.h>
#import <AVFoundation/AVFoundation.h>

@implementation TEEOpenCVUtil

+ (void)imageFromCIImage:(UIImage *)image imageview:(UIImageView *)imageview bounds:(NSMutableArray *)facesLandmarks face:(FaceDlibWrapper *)face{
    
    cv::Mat mat;
    
    // 美颜
    //    mat = [self ImageTobilateraFilter:image];
    
    // 绘制68 个关键点
    for (NSArray *landmarks in facesLandmarks) {
        //        NSLog(@"坐标的总个数=%zd",landmarks.count);
        
        //        NSValue *value0 = landmarks[36];
        NSValue *value1 = landmarks[37];
        //        NSValue *value2 = landmarks[38];
        //        NSValue *vlaue3 = landmarks[39];
        //        NSValue *value4 = landmarks[40];
        
        // 嘴唇 20个点
        NSValue *value5 = landmarks[41];
        
        NSValue *value6 = landmarks[38];
        NSValue *value7 = landmarks[40];
        //        CGPoint point0 = [value0 CGPointValue];
        //        CGPoint point1 = [value1 CGPointValue];
        CGPoint point2 = [value1 CGPointValue];
        //        CGPoint point3 = [vlaue3 CGPointValue];
        //        CGPoint point4 = [value4 CGPointValue];
        CGPoint point5 = [value5 CGPointValue];
        
        CGPoint point6 = [value6 CGPointValue];
        CGPoint point7 = [value7 CGPointValue];
        
        //        for (AVMetadataFaceObject *object in self.currentMetadata) {
        //
        //            //            if (object.yawAngle >= 315) {//左转头
        //            //
        //            //            }else if (object.yawAngle >= 45 && object.yawAngle <= 90){//右转头
        //            //
        //            //            }
        //            if (object.yawAngle == 0) {//说明正脸面对镜头
        //                if (point5.y - point2.y < 5) {
        //
        //                    _isTwinkle = YES;
        //                }else{
        //                    //            NSLog(@"没有眨眼睛");
        //
        //                }
        //                if (point5.y - point2.y > 8) {
        //                    if (_isTwinkle == YES) {
        //                        //            dispatch_async(dispatch_get_main_queue(), ^{
        //                        //            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"眨眼睛了" message: nil preferredStyle:UIAlertControllerStyleAlert];
        //                        //                        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        //                        //                                            }]];
        //                        //                [self presentViewController:alertController animated:YES completion:nil];
        //                        //                            });
        //                    }
        //                    _isTwinkle = NO;
        //                }
        //            }
        //        }
        
        //        for (NSValue *point in landmarks) {
        //            CGPoint p = [point CGPointValue];
        //            NSLog(@"人脸信息坐标位置=%@",NSStringFromCGPoint(p));
        //            // 人脸信息坐标位置绘制点
        //            cv::rectangle(mat, cv::Rect(p.x,p.y,4,4), cv::Scalar(255,0,0,255),-1);
        //        }
        //        cv::Point pointArray = new [cv::Point]();
        
        for (int i = 0 ; i < landmarks.count; i++) {
            CGPoint p = [landmarks[i] CGPointValue];
            NSLog(@"人脸信息坐标位置=%@",NSStringFromCGPoint(p));
            
            // 人脸信息坐标位置绘制点
            cv::rectangle(mat, cv::Rect(p.x,p.y,4,4), cv::Scalar(255,0,0,255),-1);
            
            // 嘴唇美妆
            if ( i > 47 && i < 68) {
                //                cv::rectangle(mat, cv::Rect(p.x,p.y,8,8), cv::Scalar(179,0,0,10),-1);
                //                cv::Mat beautiful = cv::Mat::zeros(<#int rows#>, <#int cols#>, <#int type#>)
                //                cv::cvFillPoly(mat, point1, npts, 2, color);
                //                pointArray[i - 47] = p
                //cv::cvFillPoly(mat, point1, npts, 2, cv::Scalar(179,0,0,10));
            }
            
        }
        //cv::fillPoly(mat, InputArrayOfArrays pts, <#const Scalar &color#>)
    }
    
    for (NSValue *rect in facesLandmarks) {
        CGRect r = [rect CGRectValue];
        //画框
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            self.catImageView.frame = CGRectMake(r.origin.x, r.origin.y - r.size.width / 566 * 404, r.size.width, r.size.width / 566 * 404);
        //            self.catImageView.center = CGPointMake(r.origin.x + r.size.width / 2 - 50, r.origin.y - r.size.height / 2 );
        //        });
        cv::rectangle(mat, cv::Rect(r.origin.x,r.origin.y,r.size.width,r.size.height), cv::Scalar(255,0,0,255));
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        imageview.image = [UIImage imageFromCVMat:mat];
        //        self.cameraView.image = image;
    });
    
}

+(UIImage *)imageFromPixelBuffer:(CMSampleBufferRef)p {
    CVImageBufferRef buffer;
    buffer = CMSampleBufferGetImageBuffer(p);
    
    CVPixelBufferLockBaseAddress(buffer, 0);
    uint8_t *base;
    size_t width, height, bytesPerRow;
    base = (uint8_t *)CVPixelBufferGetBaseAddress(buffer);
    width = CVPixelBufferGetWidth(buffer);
    height = CVPixelBufferGetHeight(buffer);
    bytesPerRow = CVPixelBufferGetBytesPerRow(buffer);
    
    CGColorSpaceRef colorSpace;
    CGContextRef cgContext;
    colorSpace = CGColorSpaceCreateDeviceRGB();
    cgContext = CGBitmapContextCreate(base, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
    
    CGImageRef cgImage;
    UIImage *image;
    cgImage = CGBitmapContextCreateImage(cgContext);
    image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    CGContextRelease(cgContext);
    CVPixelBufferUnlockBaseAddress(buffer, 0);
    return image;
}
@end
