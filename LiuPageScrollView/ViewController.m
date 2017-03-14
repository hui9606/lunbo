//
//  ViewController.m
//  LiuPageScrollView
//
//  Created by qingyun on 17/3/14.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ViewController.h"
#import "LiuPageScrollView.h"
#import "UIView+Extension.h"
#import "WEBViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    self.navigationItem.title=@"轮播图";

    LiuPageScrollView *lunboView=[[ LiuPageScrollView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height*0.3)];
    
    lunboView.imgArr=@[@"Image2",@"Image1",@"Image4",@"Image3"];
    
    __weak typeof (self)weakSelf=self;
    lunboView.didClickImg=^(NSInteger index){
         NSLog(@"第%ld张图片被点击",(long)index);
        
        WEBViewController *vc=[WEBViewController new];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    
    };
    
    [self.view addSubview:lunboView];
    
}

@end
