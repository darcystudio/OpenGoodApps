//
//  DSViewController.h
//  Whiteboard
//
//  Created by darcystudio on 2/3/13.
//  Copyright (c) 2013 darcystudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSDrawView.h"
#import "DSDataCenter.h"
#import "DSSensorView.h"
#import "DSSreenRecorder.h"


@interface DSViewController : UIViewController
{
    IBOutlet UIView *toolView;
    
    DSDataCenter *dataCenter;
    DSDrawView *drawView;
    
    
    DSSreenRecorder *screenRecorder;
    BOOL isScreenRecording;
}


@end
