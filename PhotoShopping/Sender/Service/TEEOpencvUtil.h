//
//  TEEOpencvUtil.h
//  PhotoShopping
//
//  Created by TEE on 2019/2/25.
//  Copyright © 2019 TEE. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TEEOpencvUtil : NSObject
+(void)facesLandmarks:(CMSampleBufferRef)sampleBuffer bounds:(NSMutableArray*)bounds;
@end

NS_ASSUME_NONNULL_END
