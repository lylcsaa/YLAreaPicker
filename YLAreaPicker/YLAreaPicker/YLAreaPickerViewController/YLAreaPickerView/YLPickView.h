//
//  YLPickView.h
//  TestAreaData
//
//  Created by wlx on 17/4/12.
//  Copyright © 2017年 Tim. All rights reserved.
//
#import "YLStreet.h"
#import "YLArea.h"
#import "YLCity.h"
#import "YLProvence.h"
#import "YLDataSource.h"
#import <UIKit/UIKit.h>

@interface YLPickView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>
/**
 **:确认按钮
 **/
@property (nonatomic,strong)UIButton *doneButton;
/**
 **:取消按钮
 **/
@property (nonatomic,strong)UIButton *cancelButton;


/**
 **:pickView
 **/
@property (nonatomic,strong)UIPickerView *pickView;
/**
 **:是否单列
 **/
@property (nonatomic,assign)BOOL isSingle;

/**
 **:区域id
 **/
@property (nonatomic,assign)NSInteger areaID;

/**
 **:有多少列
 **/
@property (nonatomic,assign)NSInteger numberOfSections;

/**
 **:数据源
 **/
@property (nonatomic,strong)YLDataSource *dataSource;

/**
 **:完成选择回调
 **/
@property (nonatomic,copy) void (^completionBlock)(YLAreaModel *model);
/*
 *  取消
 */
@property (nonatomic,copy) void (^cancelBlock)();

-(void)reloadPicker;
@end
