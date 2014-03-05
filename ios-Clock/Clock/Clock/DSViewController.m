//
//  DSViewController.m
//  Clock
//
//  Created by darcystudio on 2/16/13.
//  Copyright (c) 2013 darcystudio. All rights reserved.
//

#import "DSViewController.h"

@interface DSViewController ()

@end

@implementation DSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //[[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    //idleTimerDisabled = YES;
    

    
    angleBegin = 0;
    angleMove = 0;
    angleEnd = 0;
    angleTimeZone = 0;
    shiftAngleByTouch = 0;
    

    
    //NSString *schoolSoundFileName = [[NSBundle mainBundle] pathForResource:@"sound-school" ofType:@"wav"];
    //NSURL *schoolSoundURL = [NSURL fileURLWithPath:schoolSoundFileName];
    //AudioServicesCreateSystemSoundID((CFURLRef)schoolSoundURL, &schoolSoundID);
    
    NSString *schoolSoundFileName = [[NSBundle mainBundle] pathForResource:@"sound-school" ofType:@"mp3"];
    NSURL *schoolSoundURL = [NSURL fileURLWithPath:schoolSoundFileName];
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:schoolSoundURL error:nil];
    [audioPlayer prepareToPlay];
    
    
    //[self playSchoolSound:self];
    
    [self powerOnTimer];
    [self onTimer];
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	keepScreenOn = [userDefaults boolForKey:@"user.keepScreenOn"];
    pomodoroClockOn = [userDefaults boolForKey:@"user.pomodoroClockOn"];
    
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:keepScreenOn];
    

    //[[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
}


- (BOOL)prefersStatusBarHidden
{
    return YES;
}


- (void)dealloc
{
    [self powerOffTimer];
    
    //AudioServicesDisposeSystemSoundID(schoolSoundID);
    
    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}


//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//}
//
//
//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//}
//
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//}
//
//
//- (void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:animated];
//}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}



- (void)powerOnTimer
{
	timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    startTime = 0;
}


- (void)powerOffTimer
{
	[timer invalidate];
}


- (void)onTimer
{
    
    //[self playButtonSound:self];
    
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    //[formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:currentTimeZone*60*60]];
    
	
    [formatter setDateFormat:@"H"];
    NSInteger h = [[formatter stringFromDate:date] intValue];
    
    [formatter setDateFormat:@"m"];
    NSInteger m = [[formatter stringFromDate:date] intValue];
    
    [formatter setDateFormat:@"s"];
    NSInteger s = [[formatter stringFromDate:date] intValue];
    
    //imageSecHand.center = CGPointMake(160, 272);
    secondHand.transform = CGAffineTransformMakeRotation(2*M_PI*s/60);
    //    [UIView beginAnimations:nil context:NULL];
    //    [UIView setAnimationDuration:0.1f];
    //    [UIView setAnimationBeginsFromCurrentState:YES];
    //    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    //    imageSecHand.transform = CGAffineTransformMakeRotation(2*M_PI*s/60);
    //    [UIView commitAnimations];
    
    
    minuteHand.transform = CGAffineTransformMakeRotation(2*M_PI*(m*60+s)/60/60);
    
    
    if(pomodoroClockOn == YES)
    {
        if(s == 0)
        {
            if(m == 0 ||
               m == 25 ||
               m == 30 ||
               m == 55)
            {
                
                [self playSchoolSound:self];
            }
        }
    }
        
    //shiftByTouch = (360.0*(angleMove - angleBegin)/2/M_PI);
    //NSLog(@"%i", shiftByTouch);
    
    hourHand.transform = CGAffineTransformMakeRotation(2*M_PI*((h%12)*60+m)/12/60-2.0*shiftAngleByTouch);
    //    [UIView beginAnimations:nil context:NULL];
    //    [UIView setAnimationDuration:0.05f];
    //    [UIView setAnimationBeginsFromCurrentState:YES];
    //    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    //    imageHourHand.transform = CGAffineTransformMakeRotation(2*M_PI*((h%12)*60+m)/12/60);
    //    [UIView commitAnimations];
    
    
    startTime++;
    
//    if(startTime%60 == 0)
//    {
//        
//        if(idleTimerDisabled == YES)
//        {
//            UIDeviceBatteryState batteryState = [[UIDevice currentDevice] batteryState];
//            float batteryLevel = [[UIDevice currentDevice] batteryLevel];
//            //NSLog(@"1 batteryLevel=%f, batteryState=%d", batteryLevel, batteryState);
//            
//            if(batteryState == UIDeviceBatteryStateUnknown ||
//               batteryState == UIDeviceBatteryStateUnplugged)
//            {
//                if(batteryLevel < 0.2)
//                {
//                    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
//                    idleTimerDisabled = NO;
//                }
//            }
//        }
//        else
//        {
//            UIDeviceBatteryState batteryState = [[UIDevice currentDevice] batteryState];
//            float batteryLevel = [[UIDevice currentDevice] batteryLevel];
//            //NSLog(@"2 batteryLevel=%f, batteryState=%d", batteryLevel, batteryState);
//            
//            if(batteryState == UIDeviceBatteryStateCharging ||
//               batteryState == UIDeviceBatteryStateFull ||
//               batteryLevel > 0.2)
//            {
//                [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
//                idleTimerDisabled = YES;
//            }
//        }
//    }
    
    
}



- (BOOL)playSchoolSound:(id)sender
{
    //AudioServicesPlaySystemSound(schoolSoundID);
    [audioPlayer play];
    return YES;
}



- (IBAction)clickSettingsButton:(id)sender
{
    DSSettingsViewController *controller = [[DSSettingsViewController alloc] init];
    controller.settingsCallback = self;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentModalViewController:navigationController animated:YES];    
}


- (void)onSettingsCallback
{
    // 讀取使用者的設定，使用NSUserDefaults元件來達成此功能
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	keepScreenOn = [userDefaults boolForKey:@"user.keepScreenOn"];
    pomodoroClockOn = [userDefaults boolForKey:@"user.pomodoroClockOn"];
    
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:keepScreenOn];
    
    //NSLog(@"%d %d", keepScreenOn, pomodoroClockOn);
}





@end
