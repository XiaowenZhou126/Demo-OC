//
//  DShowlist2.h
//  DropDown
//  下拉框的制作，与DShowListView区别：1.DShowList下拉框中选中的项是用button为载体且button没有点击事件（有点击事件的是UIImageView *openImg），而DShowListView是textFiled为载体且有点击事件；2。推荐使用DShowList，因为有下拉框，并且不能将textField处于不可编辑状态（原因：一旦设置为不可编辑，则点击事件也不能响应。当然你也可以在TextField旁设置ImageViewm，并让ImageViewm响应事件）
//
//  Created by mac on 2017/5/12.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
//@protocol 拥有某个代理对象属性
@protocol DShowListDelegate <NSObject>
//@required ： 这个方法必须要实现（若不实现，编译器会发出警告）
//getTextField 代理的方法
@required
//返回下拉所选中的内容
- (void)getTextField:(NSString *)textField;

@end

@interface DShowlist2 : UIView <UITableViewDelegate, UITableViewDataSource>
{
    CGAffineTransform transform;
}
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
//Button
@property (nonatomic,strong) UIButton *btn;
@property (nonatomic,strong) UIImageView *openImg;
//原始的frame
@property (nonatomic, assign) CGRect oldFrame;

@property (nonatomic, assign) BOOL flag;

//得到下拉列表字符串的值
- (void)createListArray:(NSMutableArray *)listArray;

//设置代理
@property (nonatomic, assign) id<DShowListDelegate>delegate;

@end
