//
//  MLSSlider.m
//  MLSSlider
//
//  Created by Apple on 15/11/9.
//

#import "MLSSlider.h"
@interface MLSSlider()
@property (strong, nonatomic) UIImageView *bufferView; // 缓冲进度
@property (assign, atomic) CGFloat layoutHeight;
@property (strong, nonatomic) UIView *bufferSuperView;
@property (assign, nonatomic) CGRect bufferFrame;
@end
@implementation MLSSlider
- (instancetype)init {
    if (self = [super init]) {
        [self setupUI];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupUI];
    }
    return self;
}
- (void)setupUI {
    self.bufferSuperView = nil;
    self.bufferView = nil;
}
- (void)setBufferTrackImage:(UIImage *)image forState:(UIControlState)state {
    [self.bufferView setImage:image];
    [self.bufferView sizeToFit];
}
- (void)setBufferImage:(UIImage *)bufferImage {
    _bufferImage = bufferImage;
    [self.bufferView setImage:bufferImage];
    [self.bufferView sizeToFit];
}
- (void)setMaximumTrackTintColor:(UIColor *)maximumTrackTintColor {
    UIImage *image = [self creatImageFromColor:maximumTrackTintColor];
    [self setMaximumTrackImage:image forState:(UIControlStateNormal)];
}
- (void)setMinimumTrackTintColor:(UIColor *)minimumTrackTintColor {
    UIImage *image = [self creatImageFromColor:minimumTrackTintColor];
    [self setMinimumTrackImage:image forState:(UIControlStateNormal)];
}
- (void)setBufferTintColor:(UIColor *)bufferTintColor {
    UIImage *image = [self creatImageFromColor:bufferTintColor];
    [self setBufferTrackImage:image forState:(UIControlStateNormal)];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.layoutHeight = self.frame.size.height;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[UIImageView class]]) {
                continue;
            }else {
                self.bufferSuperView = view;
            }
        }
        if (self.bufferSuperView != nil) {
            [self.bufferSuperView addSubview:self.bufferView];
        }
    });
    
    self.bufferView.frame = self.bufferFrame;
}
- (void)setBufferValue:(CGFloat)bufferValue {
    _bufferValue = bufferValue;
    
    CGFloat bufferX = 0;
    CGFloat bufferY = 0;
    CGFloat bufferW = 0;
    if (self.bufferValue > self.value) {
        bufferW = (self.bufferValue - self.value) * self.frame.size.width;
    }
    CGFloat bufferH = self.bufferSuperView.frame.size.height;
    self.bufferFrame = CGRectMake(bufferX, bufferY, bufferW, bufferH);
    
    [self layoutSubviews];
}


- (UIImageView *)bufferView {
    if (_bufferView == nil) {
        _bufferView = [[UIImageView alloc] init];
    }
    return _bufferView;
}
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    
    if (self.trackTouch) {
        CGPoint point = [touch locationInView:self];
        self.value = point.x / self.frame.size.width * self.maximumValue;
        [self sendActionsForControlEvents:(UIControlEventValueChanged)];
    }
    
    return [super beginTrackingWithTouch:touch withEvent:event];
}
- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    if (self.trackTouch) {
        CGPoint point = [touch locationInView:self];
        self.value = point.x / self.frame.size.width * self.maximumValue;
        [self sendActionsForControlEvents:(UIControlEventValueChanged)];
    }
    return [super continueTrackingWithTouch:touch withEvent:event];
}
- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super endTrackingWithTouch:touch withEvent:event];
}

- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value {
    
    CGRect thumbRect = [super thumbRectForBounds:bounds trackRect:rect value:value];
    if (value == self.minimumValue) {
        thumbRect.origin.x -= 5;
    }else if (value == self.maximumValue) {
        thumbRect.origin.x += 5;
    }
    return thumbRect;
}


- (UIImage *)creatImageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 2, 2);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}
@end
