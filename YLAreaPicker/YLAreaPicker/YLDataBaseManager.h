//
//  DataBaseManager.h
//  CASMagazine
//
//  Created by smn on 17/3/14.
//  Copyright © 2017年 Tim. All rights reserved.
//
#import "YLStreet.h"
#import "YLArea.h"
#import "YLCity.h"
#import "YLProvence.h"
#import <Foundation/Foundation.h>
#define KDataBaseManager [YLDataBaseManager shareManager]

@interface YLDataBaseManager : NSObject

+(YLDataBaseManager *)shareManager;
-(void)insertAreaByArr:(NSArray *)arr tag:(int)tag;
/*
 *获取省级行政区域
 */
-(NSArray*)queryProvenceByTable;
/*
 *获取市级行政区域
 */
-(NSArray*)queryCityBySuperId:(NSInteger)pid;
/*
 *获取区县行政区域
 */
-(NSArray*)queryAreaBySuperId:(NSInteger)cid;
/*
 *获取乡镇行政区域
 */
-(NSArray*)queryStreetBySuperId:(NSInteger)sid;
/*
 *获取城市
 */
-(YLCity*)queryCityByArea:(NSInteger)pid;
/*
 *获取省级行政单位
 */
-(YLProvence*)queryProvenceByAreaId:(NSInteger)areaId;
/*
 *获取区县行政单位
 */
-(YLArea*)queryAreaByAreaId:(NSInteger)cid;
@end
