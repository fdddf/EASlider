//
//  EASlider.h
//  EASlider
//
//  Created by Yongliang Wang on 1/19/16.
//  Copyright © 2016 Yongliang Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EAThumb;
@interface EASlider : UIControl

@property(nonatomic, strong) EAThumb *thumb;
@property(nonatomic, strong) NSMutableArray *titleLabels;
@property(nonatomic, strong) UIColor *progressColor;
@property(nonatomic, assign) NSInteger selectedIndex;
@property(nonatomic, assign) BOOL continuous;

- (instancetype)initWithLabels:(NSArray *)labels;

- (void)setSelectedIndex:(NSInteger)index animated:(BOOL)animated;
- (void)setSelectedIndex:(NSInteger)index;
@end
