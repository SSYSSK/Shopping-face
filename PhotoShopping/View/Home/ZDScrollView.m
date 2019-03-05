//
//  ZDScrollView.m
//  ScrollToCenter
//
//  Created by zhudong on 2017/5/23.
//  Copyright © 2017年 zhudong. All rights reserved.
//

#import "ZDScrollView.h"
#define BaseTag_btn 1000

@interface ZDScrollView ()
{
    NSInteger selectIndex;
}
@property (nonatomic,strong) UIView *lineV;

@end
@implementation ZDScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.showsHorizontalScrollIndicator = false;
        self.showsVerticalScrollIndicator = false;
        self.scrollEnabled = false;
    }
    return self;
}

- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    [self addSubview:self.lineV];
    CGFloat btnW = (ScreenSize.width - 2 * _margin) / 6;
    CGFloat btnH = self.bounds.size.height;
    [titles enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:obj forState:UIControlStateNormal];
        btn.frame = CGRectMake(_margin + idx * btnW, 0, btnW, btnH);
        [self addSubview:btn];
        if (self.titleColor_normal) {
            [btn setTitleColor:self.titleColor_normal forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        if (self.titleColor_selected) {
            [btn setTitleColor:self.titleColor_selected forState:UIControlStateSelected];
        }else{
            [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        }
        btn.tag = BaseTag_btn + idx;
        if (idx == 0) {
            btn.selected = true;
            selectIndex =  btn.tag;
        }
        [btn addTarget:self action:@selector(selectedBtn:) forControlEvents:UIControlEventTouchUpInside];
    }];
    self.contentSize = CGSizeMake(btnW * titles.count + 2 * _margin, self.frame.size.height);
}

- (void)selectedBtn: (UIButton *)btn {
    if (selectIndex >= BaseTag_btn) {
        UIButton *oldSelectedBtn = [self viewWithTag: selectIndex];
        oldSelectedBtn.selected = false;
    }
    btn.selected = true;
    selectIndex =  btn.tag;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.lineV.frame = CGRectMake(btn.frame.origin.x, self.frame.size.height - _lineHeight, (ScreenSize.width - 2 * _margin) / 6, _lineHeight);
        CGFloat offSetX = btn.center.x - self.bounds.size.width * 0.5 + _margin;
//        CGFloat offsetX1 = (self.contentSize.width - btn.center.x) - self.bounds.size.width * 0.5 + _margin;
        self.contentOffset = CGPointMake(offSetX, 0);
//        if (offSetX > 0 && offsetX1 > 0) {
//            self.contentOffset = CGPointMake(offSetX, 0);
//        }else if(offSetX < 0){
//            self.contentOffset = CGPointMake(0, 0);
//        }else if (offsetX1 < 0){
//            self.contentOffset = CGPointMake(self.contentSize.width - self.bounds.size.width - _margin, 0);
//        }
    }];
    
}

- (UIView *)lineV{
    if (!_lineV) {
        _lineV = [[UIView alloc] initWithFrame:CGRectMake(_margin, self.frame.size.height - _lineHeight, (ScreenSize.width - 2 * _margin) / 6, 20)];
        if (self.titleColor_selected) {
            _lineV.backgroundColor = self.titleColor_selected;
        }else{
            _lineV.backgroundColor = [UIColor orangeColor];
        }
    }
    return _lineV;
}
@end
