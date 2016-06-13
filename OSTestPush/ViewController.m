//
//  ViewController.m
//  OSTestPush
//
//  Created by Ha Ki on 5/31/16.
//  Copyright © 2016 Ha Ki. All rights reserved.
//

#import "ViewController.h"
#import "OneSignalManager.h"
#import "NotificationCenter.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    _statusLabel.text = [LocalPushMgr stringOfAllNotifications];
    if ([_statusLabel.text isEqualToString:@""]) {
        _statusLabel.text = @"Status";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)reloadPressed:(id)sender {
    _statusLabel.text = [LocalPushMgr stringOfAllNotifications];
}

- (IBAction)pushButtonPressed:(id)sender {

    [pushMgr postNotificationWithText:@"Normal OneSignal" time:[[NSDate date] dateByAddingTimeInterval:30] success:^(NSString *notificationID) {
        NSLog(@"Success");
        
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [pushMgr postWithInteractiveNotificationWithText:@"Interactive OneSignal" time:[[NSDate date] dateByAddingTimeInterval:40] success:^(NSString *notificationID) {
        NSLog(@"Success");
        
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    _statusLabel.text = [LocalPushMgr stringOfAllNotifications];
}
@end
