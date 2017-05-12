//
//  DShowlist2.m
//  DropDown
//
//  Created by mac on 2017/5/12.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "DShowlist2.h"

@implementation DShowlist2

@synthesize listArray = _listArray;

//初始化View
- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        //默认的背景色为白色
        self.backgroundColor = [UIColor whiteColor];
        //默认输入文本框字体的颜色
        self.textColor = [UIColor blackColor];
        //moren输入文本框字体的大小
        self.textFont = [UIFont fontWithName:@"Arial" size:18.0];
        //设置输入内容左对齐
        self.textAlignment = NSTextAlignmentLeft;
        
        //默认的线宽为1.0
        self.lindWidth = 1.0;
        self.oldFrame = frame;
        self.flag = true;
        
        [self drawListView];
    }
    
    return self;
}

//懒加载listArray
- (NSMutableArray *)listArray{
    if (_listArray == nil) {
        _listArray = [NSMutableArray array];
    }
    
    return _listArray;
}

//设置可变数组
-(void)createListArray:(NSMutableArray *)listArray{
    self.listArray = listArray;
    
    self.listView.frame = CGRectMake(self.btn.frame.origin.x + self.lindWidth, self.frame.size.height + self.lindWidth, self.frame.size.width - (2 * self.lindWidth), self.btn.frame.size.height * self.listArray.count - (2 * self.lindWidth));
    
    self.listView.hidden = self.flag;
    //重新刷新表格
    [self.listView reloadData];
    
    //当listArray不为空
    if(self.listArray.count > 0){
        // 默认选中第一行
        NSIndexPath *indextPath = [NSIndexPath indexPathForRow:0 inSection:0];
        // 调用UItableViewDelegate
        [self tableView:self.listView didSelectRowAtIndexPath:indextPath];
        
        [self.listView selectRowAtIndexPath:indextPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        self.listView.hidden = true;
    }
    
}

//创建下拉列表tableView
- (void)drawListView{
    //初始化按钮
    self.btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    //默认输入文本框的颜色为白色
    self.btn.backgroundColor = [UIColor whiteColor];
    //默认输入文本框字体的颜色
    [self.btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //设置文字位置，现设为居左,并且距离左边框10px，默认的是居中
    self.btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    self.btn.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    //默认输入文本框字体的大小
    self.btn.titleLabel.font = self.textFont;
    //设置圆角
    self.btn.layer.cornerRadius = 5.0;
    //设置文本的边框样式
    self.btn.layer.borderWidth = 1.0;
    
    //下拉菜单弹出按钮
    self.openImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.btn.frame.size.width-30, 0, 30, 30)];
    [self.openImg setImage:[UIImage imageNamed:@"drop_down1"]];
    
    self.openImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickedTextBox)];
    [self.openImg addGestureRecognizer:singleTap];
    self.openImg.transform=CGAffineTransformMakeRotation(M_PI);
    [self.btn addSubview:self.openImg];
    
    [self addSubview:self.btn];
    
    //初始化下拉列表框
    self.listView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    //设置不被编辑
    self.listView.editing = NO;
    self.listView.backgroundColor = [UIColor clearColor];
    //设置代理
    self.listView.delegate = self;
    self.listView.dataSource = self;
    
    [self addSubview:self.listView];
}

//点击文本框是否隐藏下拉列表框
- (void)clickedTextBox{
    NSLog(@"--- clickedTextBox:%d ---", self.flag);
    
    if (self.flag) {
        //        self.openImg.transform=CGAffineTransformMakeRotation(M_PI);
        //下拉框图标旋转180度
        transform = self.openImg.transform;
        transform=CGAffineTransformRotate(transform, M_PI);
        self.openImg.transform=transform;
        //如果下拉框尚未显示，则进行显示
        //把ListView放到前面，防止下拉框被别的控件遮住
        [self.superview bringSubviewToFront:self];
        
        self.listView.hidden = !self.flag;
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.btn.frame.size.width, self.btn.frame.size.height * (1 + self.listArray.count));
        
        self.flag = false;
    }
    else{
        //下拉框图标旋转180度
        transform = self.openImg.transform;
        transform=CGAffineTransformRotate(transform, -M_PI);
        self.openImg.transform=transform;
        
        self.listView.hidden = !self.flag;
        
        self.frame = self.oldFrame;
        self.flag = true;
    }
}

//下拉列表的表格行个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

//各表格行控件的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.btn.frame.size.height;
}

//决定各表格行的控件
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    
    cell.textLabel.text = self.listArray[indexPath.row];
    
    return cell;
}

//选中表格行N
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //设置button的字体
    [self.btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.btn.titleLabel.font = self.textFont;
    self.btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    self.btn.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    
    [self.btn setTitle:self.listArray[indexPath.row] forState:UIControlStateNormal];
    
    [_delegate getTextField:self.btn.titleLabel.text];
    
    self.frame = self.oldFrame;
    self.listView.hidden = !self.flag;
    self.flag = true;
    
    //下拉框图标旋转
    transform = self.openImg.transform;
    transform=CGAffineTransformRotate(transform, M_PI);
    self.openImg.transform=transform;
}

@end
