//
//  YMNetRequest.h
//  KMTPay
//
//  Created by 123 on 15/11/5.
//  Copyright © 2015年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>

//生产
#define ImageUploadUrl      [YMNetRequest sharedYMNetRequest].baseURL
//开发服务器
#define BaseUrl             [YMNetRequest sharedYMNetRequest].baseURL

///响应常量
static NSString *const SUCESS = @"0000";

#define APP_MD5_KEY       @"xid9OVYOq3d9Dc6sVnCpiw1JI3loLP6q"
#define ServerProblemMsg  @"对不起,连接服务器异常!稍后再试"
#define NetworkProblemMsg @"当前网络不可用，请查看网络连接"

typedef NS_ENUM(NSInteger, YMHttpRequestCode) {
    kYMHttpRequestCodeSuccess        =   200,       // 请求成功
    kYMHttpRequestCodeFailed         =   404,       // 请求失败(Url错误时)
    kYMHttpRequestCodeTimeOut        =   2000,      // 请求超时
};

//请求完成后的回调
typedef void(^CompletionBlock)(NSDictionary *resDic, YMHttpRequestCode resCode);
typedef void(^finishBlock)(NSDictionary *resDic, NSError *error);


@interface YMNetRequest : NSObject

@property(nonatomic, copy) NSString *baseURL;

// 获取网络请求的单例
+ (instancetype)sharedYMNetRequest;

//使用单例调用此方法,发起网络请求
// 接口名称(method)以subUrl的形式传递
// 签名值(sign)在请求方法内生成,由parameters中的业务参数与后台规定的协议参数(只取method)与签名key拼接后,md5加密而成
- (void)startHttpRequestWithSubUrl:(NSString *)subUrl parameters:(NSDictionary *)parameters completionBlock:(CompletionBlock)completionBlock;

//控制HUD是否显示
- (void)startHttpRequestWithSubUrl:(NSString *)subUrl parameters:(NSDictionary *)parameters completionBlock:(CompletionBlock)completionBlock isShowHUD:(BOOL)isShow;

//上传图片(以二进制的方式上传),上传的图片需要进行压缩处理
- (void)startMultipartRequestWithSubUrl:(NSString *)subUrl parameters:(NSDictionary *)parameters imagesArr:(NSArray *)imagesArr completionBlock:(CompletionBlock)completionBlock;

//上传视频
- (void)uploadVideoRequestWithSubUrl:(NSString *)subUrl parameters:(NSDictionary *)parameters videosArr:(NSArray *)videosArr completionBlock:(CompletionBlock)completionBlock;

//获取baseUrl
+(NSString *)getBaseUrl;

- (NSURLSessionDataTask *)startHttpRequestWithoutProcessErrorWithSubUrl:(NSString *)subUrl parameters:(NSDictionary *)parameters completionBlock:(finishBlock)completionBlock;
@end
