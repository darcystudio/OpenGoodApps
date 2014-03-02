//
//  DSDataCenter.h
//  Whiteboard
//
//  Created by WU MING-YEN on 12/10/6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSDataCenter : NSObject
{
    
    NSString *currentButtonName;
    

    BOOL isScreenChanged;
}


@property (copy) NSString *currentButtonName;
@property (assign) BOOL isScreenChanged;


//- (BOOL)loadUserDefaults;
//- (BOOL)login;


@end
