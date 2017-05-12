//
//  ViewController.m
//  UIDwmo
//
//  Created by kathy on 2017/5/1.
//  Copyright © 2017年 kathy. All rights reserved.
//

#import "ViewController.h"

#define KlineHeight 20
#define KlineWidth 20

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"2");
    myView *mm = [[myView alloc] init];
    mm.frame = CGRectMake(0,20,300,300);//每一个UIView都需要创建尺寸
    mm.backgroundColor =  [UIColor clearColor];//mm的清除背景色

    /**以下是折线图需要数据的代码，需要横轴标签、纵轴标签和折线图的数据**/
    //生成随机点
    NSMutableArray *pointArr = [[NSMutableArray alloc] init];
    //[pointArr addObject:[NSValue valueWithCGPoint:CGPointMake(KlineWidth*0, 0)]];
    for (int i = 0; i < 12; i++) {
        int value = arc4random() % 160;
        [pointArr addObject:[NSValue valueWithCGPoint:CGPointMake(KlineWidth* (i+1), value)]];
        
    }
    //竖轴
    NSMutableArray *vArr = [[NSMutableArray alloc]initWithCapacity:pointArr.count-1];
    for (int i=0; i<9; i++) {
        [vArr addObject:[NSString stringWithFormat:@"%d",i*20]];
    }
    //横轴
    NSMutableArray *hArr = [[NSMutableArray alloc]initWithCapacity:pointArr.count-1];
    for (int i = 1; i <= 12; i++) {
        [hArr addObject:[NSString stringWithFormat:@"%d",i]];
    }
    [mm setHDesc:hArr];
    [mm setVDesc:vArr];
    [mm setArray:pointArr];
    /***************结束***************/
    
    [self.view addSubview:mm];
}


- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
