//
//  DSSensorView.m
//  Whiteboard
//
//  Created by darcystudio on 2/7/13.
//
//

#import "DSSensorView.h"

@implementation DSSensorView
@synthesize sensorCallback;
@synthesize deltaY;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        sensorCallback = nil;
        deltaY = 0;
        isMoved = NO;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"touchesBegan");
    deltaY = 0;
    
    
    UITouch *touch = [touches anyObject];
    previousPoint = [touch locationInView:self];
    currentPoint = [touch locationInView:self];
    
    isMoved = NO;
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"touchesMoved");
    UITouch *touch = [touches anyObject];
    
    currentPoint = [touch locationInView:self];
    
    deltaY = currentPoint.y - previousPoint.y;
    
    if(sensorCallback != nil)
    {
        [sensorCallback performSelector:@selector(onSensorCallbackTouchMove:) withObject:self];
        deltaY = 0;
    }
    
    previousPoint = currentPoint;
    
    isMoved = YES;
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"touchesEnded");
    if(isMoved == NO)
    {
        if(sensorCallback != nil)
        {
            [sensorCallback performSelector:@selector(onSensorCallbackClick:) withObject:self];
        }
    }
    else
    {
        if(sensorCallback != nil)
        {
            [sensorCallback performSelector:@selector(onSensorCallbackTouchUp:) withObject:self];
        }
    }
}




@end
