//
//  DSSensorView.h
//  Whiteboard
//
//  Created by darcystudio on 2/7/13.
//
//

#import <UIKit/UIKit.h>

@interface DSSensorView : UIView
{
    id __unsafe_unretained sensorCallback;
    
    CGPoint previousPoint;
    CGPoint currentPoint;
    CGFloat deltaY;
    BOOL isMoved;
}


@property (unsafe_unretained) id sensorCallback;
@property (assign) CGFloat deltaY;


@end
