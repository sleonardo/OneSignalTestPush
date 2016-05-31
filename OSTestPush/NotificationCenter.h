//
//  LocalNotificationManager.h
//  OSTestPush
//
//  Created by Ha Ki on 5/31/16.
//  Copyright © 2016 Ha Ki. All rights reserved.
//

#import <Foundation/Foundation.h>
#define LocalPushMgr [NotificationCenter sharedInstance]

@interface NotificationCenter : NSObject

+ (NotificationCenter *)sharedInstance;

- (void)scheduleAtDate:(NSDate *)fireDate;
- (NSString *)stringOfAllNotifications;

@end
