//
//  CZSlider.m
//  ChengZiPlayerTest
//
//  Created by MinLison on 2017/2/22.
//  Copyright © 2017年 com.chengzivr.orgz. All rights reserved.
//

#import "MLSSlider.h"

#define CZ_LESS_ZERO(value) ((value) < 0 ? 0 : (value))

static void *BufferProgressContext = &BufferProgressContext;
static void *TotoalProgressContext = &TotoalProgressContext;
static NSString *const FractionCompletedKeyPath = @"fractionCompleted";

@interface MLSSlider()

/**
 是否点中了滑块
 */
@property (assign, nonatomic) BOOL thumbSel;
@end

@implementation MLSSlider
- (void)awakeFromNib
{
	[super awakeFromNib];
//	[self _InitDefault];
}
- (void)_InitDefault
{
	self.minimumValue = 0.0;
	self.maximumValue = 1.0;
	self.value = 0.5;
	self.backgroundColor = [UIColor clearColor];
	self.clipsToBounds = NO;
	self.layer.masksToBounds = NO;
	self.maximumTrackColor = [UIColor grayColor];
	self.minimumTrackColor = [UIColor orangeColor];
	self.bufferColor = [UIColor lightGrayColor];
	self.thumbColor = [UIColor whiteColor];
}
- (instancetype)init
{
	if (self == [super init])
	{
		[self _InitDefault];
	}
	return self;
}
- (void)setThumbSel:(BOOL)thumbSel
{
	_thumbSel = thumbSel;
	if (thumbSel)
	{
		[self sendActionsForControlEvents:(MLSSliderControlEventsValueWillChanged)];
	}
	else
	{
		[self sendActionsForControlEvents:(MLSSliderControlEventsValueEndChanged)];
	}
}
- (void)setBufferProgress:(NSProgress *)bufferProgress
{
	if (!_bufferProgress) {
		[_bufferProgress removeObserver:self forKeyPath:FractionCompletedKeyPath];
	}
	_bufferProgress = bufferProgress;
	
	[bufferProgress addObserver:self forKeyPath:FractionCompletedKeyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:BufferProgressContext];
}
- (void)setTotoalProgress:(NSProgress *)totoalProgress
{
	if (!_totoalProgress)
	{
		[_totoalProgress removeObserver:self forKeyPath:FractionCompletedKeyPath];
	}
	_totoalProgress = totoalProgress;
	[totoalProgress addObserver:self forKeyPath:FractionCompletedKeyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:TotoalProgressContext];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
	if (context == BufferProgressContext)
	{
		self.bufferValue = self.bufferProgress.fractionCompleted * self.maximumValue;
	}
	else if (context == TotoalProgressContext)
	{
		self.value = self.totoalProgress.fractionCompleted * self.maximumValue;
	}
}
- (void)setMinimumValue:(float)minimumValue
{
	_minimumValue = minimumValue;
	[self setNeedsDisplay];
}
- (void)setMaximumValue:(float)maximumValue
{
	_maximumValue = maximumValue;
	[self setNeedsDisplay];
}
- (void)setValue:(float)value
{
	_value = value;
	if (value < self.minimumValue || value > self.maximumValue)
	{
		return;
	}
	[self setNeedsDisplay];
}
- (void)setThumbSize:(CGSize)thumbSize
{
	_thumbSize = thumbSize;
	[self setNeedsDisplay];
}
- (void)setThumbImage:(UIImage *)thumbImage
{
	_thumbImage = thumbImage;
	[self setNeedsDisplay];
}
- (void)setMaximumTrackColor:(UIColor *)maximumTrackColor
{
	_maximumTrackColor = maximumTrackColor;
	[self setNeedsDisplay];
}
- (void)setMinimumTrackColor:(UIColor *)minimumTrackColor
{
	_minimumTrackColor = minimumTrackColor;
	[self setNeedsDisplay];
}
- (void)setBufferColor:(UIColor *)bufferColor
{
	_bufferColor = bufferColor;
	[self setNeedsDisplay];
}

- (void)setBufferValue:(float)bufferValue
{
	_bufferValue = bufferValue;
	[self setNeedsDisplay];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = touches.anyObject;
	CGPoint location = [touch locationInView:self];
	
	
	CGFloat minPercent = CZ_LESS_ZERO((self.value - self.minimumValue)) / CZ_LESS_ZERO(self.maximumValue - self.minimumValue);
	CGFloat progressWidth = self.progressSize.width  - self.thumbSize.width;
	CGFloat minTrackWidth = progressWidth * minPercent;
	
	CGFloat x = (CGRectGetWidth(self.bounds) - progressWidth) * 0.5 + minTrackWidth;
	
	CGRect thumbImgRect = CGRectMake(x - self.responseSize.width * 0.5, 0, self.responseSize.width, self.responseSize.height);
	
	if (CGRectContainsPoint(thumbImgRect, location))
	{
		self.thumbSel = YES;
	}
	else
	{
		self.thumbSel = NO;
	}
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
	if (self.thumbSel)
	{
		UITouch *touch = touches.anyObject;
		CGPoint location = [touch locationInView:self];
		CGFloat percent = 0.0;
		CGFloat minLoc = ((CGRectGetWidth(self.bounds) - self.progressSize.width - self.thumbSize.width) * 0.5);
		CGFloat maxLoc = ((CGRectGetWidth(self.bounds) + self.progressSize.width + self.thumbSize.width) * 0.5);
		if (location.x <= minLoc)
		{
			percent = 0.0;
			self.value = self.minimumValue;
		}
		else if (location.x >= maxLoc)
		{
			percent = 1.0;
			self.value = self.maximumValue;
		}
		else
		{
			percent = CZ_LESS_ZERO(location.x - minLoc) / (maxLoc - minLoc);
			
			self.value = (self.maximumValue - self.minimumValue) * percent;
		}
		[self sendActionsForControlEvents:(MLSSliderControlEventsValueDidChanged)];
	}
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
	self.thumbSel = NO;
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
	self.thumbSel = NO;
}

- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
	self.layer.contentsScale = [UIScreen mainScreen].scale;
	
	if (CGSizeEqualToSize(self.responseSize, CGSizeZero))
	{
		self.responseSize = CGSizeMake(CGRectGetHeight(rect), CGRectGetHeight(rect));
	}
	if (CGSizeEqualToSize(CGSizeZero, self.thumbSize) || self.thumbSize.height > CGRectGetHeight(rect))
	{
		self.thumbSize = CGSizeMake(CGRectGetHeight(rect), CGRectGetHeight(rect));
	}
	if (CGSizeEqualToSize(CGSizeZero, self.progressSize))
	{
		self.progressSize = CGSizeMake(CGRectGetWidth(rect), CGRectGetHeight(rect) * 0.5);
	}
	
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	CGFloat minPercent = CZ_LESS_ZERO((self.value - self.minimumValue)) / CZ_LESS_ZERO(self.maximumValue - self.minimumValue);
	
	CGFloat bufferPercent = CZ_LESS_ZERO(self.bufferValue - self.minimumValue) / CZ_LESS_ZERO(self.maximumValue - self.minimumValue);
	
	CGFloat progressWidth = self.progressSize.width  - self.thumbSize.width;
	
	CGFloat progressHeight = self.progressSize.height;
	
	CGFloat progressY = CZ_LESS_ZERO((CGRectGetHeight(rect) - progressHeight) * 0.5);
	
	CGFloat minTrackWidth = progressWidth * minPercent;
	
	CGFloat x = (CGRectGetWidth(rect) - progressWidth) * 0.5;
	
	// 左侧已走进度
	CGRect minTrackRect = CGRectMake(x, progressY, minTrackWidth, progressHeight);
	
	// 右侧未走进度
	x += minTrackWidth;
	CGRect maxTrackRect = CGRectMake(x, progressY, progressWidth - minTrackWidth, progressHeight);
	
	// thumb rect
	CGRect thumbImgRect = CGRectMake(x - self.thumbSize.width * 0.5, 0, self.thumbSize.width, self.thumbSize.height);
	
	// 缓冲进度
	CGRect bufferRect = CGRectZero;
	if (bufferPercent > minPercent)
	{
		bufferRect = CGRectMake(x, progressY, (bufferPercent - minPercent) * progressWidth, progressHeight);
	}
	
	[self.backgroundColor setFill];
	
	// 左侧已走进度
	CGContextSaveGState(ctx);
	[self.minimumTrackColor setFill];
	CGContextMoveToPoint(ctx, 0, 0);
	CGContextAddRect(ctx, minTrackRect);
	CGContextFillPath(ctx);
	CGContextRestoreGState(ctx);
	
	// 右侧未走进度
	CGContextSaveGState(ctx);
	[self.maximumTrackColor setFill];
	CGContextMoveToPoint(ctx, CGRectGetWidth(minTrackRect), 0);
	CGContextAddRect(ctx, maxTrackRect);
	CGContextFillPath(ctx);
	CGContextRestoreGState(ctx);
	
	// 缓冲 buffer
	CGContextSaveGState(ctx);
	[self.bufferColor setFill];
	CGContextMoveToPoint(ctx, CGRectGetWidth(bufferRect), 0);
	CGContextAddRect(ctx, bufferRect);
	CGContextFillPath(ctx);
	CGContextRestoreGState(ctx);
	
	// thumb
	CGContextSaveGState(ctx);
	
	if (self.thumbImage)
	{
		//以矩形ctx为依据画一个圆
		CGContextAddEllipseInRect(ctx, thumbImgRect);
		//设置裁剪区域
		CGContextClip(ctx);
		// 把图片加入smallRect的矩形区域内，超过上面设定的裁剪区域的部分将被裁剪掉
		CGContextDrawImage(ctx, thumbImgRect, self.thumbImage.CGImage);
		// 将上下文的内容渲染到视图的layer图层上
		CGContextStrokePath(ctx);
	}
	else
	{
		[self.thumbColor setFill];
		//以矩形ctx为依据画一个圆
		CGContextAddEllipseInRect(ctx, thumbImgRect);
		CGContextFillPath(ctx);
		
	}
	CGContextRestoreGState(ctx);
	

}
- (void)dealloc
{
	[self.bufferProgress removeObserver:self forKeyPath:FractionCompletedKeyPath];
	[self.totoalProgress removeObserver:self forKeyPath:FractionCompletedKeyPath];
}
@end
