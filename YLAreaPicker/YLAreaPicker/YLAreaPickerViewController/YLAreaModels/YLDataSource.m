//
//  YLDataSource.m
//  TestAreaData
//
//  Created by wlx on 17/4/12.
//  Copyright © 2017年 Tim. All rights reserved.
//


#import "YLDataSource.h"
#import "YLDataBaseManager.h"

 const NSString *kYLProvenceKey = @"kYLProvenceKey";
 const NSString *kYLCityKey = @"kYLCityKey";
 const NSString *kYLAreaKey = @"kYLAreaKey";
 const NSString *kYLStreetKey = @"kYLStreetKey";


@implementation YLDataSource


-(NSMutableDictionary *)dataSourceDict
{
    if (!_dataSourceDict) {
        _dataSourceDict = [NSMutableDictionary dictionary];
    }
    return _dataSourceDict;
}
-(void)streetDataWithAreaID:(NSInteger)areaid
{
    NSArray *arr = [KDataBaseManager queryStreetBySuperId:areaid];
    if (!arr) return;
    [self.dataSourceDict setObject:arr forKey:kYLStreetKey];
}
-(void)getThreeComponentDefaultDatas
{
    NSArray * pArr = [KDataBaseManager queryProvenceByTable];
    if (!pArr ||!pArr.count) return;
    [self.dataSourceDict setObject:pArr forKey:kYLProvenceKey];
    YLProvence *p = pArr.firstObject;
    NSArray * cArr = [KDataBaseManager queryCityBySuperId:p._id];
    if (!cArr ||!cArr.count) return ;
    [self.dataSourceDict setObject:cArr forKey:kYLCityKey];
    YLCity *c = cArr.firstObject;
    NSArray *aArr = [KDataBaseManager queryAreaBySuperId:c._id];
    if (!aArr ||!aArr.count)  return ;
    [self.dataSourceDict setObject:aArr forKey:kYLAreaKey];
}
-(void)getThreeComponentCityDatasByProvenceID:(NSInteger)pid
{
    NSArray *cArr = [KDataBaseManager queryCityBySuperId:pid];
    if (!cArr ||!cArr.count){
     NSLog(@"++++++++++");
        return ;
    }
    [self.dataSourceDict setObject:cArr forKey:kYLCityKey];
}
-(void)getThreeComponentAreaDatasByCityID:(NSInteger)cid
{
    NSArray *aArr = [KDataBaseManager queryAreaBySuperId:cid];
    if (!aArr ||!aArr.count)  return ;
    [self.dataSourceDict setObject:aArr forKey:kYLAreaKey];
}
-(YLAreaModel *)getAreaInfoByStreetModel:(YLStreet*)street
{
    YLArea *area = [KDataBaseManager queryAreaByAreaId:street.super_id];
    YLCity *city = [KDataBaseManager queryCityByArea:area.super_id];
    YLProvence *provence = [KDataBaseManager queryProvenceByAreaId:city.super_id];
    YLAreaModel *model = [[YLAreaModel alloc] init];
    model.area = area;
    model.provence = provence;
    model.city = city;
    model.street = street;
    return model;
}
-(YLAreaModel *)getAreaInfoByAreaModel:(YLArea*)area
{
    YLCity *city = [KDataBaseManager queryCityByArea:area.super_id];
    YLProvence *provence = [KDataBaseManager queryProvenceByAreaId:city.super_id];
    YLAreaModel *model = [[YLAreaModel alloc] init];
    model.area = area;
    model.provence = provence;
    model.city = city;
    return model;
}
@end
