//
//  ViewController.m
//  ECGWavesPlayer1
//
//  Created by mac on 2017/5/13.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ViewController.h"
#import "LeadPlayer.h"
#import "ECGDatas.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize leads,scrollView;
@synthesize labelRate;
@synthesize buffer, photoView;
int leadCount = 1;//画leadCount个心电图
int sampleRate = 500;
float drawingInterval = 0.04;
int bufferSecond = 300;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
//    CGFloat height = [[UIScreen mainScreen] bounds].size.height;
    
    UILabel *labelMsg = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, width, 30)];
    labelMsg.text = @"25mm/s  10mm/mv";//Label
    labelMsg.textAlignment = NSTextAlignmentRight;
    labelMsg.textColor = [UIColor greenColor];
    [self.view addSubview:labelMsg];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, width, 200)];
    scrollView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:scrollView];
    
    [self addViews];
    
    NSMutableArray *buf = [[NSMutableArray alloc] init];
    self.buffer = buf;//buffer初始化
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setLeadsLayout];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self startLiveMonitoring];
}

- (void)startLiveMonitoring
{
    //	stopTheTimer = NO;
    
    [self startTimer_popDataFromBuffer];
    [self startTimer_drawing];
}

- (void)startTimer_popDataFromBuffer
{
    CGFloat popDataInterval = 420.0f / sampleRate;//绘画的时间间隔，即隔几秒绘制一段
    
    popDataTimer = [NSTimer scheduledTimerWithTimeInterval:popDataInterval
                                                    target:self
                                                  selector:@selector(timerEvent_popData)
                                                  userInfo:NULL
                                                   repeats:YES];
}

- (void)timerEvent_popData
{
    [self popDemoDataAndPushToLeads];
}

- (void)popDemoDataAndPushToLeads
{
    int length = 440;
    short **data = [ECGDatas getDemoData:length];
    
    NSArray *data12Arrays = [self convertDemoData:data dataLength:length doWilsonConvert:NO];
    
    for (int i=0; i<leadCount; i++)
    {
        NSArray *data = [data12Arrays objectAtIndex:i];
        [self pushPoints:data data12Index:i];
    }
}

- (void)pushPoints:(NSArray *)_pointsArray data12Index:(NSInteger)data12Index;
{
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

- (void)timerEvent_drawing
{
    [self drawRealTime];
}

- (void)drawRealTime
{
    LeadPlayer *l = [self.leads objectAtIndex:0];
    
    if (l.pointsArray.count > l.currentPoint)
    {
        for (LeadPlayer *lead in self.leads)
        {
            [lead fireDrawing];
        }
    }
}

- (void)startTimer_drawing
{
    drawingTimer = [NSTimer scheduledTimerWithTimeInterval:drawingInterval
                                                    target:self
                                                  selector:@selector(timerEvent_drawing)
                                                  userInfo:NULL
                                                   repeats:YES];
}

//setLeadsLayout设置Leads Layout
- (void)setLeadsLayout
{
    float margin = 5;
    NSInteger leadHeight = self.scrollView.frame.size.height - margin*2;
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
        float pos_y = i * (margin + leadHeight)+margin;
        
        [lead setFrame:CGRectMake(0., pos_y, leadWidth, leadHeight)];
        lead.pos_x_offset = lead.currentPoint;
        lead.alpha = 1;
        [lead setNeedsDisplay];
    }
    
        [UIView animateWithDuration:0.6f animations:^{
            for (int i=0; i<leadCount; i++)
            {
                LeadPlayer *lead = [self.leads objectAtIndex:i];
                lead.alpha = 1;
            }
        }];
}

- (void)addViews
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (int i=0; i<leadCount; i++) {
        LeadPlayer *lead = [[LeadPlayer alloc] init];
        
        lead.layer.cornerRadius = 8;//设置圆角
        lead.layer.borderColor = [[UIColor grayColor] CGColor];
        lead.layer.borderWidth = 3;//border
        lead.clipsToBounds = YES;//当它取值为 YES 时，剪裁超出父视图范围的子视图部分；当它取值为 NO 时，不剪裁子视图。
        
        lead.index = i;//此时正在初始化第i个图形
        lead.pointsArray = [[NSMutableArray alloc] init];
        
        lead.liveMonitor = self;
		      
        [array insertObject:lead atIndex:i];//进栈
        
        [self.scrollView addSubview:lead];//将第i个心电图放入scrollView中
    }
    
    self.leads = array;
}

@end
