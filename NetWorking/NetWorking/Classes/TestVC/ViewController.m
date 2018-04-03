//
//  ViewController.m
//  NetWorking
//
//  Created by 李泽宇 on 2018/3/27.
//  Copyright © 2018年 丶信步沧桑. All rights reserved.
//

#import "ViewController.h"
#import "TestHomeDataCenter.h"
@interface ViewController () <TestHomeDataCenterDelegate>

@property (nonatomic, strong) TestHomeDataCenter *dataCenter;

@end

@implementation ViewController

#pragma mark - ###################### LifeCycle Methods ####################

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.dataCenter requestTestList];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - ###################### Delegate Methods #####################
- (void)requestTestListSucceed:(TestHomeBaseModel *)baseModel {
    
    NSLog(@"%@", baseModel);
    // 逻辑处理...
    
}
- (void)requestTestListFailed:(NSString *)msg {
    // 逻辑处理...
}


#pragma mark - ###################### Getter & Setter ######################
- (TestHomeDataCenter *)dataCenter {
    if (!_dataCenter) {
        _dataCenter = [[TestHomeDataCenter alloc] init];
        _dataCenter.delegate = self;
    }
    return _dataCenter;
    
}

@end
