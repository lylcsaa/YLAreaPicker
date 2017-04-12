//
//  YLDataSource.h
//  TestAreaData
//
//  Created by wlx on 17/4/12.
//  Copyright © 2017年 Tim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YLStreet.h"
#import "YLArea.h"
#import "YLCity.h"
#import "YLProvence.h"
#import "YLAreaModel.h"
extern const NSString *kYLProvenceKey;
extern const NSString *kYLCityKey;
extern const NSString *kYLAreaKey;
extern const NSString *kYLStreetKey;
@interface YLDataSource : NSObject
/**
 **:<#注释#>
 **/
@property (nonatomic,strong)NSMutableDictionary *dataSourceDict;
-(void)streetDataWithAreaID:(NSInteger)areaid;
-(void)getThreeComponentDefaultDatas;
-(void)getThreeComponentCityDatasByProvenceID:(NSInteger)pid;
-(void)getThreeComponentAreaDatasByCityID:(NSInteger)cid;

-(YLAreaModel *)getAreaInfoByStreetModel:(YLStreet*)street;
-(YLAreaModel *)getAreaInfoByAreaModel:(YLArea*)area;
@end
