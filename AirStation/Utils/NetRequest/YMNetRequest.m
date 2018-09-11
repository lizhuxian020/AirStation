//
//  YMNetRequest.m
//  KMTPay
//
//  Created by 123 on 15/11/5.
//  Copyright © 2015年 KM. All rights reserved.
//

#import "YMNetRequest.h"

static NSString * const netError = @"网络服务异常，请稍后再试!";
//网络错误消息标识
static NSString *const NetWorkingError = @"NetWorkingError";
//图片上传//TOOD:临时解决, 待优化
static NSString * const upLoadPhotoSubString = @"try.file.upload";
@interface YMNetRequest() {
    NSString *_baseURL;
}

@end

@implementation YMNetRequest
/**
 *  创建网络请求类单例
 *
 *  @return 返回网络请求类单例
 */
+ (instancetype)sharedYMNetRequest {
    static YMNetRequest *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (NSURLSessionDataTask *)startHttpRequestWithoutProcessErrorWithSubUrl:(NSString *)subUrl parameters:(NSDictionary *)parameters completionBlock:(finishBlock)completionBlock{
    //构建签名字符串
    NSString *signStr  = [self createSignStringWithSuburl:subUrl parameters:parameters];
    
    //对签名字符串进行md5签名
    NSString *signedStr = [signStr md5String];
    
    //组装请求参数
    NSDictionary *reqParaDic = nil;
    if (signedStr) {
        reqParaDic = [self createRequestParametersWithSuburl:subUrl signedStr:signedStr parameters:parameters];
    } else {
        NSLog(@"md5签名失败");
    }
    
    //响应回调
    void (^responseBlock)(NSURLSessionDataTask *task, id responseObject, NSError *error) = ^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        
        //请求成功时返回的响应数据对象,错误时该对象为nil
        NSDictionary    *responseDic = (NSDictionary *)responseObject;
        //请求失败时返回的响应错误对象,正确时该对象为nil
        NSError         *responseError            = error;
        
        completionBlock(responseDic, responseError);
        
    };
    //网络请求
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [securityPolicy setValidatesDomainName:NO];
    securityPolicy.allowInvalidCertificates = YES; //还是必须设成YES
    manager.securityPolicy = securityPolicy;
    
    log_debug(@"请求参数:url===>%@ \n parameters===>%@",BaseUrl, [CommonTool getJSONStr:reqParaDic]);
    NSURLSessionDataTask *task = [manager POST:BaseUrl parameters:reqParaDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSString *json = [CommonTool getJSONStr:responseObject];
        KMTLog(@" \n ================ responseObject_SUCCESS ================ \n%@",json);
        if (responseBlock) responseBlock(task, responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        KMTLog(@" \n ================ responseObject_ERROR ================ \n%@",error);
        if (responseBlock) responseBlock(task, nil, error);
    }];
    return task;
}

- (void)startHttpRequestWithSubUrl:(NSString *)subUrl parameters:(NSDictionary *)parameters completionBlock:(CompletionBlock)completionBlock isShowHUD:(BOOL)isShow{
    //构建签名字符串
    NSString *signStr  = [self createSignStringWithSuburl:subUrl parameters:parameters];
    
    //对签名字符串进行md5签名
    NSString *signedStr = [signStr md5String];
    
    //组装请求参数
    NSDictionary *reqParaDic = nil;
    if (signedStr) {
        reqParaDic = [self createRequestParametersWithSuburl:subUrl signedStr:signedStr parameters:parameters];
    } else {
        NSLog(@"md5签名失败");
    }
    
    //响应回调
    void (^responseBlock)(NSURLSessionDataTask *task, id responseObject, NSError *error) = ^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        
        //默认请求错误码为kYMHttpRequestCodeFailed
        NSInteger       errorCode       = kYMHttpRequestCodeFailed;
        //响应码100系列,200系列,300系列,400系列,500系列
        NSInteger       responseCode    = [((NSHTTPURLResponse *)task.response) statusCode];
        //请求成功时返回的响应数据对象,错误时该对象为nil
        NSDictionary    *responseDic = (NSDictionary *)responseObject;
        //请求失败时返回的响应错误对象,正确时该对象为nil
        NSError         *responseError            = error;
        
        //根据响应状态码来标识响应状态
        if ((responseCode == 200) && (responseError == nil)) {
            errorCode = kYMHttpRequestCodeSuccess;
        } else if (responseCode == NSURLErrorTimedOut) {
            // request timeout
            errorCode = kYMHttpRequestCodeTimeOut;
        }
        
        if (completionBlock) {
            
            if (responseDic) {
                //会话过期，退出登录
                if ([[responseDic jsonString:@"code"] isEqualToString:@"10063"]) {
                    //会话过期
                    [self setRootViewControllerWhenTokenInvalid];
                }else if([[responseDic jsonString:@"code"] isEqualToString:@"17010"]){
                    NSString *message = [responseDic jsonString:@"message"];
                    KMTLog(@"%@",message);
                    return ;
                }else if([[responseDic jsonString:@"code"] isEqualToString:@"17020"]){
                    NSString *message = [responseDic jsonString:@"message"];
                    KMTLog(@"%@",message);
                    
                    return ;
                }
                
            }
            //请求不成功
            if (errorCode != kYMHttpRequestCodeSuccess) {
                
                if (errorCode == kYMHttpRequestCodeTimeOut ) {
                    [KMTProgressTool showErrorWithStatus:@"对不起,服务器连接超时"];
                } else {
                    [KMTProgressTool showErrorWithStatus:netError];
                }
                
                //发送网络错误通知
                [[NSNotificationCenter defaultCenter]postNotificationName:NetWorkingError object:nil];
                
                return;
            }
            //回调请求成功时的响应数据
            completionBlock(responseDic, errorCode);
        }
    };
    //网络请求
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [securityPolicy setValidatesDomainName:NO];
    securityPolicy.allowInvalidCertificates = YES; //还是必须设成YES
    manager.securityPolicy = securityPolicy;
    
    if (isShow) [KMTProgressTool show];
    KMTLog(@"请求参数:url===>%@ \n parameters===>%@",BaseUrl, [CommonTool getJSONStr:reqParaDic]);
    [manager POST:BaseUrl parameters:reqParaDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSString *json = [CommonTool getJSONStr:responseObject];
        KMTLog(@" \n ================ responseObject_SUCCESS ================ \n%@",json);
        if (isShow) [KMTProgressTool dismiss];
        if (responseBlock) responseBlock(task, responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        KMTLog(@" \n ================ responseObject_ERROR ================ \n%@",error);
        if (responseBlock) responseBlock(task, nil, error);
    }];
}


- (void)startHttpRequestWithSubUrl:(NSString *)subUrl parameters:(NSDictionary *)parameters completionBlock:(CompletionBlock)completionBlock {
    [self startHttpRequestWithSubUrl:subUrl parameters:parameters completionBlock:completionBlock isShowHUD:YES];
}

//上传图片
- (void)startMultipartRequestWithSubUrl:(NSString *)subUrl parameters:(NSDictionary *)parameters imagesArr:(NSArray *)imagesArr completionBlock:(CompletionBlock)completionBlock {
    //构建签名字符串
    NSString *signStr  = [self createSignStringWithSuburl:subUrl parameters:parameters];
    //对签名字符串进行md5签名
    NSString *signedStr = [signStr md5String];
    //组装请求参数
    NSDictionary *reqParaDic = nil;
    if (signedStr) {
        reqParaDic = [self createRequestParametersWithSuburl:subUrl signedStr:signedStr parameters:parameters];
    }
    
    void (^responseBlock)(NSURLSessionDataTask *task, id responseObject, NSError *error) = ^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        
        //默认请求错误码为kYMHttpRequestCodeFailed
        NSInteger       errorCode       = kYMHttpRequestCodeFailed;
        //响应码100系列,200系列,300系列,400系列,500系列
        NSInteger       responseCode    = [((NSHTTPURLResponse *)task.response) statusCode];
        //请求成功时返回的响应数据对象,错误时该对象为nil
        NSDictionary    *responseDic = (NSDictionary *)responseObject;
        //请求失败时返回的响应错误对象,正确时该对象为nil
        NSError         *responseError            = error;
        //根据响应状态码来标识响应状态
        if ((responseCode == 200) && (responseError == nil)) {
            errorCode = kYMHttpRequestCodeSuccess;
        } else if (responseCode == NSURLErrorTimedOut) {
            // request timeout
            errorCode = kYMHttpRequestCodeTimeOut;
        }
        
        if (completionBlock) {
            if (responseDic) {
                if ([[responseDic jsonString:@"code"] isEqualToString:@"10063"]) {
                    //退出登录
                    //只要已收到这个会话过期，就立马改变用户的登录状态
                    //                    [YMUserDefaults saveStringObject:@"unlogin" forKey:LOGINSTATUSKEY];
                    [self setRootViewControllerWhenTokenInvalid];
                    return ;
                }
                completionBlock(responseDic, errorCode);
            }
        }
    };
    
    //网络请求
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //上传图片
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain", @"application/json",  nil];
    //    [manager setSecurityPolicy:[self customSecurityPolicy]];
    //    manager.responseSerializer.acceptableContentTypes = nil;
    //    manager.securityPolicy.allowInvalidCertificates = YES;//忽略https证书
    //    manager.securityPolicy.validatesDomainName = NO;//是否验证域名
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [securityPolicy setValidatesDomainName:NO];
    securityPolicy.allowInvalidCertificates = YES; //还是必须设成YES
    manager.securityPolicy = securityPolicy;
    NSString *urlStr;
    
    if ([subUrl isEqualToString:upLoadPhotoSubString]) {
        urlStr = ImageUploadUrl;
    }else{
        urlStr = BaseUrl;
    }
    
    [manager.requestSerializer setValue:@"COURIER" forHTTPHeaderField:@"appType"];
    
    KMTLog(@"urlStr:%@ \n parameters:%@",urlStr,reqParaDic);
    [KMTProgressTool showWithStatus:@"上传中"];
    [manager POST:urlStr parameters:reqParaDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (NSInteger i=0; i < imagesArr.count; i++) {
            NSData   *imageData = UIImageJPEGRepresentation(imagesArr[i], 1);
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *name = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", name];
            [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:@"image/jpeg"];
        }
    } progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
              [KMTProgressTool showSuccessWithStatus:@"上传成功！" completion:^{
                  responseBlock(task, responseObject, nil);
              }];
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              responseBlock(task, nil, error);
              [KMTProgressTool showErrorWithStatus:netError];
              KMTLog(@"%@",error);
              
          }];
}


//上传视频
- (void)uploadVideoRequestWithSubUrl:(NSString *)subUrl parameters:(NSDictionary *)parameters videosArr:(NSArray *)videosArr completionBlock:(CompletionBlock)completionBlock {
    //构建签名字符串
    NSString *signStr  = [self createSignStringWithSuburl:subUrl parameters:parameters];
    //对签名字符串进行md5签名
    NSString *signedStr = [signStr md5String];
    //组装请求参数
    NSDictionary *reqParaDic = nil;
    if (signedStr) {
        reqParaDic = [self createRequestParametersWithSuburl:subUrl signedStr:signedStr parameters:parameters];
    }
    
    void (^responseBlock)(NSURLSessionDataTask *task, id responseObject, NSError *error) = ^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        
        //默认请求错误码为kYMHttpRequestCodeFailed
        NSInteger       errorCode       = kYMHttpRequestCodeFailed;
        //响应码100系列,200系列,300系列,400系列,500系列
        NSInteger       responseCode    = [((NSHTTPURLResponse *)task.response) statusCode];
        //请求成功时返回的响应数据对象,错误时该对象为nil
        NSDictionary    *responseDic = (NSDictionary *)responseObject;
        //请求失败时返回的响应错误对象,正确时该对象为nil
        NSError         *responseError            = error;
        //根据响应状态码来标识响应状态
        if ((responseCode == 200) && (responseError == nil)) {
            errorCode = kYMHttpRequestCodeSuccess;
        } else if (responseCode == NSURLErrorTimedOut) {
            // request timeout
            errorCode = kYMHttpRequestCodeTimeOut;
        }
        
        if (completionBlock) {
            if (responseDic) {
                if ([[responseDic jsonString:@"code"] isEqualToString:@"10063"]) {
                    //退出登录
                    //只要已收到这个会话过期，就立马改变用户的登录状态
                    //                    [YMUserDefaults saveStringObject:@"unlogin" forKey:LOGINSTATUSKEY];
                    [self setRootViewControllerWhenTokenInvalid];
                    return ;
                }
                completionBlock(responseDic, errorCode);
            }
        }
    };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:@"COURIER" forHTTPHeaderField:@"appType"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain", @"application/json", nil];
    //[manager setSecurityPolicy:[self customSecurityPolicy]];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [securityPolicy setValidatesDomainName:NO];
    securityPolicy.allowInvalidCertificates = YES; //还是必须设成YES
    manager.securityPolicy = securityPolicy;
    
    //上传视频
    [manager POST:ImageUploadUrl parameters:reqParaDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (NSInteger i=0; i < videosArr.count; i++) {
            NSData   *videoData = videosArr[i];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *name = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.mp4", name];
            [formData appendPartWithFileData:videoData name:@"video" fileName:fileName mimeType:@"video/mp4"];
        }
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        responseBlock(task, responseObject, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        responseBlock(task, nil, error);
    }];
}

#pragma mark - private
//构建签名字符串
- (NSString *)createSignStringWithSuburl:(NSString *)subUrl parameters:(NSDictionary *)parameters {
    
    //将需要签名的业务参数与协议参数组装在字典里
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [dic setValue:subUrl forKey:@"method"];
    if (![[parameters allKeys] containsObject:@"v"]) {
        //如果传参中不包含接口版本，则使用默认的接口版本1.0.0
        [dic setValue:@"1.0.0" forKey:@"v"];
    }
    //风控参数/设置设备采集信息
    //    [dic setValue:[DeviceUtils getDeviceInfo] forKey:@"deviceFinger"];
    //由参数字典(含业务参数与协议参数)字符串化与签名key拼接构成
    NSString *signStr = [NSString stringWithFormat:@"%@%@", [dic stringFromDictionaryParameters], APP_MD5_KEY];
    return signStr;
}

//组装请求参数
- (NSDictionary *)createRequestParametersWithSuburl:(NSString *)subUrl signedStr:(NSString *)signedStr parameters:(NSDictionary *)parameters {
    NSMutableDictionary *requestParaDic = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [requestParaDic setValue:subUrl forKey:@"method"];
    if (![[parameters allKeys] containsObject:@"v"]) {
        //如果传参中不包含接口版本，则覆盖默认的接口版本1.0.0
        [requestParaDic setValue:@"1.0.0" forKey:@"v"];
    }
    [requestParaDic setValue:signedStr forKey:@"sign"];
    //风控参数/设备采集信息
    //    [requestParaDic setValue:[DeviceUtils getDeviceInfo] forKey:@"deviceFinger"];
    return requestParaDic;
}

// app内的请求方式通过https 需要通过SSL加密
- (AFSecurityPolicy*)customSecurityPolicy {
    //先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"kmpay518.com" ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    //AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    securityPolicy.allowInvalidCertificates = YES;
    //validatesDomainName 是否需要验证域名，默认为YES
    securityPolicy.validatesDomainName = NO;
    securityPolicy.pinnedCertificates = [NSSet setWithObject:certData];
    return securityPolicy;
}

+(NSString *)getBaseUrl{
    if ([BaseUrl containsString:@"/kame-mapi/gw/router"]) {
        NSString *baseUrlStr = [BaseUrl componentsSeparatedByString:@"/kame-mapi/gw/router"][0];
        return baseUrlStr;
    }
    return BaseUrl;
}

#pragma mark - TokenInvalid
- (void)setRootViewControllerWhenTokenInvalid {
    KMTLog(@"会话过期，请重新登录");
    [YMUserDefaults saveStringObject:@"unlogin" forKey:kLOGINSTATUS];
    [YMUserDefaults removeObjectForKey:kUSERINFORKEY];
    [[NSNotificationCenter defaultCenter]postNotificationName:TokenInvalid object:nil];
}

@end

