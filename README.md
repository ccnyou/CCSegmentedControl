CCSegmentedControl
=========

使用一个背景图片和一个阴影图片定制自己的 SegmentedControl。

效果图
----------

<p align="center" >
  <img src="https://raw.github.com/ccnyou/CCSegmentedControl/master/%E6%95%88%E6%9E%9C%E5%9B%BE.jpg" alt="CCSegmentedControl" title="CCSegmentedControl">
</p>

用法
----------

```objective-c
#import "CCSegmentedControl.h"

	...	
	
- (void)viewDidLoad
{
    CCSegmentedControl* segmentedControl = [[CCSegmentedControl alloc] initWithItems:@[@"本周热门", @"最佳餐厅", @"口味最佳", @"更多排行"]];
    segmentedControl.frame = CGRectMake(0, 0, 320, 50);
    
    //设置背景图片，或者设置颜色，或者使用默认白色外观
    segmentedControl.backgroundImage = [UIImage imageNamed:@"segment_bg.png"];
    //segmentedControl.backgroundColor = [UIColor grayColor];
  
    //阴影部分图片，不设置使用默认椭圆外观的stain
    segmentedControl.selectedStainView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stain.png"]];
    
    segmentedControl.selectedSegmentTextColor = [UIColor whiteColor];
    segmentedControl.segmentTextColor = [self colorWithHexString:@"#535353"];
    [segmentedControl addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
}

- (void)valueChanged:(id)sender
{
    CCSegmentedControl* segmentedControl = sender;
    NSLog(@"%s line:%d segment has changed to %d", __FUNCTION__, __LINE__, segmentedControl.selectedSegmentIndex);
}

```

###Bug Report to:
ccnyou@qq.com
