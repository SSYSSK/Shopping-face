//
//  FaceDlibWrapper.h
//  EyeBlickCheck
//
//  Created by Lixin Zhou on 2018/11/1.
//  Copyright © 2018 Nile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import<UIKit/UIKit.h>

@interface FaceDlibWrapper : NSObject
- (NSArray <NSArray <NSValue *> *>*)detecitonOnSampleBuffer:(CMSampleBufferRef)sampleBuffer inRects:(NSArray<NSValue *> *)rects;
@end


