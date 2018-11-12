//
//  CCSegmentedControl.h
//  b866
//
//  Created by ccnyou on 10/30/13.
//  Copyright (c) 2013 ccnyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCSegmentedControl : UIControl<NSCoding>
@property (nonatomic, strong) UIView *selectedStainView;        //阴影效果
@property (nonatomic, strong) UIColor *segmentTextColor;
@property (nonatomic, strong) UIColor *selectedSegmentTextColor;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, assign) NSInteger selectedSegmentIndex;
@property (nonatomic, assign) NSInteger numberOfLines;

- (id)initWithItems:(NSArray *)items;

- (NSString *)titleForSegmentAtIndex:(NSUInteger)segment;

- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)segment;

- (void)removeAllSegments;

- (void)removeSegmentAtIndex:(NSUInteger)segment animated:(BOOL)animated;

- (void)appendSegmentWithTitle:(NSString *)title animated:(BOOL)animated;

- (void)insertSegmentWithTitle:(NSString *)title atIndex:(NSUInteger)segmentIndex animated:(BOOL)animated;

@end
