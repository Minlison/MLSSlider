//
//  CZSlider.h
//  ChengZiPlayerTest
//
//  Created by MinLison on 2017/2/22.
//  Copyright © 2017年 com.chengzivr.orgz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, MLSSliderControlEvents)
{
	MLSSliderControlEventsValueWillChanged = 1 << 1,
	MLSSliderControlEventsValueDidChanged = 1 << 2,
	MLSSliderControlEventsValueEndChanged = 1 << 3,
};


#if !TARGET_INTERFACE_BUILDER
@interface MLSSlider : UIControl

/**
 总进度
 */
@property (strong, nonatomic) NSProgress *totoalProgress;

/**
 缓冲进度
 */
@property (strong, nonatomic) NSProgress *bufferProgress;

/**
 当前值 默认 0.5
 */
@property (assign, nonatomic) float value;

/**
 最小值 默认 0.0
 */
@property (assign, nonatomic) float minimumValue;

/**
 最大值 默认 1.0
 */
@property (assign, nonatomic) float maximumValue;

/**
 缓冲值 默认等于 value
 */
@property (assign, nonatomic) float bufferValue;

/**
 自定义滑块大小 Default CGSizeMake(self.bounds.size.height,self.bounds.size.height)
 */
@property (assign, nonatomic) CGSize thumbSize;

/**
 自定义进度高度, Default CGSizeMake(self.bounds.size.width, self.bounds.size.height * 0.5)
 */
@property (assign, nonatomic) CGSize progressSize;

/**
 thumb 响应范围大小 默认 CGSizeMake(self.bounds.size.height, self.bounds.size.height)
 */
@property (assign, nonatomic) CGSize responseSize;

/**
 缓冲进度颜色
 */
@property (strong, nonatomic) UIColor *bufferColor;

/**
 未完成进度颜色
 */
@property (strong, nonatomic) UIColor *maximumTrackColor;

/**
 已完成进度颜色
 */
@property (strong, nonatomic) UIColor *minimumTrackColor;

/**
 滑块图片
 */
@property (strong, nonatomic) UIImage *thumbImage;

/**
 滑块颜色，如果thubImage不为空，使用，默认为白色
 */
@property (strong, nonatomic) UIColor *thumbColor;

@end
#else // TARGET_INTERFACE_BUILDER
IB_DESIGNABLE
@interface MLSSlider : UIControl
@property (assign, nonatomic) IBInspectable float value;
@property (assign, nonatomic) IBInspectable float minimumValue;
@property (assign, nonatomic) IBInspectable float maximumValue;
@property (assign, nonatomic) IBInspectable float bufferValue;
@property (assign, nonatomic) IBInspectable CGSize thumbSize;
@property (assign, nonatomic) IBInspectable CGSize responseSize;
@property (assign, nonatomic) IBInspectable CGSize progressSize;
@property (strong, nonatomic) IBInspectable UIColor *bufferColor;
@property (strong, nonatomic) IBInspectable UIColor *maximumTrackColor;
@property (strong, nonatomic) IBInspectable UIColor *minimumTrackColor;
@property (strong, nonatomic) IBInspectable UIImage *thumbImage;
@property (strong, nonatomic) IBInspectable UIColor *thumbColor;
@end
#endif // !TARGET_INTERFACE_BUILDER
