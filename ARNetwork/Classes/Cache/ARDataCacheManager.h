//
//  ARDataCacheManager.h
//  ARNetwork
//
//  Created by Linzh on 12/14/16.
//  Copyright © 2016 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ARDataCacheManager : NSObject

+ (void)initDataCacheConfigurationWithSchemaVersion:(uint64_t)version;

+ (void)clearAllDataCache;
@end
