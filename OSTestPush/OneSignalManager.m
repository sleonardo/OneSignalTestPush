//
//  OneSignalManger.m
//  OSTestPush
//
//  Created by Ha Ki on 5/31/16.
//  Copyright © 2016 Ha Ki. All rights reserved.
//

#import "OneSignalManager.h"
#import <OneSignal/OneSignal.h>
#define onesignal_url       @"https://onesignal.com/api/v1/notifications/"
#define onesignal_appid     @"a09a5d0e-2ca0-469e-84b3-154cf476983f"
#define onesignal_password  @"YWIwOGFlMmMtMzA2Yy00ZmViLWE4NjctNTA5NzI2M2E0ZDVh"
#define OS_USER_ID_KEY      @"OS_USER_ID_KEY"

#define SET_OBJECT(key,value) {[[NSUserDefaults standardUserDefaults] setObject:value forKey:key];[[NSUserDefaults standardUserDefaults] synchronize]; }

#define GET_OBJECT(key)\
![[NSUserDefaults standardUserDefaults] objectForKey:key] ? nil :[[NSUserDefaults standardUserDefaults] objectForKey:key]

@implementation OneSignalManager {
    OneSignal *_oneSignal;
    NSString *_userID;
}

+ (OneSignalManager *)sharedInstance {
    
    static OneSignalManager *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[OneSignalManager alloc] init];
    });
    return _sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        _userID = GET_OBJECT(OS_USER_ID_KEY);
    }
    return self;
}

- (void)registerWithLaunchOptions:(NSDictionary *)launchOptions {
    _oneSignal = [[OneSignal alloc] initWithLaunchOptions:launchOptions
                                                    appId:onesignal_appid
                                       handleNotification:^(NSString *message, NSDictionary *additionalData, BOOL isActive) {
                                           NSLog(@"RegisterOneSignal: %@ %@ %d", message, additionalData, isActive);
                                       } autoRegister:NO];
    [_oneSignal enableInAppAlertNotification:YES];
    if (!_userID) {
        [_oneSignal IdsAvailable:^(NSString* userId, NSString* pushToken) {
            NSLog(@"UserId:%@", userId);
            _userID = userId;
            SET_OBJECT(OS_USER_ID_KEY, userId);
        }];
    }
}



- (void)postNotificationWithText:(NSString *)msg
                            time:(NSDate *)date
                         success:(void(^)(NSString *notificationID))handler
                         failure:(void(^)(NSError *error))failHandler
{
    if (!_userID) {
        NSLog(@"Error: OS user id nill");
        return;
    }
    NSString *time = [self getUTCFormateDate:date];
    NSDictionary *info = @{
                           @"contents" : @{@"en": msg},
                           @"include_player_ids": @[_userID],
                           @"send_after": time,
                           @"content_available" : [NSNumber numberWithBool:YES]
                           };
    [_oneSignal postNotification:info onSuccess:^(NSDictionary *result) {
        NSLog(@"Post Success: %@", result);
        NSString *notify_id = [result objectForKey:@"id"];
        handler(notify_id);
    } onFailure:^(NSError *error) {
        NSLog(@"Post Error: %@", error);
        failHandler(error);
    }];
    
}

- (void)postWithInteractiveNotificationWithText:(NSString *)msg
                                           time:(NSDate *)date
                                        success:(void(^)(NSString *notificationID))handler
                                        failure:(void(^)(NSError *error))failHandler {
    if (!_userID) {
        NSLog(@"Error: OS user id nill");
        return;
    }
    NSString *time = [self getUTCFormateDate:date];
    NSArray *array = @[@{@"id": @"id1", @"text": @"button1", @"icon": @"ic_menu_share"}, @{@"id": @"id2", @"text": @"button2", @"icon": @"ic_menu_share"}];
    
    NSDictionary *info = @{
                           @"contents" : @{@"en": msg},
                           @"include_player_ids": @[_userID],
                           @"send_after": time,
                           @"buttons": array,
                           @"content_available" : [NSNumber numberWithBool:YES]
                           };
    [_oneSignal postNotification:info onSuccess:^(NSDictionary *result) {
        NSLog(@"Post Success: %@", result);
        NSString *notify_id = [result objectForKey:@"id"];
        handler(notify_id);
    } onFailure:^(NSError *error) {
        NSLog(@"Post Error: %@", error);
        failHandler(error);
    }];
    
}



#pragma - Utilities

- (NSString *)getUTCFormateDate:(NSDate *)localDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZZ"];
    NSString *dateString = [dateFormatter stringFromDate:localDate];
    //    dateString = [dateString stringByAppendingString:@" GMT-0000"];
    return dateString;
}


@end
