//
//  Area.m
//  TestAreaData
//
//  Created by wlx on 17/4/11.
//  Copyright © 2017年 Tim. All rights reserved.
//

#import "YLAreaModel.h"

@implementation YLAreaModel
-(NSString *)description
{
    return [NSString stringWithFormat:@"[code:%@  fatherCode:%@  areName:%@  leval:%@]",self.areaCode,self.fatherCode,self.areaName,self.areaLevel];
}
@end
