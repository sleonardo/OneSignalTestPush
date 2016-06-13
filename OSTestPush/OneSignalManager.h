//
//  OneSignalManger.h
//  OSTestPush
//
//  Created by Ha Ki on 5/31/16.
//  Copyright © 2016 Ha Ki. All rights reserved.
//

#import <Foundation/Foundation.h>
#define pushMgr [OneSignalManager sharedInstance]

@interface OneSignalManager : NSObject

+ (OneSignalManager *)sharedInstance;

- (void)registerWithLaunchOptions:(NSDictionary *)launchOptions;

- (void)postNotificationWithText:(NSString *)msg
                            time:(NSDate *)date
                         success:(void(^)(NSString *notificationID))handler
                         failure:(void(^)(NSError *error))failHandler;

- (void)postWithInteractiveNotificationWithText:(NSString *)msg
                            time:(NSDate *)date
                         success:(void(^)(NSString *notificationID))handler
                         failure:(void(^)(NSError *error))failHandler;

@end
