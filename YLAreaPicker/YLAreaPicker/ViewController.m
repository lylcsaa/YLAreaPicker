//
//  ViewController.m
//  TestAreaData
//
//  Created by wlx on 17/4/11.
//  Copyright © 2017年 Tim. All rights reserved.
//

#import "ViewController.h"
#import "YLAreaModel.h"
#import "YLDataBaseManager.h"
#import "YLAreaPickerViewController.h"
@interface ViewController ()
@property(nonatomic,assign)NSInteger areaID;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)presentPick:(UIButton *)sender
{
    __weak __typeof(&*self)weakSelf = self;
    YLAreaPickerViewController *pickVC = [YLAreaPickerViewController creatPickerViewControllerWithAreaID:self.areaID CompletionBackBlock:^(YLAreaModel *model) {
        weakSelf.areaID = model.area._id;
        [weakSelf showSelectedAddress:model];
    }];
    [self presentViewController:pickVC animated:NO completion:nil];
}
-(void)showSelectedAddress:(YLAreaModel*)model
{
    self.addressLabel.text = [NSString stringWithFormat:@"%@-%@-%@-%@", model.provence.pname, model.city.cname, model.area.aname, model.street ? model.street.sname : @"请选择街道"];
}
- (IBAction)reset:(UIButton *)sender
{
    self.areaID = 0;
}

-(void)insertDB
{
    __block NSMutableArray *arr1 = [NSMutableArray array];
    __block NSMutableArray *arr2 = [NSMutableArray array];
    __block NSMutableArray *arr3 = [NSMutableArray array];
    __block NSMutableArray *arr4 = [NSMutableArray array];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area" ofType:@"json"]] options:NSJSONReadingMutableContainers error:nil];
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSArray class]]) {
            YLAreaModel *a = [[YLAreaModel alloc] init];
            a.areaCode = key;
            for (int i = 0;i < 3;i++) {
                NSString *b = obj[i];
                if (i == 0) {
                    a.areaName = b;
                }else if (i == 1){
                    a.fatherCode = b;
                }else{
                    a.areaLevel = b;
                }
            }
            NSLog(@"%@",a);
            if ([a.areaLevel integerValue] == 1) {
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:a.areaCode,@"areaCode",a.areaName,@"name",a.areaLevel,@"level",a.fatherCode,@"fcode", nil];
                [arr1 addObject:dic];
            }else if ([a.areaLevel integerValue] == 2) {
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:a.areaCode,@"areaCode",a.areaName,@"name",a.areaLevel,@"level",a.fatherCode,@"fcode", nil];
                [arr2 addObject:dic];
            }else if ([a.areaLevel integerValue] == 3) {
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:a.areaCode,@"areaCode",a.areaName,@"name",a.areaLevel,@"level",a.fatherCode,@"fcode", nil];
                [arr3 addObject:dic];
            }else if ([a.areaLevel integerValue] == 4) {
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:a.areaCode,@"areaCode",a.areaName,@"name",a.areaLevel,@"level",a.fatherCode,@"fcode", nil];
                [arr4 addObject:dic];
            }
        }
    }];
    
    [arr1 sortUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
        return [obj1[@"areaCode"] compare:obj2[@"areaCode"]];
    }];
    
    [KDataBaseManager insertAreaByArr:arr1 tag:1];
    
    [arr2 sortUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
        return [obj1[@"areaCode"] compare:obj2[@"areaCode"]];
    }];
    [KDataBaseManager insertAreaByArr:arr2 tag:2];
    
    [arr3 sortUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
        return [obj1[@"areaCode"] compare:obj2[@"areaCode"]];
    }];
    [KDataBaseManager insertAreaByArr:arr3 tag:3];
    
    [arr4 sortUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
        return [obj1[@"areaCode"] compare:obj2[@"areaCode"]];
    }];
    [KDataBaseManager insertAreaByArr:arr4 tag:4];

}
@end
