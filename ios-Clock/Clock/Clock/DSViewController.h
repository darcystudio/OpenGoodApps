//
//  DSViewController.h
//  Clock
//
//  Created by darcystudio on 2/16/13.
//  Copyright (c) 2013 darcystudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "DSSettingsViewController.h"


@interface DSViewController : UIViewController
{

    IBOutlet UIImageView *timeText;
    IBOutlet UIImageView *hourHand;
    IBOutlet UIImageView *minuteHand;
    IBOutlet UIImageView *secondHand;

    
    AVAudioPlayer *audioPlayer;

    
    float angleBegin;
    float angleMove;
    float angleEnd;
    float angleTimeZone;
    float shiftAngleByTouch;
    
    NSTimer *timer;
    NSInteger startTime;
    

    SystemSoundID schoolSoundID;
    
    //BOOL idleTimerDisabled;

    BOOL keepScreenOn;
    BOOL pomodoroClockOn;

}



- (void)powerOnTimer;
- (void)powerOffTimer;
- (void)onTimer;

- (IBAction)clickSettingsButton:(id)sender;
- (void)onSettingsCallback;



@end
