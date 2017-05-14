//
//  ViewController.h
//  ECGWavesPlayer1
//
//  Created by mac on 2017/5/13.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    NSMutableArray *leads, *buffer;//leads存放多少个心电图
    NSTimer *drawingTimer, *popDataTimer;
    
    UILabel *labelRate;
    //	int countOfPointsInQueue;
    int currentDrawingPoint;
}

@property (nonatomic, strong) NSMutableArray *leads, *buffer;
@property (nonatomic, strong) IBOutlet UIButton *photoView;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UILabel *labelRate;

@end

