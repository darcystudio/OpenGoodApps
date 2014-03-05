//
//  DSDataCenter.m
//  Whiteboard
//
//  Created by WU MING-YEN on 12/10/6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DSDataCenter.h"
//#import "JSON.h"

@implementation DSDataCenter

@synthesize currentButtonName;
@synthesize isScreenChanged;


- (id)init
{
    if (!(self = [super init])) return nil;

    self.currentButtonName = @"pen1";
    self.isScreenChanged = YES;
    
    return self;
}



@end
