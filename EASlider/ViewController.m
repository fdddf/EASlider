//
//  ViewController.m
//  EASlider
//
//  Created by Yongliang Wang on 1/19/16.
//  Copyright © 2016 Yongliang Wang. All rights reserved.
//

#import "ViewController.h"
#import "EASlider.h"
#import <Masonry/Masonry.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.    
    
    EASlider *slider = [[EASlider alloc] initWithLabels:@[
                                                          [self labelWithFont:[UIFont systemFontOfSize:10.f] text:@"A"],
                                                          [self labelWithFont:nil text:@""],
                                                          [self labelWithFont:nil text:@""],
                                                          [self labelWithFont:nil text:@""],
                                                          [self labelWithFont:nil text:@""],
                                                          [self labelWithFont:[UIFont systemFontOfSize:30.f] text:@"A"],
                                                          ]];
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    slider.backgroundColor = [UIColor greenColor];
    [self.view addSubview:slider];
    
    [slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.left.equalTo(@30);
        make.right.equalTo(@(-30));
        make.height.equalTo(@100);
    }];
    
    EASlider *slider2 = [[EASlider alloc] initWithFrame:CGRectMake(10, 64, 300, 120)];
    slider2.progressColor = [UIColor blueColor];
    slider2.selectedIndex = 1;
    [slider2 setTitleLabels:[NSMutableArray arrayWithArray:@[
                                                             [self labelWithFont:nil text:@"Poor"],
                                                             [self labelWithFont:nil text:@"Good"],
                                                             [self labelWithFont:nil text:@"Excellent"]
                                                             ]]];
    [self.view addSubview:slider2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sliderValueChanged:(EASlider *)sender
{
    NSLog(@"slider value changed to: %li", (long)sender.selectedIndex);
}

- (UILabel *)labelWithFont:(UIFont *)font text:(NSString *)text
{
    UILabel *label = [[UILabel alloc] init];
    label.font = font ? font : [UIFont systemFontOfSize:14.f];
    label.text = text;
    label.textColor = [UIColor redColor];
    return label;
}

@end
