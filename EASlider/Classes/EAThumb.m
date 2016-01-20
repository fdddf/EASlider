//
//  EAThumb.m
//  EASlider
//
//  Created by Yongliang Wang on 1/19/16.
//  Copyright © 2016 Yongliang Wang. All rights reserved.
//

#import "EAThumb.h"

#define kThumbBorderWidth .5f
@implementation EAThumb

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Color Declarations
    UIColor* color2 = [UIColor colorWithRed: 0.886 green: 0.886 blue: 0.886 alpha: 1];
    UIColor* shadowColor = [UIColor colorWithRed: 0.786 green: 0.786 blue: 0.786 alpha: 1];
    
    CGFloat shadowHeight = 3;
    
    // Shadow Declarations
    NSShadow* shadow = [[NSShadow alloc] init];
    [shadow setShadowColor: shadowColor];
    [shadow setShadowOffset: CGSizeMake(0, shadowHeight)];
    [shadow setShadowBlurRadius: shadowHeight];
    
    // Oval Drawing
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(rect.origin.x, rect.origin.y, rect.size.width-1, rect.size.width-1)];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadow.shadowOffset, shadow.shadowBlurRadius, [shadow.shadowColor CGColor]);
    [[UIColor whiteColor] setFill];
    [ovalPath fill];
    CGContextRestoreGState(context);
    
    [color2 setStroke];
    ovalPath.lineWidth = .5;
    [ovalPath stroke];
}

@end
