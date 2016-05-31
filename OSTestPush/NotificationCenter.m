//
//  LocalNotificationManager.m
//  OSTestPush
//
//  Created by Ha Ki on 5/31/16.
//  Copyright © 2016 Ha Ki. All rights reserved.
//

#import "NotificationCenter.h"
#import "AppDelegate.h"

@implementation NotificationCenter


+ (NotificationCenter *)sharedInstance {
    
    static NotificationCenter *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[NotificationCenter alloc] init];
    });
    return _sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)scheduleAtDate:(NSDate *)fireDate {
    
    if ([fireDate compare:[NSDate date]] == NSOrderedAscending) {
        NSLog(@"fire date < [NSDate date]");
        return;
    }
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    localNotif.fireDate = fireDate;
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    
    NSString *strNotify = @"Local ";
    
    localNotif.alertBody = strNotify;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    
}

- (NSString *)stringOfAllNotifications
{
    NSString *str = @"";
    
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *eventArray = [app scheduledLocalNotifications];
    for (int i=0; i<[eventArray count]; i++)
    {
        UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
        NSString *dateString = [NSDateFormatter localizedStringFromDate:oneEvent.fireDate
                                                              dateStyle:NSDateFormatterShortStyle
                                                              timeStyle:NSDateFormatterFullStyle];
        NSString *full = [NSString stringWithFormat:@"%@ -- [%@]\n", oneEvent.alertBody, dateString];
        str = [str stringByAppendingString:full];
    }
    return str;
}

@end
