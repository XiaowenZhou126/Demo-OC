//
//  LiveMonitorVC.h
//  ECG
//
//  Created by Will Yang (yangyu.will@gmail.com) on 4/29/11.
//  Copyright 2013 WMS Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeadPlayer.h"

@interface LiveMonitorVC : UIViewController {

	NSMutableArray *leads, *buffer;//leads存放多少个心电图
	NSTimer *drawingTimer, *popDataTimer;
	
//	UIScrollView *scrollView;

	UILabel *labelRate, *labelMsg;
	
//	int countOfPointsInQueue;
	int currentDrawingPoint;

}

@property (nonatomic, strong) NSMutableArray *leads, *buffer;
@property (nonatomic, strong) IBOutlet UIButton *photoView;
//@property (nonatomic, strong) IBOutlet UIView *vwProfile, *vwMonitor;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UILabel *labelRate, *labelMsg;
//@property (nonatomic) int newBornMode;
//@property (nonatomic) BOOL stopTheTimer;
//@property (nonatomic, strong) IBOutlet UILabel *lbDevice;


@end
