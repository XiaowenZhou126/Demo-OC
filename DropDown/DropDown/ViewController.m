//
//  ViewController.m
//  DropDown
//
//  Created by mac on 2017/5/12.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"1",@"2", nil];
//    DShowListView *d = [[DShowListView alloc] initWithFrame:CGRectMake(30, 30, 150, 30)];
//    [d createListArray:arr];
//    [self.view addSubview:d];
    DShowlist2 *d = [[DShowlist2 alloc] initWithFrame:CGRectMake(30, 30, 150, 30)];
    [d createListArray:arr];
    [self.view addSubview:d];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
