//
//  DSSettingsViewController.h
//  Clock
//
//  Created by darcystudio on 3/3/14.
//  Copyright (c) 2014 darcystudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSSettingsViewController : UITableViewController
{
    BOOL keepScreenOn;
    BOOL pomodoroClockOn;
    
    
    id __unsafe_unretained settingsCallback;
}


@property (unsafe_unretained) id settingsCallback;


@end
