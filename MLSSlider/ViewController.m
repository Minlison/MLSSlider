//
//  ViewController.m
//  MLSSlider
//
//  Created by Apple on 15/11/9.
//

#import "ViewController.h"
#import "MLSSlider.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet MLSSlider *slider;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.slider addTarget:self action:@selector(changed1) forControlEvents:MLSSliderControlEventsValueDidChanged];
	[self.slider addTarget:self action:@selector(changed2) forControlEvents:MLSSliderControlEventsValueEndChanged];
	[self.slider addTarget:self action:@selector(changed3) forControlEvents: MLSSliderControlEventsValueWillChanged];
    
}

- (void)changed1
{
	NSLog(@"1");
}
- (void)changed2
{
	NSLog(@"2");
}
- (void)changed3
{
	NSLog(@"3");
}
@end
