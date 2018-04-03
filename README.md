# NetWorking

## 简介
    
        XBNetWorking是对AFNetWorking的封装.
        XBModelLayer是独立的网络组件, 提供了解耦性和规范性, 解耦自不必多说,
    规范性相当于车间流水线, 众所周知, 大部分中小型公司人才流动性很强, 为了使
    代码更加规范, XBModelLayer应运而生. 新人只需根据文档或查看源码即可快速上
    手, 使网络层代码统一而规范. 不论是单人开发还是多人开发都不失为一种选择.
        缺点:
            因规范化而导致代码量略微增加.
    
## 示例

    需求: 
        GET 请求 
        BaseURL:    http://www.zhanqi.tv/api/ 
        SuffixURL:  static/live.index/recommend-apps.json?
        
    demo:
        
        1. 将BaseURL及SuffixURL在XBAPIManagerDefine中配置成宏.
        
              XBAPIManagerDefine.h 
        
              #define XBDistributionHost          (@"http://www.zhanqi.tv/api/")      
              #define kAPINameTestHome                (@"static/live.index/recommend-apps.json?")
        
        2. 创建模型TestHomeBaseModel, 这里用的是JSOMModel.
        3. 创建APIManager继承于XBBaseAPIManager, 遵守<XBAPIManagerOverideMethods>协议.实现协议方法.
            //  TestHomeAPIManager.h
            #import "XBBaseAPIManager.h"
            #import "TestHomeBaseModel.h"

            @interface TestHomeAPIManager : XBBaseAPIManager <XBAPIManagerOverideMethods>
            @end
            
            //  TestHomeAPIManager.m
            #import "TestHomeAPIManager.h"
            #import "XBErrorHelper.h"

            @implementation TestHomeAPIManager
            
            // 返回SuffixURL
            - (NSString *)apiMethodName {
                return kAPINameTestHome;
            }
            // 返回请求类型
            - (RequestMethodType)apiMethodType {
                return RequestMethodTypeGet;
            }
            // 请求成功回调
            - (void)request:(XBHttpRequest *)request succeededToLoadData:(NSDictionary *)data {
                
                if ([self.delegate respondsToSelector:@selector(apiManager:succeededToLoadModel:)]) {
                    NSError *parseError = nil;
                    TestHomeBaseModel *model = [[TestHomeBaseModel alloc] initWithDictionary:data error:&parseError];
                    
                    
                    if (!parseError) {
                        [self.delegate apiManager:self succeededToLoadModel:model];
                    } else {
                        [self.delegate apiManager:self failedToLoadDataWithError:[XBErrorHelper XBParseModelError]];
                    }
                }
                
            }
            // 请求失败回调
            - (void)request:(XBHttpRequest *)request failedToLoadWithError:(NSError *)error {
                if ([self.delegate respondsToSelector:@selector(apiManager:failedToLoadDataWithError:)]) {
                    [self.delegate apiManager:self failedToLoadDataWithError:error];
                }
            }
    
            @end
        
        4. 创建DataCenter作为中介.继承于XBBaseDataCenter, 遵守XBAPIManagerDelegate代理. 创建DataCenterDelegate(回调方法代理).
        
            
            //  TestHomeDataCenter.h
            
            #import "XBBaseDataCenter.h"
            #import "TestHomeAPIManager.h"

            @protocol TestHomeDataCenterDelegate <NSObject>
            - (void)requestTestListSucceed:(TestHomeBaseModel *)baseModel;
            - (void)requestTestListFailed:(NSString *)msg;
            @end
            
            @interface TestHomeDataCenter : XBBaseDataCenter <XBAPIManagerDelegate>
            
            @property (nonatomic, weak) id<TestHomeDataCenterDelegate> delegate;
            
            - (void)requestTestList;
    
            @end
            
            //  TestHomeDataCenter.m
                    
            #import "TestHomeDataCenter.h"
            
            @interface TestHomeDataCenter ()
            @property (nonatomic, strong) TestHomeAPIManager *apiManager;
            @end
            
            
            @implementation TestHomeDataCenter
            
            // 先取消请求, 再请求.防止网络延时造成的多次请求.
            - (void)requestTestList {
                [self.apiManager cancelRequest];
                [self.apiManager requestAsynchrously];
            }
            
            - (void)apiManager:(XBBaseAPIManager *)apiManager succeededToLoadModel:(id)model {
                if (apiManager == self.apiManager) {
                    TestHomeBaseModel *listModel = (TestHomeBaseModel *)model;
                    
                    if (listModel.code == kJSONModelStatusOk) {
                        if ([self.delegate respondsToSelector:@selector(requestTestListSucceed:)]) {
                            [self.delegate requestTestListSucceed:listModel];
                        }
                    } else {
                        [self requestTestListFailedWithMsg:listModel.message];
                    }
                }
            }
            
            - (void)apiManager:(XBBaseAPIManager *)apiManager failedToLoadDataWithError:(NSError *)error {
                if (apiManager == self.apiManager) {
                    [self requestTestListFailedWithMsg:NSLocalizedString(@"app_network_not_reachable", nil)];
                }
            }

            #pragma mark ####################### Private #######################
            
            - (void)requestTestListFailedWithMsg:(NSString *)msg {
                if ([self.delegate respondsToSelector:@selector(requestTestListFailed:)]) {
                    [self.delegate requestTestListFailed:msg];
                }
            }
            
            
            - (TestHomeAPIManager *)apiManager {
                if (!_apiManager) {
                    _apiManager = [[TestHomeAPIManager alloc] initWithDelegate:self params:nil];
                }
                return _apiManager;
                
            }
            
            @end


        5. 在需要网络请求时, 引入DataCenter, 实现代理方法, 设置代理, 实现代理方法即可.      
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