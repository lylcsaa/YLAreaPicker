//
//  YLPickView.m
//  TestAreaData
//
//  Created by wlx on 17/4/12.
//  Copyright © 2017年 Tim. All rights reserved.
//
#import "YLDataBaseManager.h"
#import "YLPickView.h"
#define KBUTTONWIDTH 60
#define KBUTTONHEIGHT 44
#define KMINSPACE 20
@implementation YLPickView
{
    UIView *_buttonBgView;
    YLArea *_selectArea;
    YLStreet *_selectStreet;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        _buttonBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), KBUTTONHEIGHT)];
        _buttonBgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_buttonBgView];
        [_buttonBgView addSubview:self.doneButton];
        [_buttonBgView addSubview:self.cancelButton];
        [self addSubview:self.pickView];
    }
    return self;
}
-(void)setIsSingle:(BOOL)isSingle
{
    _isSingle = isSingle;
}
-(void)reloadPicker
{
    if (_isSingle) {
        if (!self.areaID) return;
        [self.dataSource streetDataWithAreaID:self.areaID];
        self.numberOfSections = 1;
    }else{
        [self.dataSource getThreeComponentDefaultDatas];
        self.numberOfSections = 3;
    }
    [self.pickView reloadAllComponents];
}
-(YLDataSource *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[YLDataSource alloc] init];
       
    }
    return _dataSource;
}
-(UIButton *)doneButton
{
    if (!_doneButton) {
        _doneButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds) - KBUTTONWIDTH - KMINSPACE, 0, KBUTTONWIDTH, KBUTTONHEIGHT)];
        [_doneButton setTitle:@"确定" forState:UIControlStateNormal];
        [_doneButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _doneButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_doneButton addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneButton;
}
-(void)done:(UIButton*)sender
{
    YLAreaModel *model = nil;
    if (self.isSingle) {
        model = [self.dataSource getAreaInfoByStreetModel:_selectStreet];
    }else{
        model = [self.dataSource getAreaInfoByAreaModel:_selectArea];
    }
    
    if (self.completionBlock) {
        self.completionBlock(model);
    }
}
-(UIButton *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(KMINSPACE, 0, KBUTTONWIDTH, KBUTTONHEIGHT)];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}
-(void)cancel:(UIButton*)sender
{
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    
}
-(UIPickerView *)pickView
{
    if (!_pickView) {
        _pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_buttonBgView.frame), CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)-CGRectGetMaxY(self.cancelButton.frame))];
        _pickView.delegate = self;
        _pickView.dataSource = self;
    }
    return _pickView;
}

-(void)setNumberOfSections:(NSInteger)numberOfSections
{
    _numberOfSections = numberOfSections;
}
#pragma mark - UIPickerDatasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return _numberOfSections;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component{
    if (self.isSingle) {
        NSArray *streetArr = [self.dataSource.dataSourceDict objectForKey:kYLStreetKey];
        return streetArr.count;
    }else{
        switch (component) {
            case 0:
            {
                NSArray *pArr = [self.dataSource.dataSourceDict objectForKey:kYLProvenceKey];
                return pArr.count;
            }
                break;
            case 1:
            {
                NSArray *pArr = [self.dataSource.dataSourceDict objectForKey:kYLCityKey];
                return pArr.count;
            }
                break;
            case 2:
            {
                NSArray *pArr = [self.dataSource.dataSourceDict objectForKey:kYLAreaKey];
                return pArr.count;
            }
                break;
            default:
                break;
        }
    }
    
    return 10;
}
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component{
    if (self.isSingle) {
        NSArray *streetArr = [self.dataSource.dataSourceDict objectForKey:kYLStreetKey];
         YLStreet *s = streetArr[row];
        _selectStreet = s;
        return s.sname;
    }else{
        switch (component) {
            case 0:
            {
                NSArray *pArr = [self.dataSource.dataSourceDict objectForKey:kYLProvenceKey];
                YLProvence *p = pArr[row];
                return p.pname;
            }
                break;
            case 1:
            {
                NSArray *pArr = [self.dataSource.dataSourceDict objectForKey:kYLCityKey];
                YLCity *c = pArr[row];
                return c.cname;
            }
                break;
            case 2:
            {
                NSArray *pArr = [self.dataSource.dataSourceDict objectForKey:kYLAreaKey];
                YLArea *a = pArr[row];
                _selectArea = a;
                return a.aname;
            }
                break;
            default:
                break;
        }
    }

    return @"123456";
}
#pragma mark pickerView被选中
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
    if (self.isSingle) {
        NSArray *streetArr = [self.dataSource.dataSourceDict objectForKey:kYLStreetKey];
        _selectStreet = streetArr[row];
        NSLog(@"选中了：%@",_selectStreet.sname);
    }else{
        switch (component) {
            case 0:
            {
                NSArray *pArr = [self.dataSource.dataSourceDict objectForKey:kYLProvenceKey];
                YLProvence *p = pArr[row];
                [self.dataSource getThreeComponentCityDatasByProvenceID:p._id];
                
                NSArray *cArr = [self.dataSource.dataSourceDict objectForKey:kYLCityKey];
                YLCity *c = cArr[0];
                [self.dataSource getThreeComponentAreaDatasByCityID:c._id];
                [pickerView reloadComponent:1];
                [pickerView reloadComponent:2];
            }
                break;
            case 1:
            {
                NSArray *pArr = [self.dataSource.dataSourceDict objectForKey:kYLCityKey];
                YLCity *c = pArr[row];
                [self.dataSource getThreeComponentAreaDatasByCityID:c._id];
                [pickerView reloadComponent:2];
            }
                break;
            case 2:
            {
                NSArray *pArr = [self.dataSource.dataSourceDict objectForKey:kYLAreaKey];
                _selectArea = pArr[row];
            }
                break;
            default:
                break;
        }
    }

}
- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row forComponent:(NSInteger)component
           reusingView:(UIView *)view{
    
    UILabel* pickerLabel = (UILabel*)view;
    
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.textColor = [UIColor colorWithRed:51.0/255
                                                green:51.0/255
                                                 blue:51.0/255
                                                alpha:1.0];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    
    pickerLabel.text = [self pickerView:pickerView
                            titleForRow:row
                           forComponent:component];
    return pickerLabel;
}

@end
