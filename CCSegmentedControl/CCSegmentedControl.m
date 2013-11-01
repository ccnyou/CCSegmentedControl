//
//  CCSegmentedControl.m
//  b866
//
//  Created by ccnyou on 10/30/13.
//  Copyright (c) 2013 ccnyou. All rights reserved.
//

#import "CCSegmentedControl.h"

@interface DefaultStainView : UIView

@end


@interface CCSegmentedControl ()

@property (strong, nonatomic) NSMutableArray*       items;

@end


@implementation CCSegmentedControl

#pragma mark - Overrided
+ (Class)layerClass
{
    //CAShapeLayer,这个层提供了一个简单的可以使用核心图像路径在层树中组成一个阴影的方法
    return CAShapeLayer.class;
}

- (id)init
{
    if ((self = [super init]))
    {
        [self commonInit];
    }
    return self;
}


- (id)initWithItems:(NSArray *)items
{
    if ((self = [self init]))
    {
        [items enumerateObjectsUsingBlock:^(id title, NSUInteger idx, BOOL *stop)
         {
             [self insertSegmentWithTitle:title atIndex:idx animated:NO];
         }];
    }
    return self;
}

- (void)insertSegmentWithTitle:(NSString *)title atIndex:(NSUInteger)segmentIndex animated:(BOOL)animated
{
    UILabel *segmentView = [[UILabel alloc] init];
    segmentView.alpha = 0;
    segmentView.text = title;
    segmentView.textColor = self.segmentTextColor;
    segmentView.font = [UIFont boldSystemFontOfSize:15];
    segmentView.backgroundColor = UIColor.clearColor;
    segmentView.userInteractionEnabled = YES;
    [segmentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSelect:)]];
    [segmentView sizeToFit];
    
    NSUInteger index = MAX(MIN(segmentIndex, self.numberOfSegments), 0);
    if (index < self.items.count)
    {
        UIView* itemView = (UIView *)self.items[index];
        segmentView.center = itemView.center;
        [self insertSubview:segmentView belowSubview:self.items[index]];
        [self.items insertObject:segmentView atIndex:index];
    }
    else
    {
        //新增到最后的 item
        segmentView.center = self.center;
        [self addSubview:segmentView];
        [self.items addObject:segmentView];
    }
    
    //重新调整选中 item 的下标
    if (self.selectedSegmentIndex >= index)
    {
        self.selectedSegmentIndex++;
    }
    
    if (animated)
    {
        [UIView animateWithDuration:0.4 animations:^
         {
             [self layoutSubviews];
         }];
    }
    else
    {
        //这里其实也是调用 layoutSubviews 方法，时点不同
        [self setNeedsLayout];
    }
}

//在这里设定子视图的大小和位置
- (void)layoutSubviews
{
    CGFloat totalItemWidth = 0;
    for (UIView *item in self.items)
    {
        float itemWidth = CGRectGetWidth(item.bounds);
        totalItemWidth += itemWidth;
    }
    
    CGFloat spaceLeft = CGRectGetWidth(self.bounds) - totalItemWidth;
    CGFloat interItemSpace = spaceLeft / (CGFloat)(self.items.count + 1);
    CGFloat itemsVAlignCenter = CGRectGetHeight(self.bounds) / 2;   //垂直中心
    
    __block CGFloat pos = interItemSpace;
    [self.items enumerateObjectsUsingBlock:^(UIView *item, NSUInteger idx, BOOL *stop)
     {
         item.alpha = 1;
         if (self.selectedSegmentIndex == idx)
         {
             [item sizeToFit];
             item.center = CGPointMake(pos + CGRectGetWidth(item.bounds) / 2, itemsVAlignCenter);
         }
         else
         {
             item.frame = CGRectMake(pos, 0, CGRectGetWidth(item.bounds), itemsVAlignCenter * 2);
         }
         pos += CGRectGetWidth(item.bounds) + interItemSpace;
     }];
    
    if (self.selectedSegmentIndex == -1)
    {
        self.selectedStainView.hidden = NO;
        [self drawSelectedMaskAtPosition:-1];
    }
    else
    {
        UIView *selectedItem = self.items[self.selectedSegmentIndex];
        CGRect stainFrame = CGRectInset(selectedItem.frame, -4, -8);
        self.selectedStainView.layer.cornerRadius = stainFrame.size.height / 2;
        BOOL animated = !self.selectedStainView.hidden && !CGRectEqualToRect(self.selectedStainView.frame, CGRectZero);
        UIView.animationsEnabled = animated;
        [UIView animateWithDuration:animated ? 0.2 : 0 animations:^
         {
             self.selectedStainView.frame = stainFrame;
         }
                         completion:^(BOOL finished)
         {
             for (UILabel *item in self.items)
             {
                 if (item == selectedItem)
                 {
                     item.textColor = self.selectedSegmentTextColor;
                 }
                 else
                 {
                     item.textColor = self.segmentTextColor;
                 }
             }
             
             [self drawSelectedMaskAtPosition:selectedItem.center.x];
         }];
        UIView.animationsEnabled = YES;
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    CGRect frame = self.frame;
    if (frame.size.height == 0)
    {
        frame.size.height = 45;
    }
    if (frame.size.width == 0)
    {
        frame.size.width = CGRectGetWidth(newSuperview.bounds);
    }
}

- (void)removeAllSegments
{
    [self.items makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.items removeAllObjects];
    [self setNeedsLayout];
}

- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)segment
{
    NSUInteger index = MAX(MIN(segment, self.numberOfSegments - 1), 0);
    UILabel *segmentView = self.items[index];
    segmentView.text = title;
    [segmentView sizeToFit];
    [self setNeedsLayout];
}

- (NSString *)titleForSegmentAtIndex:(NSUInteger)segment
{
    NSUInteger index = MAX(MIN(segment, self.numberOfSegments - 1), 0);
    UILabel *segmentView = self.items[index];
    return segmentView.text;
}


- (void)removeSegmentAtIndex:(NSUInteger)segment animated:(BOOL)animated
{
    if (self.items.count == 0) return;
    NSUInteger index = MAX(MIN(segment, self.numberOfSegments - 1), 0);
    UIView *segmentView = self.items[index];
    
    if (self.selectedSegmentIndex >= index)
    {
        self.selectedSegmentIndex--;
    }
    
    if (animated)
    {
        [self.items removeObject:segmentView];
        [UIView animateWithDuration:.4 animations:^
         {
             segmentView.alpha = 0;
             [self layoutSubviews];
         }
                         completion:^(BOOL finished)
         {
             [segmentView removeFromSuperview];
         }];
    }
    else
    {
        [segmentView removeFromSuperview];
        [self.items removeObject:segmentView];
        [self setNeedsLayout];
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    super.backgroundColor = backgroundColor;
    
    CAShapeLayer* layer = (CAShapeLayer *)self.layer;
    layer.fillColor = backgroundColor.CGColor;
}

- (void)drawRect:(CGRect)rect
{
    if (self.backgroundImage) {
        [self.backgroundImage drawInRect:rect];
    } else {
        [super drawRect:rect];
    }
}


#pragma mark - Self Methods

- (void)setSelectedStainView:(UIView *)selectedStainView
{
    selectedStainView.frame = _selectedStainView.frame;
    [self insertSubview:selectedStainView belowSubview:_selectedStainView];
    [_selectedStainView removeFromSuperview];
    
    _selectedStainView = selectedStainView;
    [self setNeedsLayout];
}

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    _backgroundImage = backgroundImage;
    [self setNeedsDisplay];
}

- (void)commonInit
{
    _items = [[NSMutableArray alloc] init];
    _selectedSegmentIndex = -1;
    _segmentTextColor = [UIColor colorWithRed:0.451 green:0.451 blue:0.451 alpha:1];
    _selectedSegmentTextColor = [UIColor colorWithRed:0.169 green:0.169 blue:0.169 alpha:1];
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    CAShapeLayer* layer = (CAShapeLayer *)self.layer;
    layer.fillColor = [UIColor colorWithRed:0.961 green:0.961 blue:0.961 alpha:1].CGColor;
    self.layer.backgroundColor = UIColor.clearColor.CGColor;
    self.layer.shadowColor = UIColor.blackColor.CGColor;
    self.layer.shadowRadius = 2;
    self.layer.shadowOpacity = 0.6;
    self.layer.shadowOffset = CGSizeMake(0, 1);
    
    self.selectedStainView = [[DefaultStainView alloc] init];
    self.selectedStainView.backgroundColor = [UIColor colorWithRed:0.816 green:0.816 blue:0.816 alpha:1];
    [self addSubview:self.selectedStainView];
}

//画边框
- (void)drawSelectedMaskAtPosition:(CGFloat)position
{
    if (self.backgroundImage == nil) {
        //没有背景的情况下才需要设置边框
        UIBezierPath *path = UIBezierPath.new;
        CGRect bounds = self.bounds;
        [path moveToPoint:bounds.origin];
        [path addLineToPoint:CGPointMake(CGRectGetMaxX(bounds), CGRectGetMinY(bounds))];
        [path addLineToPoint:CGPointMake(CGRectGetMaxX(bounds), CGRectGetMaxY(bounds))];
        [path addLineToPoint:CGPointMake(CGRectGetMinX(bounds), CGRectGetMaxY(bounds))];
        [path addLineToPoint:bounds.origin];
        
        CAShapeLayer* shapeLayer = (CAShapeLayer *)self.layer;
        shapeLayer.path = path.CGPath;
    }
}


- (NSUInteger)numberOfSegments
{
    return self.items.count;
}


- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex
{
    if (_selectedSegmentIndex != selectedSegmentIndex)
    {
        NSParameterAssert(selectedSegmentIndex < self.items.count);
        _selectedSegmentIndex = selectedSegmentIndex;
        [self setNeedsLayout];
    }
}

- (void)handleSelect:(UIGestureRecognizer *)gestureRecognizer
{
    NSUInteger index = [self.items indexOfObject:gestureRecognizer.view];
    if (index != NSNotFound)
    {
        self.selectedSegmentIndex = index;
        [self setNeedsLayout];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

@end

@implementation DefaultStainView

- (id)init
{
    if ((self = [super init]))
    {
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPathRef roundedRect = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, -1, -1) cornerRadius:self.layer.cornerRadius].CGPath;
    CGContextAddPath(context, roundedRect);
    CGContextClip(context);
    
    CGContextAddPath(context, roundedRect);
    CGContextSetShadowWithColor(UIGraphicsGetCurrentContext(), CGSizeMake(0, 1), 3, UIColor.blackColor.CGColor);
    CGContextSetStrokeColorWithColor(context, self.backgroundColor.CGColor);
    CGContextStrokePath(context);
}

@end
