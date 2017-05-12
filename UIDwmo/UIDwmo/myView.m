//
//  myView.m
//  UIDwmo
//
//  Created by kathy on 2017/5/1.
//  Copyright © 2017年 kathy. All rights reserved.
//

#import "myView.h"
#define KlineHeight 20

@implementation myView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    NSLog(@"draw rect:");
//    [self drawLine];//画直线
//    [self drawTriangle];//画三角形
//    [self drawEllipse];//椭圆
//    [self drawCurve];//贝塞尔曲线
    
    [self drawCoordinateSystem];//折线图
}

//画三角形
-(void)drawTriangle{
    NSLog(@"draw Triangle");
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [[UIColor redColor] CGColor]);
    
    CGContextMoveToPoint(context, 160, 160);
    CGContextAddLineToPoint(context, 160, 100);
    CGContextAddLineToPoint(context, 140, 160);
    CGContextAddLineToPoint(context, 160, 160);
    
    //绘制图形
    CGContextStrokePath(context);
}

//画直线
-(void)drawLine{
    NSLog(@"draw Line");
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [[UIColor blueColor] CGColor]);
    
    CGContextMoveToPoint(context, 50, 50);
    CGContextAddLineToPoint(context, 50, 100);

    //绘制图形
    CGContextStrokePath(context);
}

//椭圆
-(void)drawEllipse{
    NSLog(@"draw Ellipse");
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [[UIColor blueColor] CGColor]);
    
    CGContextAddEllipseInRect(context, CGRectMake(90, 50, 30, 60));//椭圆
    
    //绘制图形
    CGContextStrokePath(context);
}

//贝塞尔曲线
-(void)drawCurve{
    NSLog(@"draw Curve");
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [[UIColor yellowColor] CGColor]);
    
    CGContextMoveToPoint(context, 50, 200);
    CGContextAddQuadCurveToPoint(context, 175, 325 , 300, 200);//二次贝塞尔曲线
    
    CGContextMoveToPoint(context, 100, 200);
    CGContextAddCurveToPoint(context, 125, 100 , 175, 300, 200, 200);//三次贝塞尔曲线
    
    //绘制图形
    CGContextStrokePath(context);
}

//折线图
-(void)drawCoordinateSystem{
    NSLog(@"draw CoordinateSystem");
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetBlendMode(context, kCGBlendModeNormal);  //同一画布中混合多种颜色
    
    int tempY = 200;
    
    //添加纵轴标签和线 _vDesc.count
    for (int i=0; i<_vDesc.count; i++) {
        CGPoint bPoint = CGPointMake(50, tempY);
        CGPoint ePoint = CGPointMake(290, tempY);
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
        label.font = [UIFont systemFontOfSize:15];
        [label setCenter:CGPointMake(bPoint.x-20, bPoint.y)];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setTextColor:[UIColor blackColor]];
        [label setText:[_vDesc objectAtIndex:i]];
        [self addSubview:label];

        CGContextMoveToPoint(context, bPoint.x, bPoint.y);
        CGContextAddLineToPoint(context, ePoint.x, ePoint.y);
 
        tempY -= 20;
        
    }
    
    //添加横轴标签和线 _hDesc.count
    for (int i=0; i<_hDesc.count-1; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i*KlineHeight+10+50, 200, 20, 30)];
        
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setTextColor:[UIColor redColor]];
        label.numberOfLines = 1;
        
        label.adjustsFontSizeToFitWidth = YES;
        
        [label setText:[_hDesc objectAtIndex:i]];
    
        [self addSubview:label];
    }
    
    //X轴和Y轴
    CGContextMoveToPoint(context, 290, 200);
    CGContextAddLineToPoint(context, 50, 200);
    CGContextAddLineToPoint(context, 50, 20);
    CGContextSetStrokeColorWithColor(context, [[UIColor greenColor] CGColor]);
    
    CGFloat pointLineWidth = 1.5f;
    CGFloat pointMiterLimit = 5.0f;
    CGContextSetLineWidth(context, pointLineWidth);//主线宽度
    CGContextSetMiterLimit(context, pointMiterLimit);//投影角度
    
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineCap(context, kCGLineCapRound );
    CGContextSetBlendMode(context, kCGBlendModeNormal);

    UIColor* color1 = [UIColor colorWithRed:0.0/255.0 green:157.0/255.0 blue:220.0/255.0 alpha:1.0];;
    [color1 set];
    
    //绘图
    CGPoint p1 = [[_array objectAtIndex:0] CGPointValue];
    CGContextMoveToPoint(context, p1.x + 50, 300-100-p1.y);//设置起始点
    for (int i = 0; i<[_array count]; i++)
    {
        p1 = [[_array objectAtIndex:i] CGPointValue];
        CGPoint goPoint = CGPointMake(p1.x + 50, 300-100-p1.y);
        CGContextAddLineToPoint(context, goPoint.x, goPoint.y);;
        
        //添加触摸点（红色的小矩形）
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        [bt setBackgroundColor:[UIColor redColor]];
        [bt setFrame:CGRectMake(0, 0, 10, 10)];
        [bt setCenter:goPoint];
        [self addSubview:bt];
    }

    //绘制图形
    CGContextStrokePath(context);
}

@end
