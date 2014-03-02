//
//  DSDrawView.h
//  Whiteboard
//
//  Created by darcystudio on 1/7/13.
//
//

#import <UIKit/UIKit.h>
#import "DSDataCenter.h"


@interface DSDrawView : UIView
{
    
    DSDataCenter *__unsafe_unretained dataCenter;
    
    
    CGPoint currentPoint;
    CGPoint previousPoint1;
    CGPoint previousPoint2;
    
    
    CGFloat lineWidth;
    UIColor *lineColor;
    UIImage *curImage;
	
	CGMutablePathRef path;
    
    UIImage *offscreenImage;
    BOOL drawing;
    
}

@property (nonatomic, strong) UIColor *lineColor;
@property (readwrite) CGFloat lineWidth;
@property (unsafe_unretained) DSDataCenter *dataCenter;


- (void)clearAll:(id)sender;


@end
