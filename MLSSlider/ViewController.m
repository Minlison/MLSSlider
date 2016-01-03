//
//  ViewController.m
//  MLSSlider
//
//  Created by Apple on 15/11/9.
//

#import "ViewController.h"
#import "MLSSlider.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *bootomView = [[UIView alloc] init];
    bootomView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:bootomView];
    bootomView.backgroundColor = [UIColor blackColor];
    
    
    MLSSlider *slider = [[MLSSlider alloc] init];
    [bootomView addSubview:slider];
    slider.trackTouch = YES;
    slider.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    NSDictionary *views = NSDictionaryOfVariableBindings(slider,bootomView);
    
    [bootomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[slider]-20-|" options:0 metrics:nil views:views]];
    [bootomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[slider(30)]" options:0 metrics:nil views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[bootomView(100)]" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[bootomView]-20-|" options:0 metrics:nil views:views]];
    
    
    [slider addTarget:self action:@selector(valueChanged:) forControlEvents:(UIControlEventValueChanged)];
    slider.maximumValue = 1;
    slider.minimumValue = 0;
    slider.value = 0.3;
    slider.bufferValue = 0.3*1.2;
    // 测试color
//    slider.minimumTrackTintColor = [UIColor blueColor];
//    slider.maximumTrackTintColor = [UIColor whiteColor];
//    slider.bufferTintColor = [UIColor greenColor];
    
    // 测试图片
    [slider setMaximumTrackImage:[UIImage imageNamed:@"track_right_undo"] forState:(UIControlStateNormal)];
    
    [slider setThumbImage:[UIImage imageNamed:@"player_p2_pro"] forState:(UIControlStateNormal)];
    [slider setMinimumTrackImage:[UIImage imageNamed:@"track_left"] forState:(UIControlStateNormal)];
    [slider setBufferTrackImage:[UIImage imageNamed:@"track_right"] forState:(UIControlStateNormal)];
    
}
- (void)valueChanged:(MLSSlider *)slider {
    slider.bufferValue = slider.value * 1.2;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
