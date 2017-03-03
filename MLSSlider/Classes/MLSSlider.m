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
	[self _InitDefault];
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
	if (CGSizeEqualToSize(CGSizeZero, self.thumbSize))
	{
		self.thumbSize = thumbImage.size;
	}
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
	
	CGFloat width = CGRectGetWidth(self.bounds);
	CGFloat height = CGRectGetHeight(self.bounds);
	CGFloat minPercent = CZ_LESS_ZERO((self.value - self.minimumValue)) / CZ_LESS_ZERO(self.maximumValue - self.minimumValue);
	CGFloat minTrackWidth = width * minPercent;
	CGRect thumbImgRect = CGRectMake(minTrackWidth - self.thumbSize.width * 0.5, (height - self.thumbSize.height) * 0.5, self.thumbSize.width, self.thumbSize.height);
	
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
		if (location.x <= 0)
		{
			percent = 0.0;
			self.value = self.minimumValue;
		}
		else if (location.x >= CGRectGetWidth(self.bounds))
		{
			percent = 1.0;
			self.value = self.maximumValue;
		}
		else
		{
			percent = location.x / CGRectGetWidth(self.bounds);
			self.value = (self.maximumValue - self.minimumValue) * percent;
		}
		[self sendActionsForControlEvents:(UIControlEventValueChanged)];
		
		[self.totoalProgress becomeCurrentWithPendingUnitCount:(self.totoalProgress.totalUnitCount * percent)];
		[self.totoalProgress resignCurrent];
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

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
	CGFloat margin = ABS(self.thumbSize.height - self.frame.size.height) * 0.5;
	CGFloat height = self.frame.size.height;
	CGFloat width  = self.frame.size.width;
	
	if (point.y < 0 && (ABS(point.y) < margin))
	{
		return YES;
	}
	
	if (point.y > 0 && point.y > height && ((point.y - height) < margin))
	{
		return YES;
	}
	
	if (point.x < 0 && (ABS(point.x) < margin))
	{
		return YES;
	}
	
	if (point.x > 0 && point.x > width && ((point.x - width) < margin))
	{
		return YES;
	}
	
	return [super pointInside:point withEvent:event];
}

- (void)drawRect:(CGRect)rect
{
	[self.backgroundColor setFill];
	UIRectFill([self bounds]);
	self.layer.sublayers = nil;
	
	CGFloat minPercent = CZ_LESS_ZERO((self.value - self.minimumValue)) / CZ_LESS_ZERO(self.maximumValue - self.minimumValue);
	CGFloat bufferPercent = CZ_LESS_ZERO(self.bufferValue - self.minimumValue) / CZ_LESS_ZERO(self.maximumValue - self.minimumValue);
	
	CGFloat width = CGRectGetWidth(rect);
	CGFloat height = CGRectGetHeight(rect);
	
	CGFloat minTrackWidth = width * minPercent;
	CGRect minTrackRect = CGRectMake(0, 0, minTrackWidth, height);
	CGRect maxTrackRect = CGRectMake(minTrackWidth, 0, width - minTrackWidth, height);
	
	CGRect thumbImgRect = CGRectMake(minTrackWidth - self.thumbSize.width * 0.5, (height - self.thumbSize.height) * 0.5, self.thumbSize.width, self.thumbSize.height);
	
	CGRect bufferRect = CGRectZero;
	if (bufferPercent > minPercent)
	{
		bufferRect = CGRectMake(minTrackWidth, 0, (bufferPercent - minPercent) * width, height);
	}
	
	CALayer *imageLayer = [CALayer layer];
	imageLayer.contentsScale = [UIScreen mainScreen].scale;
	imageLayer.frame = thumbImgRect;
	imageLayer.backgroundColor = self.thumbColor.CGColor;
	imageLayer.contents = (id)self.thumbImage.CGImage;
	imageLayer.cornerRadius = thumbImgRect.size.width * 0.5;
	imageLayer.masksToBounds = YES;
	
	CALayer *minTrackLayer = [CALayer layer];
	minTrackLayer.frame = minTrackRect;
	minTrackLayer.backgroundColor = self.minimumTrackColor.CGColor;
	
	CALayer *maxTrackLayer = [CALayer layer];
	maxTrackLayer.frame = maxTrackRect;
	maxTrackLayer.backgroundColor = self.maximumTrackColor.CGColor;
	
	CALayer *bufferTrackLayer = [CALayer layer];
	bufferTrackLayer.frame = bufferRect;
	bufferTrackLayer.backgroundColor = self.bufferColor.CGColor;
	
	[self.layer addSublayer:maxTrackLayer];
	[self.layer addSublayer:bufferTrackLayer];
	[self.layer addSublayer:minTrackLayer];
	[self.layer addSublayer:imageLayer];
}
- (void)dealloc
{
	[self.bufferProgress removeObserver:self forKeyPath:FractionCompletedKeyPath];
	[self.totoalProgress removeObserver:self forKeyPath:FractionCompletedKeyPath];
}
@end
