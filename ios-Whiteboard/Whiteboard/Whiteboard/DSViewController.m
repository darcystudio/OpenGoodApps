//
//  DSViewController.m
//  Whiteboard
//
//  Created by darcystudio on 2/3/13.
//  Copyright (c) 2013 darcystudio. All rights reserved.
//

#import "DSViewController.h"

@interface DSViewController ()

@end

@implementation DSViewController


- (void)dealloc
{
    
    [drawView removeFromSuperview];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.wantsFullScreenLayout = YES;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];

    dataCenter = [[DSDataCenter alloc] init];
    
    
    BOOL isPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? true : false;
    //CGRect drawViewRect = (isPad) ? CGRectMake(0, 0, 1024, 768) : CGRectMake(0, 0, 480, 320);
    //CGRect leftSensorViewRect = (isPad) ? CGRectMake(0, 45, 24, 768-90) : CGRectMake(0, 45, 24, 320-90);
    //CGRect rightSensorViewRect = (isPad) ? CGRectMake(1024-24, 45, 24, 768-90) : CGRectMake(480-24, 45, 24, 320-90);
    
    CGRect drawViewRect;
    if(isPad)
    {
        drawViewRect = CGRectMake(0, 0, 1024, 768);
    }
    else
    {
        if([UIScreen mainScreen].bounds.size.height == 568.0)
        {
            drawViewRect = CGRectMake(0, 0, 568, 320);
        }
        else
        {
            drawViewRect = CGRectMake(0, 0, 480, 320);
        }
    }
    
    
    drawView = [[DSDrawView alloc] init];
    drawView.frame = drawViewRect;
    drawView.dataCenter = dataCenter;
    [self.view addSubview:drawView];
    [self.view bringSubviewToFront:toolView];
//
//    
//    DSSensorView *leftSensorView = [[DSSensorView alloc] initWithFrame:leftSensorViewRect];
//    leftSensorView.backgroundColor = [UIColor whiteColor];
//    leftSensorView.alpha = 0.02;
//    leftSensorView.tag = 100;
//    leftSensorView.sensorCallback = self;
//    [self.view addSubview:leftSensorView];
//    
//    
//    DSSensorView *rightSensorView = [[DSSensorView alloc] initWithFrame:rightSensorViewRect];
//    rightSensorView.backgroundColor = [UIColor whiteColor];
//    rightSensorView.alpha = 0.02;
//    rightSensorView.tag = 101;
//    rightSensorView.sensorCallback = self;
//    [self.view addSubview:rightSensorView];
    
    
    
//    screenRecorder = nil;
//    screenRecorder = [[DSSreenRecorder alloc] init];
//    screenRecorder.dataCenter = dataCenter;
//    screenRecorder.mainView = self.view;
//    isScreenRecording = NO;
    
    
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:1.0];
//    //[UIView setAnimationRepeatCount:100];
//    //[UIView setAnimationRepeatAutoreverses:YES];
//    //[button1 setAlpha:0.1];
//    [button1 setTransform:CGAffineTransformMakeScale(0.2, 0.2)];
//    [UIView commitAnimations];

    dataCenter.currentButtonName = @"pen1";

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}



- (BOOL)prefersStatusBarHidden
{
    return YES;
}


- (IBAction)clickToolButton:(id)sender
{
    NSLog(@"clickToolButton");
    
    UIButton *button = sender;
    
    if(button.tag == 1001)
    {
        //[contentView setScrollEnabled:YES];
    }
    else
    {
        //[contentView setScrollEnabled:NO];
    }
    
    for(int i=1001;i<=1005;i++)
    {
        UIButton *otherButton = (UIButton *)[button.superview viewWithTag:i];
        
        if(i == button.tag)
        {
            continue;
        }
        
        otherButton.selected = NO;
        otherButton.alpha = 1.0;
    }
    
    
    switch (button.tag)
    {
        case 1001:
            
            if([dataCenter.currentButtonName isEqualToString:@"pen1"] == YES)
            {
                dataCenter.currentButtonName = @"lighter1";
                button.alpha = 0.3;
            }
            else
            {
                dataCenter.currentButtonName = @"pen1";
                button.alpha = 1.0;
            }
            break;
            
        case 1002:
            
            if([dataCenter.currentButtonName isEqualToString:@"pen2"] == YES)
            {
                dataCenter.currentButtonName = @"lighter2";
                button.alpha = 0.3;
            }
            else
            {
                dataCenter.currentButtonName = @"pen2";
                button.alpha = 1.0;
            }
            break;
            
        case 1003:
            
            if([dataCenter.currentButtonName isEqualToString:@"pen3"] == YES)
            {
                dataCenter.currentButtonName = @"lighter3";
                button.alpha = 0.3;
            }
            else
            {
                dataCenter.currentButtonName = @"pen3";
                button.alpha = 1.0;
            }
            break;
            
        case 1004:
            
            if([dataCenter.currentButtonName isEqualToString:@"pen4"] == YES)
            {
                dataCenter.currentButtonName = @"lighter4";
                button.alpha = 0.3;
            }
            else
            {
                dataCenter.currentButtonName = @"pen4";
                button.alpha = 1.0;
            }
            break;
            
        case 1005:
            
            if([dataCenter.currentButtonName isEqualToString:@"eraser"] == YES)
            {
                [drawView clearAll:self];
            }
            
            
            dataCenter.currentButtonName = @"eraser";
            
//            if(isScreenRecording == NO)
//            {
//                dataCenter.isScreenChanged = YES;
//                [screenRecorder startRecording];
//                isScreenRecording = YES;
//            }
//            else
//            {
//                [screenRecorder stopRecording];
//                isScreenRecording = NO;
//            }
            
            break;
            
        default:
            break;
    }
    
    button.selected = YES;
    

        
    if([dataCenter.currentButtonName isEqual:@"mouse"])
    {
        [drawView setUserInteractionEnabled:NO];
    }
    else
    {
        [drawView setUserInteractionEnabled:YES];
    }
    
}



- (void)onSensorCallbackClick:(id)sender
{
    DSSensorView *sensorView = sender;
    
    
    BOOL isPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? true : false;
    //CGRect leftSensorViewRect = (isPad) ? CGRectMake(0, 45, 24, 768-90) : CGRectMake(0, 45, 24, 320-90);
    //CGRect rightSensorViewRect = (isPad) ? CGRectMake(1024-24, 45, 24, 768-90) : CGRectMake(480-24, 45, 24, 320-90);
    CGRect leftToolViewRect = (isPad) ? CGRectMake(30, 249, 60, 270) : CGRectMake(30, 25, 60, 270);
    CGRect rightToolViewRect = (isPad) ? CGRectMake(934, 249, 60, 270) : CGRectMake(390, 25, 60, 270);
    
    if(sensorView.tag == 100)
    {
        if(toolView.hidden == YES || toolView.frame.origin.x == rightToolViewRect.origin.x)
        {
            toolView.frame = leftToolViewRect;
            toolView.hidden = NO;
        }
        else
        {
            toolView.frame = leftToolViewRect;
            toolView.hidden = YES;
        }
    }
    else if(sensorView.tag == 101)
    {
        if(toolView.hidden == YES || toolView.frame.origin.x == leftToolViewRect.origin.x)
        {
            toolView.frame = rightToolViewRect;
            toolView.hidden = NO;
        }
        else
        {
            toolView.frame = rightToolViewRect;
            toolView.hidden = YES;
        }
    }
    else
    {
        
    }
}


- (void)onSensorCallbackTouchDown:(id)sender
{
    
}


- (void)onSensorCallbackTouchMove:(id)sender
{

}


- (void)onSensorCallbackTouchUp:(id)sender
{

}




@end
