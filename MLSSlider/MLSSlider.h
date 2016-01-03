//
//  MLSSlider.h
//  MLSSlider
//
//  Created by Apple on 15/11/9.
//


#import <UIKit/UIKit.h>

@interface MLSSlider : UISlider
@property (strong, nonatomic) UIImage *bufferImage;
@property (strong, nonatomic) UIColor *bufferTintColor;

- (void)setBufferTrackImage:(UIImage *)image forState:(UIControlState)state;
// 缓存进度值
@property (assign, nonatomic) CGFloat bufferValue;
// 是否支持点击追踪
@property (assign, nonatomic, getter=isTrackTouch) BOOL trackTouch;

@end
