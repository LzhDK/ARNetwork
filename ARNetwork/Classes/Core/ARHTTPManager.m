//
//  ARHTTPManager.m
//  ARNetwork
//
//  Created by Linzh on 12/13/16.
//  Copyright © 2016 Daniel. All rights reserved.
//

#import "ARHTTPManager.h"

static const NSTimeInterval kARDefaultTimeoutInterval = 30;

@interface ARHTTPManager ()
@property (nonatomic, strong) NSMutableSet<NSString *> *acceptableContentTypes;
@end

@implementation ARHTTPManager
@synthesize timeoutInterval = _timeoutInterval;

#pragma mark - Override
- (instancetype)init {
    if (self = [super init]) {
        self.requestSerializer.timeoutInterval = self.timeoutInterval;
        self.responseSerializer.acceptableContentTypes = self.acceptableContentTypes;
    }
    return self;
}

#pragma mark - HTTP
+ (NSURLSessionDataTask *)getURL:(NSString *)urlStr params:(NSDictionary *)params success:(ARHTTPResponseSuccess)success failure:(ARHTTPResponseFailure)failure {
    NSURLSessionDataTask *task = [[self manager] getURL:urlStr params:params success:success failure:failure];
    return task;
}

- (NSURLSessionDataTask *)getURL:(NSString *)urlStr params:(NSDictionary *)params success:(ARHTTPResponseSuccess)success failure:(ARHTTPResponseFailure)failure {
    NSString *taskKey = [self taskKeyForUrl:urlStr];
    
    NSURLSessionDataTask *task = [self GET:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self taskSuccess:success failure:failure withData:responseObject forKey:taskKey];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self taskfailure:failure withError:error forKey:taskKey];
    }];
    return task;
}

+ (NSURLSessionDataTask *)postURL:(NSString *)urlStr params:(NSDictionary *)params success:(ARHTTPResponseSuccess)success failure:(ARHTTPResponseFailure)failure {
    NSURLSessionDataTask *task = [[self manager] postURL:urlStr params:params success:success failure:failure];
    return task;
}

- (NSURLSessionDataTask *)postURL:(NSString *)urlStr params:(NSDictionary *)params success:(ARHTTPResponseSuccess)success failure:(ARHTTPResponseFailure)failure {
    NSString *taskKey = [self taskKeyForUrl:urlStr];
    
    NSURLSessionDataTask *task = [self POST:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self taskSuccess:success failure:failure withData:responseObject forKey:taskKey];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self taskfailure:failure withError:error forKey:taskKey];
    }];
    return task;
}

+ (NSURLSessionDataTask *)putURL:(NSString *)urlStr params:(NSDictionary *)params success:(ARHTTPResponseSuccess)success failure:(ARHTTPResponseFailure)failure {
    NSURLSessionDataTask *task = [[self manager] putURL:urlStr params:params success:success failure:failure];
    return task;
}

- (NSURLSessionDataTask *)putURL:(NSString *)urlStr params:(NSDictionary *)params success:(ARHTTPResponseSuccess)success failure:(ARHTTPResponseFailure)failure {
    NSString *taskKey = [self taskKeyForUrl:urlStr];
    
    NSURLSessionDataTask *task = [self PUT:urlStr parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self taskSuccess:success failure:failure withData:responseObject forKey:taskKey];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self taskfailure:failure withError:error forKey:taskKey];
    }];
    return task;
}

+ (NSURLSessionDataTask *)patchURL:(NSString *)urlStr params:(NSDictionary *)params success:(ARHTTPResponseSuccess)success failure:(ARHTTPResponseFailure)failure {
    NSURLSessionDataTask *task = [[self manager] patchURL:urlStr params:params success:success failure:failure];
    return task;
}

- (NSURLSessionDataTask *)patchURL:(NSString *)urlStr params:(NSDictionary *)params success:(ARHTTPResponseSuccess)success failure:(ARHTTPResponseFailure)failure {
    NSString *taskKey = [self taskKeyForUrl:urlStr];
    
    NSURLSessionDataTask *task = [self PATCH:urlStr parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self taskSuccess:success failure:failure withData:responseObject forKey:taskKey];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self taskfailure:failure withError:error forKey:taskKey];
    }];
    return task;
}

+ (NSURLSessionDataTask *)deleteURL:(NSString *)urlStr params:(NSDictionary *)params success:(ARHTTPResponseSuccess)success failure:(ARHTTPResponseFailure)failure {
    NSURLSessionDataTask *task = [[self manager] deleteURL:urlStr params:params success:success failure:failure];
    return task;
}

- (NSURLSessionDataTask *)deleteURL:(NSString *)urlStr params:(NSDictionary *)params success:(ARHTTPResponseSuccess)success failure:(ARHTTPResponseFailure)failure {
    NSString *taskKey = [self taskKeyForUrl:urlStr];
    
    NSURLSessionDataTask *task = [self DELETE:urlStr parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self taskSuccess:success failure:failure withData:responseObject forKey:taskKey];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self taskfailure:failure withError:error forKey:taskKey];
    }];
    return task;
}

#pragma mark - Private
- (NSString *)taskKeyForUrl:(NSString *)urlStr {
    NSString *taskKey;
    if ([self.requestDelegate respondsToSelector:@selector(ar_taskKeyForRequestURL:)]) {
        taskKey = [self.requestDelegate ar_taskKeyForRequestURL:urlStr];
    }
    
    ARLogDebug(@"Request<%@>:\n%@", taskKey, urlStr);
    return taskKey;
}

- (void)taskSuccess:(ARHTTPResponseSuccess)success failure:(ARHTTPResponseFailure)failure withData:(id)data forKey:(NSString *)key {
    ARLogDebug(@"Response<%@>:\n%@", key, data);
    
    if ([self.responseDelegate respondsToSelector:@selector(ar_onSuccess:onFailure:withData:)]) {
        [self.responseDelegate ar_onSuccess:success onFailure:failure withData:data];
    }
}

- (void)taskfailure:(ARHTTPResponseFailure)failure withError:(NSError *)error forKey:(NSString *)key {
    ARLogError(@"Response<%@>:\n%@", key, error);
    
    if ([self.responseDelegate respondsToSelector:@selector(ar_onFailure:withError:)]) {
        [self.responseDelegate ar_onFailure:failure withError:error];
    }
}

#pragma mark -
- (NSTimeInterval)timeoutInterval {
    if (_timeoutInterval > 0) {
        return _timeoutInterval;
    }
    return kARDefaultTimeoutInterval;
}

- (void)setTimeoutInterval:(NSTimeInterval)timeoutInterval {
    if (timeoutInterval > 0) {
        _timeoutInterval = timeoutInterval;
        self.requestSerializer.timeoutInterval = _timeoutInterval;
    }
}

- (NSMutableSet<NSString *> *)acceptableContentTypes {
    if (_acceptableContentTypes) {
        return _acceptableContentTypes;
    }
    _acceptableContentTypes = [NSMutableSet setWithSet:self.responseSerializer.acceptableContentTypes];
    [_acceptableContentTypes addObject:@"text/html"];
    return _acceptableContentTypes;
}

- (id<ARHTTPResponseDelegate>)responseDelegate {
    if (_responseDelegate) {
        return _responseDelegate;
    }
    return _responseDelegate = [[ARHTTPResponse alloc] init];
}

- (id<ARHTTPRequestDelegate>)requestDelegate {
    if (_requestDelegate) {
        return _requestDelegate;
    }
    return _requestDelegate = [[ARHTTPRequest alloc] init];
}
@end
