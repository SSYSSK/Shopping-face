//
//  TEEOpenCVUtil.h
//  PhotoShopping
//
//  Created by TEE on 2019/2/25.
//  Copyright © 2019 TEE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "../FaceDlibWrapper.h"
#ifdef __cplusplus
#import <opencv2/opencv.hpp>
#import "UIImage+OpenCV.h"
#endif

NS_ASSUME_NONNULL_BEGIN

@interface TEEOpenCVUtil : NSObject

+ (void)imageFromCIImage:(UIImage *)ciImage imageview:(UIImageView *)imageview bounds:(NSMutableArray*)bounds face:(FaceDlibWrapper*)face;
@end

NS_ASSUME_NONNULL_END
