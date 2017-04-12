//
//  YLAreaPickerViewController.h
//  TestAreaData
//
//  Created by wlx on 17/4/12.
//  Copyright © 2017年 Tim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLPickView.h"
@interface YLAreaPickerViewController : UIViewController
+(YLAreaPickerViewController*)creatPickerViewControllerWithAreaID:(NSInteger)areaId CompletionBackBlock:(void(^)(YLAreaModel*model))completionBackBlock;
@end
