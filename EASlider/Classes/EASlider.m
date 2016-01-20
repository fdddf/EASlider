//
//  EASlider.m
//  EASlider
//
//  Created by Yongliang Wang on 1/19/16.
//  Copyright © 2016 Yongliang Wang. All rights reserved.
//

#import "EASlider.h"
#import "EAThumb.h"

#define kEASliderThumbWidth 30
#define kEASliderThumbHeight 33
#define kEASliderShadowHeight (kEASliderThumbHeight-kEASliderThumbWidth)
#define kEASliderLeftOffset kEASliderThumbWidth/2
#define kEASliderRightOffset kEASliderThumbWidth/2
#define kEASliderSelectedTitleDistance 10
#define kEASliderLineHeight 6

@interface EASlider ()
{
    BOOL dragging;
    CGFloat dragOffset;
}
@end

@implementation EASlider

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.titleLabels = [NSMutableArray arrayWithArray:[self defaultLabels]];
        [self commitInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        self.titleLabels = [NSMutableArray arrayWithArray:[self defaultLabels]];
        [self commitInit];
    }
    return self;
}

- (instancetype)initWithLabels:(NSArray *)labels
{
    self = [super initWithFrame:CGRectZero];
    if(self){
        self.titleLabels = [NSMutableArray arrayWithArray:labels];
        [self commitInit];
    }
    return self;
}

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //Fill Main Path
    CGContextSetFillColorWithColor(context, self.progressColor.CGColor);
    CGContextFillRect(context, CGRectMake(kEASliderLeftOffset, rect.size.height - kEASliderShadowHeight - kEASliderThumbWidth/2, rect.size.width-kEASliderRightOffset-kEASliderLeftOffset, 1));
    CGContextSaveGState(context);
    
    CGPoint centerPoint;
    for (NSInteger i = 0; i < [self.titleLabels count]; i++) {
        centerPoint = [self centerPointForIndex:i];
        
        CGContextSetLineWidth(context, .5f);
        CGContextSetStrokeColorWithColor(context, self.progressColor.CGColor);
        
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, centerPoint.x, centerPoint.y-kEASliderLineHeight/2);
        CGContextAddLineToPoint(context, centerPoint.x, centerPoint.y+kEASliderLineHeight/2);
        CGContextStrokePath(context);
    }
}

/**
 *  Default label
 *
 *  @param text string
 *
 *  @return UILabel
 */
- (UILabel *)labelWithText:(NSString *)text
{
    UILabel *label = [[UILabel alloc] init];
    
    [label setFont:[UIFont systemFontOfSize:14.f]];
    [label setTextColor:[UIColor blackColor]];
    label.textAlignment = NSTextAlignmentCenter;
    
    return label;
}

- (NSArray *)defaultLabels
{
    return @[[self labelWithText:@""], [self labelWithText:@""]];
}

- (void)commitInit
{
    self.backgroundColor = [UIColor clearColor];
    _progressColor = [UIColor grayColor];
    _selectedIndex = 0;
    _continuous = NO;
    
    [self configThumb];
    [self configureGestures];
    [self configLabels];
    
    [self setSelectedIndex:0];
}

- (void)layoutSubviews
{
    CGPoint currentPoint = [self centerPointForIndex:self.selectedIndex];
    self.thumb.center = currentPoint;
    
    for(int i=0; i<[self.titleLabels count]; i++){
        CGPoint p = [self centerPointForIndex:i];
        UILabel *label = self.titleLabels[i];
        CGFloat y = CGRectGetHeight(self.frame) - kEASliderThumbHeight;
        [label sizeToFit];
        if(i==self.selectedIndex){
            label.center = CGPointMake(p.x, y - CGRectGetHeight(label.frame)/2 - kEASliderSelectedTitleDistance);
            [label setAlpha:1];
        }else{
            label.center = CGPointMake(p.x, y - CGRectGetHeight(label.frame)/2);
            [label setAlpha:.8];
        }
    }
    
    [self setNeedsDisplay];
    
    [super layoutSubviews];
}

- (void)configThumb
{
    self.thumb = [[EAThumb alloc] initWithFrame:CGRectMake(0, 0, kEASliderThumbWidth, kEASliderThumbHeight)];
    [self addSubview:self.thumb];
}

- (void)configLabels
{
    [self.titleLabels enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addSubview:obj];
    }];
}

- (void)setTitleLabels:(NSMutableArray *)titleLabels
{
    if(_titleLabels != titleLabels){
        [_titleLabels enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        _titleLabels = titleLabels;
        
        [self configLabels];
        [self setNeedsLayout];
        [self setNeedsDisplay];
    }
}

/**
 *  Thumb center point
 *
 *  @param index
 *
 *  @return point of thumb center
 */
- (CGPoint)centerPointForIndex:(NSInteger)index
{
    NSInteger titlesCount = [self.titleLabels count];
    CGFloat x = (index/(float)(titlesCount-1)) * (CGRectGetWidth(self.frame)-kEASliderLeftOffset-kEASliderRightOffset) + kEASliderLeftOffset;
    CGFloat y = CGRectGetHeight(self.frame) - kEASliderShadowHeight - kEASliderThumbWidth/2;
    return CGPointMake(x, y);
}

- (void)configureGestures
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureDetected:)];
    [self addGestureRecognizer:tapGesture];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureDetected:)];
    [self addGestureRecognizer:panGesture];
}

- (void)tapGestureDetected:(UITapGestureRecognizer *)tapGesture {
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    CGPoint loc = [tapGesture locationInView:self];
    NSInteger index = [self selectedIndexForPoint:loc];
    [self setSelectedIndex:index animated:YES];
}

- (NSInteger)selectedIndexForPoint:(CGPoint)pnt
{
    CGFloat size = (CGRectGetWidth(self.frame) - kEASliderLeftOffset - kEASliderRightOffset) / ([self.titleLabels count]-1);
    NSInteger idx = round((pnt.x-kEASliderLeftOffset)/size);
    return idx;
}

- (void)setSelectedIndex:(NSInteger)index
{
    [self setSelectedIndex:index animated:NO];
}

- (void)setSelectedIndex:(NSInteger)index animated:(BOOL)animated
{
    _selectedIndex = index;
    [self updateLabelsToIndex:index animated:animated];
    [self moveThumbToIndex:index animated:animated];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)updateLabelsToIndex:(NSInteger)index animated:(BOOL)animated
{
    [self.titleLabels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
        if (animated)
        {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationBeginsFromCurrentState:YES];
        }
        
        if (idx == index) {
            CGPoint p = [self centerPointForIndex:idx];
            CGFloat y = CGRectGetHeight(self.frame) - kEASliderThumbHeight;
            label.center = CGPointMake(p.x, y - CGRectGetHeight(label.frame)/2 - kEASliderSelectedTitleDistance);
            [label setAlpha:1];
        }else{
            CGPoint p = [self centerPointForIndex:idx];
            CGFloat y = CGRectGetHeight(self.frame) - kEASliderThumbHeight;
            label.center = CGPointMake(p.x, y-CGRectGetHeight(label.frame)/2);
            [label setAlpha:0.8];
        }
        
        if (animated)
            [UIView commitAnimations];
    }];
}

- (void)moveThumbToIndex:(NSInteger)index animated:(BOOL)animated
{
    CGPoint toPoint = [self centerPointForIndex:index];
    
    if (animated)
        [UIView beginAnimations:nil context:nil];
    
    // Move handler
    self.thumb.center = toPoint;
    
    if (animated)
        [UIView commitAnimations];
}

- (void)moveThumbToPoint:(CGPoint)pnt
{
    CGPoint toPoint = CGPointMake(pnt.x, self.thumb.center.y);
    toPoint = [self fixFinalPoint:toPoint];
    self.thumb.center = toPoint;
    
    [self updateLabelsToIndex:[self selectedIndexForPoint:self.thumb.center]
                     animated:YES];
    [self sendActionsForControlEvents:UIControlEventTouchDragInside];
}

/**
 *  Fix point x inside parent view
 *
 *  @param pnt CGPoint
 *
 *  @return CGPoint x modified
 */
- (CGPoint)fixFinalPoint:(CGPoint)pnt
{
    if (pnt.x < kEASliderLeftOffset) {
        pnt.x = kEASliderLeftOffset;
    }else if (pnt.x > self.frame.size.width-kEASliderRightOffset){
        pnt.x = self.frame.size.width-kEASliderRightOffset;
    }
    return pnt;
}

- (void)panGestureDetected:(UIPanGestureRecognizer *)panGesture {
    CGPoint point = [panGesture locationInView:self];
    if (panGesture.state == UIGestureRecognizerStateBegan)
    {
        if (CGRectContainsPoint(CGRectInset(self.thumb.frame, -40, -40) , point))
        {
            dragOffset = point.x - CGRectGetMinX(self.thumb.frame);
            dragging = YES;
            [self moveThumbToPoint:CGPointMake(point.x - dragOffset, point.y)];
        }
        
        return;
    }
    
    // If no dragging, nothing to do
    if (!dragging)
        return;
    
    if (panGesture.state == UIGestureRecognizerStateEnded || panGesture.state == UIGestureRecognizerStateChanged || panGesture.state == UIGestureRecognizerStateCancelled)
    {
        [self moveThumbToPoint:CGPointMake(point.x - dragOffset, point.y)];
        
        if (panGesture.state == UIGestureRecognizerStateEnded || panGesture.state == UIGestureRecognizerStateCancelled)
        {
            [self sendActionsForControlEvents:UIControlEventTouchUpInside];
            NSInteger idx = [self selectedIndexForPoint:self.thumb.center];
            [self setSelectedIndex:idx
                          animated:YES];
            dragging = NO;
        }
        else if (_continuous)
        {
            // Update selected index if continuous
            NSInteger idx = [self selectedIndexForPoint:self.thumb.center];
            if (idx != _selectedIndex)
            {
                _selectedIndex = idx;
                [self sendActionsForControlEvents:UIControlEventValueChanged];
            }
        }
    }
}

@end
