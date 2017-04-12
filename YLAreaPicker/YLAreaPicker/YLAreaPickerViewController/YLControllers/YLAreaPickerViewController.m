//
//  YLAreaPickerViewController.m
//  TestAreaData
//
//  Created by wlx on 17/4/12.
//  Copyright © 2017年 Tim. All rights reserved.
//

#import "YLAreaPickerViewController.h"
#define kPICKERVIEWHEIGHT 250
@interface YLAreaPickerViewController ()
@property(nonatomic,strong)YLPickView *pickView;
@property(nonatomic,copy)void(^completionBlock)(YLAreaModel *model);
@end

@implementation YLAreaPickerViewController
+(YLAreaPickerViewController*)creatPickerViewControllerWithAreaID:(NSInteger)areaId CompletionBackBlock:(void(^)(YLAreaModel*model))completionBackBlock
{
    YLAreaPickerViewController *pickVc = [[YLAreaPickerViewController alloc] init];
    pickVc.modalPresentationStyle = UIModalPresentationCustom;
    pickVc.completionBlock = ^(YLAreaModel*model)
    {
        if (completionBackBlock) {
            completionBackBlock(model);
        }
    };
    if (!areaId) {
        [pickVc loadThreeComponent];
    }else{
        [pickVc loadSingleComponentByAreaId:areaId];
    }
    return pickVc;
}

-(YLPickView *)pickView
{
    if (!_pickView) {
        _pickView = [[YLPickView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), kPICKERVIEWHEIGHT)];
        __weak __typeof(&*self)weakSelf = self;
        _pickView.cancelBlock = ^()
        {
            [weakSelf hiddenPickView];
        };
        _pickView.completionBlock = ^(YLAreaModel *model){
            [weakSelf hiddenPickView];
            if (weakSelf.completionBlock) {
                weakSelf.completionBlock(model);
            }
        };
    }
    return _pickView;
}
-(void)showPickView
{
    [self.view addSubview:self.pickView];
    CGRect frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - kPICKERVIEWHEIGHT, CGRectGetWidth(self.view.bounds), kPICKERVIEWHEIGHT);
    [UIView animateWithDuration:0.25 animations:^{
        self.pickView.frame = frame;
    }];
}
-(void)hiddenPickView
{
    CGRect frame = CGRectMake(0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), kPICKERVIEWHEIGHT);
    [UIView animateWithDuration:0.25 animations:^{
        self.pickView.frame = frame;
    }completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showPickView];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self hiddenPickView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.view.layer.opacity = 0.5;
   
}
-(void)loadThreeComponent
{
    [self.pickView reloadPicker];
}
-(void)loadSingleComponentByAreaId:(NSInteger)areaId
{
    self.pickView.isSingle = YES;
    self.pickView.areaID = areaId;
    [self.pickView reloadPicker];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hiddenPickView];
}
@end
