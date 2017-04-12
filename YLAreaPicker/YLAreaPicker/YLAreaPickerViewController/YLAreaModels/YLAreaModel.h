//
//  Area.h
//  TestAreaData
//
//  Created by wlx on 17/4/11.
//  Copyright © 2017年 Tim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YLStreet.h"
#import "YLArea.h"
#import "YLCity.h"
#import "YLProvence.h"
@interface YLAreaModel : NSObject
/**
 **:
 **/
@property (nonatomic,copy)NSString * areaCode;
@property (nonatomic,copy)NSString * areaLevel;
@property (nonatomic,copy)NSString * areaName;
@property (nonatomic,copy)NSString * fatherCode;
/**
 **:区县
 **/
@property (nonatomic,strong)YLArea *area;
/**
 **:市
 **/
@property (nonatomic,strong)YLCity *city;
/**
 **:省
 **/
@property (nonatomic,strong)YLProvence *provence;
/**
 **:街道、乡镇
 **/
@property (nonatomic,strong)YLStreet *street;
@end
