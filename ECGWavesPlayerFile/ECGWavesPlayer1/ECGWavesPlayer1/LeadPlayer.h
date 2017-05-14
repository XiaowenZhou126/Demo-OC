//
//  LeadPlayer.h
//  ECGWavesPlayer1
//
//  Created by mac on 2017/5/13.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface LeadPlayer : UIView <UIGestureRecognizerDelegate> {
    CGPoint drawingPoints[1000];
    CGPoint endPoint, endPoint2, endPoint3, viewCenter;
    int currentPoint;
    CGContextRef context;
    
    ViewController *__unsafe_unretained liveMonitor;
    
    NSMutableArray *pointsArray;
    int index;
    NSString *label;
    
    int count;
    UIView *lightSpot;
    int pos_x_offset;
}

@property (nonatomic, strong) NSMutableArray *pointsArray;
@property (nonatomic, strong) UIView *lightSpot;
@property (nonatomic, strong) NSString *label;
@property (nonatomic, unsafe_unretained) ViewController *liveMonitor;

@property (nonatomic) int index;//此时正在绘画第index个图形
@property (nonatomic) int currentPoint;
@property (nonatomic) int pos_x_offset;
@property (nonatomic) CGPoint viewCenter;


- (void)fireDrawing;
- (void)drawGrid:(CGContextRef)ctx;
- (void)drawCurve:(CGContextRef)ctx;
- (CGFloat)getPosX:(int)tick;
- (BOOL)pointAvailable:(NSInteger)pointIndex;
- (void)resetBuffer;

@end
