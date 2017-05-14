//
//  HeartBeatDrawing.m
//  ECG
//
//  Created by Will Yang (yangyu.will@gmail.com) on 5/7/11.
//  Copyright 2013 WMS Studio. All rights reserved.
//

#import "LeadPlayer.h"
//#import "LiveMonitorVC.h"

@implementation LeadPlayer
@synthesize pointsArray, index, label, liveMonitor, lightSpot, currentPoint, pos_x_offset, viewCenter;

int pixelsPerCell = 30.00; // 0.2 second per cell

float lineWidth_Grid = 0.5;
float lineWidth_LiveMonitor = 1.3;
float lineWidth_Static = 1;

int pointsPerSecond = 500;
float pixelPerPoint = 2 * 60.0f / 500.0f;
int pointPerDraw = 500.0f * 0.04f;

- (id)initWithFrame:(CGRect)frame {
//    NSLog(@"1-*2-0");
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = [UIColor blackColor];
		self.clearsContextBeforeDrawing = YES;
		
		[self addGestureRecgonizer];
	}
    return self;
}

- (void)drawRect:(CGRect)rect
{
//    NSLog(@"2-*2-0");
	context = UIGraphicsGetCurrentContext();
    
    [self drawGrid:context];
    [self drawCurve:context];
}

//绘制方格
- (void)drawGrid:(CGContextRef)ctx {
//    NSLog(@"3-3-1");
	CGFloat full_height = self.frame.size.height;
	CGFloat full_width = self.frame.size.width;
	CGFloat cell_square_width = pixelsPerCell;
	
	CGContextSetLineWidth(ctx, 0.2);
	CGContextSetStrokeColorWithColor(ctx, [UIColor greenColor].CGColor);
	
	int pos_x = 1;
	while (pos_x < full_width) {
		CGContextMoveToPoint(ctx, pos_x, 1);
		CGContextAddLineToPoint(ctx, pos_x, full_height);
		pos_x += cell_square_width;
		
		CGContextStrokePath(ctx);
	}
	
	CGFloat pos_y = 1;
	while (pos_y <= full_height) {
		
		CGContextSetLineWidth(ctx, 0.2);
        
		CGContextMoveToPoint(ctx, 1, pos_y);
		CGContextAddLineToPoint(ctx, full_width, pos_y);
		pos_y += cell_square_width;
		
		CGContextStrokePath(ctx);
	}
	
    
	CGContextSetLineWidth(ctx, 0.1);
    
	cell_square_width = cell_square_width / 5;
	pos_x = 1 + cell_square_width;
	while (pos_x < full_width) {
		CGContextMoveToPoint(ctx, pos_x, 1);
		CGContextAddLineToPoint(ctx, pos_x, full_height);
		pos_x += cell_square_width;
		
		CGContextStrokePath(ctx);
	}
	
	pos_y = 1 + cell_square_width;
	while (pos_y <= full_height) {
		CGContextMoveToPoint(ctx, 1, pos_y);
		CGContextAddLineToPoint(ctx, full_width, pos_y);
		pos_y += cell_square_width;
		
		CGContextStrokePath(ctx);
	}
}

//- (void)drawLabel:(CGContextRef)ctx {
//    NSLog(@"4-2-1");
//	CGContextSetRGBFillColor(ctx, 1.0, 1.0, 1.0, 1.0);
//	CGContextSelectFont(ctx, "Helvetica", 12, kCGEncodingMacRoman);
//
//	CGAffineTransform xform = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0);
//    CGContextSetTextMatrix(ctx, xform);
//    CGContextShowTextAtPoint(ctx, 8, 18, [self.label UTF8String], strlen([self.label UTF8String]));
//}

//- (void)clearDrawing {
//    NSLog(@"5-2-1");
//	CGFloat full_height = self.frame.size.height;
//	CGFloat full_width = self.frame.size.width;
//	
//	CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
//	CGContextFillRect(context, CGRectMake(0, 0, full_width, full_height));
//	[self setNeedsDisplay];
//}

//绘制心电
- (void)drawCurve:(CGContextRef)ctx
{
//    NSLog(@"6-3-1");
	if (count == 0) return;
	
	CGContextSetLineWidth(ctx, lineWidth_LiveMonitor);
	CGContextSetStrokeColorWithColor(ctx, [UIColor greenColor].CGColor);
	
	CGContextAddLines(ctx, drawingPoints, count);
	CGContextStrokePath(ctx);

	endPoint = drawingPoints[count-1]; 
	endPoint2 = drawingPoints[count-2];
	endPoint3 = drawingPoints[count-3];
	
}

- (void)fireDrawing
{
    NSLog(@"7-3-0");
    float uVpb = 0.9;
    float pixelPerUV = 5 * 10.0 / 1000;
    
	int pointCount = pointPerDraw;
	CGFloat pointPixel = pixelPerPoint;
	CGFloat full_height = self.frame.size.height;
	
	count = 0;
	for (int i=0; i<pointCount; i++)
    {
		if ([self pointAvailable:currentPoint])
		{
			CGFloat pos_x = [self getPosX:currentPoint];
			if (i > 0 && pos_x == 0) break;
			
			if (i == 0 && pos_x != 0)
			{
				drawingPoints[0] = endPoint3;
				drawingPoints[1] = endPoint2;
				drawingPoints[2] = endPoint;
				i+=3; pointCount+=3; count+=3;
			}
			
			CGFloat value = full_height/2 - [[self.pointsArray objectAtIndex:currentPoint] intValue] * uVpb * pixelPerUV;
			drawingPoints[i] = CGPointMake(pos_x, value); 
						
			currentPoint++;	
			count++;
		}
		else {
			break;
		}
	}
	
	if (count > 0)
	{
		CGRect rect = CGRectMake(drawingPoints[1].x, 0, count*pointPixel+20, full_height);
		[self setNeedsDisplayInRect:rect];
	}
}

- (void)resetBuffer
{
//    NSLog(@"8-3-0");
	CGFloat full_width = self.frame.size.width;
	CGFloat pixelsPerPoint = pixelPerPoint;
	int cyclePoints = ceil(full_width / pixelsPerPoint);
	int temp = currentPoint % cyclePoints;
	int countToRemove = currentPoint - temp;
	
	currentPoint = temp;
	
	if (self.pointsArray.count > countToRemove)
	{
		[pointsArray removeObjectsInRange:NSMakeRange(0, countToRemove)];
	}
	

	//currentPoint = 0;
//	[pointsArray removeAllObjects];	
//	[self setNeedsDisplay];
}

- (CGFloat)getPosX:(int)point
{
//    NSLog(@"9-3-1");
	CGFloat full_width = self.frame.size.width;
	
	int cyclePoints = ceil(full_width / pixelPerPoint);
	int aPoint = (point - pos_x_offset) % cyclePoints;
	
	return aPoint * pixelPerPoint;
}

//判断下一次的数据是否有效
- (BOOL)pointAvailable:(NSInteger)pointIndex
{
//    NSLog(@"10-3-1");
	return ((self.pointsArray.count > pointIndex) && ([self.pointsArray objectAtIndex:pointIndex] != NULL));
}

//- (void)redraw
//{
//    NSLog(@"11-2-1");
//	[self setNeedsDisplay];
//}

#pragma mark -
#pragma mark GestureRecognizer


- (void)singleTapGestureRecognizer:(UIGestureRecognizer *)sender
{
}

- (void)doubleTapGestureRecognizer:(UIGestureRecognizer *)sender
{
}

- (void)longPressGestureRecognizerStateChanged:(UIGestureRecognizer *)sender
{
}

- (void)addGestureRecgonizer
{

}

//- (void)dealloc {
//
////	NSLog(@"Lead dealloced");
//	NSLog(@"12-1-1");
//	self.liveMonitor = nil;
//	
//}

@end
