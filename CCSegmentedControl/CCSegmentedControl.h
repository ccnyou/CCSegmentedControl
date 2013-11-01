//
//  CCSegmentedControl.h
//  b866
//
//  Created by ccnyou on 10/30/13.
//  Copyright (c) 2013 ccnyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCSegmentedControl : UIControl<NSCoding>

@property (strong, nonatomic) UIView*     selectedStainView;        //阴影效果
@property (strong, nonatomic) UIColor*    segmentTextColor;
@property (strong, nonatomic) UIColor*    selectedSegmentTextColor;
@property (strong, nonatomic) UIImage*    backgroundImage;
@property (assign, nonatomic) NSInteger   selectedSegmentIndex;


- (id)initWithItems:(NSArray *)items;

- (NSString *)titleForSegmentAtIndex:(NSUInteger)segment;
- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)segment;

- (void)removeAllSegments;
- (void)removeSegmentAtIndex:(NSUInteger)segment animated:(BOOL)animated;

@end
