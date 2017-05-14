//
//  LiveMonitorVC.m
//  ECG
//
//  Created by Will Yang (yangyu.will@gmail.com) on 4/29/11.
//  Copyright 2013 WMS Studio. All rights reserved.
//


#import <QuartzCore/QuartzCore.h>
#import "LiveMonitorVC.h"
#import "LeadPlayer.h"
#import "Helper.h"

@implementation LiveMonitorVC
@synthesize leads,scrollView;
@synthesize labelRate;
@synthesize buffer, labelMsg, photoView;

int leadCount = 3;//画leadCount个心电图
int sampleRate = 500;
//float uVpb = 0.9;
float drawingInterval = 0.04; // the interval is greater, the drawing is faster, but more choppy, smaller -> slower and smoother
int bufferSecond = 300;
//float pixelPerUV = 5 * 10.0 / 1000;

- (void)viewDidLoad {
    [super viewDidLoad];

    NSLog(@"a，1");
	[self addViews];
//    [self initialMonitor];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"a1，4");

	[self setLeadsLayout:self.interfaceOrientation];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"a2，6");

    [self startLiveMonitoring];
}

//canBecomeFirstResponder，第一响应对象，负责处理那些和屏幕位置无关的事件，默认返回No
//-(BOOL)canBecomeFirstResponder
//{
//    NSLog(@"b");
//
//    return YES;
//}


- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"a3");

    [super viewWillDisappear:animated];
}


#pragma mark -
#pragma mark Initialization, Monitoring and Timer events 

- (void)initialMonitor
{
    NSLog(@"c，3");

	self.labelMsg.text = @"25mm/s  10mm/mv";//Label
    
    NSMutableArray *buf = [[NSMutableArray alloc] init];
    self.buffer = buf;//buffer初始化
}

- (void)startLiveMonitoring
{
    NSLog(@"d，7");

//	stopTheTimer = NO;
    
    [self startTimer_popDataFromBuffer];
    [self startTimer_drawing];
}

- (void)startTimer_popDataFromBuffer
{
    NSLog(@"e，8");

	CGFloat popDataInterval = 420.0f / sampleRate;//绘画的时间间隔，即隔几秒绘制一段
	
	popDataTimer = [NSTimer scheduledTimerWithTimeInterval:popDataInterval
													target:self
												  selector:@selector(timerEvent_popData)
												  userInfo:NULL
												   repeats:YES];
}

- (void)startTimer_drawing
{
    NSLog(@"f，9");

	drawingTimer = [NSTimer scheduledTimerWithTimeInterval:drawingInterval
													target:self
												  selector:@selector(timerEvent_drawing)
												  userInfo:NULL
                                                    repeats:YES];
}


- (void)timerEvent_drawing
{
    NSLog(@"g，10，12，26");

    [self drawRealTime];
}

- (void)timerEvent_popData
{
    NSLog(@"h，20");

    [self popDemoDataAndPushToLeads];
}

- (void)popDemoDataAndPushToLeads
{
    NSLog(@"i，21");

	int length = 440;
	short **data = [Helper getDemoData:length];
	
	NSArray *data12Arrays = [self convertDemoData:data dataLength:length doWilsonConvert:NO];
	
	for (int i=0; i<leadCount; i++)
	{
		NSArray *data = [data12Arrays objectAtIndex:i];
		[self pushPoints:data data12Index:i];
	}
}

- (void)pushPoints:(NSArray *)_pointsArray data12Index:(NSInteger)data12Index;
{
    NSLog(@"j，23，24，25，27");

	LeadPlayer *lead = [self.leads objectAtIndex:data12Index];
    
	if (lead.pointsArray.count > bufferSecond * sampleRate)
	{
		[lead resetBuffer];
	}
	
    if (lead.pointsArray.count - lead.currentPoint <= 2000)
    {
        [lead.pointsArray addObjectsFromArray:_pointsArray];
    }

	if (data12Index==0)
	{
//		countOfPointsInQueue = lead.pointsArray.count;
		currentDrawingPoint = lead.currentPoint;
	}
}

- (NSArray *)convertDemoData:(short **)rawdata dataLength:(int)length doWilsonConvert:(BOOL)wilsonConvert
{
    NSLog(@"k，22");

	NSMutableArray *data = [[NSMutableArray alloc] init];
	for (int i=0; i<12; i++)
	{
		NSMutableArray *array = [[NSMutableArray alloc] init];
		[data addObject:array];
	}
	
	for (int i=0; i<length; i++)
	{
		for (int j=0; j<12; j++)
		{
			NSMutableArray *array = [data objectAtIndex:j];
			NSNumber *number = [NSNumber numberWithInt:rawdata[i][j]];
			[array insertObject:number atIndex:i];
		}
	}
	
	return data;
}

- (void)drawRealTime
{
    NSLog(@"l，11，13，26-f，28-f");

	LeadPlayer *l = [self.leads objectAtIndex:0];
	
	if (l.pointsArray.count > l.currentPoint)
	{	
		for (LeadPlayer *lead in self.leads)
		{
			[lead fireDrawing];
		}
	}
}

- (void)addViews
{
    NSLog(@"m，2");

	NSMutableArray *array = [[NSMutableArray alloc] init];
	
	for (int i=0; i<leadCount; i++) {
		LeadPlayer *lead = [[LeadPlayer alloc] init];
		
        lead.layer.cornerRadius = 8;//设置圆角
        lead.layer.borderColor = [[UIColor grayColor] CGColor];
        lead.layer.borderWidth = 1;//border
        lead.clipsToBounds = YES;//当它取值为 YES 时，剪裁超出父视图范围的子视图部分；当它取值为 NO 时，不剪裁子视图。
        
		lead.index = i;//此时正在初始化第i个图形
        lead.pointsArray = [[NSMutableArray alloc] init];
                
        lead.liveMonitor = self;
		      
        [array insertObject:lead atIndex:i];//进栈
        
        [self.scrollView addSubview:lead];//将第i个心电图放入scrollView中
	}
	
	self.leads = array;
}

//setLeadsLayout设置Leads Layout
- (void)setLeadsLayout:(UIInterfaceOrientation)orientation
{
    NSLog(@"n，5");

    float margin = 5;
	NSInteger leadHeight = self.scrollView.frame.size.height / 3 - margin * 2;
	NSInteger leadWidth = self.scrollView.frame.size.width;
//    scrollView.contentSize = self.scrollView.frame.size;
    /*
     contentSize、contentInset和contentOffset 是 scrollView三个基本的属性。
     contentSize: The size of the content view. 其实就是scrollview可以滚动的区域，比如frame = (0 ,0 ,320 ,480) contentSize = (320 ,960)，代表你的scrollview可以上下滚动，滚动区域为frame大小的两倍。
     contentOffset:The point at which the origin of the content view is offset from the origin of the scroll view. 是scrollview当前显示区域顶点相对于frame顶点的偏移量，比如上个例子你拉到最下面，contentoffset就是(0 ,480)，也就是y偏移了480
     contentInset:The distance that the content view is inset from the enclosing scroll view.是scrollview的contentview的顶点相对于scrollview的位置，例如你的contentInset = (0 ,100)，那么你的contentview就是从scrollview的(0 ,100)开始显示
     */
    
    for (int i=0; i<leadCount; i++)
    {
        LeadPlayer *lead = [self.leads objectAtIndex:i];
        float pos_y = i * (margin + leadHeight);
        
        [lead setFrame:CGRectMake(0., pos_y, leadWidth, leadHeight)];
        lead.pos_x_offset = lead.currentPoint;
        lead.alpha = 1;
        [lead setNeedsDisplay];
    }
    
//    [UIView animateWithDuration:0.6f animations:^{
//        for (int i=0; i<leadCount; i++)
//        {
//            LeadPlayer *lead = [self.leads objectAtIndex:i];
//            lead.alpha = 1;
//        }
//    }];
}

//didRotateFromInterfaceOrientation，通知view controller旋转动画执行完毕
//- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
//{
//
//}


#pragma mark -
#pragma mark Memory and others

/*
 在iOS 3.0 之前，当系统的内存不足时，UIViewController的didReceiveMemoryWarining 方法会被调用，我们可以在didReceiveMemoryWarining 方法里释放掉部分暂时不用的资源。从iOS3.0 开始，UIViewController增加了viewDidUnload方法。该方法和viewDIdLoad相配对。
 当系统内存不足时，首先UIViewController的didReceiveMemoryWarining 方法会被调用，而didReceiveMemoryWarining 会判断当前ViewController的view是否显示在window上，如果没有显示在window上，则didReceiveMemoryWarining 会自动将viewcontroller 的view以及其所有子view全部销毁，然后调用viewcontroller的viewdidunload方法。如果当前UIViewController的view显示在window上，则不销毁该viewcontroller的view，当然，viewDidunload也不会被调用了。
 */
//- (void)didReceiveMemoryWarning
//{
//    NSLog(@"o");
//
//    [super didReceiveMemoryWarning];//如没有显示在window上，会自动将self.view释放。
//    // ios6.0以前，不用在此做处理，self.view释放之后，会调用下面的viewDidUnload函数，在viewDidUnload函数中做处理就可以了。
//    /*到了ios6.0之后，又有所变化，ios6.0内存警告的viewDidUnload 被屏蔽，即又回到了ios3.0的时期的内存管理方式。调用didReceiveMemoryWarning内调用super的didReceiveMemoryWarning调只是释放controller的resouse，不会释放view（即使没有显示在window上，也不会自动的将self.view释放）。这时做兼容处理需要加上ios6.0的宏开关，保证是在6.0下使用的,6.0以前屏蔽以下代码，否则会在下面使用self.view时自动加载viewDidUnLoad
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
//        //需要注意的是self.isViewLoaded是必不可少的，其他方式访问视图会导致它加载 ，在WWDC视频也忽视这一点。
//        if (self.isViewLoaded && !self.view.window){// 是否是正在使用的视图
//            // Add code to preserve data stored in the views that might be
//            // needed later.
//            // Add code to clean up other strong references to the view in
//            // the view hierarchy.
//            self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
//        }
//    }*/
//
//}
//
//- (void)viewDidUnload {
//    NSLog(@"a5");
//
//    //处理一些内存和资源问题
//    [super viewDidUnload];
//}

//- (void)dealloc {
//
//	drawingTimer = nil;
//	readDataTimer = nil;
//	popDataTimer = nil;
//	
//}

@end
