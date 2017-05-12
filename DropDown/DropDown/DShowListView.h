//
//  DShowListView.h
//  DropDown
//
//  下拉框制作
//  Created by mac on 2017/5/12.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol 拥有某个代理对象属性
@protocol DShowListViewDelegate <NSObject>
//@required ： 这个方法必须要实现（若不实现，编译器会发出警告）
//getTextField 代理的方法
@required
//返回下拉所选中的内容
- (void)getTextField:(NSString *)textField;

@end

@interface DShowListView : UIView <UITableViewDelegate, UITableViewDataSource> 

//可变数组存储tableView的内容
@property (nonatomic, strong) NSMutableArray *listArray;
//下拉框的线宽
@property (nonatomic, assign) CGFloat lindWidth;
//输入文本框字体的颜色
@property (nonatomic, strong) UIColor *textColor;
//输入文本框字体的大小
@property (nonatomic, strong) UIFont *textFont;
//设置输入内容左对齐
@property (nonatomic, assign) NSTextAlignment textAlignment;

//显示下拉列表tableView
@property (nonatomic, strong) UITableView *listView;
//输入文本框
@property (nonatomic, strong) UITextField *textField;
//原始的frame
@property (nonatomic, assign) CGRect oldFrame;

@property (nonatomic, assign) BOOL flag;

//得到下拉列表字符串的值
- (void)createListArray:(NSMutableArray *)listArray;

//设置代理
@property (nonatomic, assign) id<DShowListViewDelegate>delegate;

@end
