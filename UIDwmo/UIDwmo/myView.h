//
//  myView.h
//  UIDwmo
//
//  Created by kathy on 2017/5/1.
//  Copyright © 2017年 kathy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myView : UIView
//横竖轴距离间隔
@property (assign) NSInteger hInterval;
@property (assign) NSInteger vInterval;
//横竖轴显示标签
@property (nonatomic, strong) NSArray *hDesc;
@property (nonatomic, strong) NSArray *vDesc;
//点信息
@property (nonatomic, strong) NSArray *array;

-(void)drawTriangle;
-(void)drawLine;
-(void)drawEllipse;
-(void)drawCurve;
-(void)drawCoordinateSystem;
@end
