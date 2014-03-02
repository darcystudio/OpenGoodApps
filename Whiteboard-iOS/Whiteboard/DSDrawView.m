//
//  DSDrawView.m
//  Whiteboard
//
//  Created by darcystudio on 1/7/13.
//
//

#import "DSDrawView.h"
#import <QuartzCore/QuartzCore.h>

#define DEFAULT_COLOR [UIColor blackColor]
#define DEFAULT_WIDTH 128.0f

static const CGFloat kPointMinDistance = 5;

static const CGFloat kPointMinDistanceSquared = kPointMinDistance * kPointMinDistance;


@implementation DSDrawView

@synthesize lineColor;
@synthesize lineWidth;
@synthesize dataCenter;




- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.lineWidth = DEFAULT_WIDTH;
        self.lineColor = [UIColor colorWithRed:0 green:52.0/255 blue:114.0/255 alpha:1.0]; //DEFAULT_COLOR;
		path = CGPathCreateMutable();
        
        offscreenImage = nil;
        drawing = NO;
    }
    return self;

}


-(void)dealloc
{
    if(offscreenImage != nil)
    {
        offscreenImage = nil;
    }
    
	CGPathRelease(path);
    
}



CGPoint middlePoint(CGPoint p1, CGPoint p2)
{
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"touchesBegan");
    
    
    if([dataCenter.currentButtonName isEqualToString:@"mouseButton"] == YES)
    {
        return;
    }
    else if([dataCenter.currentButtonName isEqualToString:@"clearAllButton"] == YES)
    {
        CGPathRelease(path);
        path = CGPathCreateMutable();
        
        
        if(offscreenImage != nil)
        {
            offscreenImage = nil;
        }
        
        [self setNeedsDisplay];
        return;
    }
    
    
    UITouch *touch = [touches anyObject];
    
    previousPoint1 = [touch previousLocationInView:self];
    previousPoint2 = [touch previousLocationInView:self];
    
    //previousPoint1.y = previousPoint1.y - 2;
    //previousPoint2.y = previousPoint2.y - 2;
    
    currentPoint = [touch locationInView:self];
    
    drawing = YES;
    [self touchesMoved:touches withEvent:event];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"touchesMoved");
    
    //if([dataCenter.currentButtonName isEqualToString:@"mouseButton"] == YES)
    //{
    //    return;
    //}
    //else if([dataCenter.currentButtonName isEqualToString:@"clearAllButton"] == YES)
    //{
    //    return;
    //}
    
    UITouch *touch = [touches anyObject];
	
	//CGPoint point = [touch locationInView:self];
	
	/* check if the point is farther than min dist from previous */
    //CGFloat dx = point.x - currentPoint.x;
    //CGFloat dy = point.y - currentPoint.y;
	
    //if ((dx * dx + dy * dy) < kPointMinDistanceSquared) {
    //    return;
    //}
    BOOL isPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? true : false;
    
    
    if([dataCenter.currentButtonName isEqualToString:@"pen1"] == YES)
    {
        self.lineWidth = (isPad) ? 4.0 : 4.0;
        //self.lineColor = [UIColor blueColor];
        //self.lineColor = [UIColor colorWithRed:0.0 green:0.0 blue:200.0/255 alpha:1.0];
        //self.lineColor = [UIColor colorWithRed:80.0/255 green:97.0/255 blue:109.0/255 alpha:1.0];
        //self.lineColor = [UIColor colorWithRed:32.0/255 green:32.0/255 blue:32.0/255 alpha:1.0];
        self.lineColor = [UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
    }
    else if([dataCenter.currentButtonName isEqualToString:@"pen2"] == YES)
    {
        self.lineWidth = (isPad) ? 4.0 : 4.0;
        //self.lineColor = [UIColor blueColor];
        //self.lineColor = [UIColor colorWithRed:0.0 green:0.0 blue:200.0/255 alpha:1.0];
        self.lineColor = [UIColor colorWithRed:75.0/255 green:92.0/255 blue:196.0/255 alpha:1.0];
    }
    else if([dataCenter.currentButtonName isEqualToString:@"pen3"] == YES)
    {
        self.lineWidth = (isPad) ? 4.0 : 4.0;
        //self.lineColor = [UIColor blueColor];
        //self.lineColor = [UIColor colorWithRed:0.0 green:0.0 blue:200.0/255 alpha:1.0];
        //self.lineColor = [UIColor colorWithRed:22.0/255 green:169.0/255 blue:81.0/255 alpha:1.0];
        self.lineColor = [UIColor colorWithRed:0.0/255 green:229.0/255 blue:0.0/255 alpha:1.0];
    }
    else if([dataCenter.currentButtonName isEqualToString:@"pen4"] == YES)
    {
        self.lineWidth = (isPad) ? 4.0 : 4.0;
        //self.lineColor = [UIColor blueColor];
        //self.lineColor = [UIColor colorWithRed:0.0 green:0.0 blue:200.0/255 alpha:1.0];
        self.lineColor = [UIColor colorWithRed:255.0/255 green:76.0/255 blue:0.0/255 alpha:1.0];
        //self.lineColor = [UIColor colorWithRed:255.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
    }
    else if([dataCenter.currentButtonName isEqualToString:@"lighter1"] == YES)
    {
        self.lineWidth = (isPad) ? 32.0 : 32.0;
        //self.lineColor = [UIColor yellowColor];
        self.lineColor = [UIColor colorWithRed:80.0/255 green:97.0/255 blue:109.0/255 alpha:1.0];
        //self.lineColor = [UIColor colorWithRed:32.0/255 green:32.0/255 blue:32.0/255 alpha:1.0];
        //self.lineColor = [UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
    }
    else if([dataCenter.currentButtonName isEqualToString:@"lighter2"] == YES)
    {
        self.lineWidth = (isPad) ? 32.0 : 32.0;
        //self.lineColor = [UIColor yellowColor];
        self.lineColor = [UIColor colorWithRed:75.0/255 green:92.0/255 blue:196.0/255 alpha:1.0];
        //self.lineColor = [UIColor colorWithRed:0.0/255 green:0.0/255 blue:255.0/255 alpha:1.0];
    }
    else if([dataCenter.currentButtonName isEqualToString:@"lighter3"] == YES)
    {
        self.lineWidth = (isPad) ? 32.0 : 32.0;
        //self.lineColor = [UIColor yellowColor];
        //self.lineColor = [UIColor colorWithRed:22.0/255 green:169.0/255 blue:81.0/255 alpha:1.0];
        self.lineColor = [UIColor colorWithRed:0.0/255 green:229.0/255 blue:0.0/255 alpha:1.0];
    }
    else if([dataCenter.currentButtonName isEqualToString:@"lighter4"] == YES)
    {
        self.lineWidth = (isPad) ? 32.0 : 32.0;
        //self.lineColor = [UIColor yellowColor];
        self.lineColor = [UIColor colorWithRed:255.0/255 green:76.0/255 blue:0.0/255 alpha:1.0];
        //self.lineColor = [UIColor colorWithRed:255.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
    }
    else if([dataCenter.currentButtonName isEqualToString:@"eraser"] == YES)
    {
        self.lineWidth = (isPad) ? 128.0 : 64.0;
        self.lineColor = [UIColor lightGrayColor];
    }
    else
    {
        return;
    }
    
    
    previousPoint2 = previousPoint1;
    previousPoint1 = [touch previousLocationInView:self];
    currentPoint = [touch locationInView:self];
    
    CGPoint mid1 = middlePoint(previousPoint1, previousPoint2);
    CGPoint mid2 = middlePoint(currentPoint, previousPoint1);
	CGMutablePathRef subpath = CGPathCreateMutable();
    CGPathMoveToPoint(subpath, NULL, mid1.x, mid1.y);
    if([dataCenter.currentButtonName isEqualToString:@"eraserButton"] == YES)
    {
        CGPathAddLineToPoint(subpath, NULL, mid2.x, mid2.y);
    }
    else
    {
        CGPathAddQuadCurveToPoint(subpath, NULL, previousPoint1.x, previousPoint1.y, mid2.x, mid2.y);
    }
    CGRect bounds = CGPathGetBoundingBox(subpath);
	
	CGPathAddPath(path, NULL, subpath);
	CGPathRelease(subpath);
    
    CGRect drawBox = bounds;
    drawBox.origin.x -= self.lineWidth*1.0;
    drawBox.origin.y -= self.lineWidth*1.0;
    drawBox.size.width += self.lineWidth*2.0;
    drawBox.size.height += self.lineWidth*2.0;
    
    [self setNeedsDisplayInRect:drawBox];
    
    
    dataCenter.isScreenChanged = YES;
    
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"touchesEnded");
    
    //if([dataCenter.currentButtonName isEqualToString:@"mouseButton"] == YES)
    //{
    //    return;
    //}
    //else if([dataCenter.currentButtonName isEqualToString:@"clearAllButton"] == YES)
    //{
    //    return;
    //}
    
    drawing = NO;
    
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    
    UIGraphicsBeginImageContext(CGSizeMake(w, h));
    
    if(offscreenImage != nil)
    {
        [offscreenImage drawAtPoint:CGPointZero];
        offscreenImage = nil;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextAddPath(context, path);
    
    
    if([dataCenter.currentButtonName isEqualToString:@"pen1"] == YES)
    {
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineWidth(context, self.lineWidth);
        CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
        CGContextStrokePath(context);
    }
    else if([dataCenter.currentButtonName isEqualToString:@"pen2"] == YES)
    {
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineWidth(context, self.lineWidth);
        CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
        CGContextStrokePath(context);
    }
    else if([dataCenter.currentButtonName isEqualToString:@"pen3"] == YES)
    {
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineWidth(context, self.lineWidth);
        CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
        CGContextStrokePath(context);
    }
    else if([dataCenter.currentButtonName isEqualToString:@"pen4"] == YES)
    {
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineWidth(context, self.lineWidth);
        CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
        CGContextStrokePath(context);
    }
    else if([dataCenter.currentButtonName isEqualToString:@"lighter1"] == YES)
    {
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineWidth(context, self.lineWidth);
        CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
        //CGContextSetBlendMode(context, kCGBlendModePlusDarker);
        CGContextSetAlpha(context, 0.3);
        CGContextStrokePath(context);
    }
    else if([dataCenter.currentButtonName isEqualToString:@"lighter2"] == YES)
    {
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineWidth(context, self.lineWidth);
        CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
        //CGContextSetBlendMode(context, kCGBlendModePlusDarker);
        CGContextSetAlpha(context, 0.3);
        CGContextStrokePath(context);
    }
    else if([dataCenter.currentButtonName isEqualToString:@"lighter3"] == YES)
    {
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineWidth(context, self.lineWidth);
        CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
        //CGContextSetBlendMode(context, kCGBlendModePlusDarker);
        CGContextSetAlpha(context, 0.3);
        CGContextStrokePath(context);
    }
    else if([dataCenter.currentButtonName isEqualToString:@"lighter4"] == YES)
    {
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineWidth(context, self.lineWidth);
        CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
        //CGContextSetBlendMode(context, kCGBlendModePlusDarker);
        CGContextSetAlpha(context, 0.3);
        CGContextStrokePath(context);
    }
    else if([dataCenter.currentButtonName isEqualToString:@"eraser"] == YES)
    {
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineWidth(context, self.lineWidth);
        CGContextSetBlendMode(context, kCGBlendModeClear);
        CGContextStrokePath(context);
        
        
        CGRect drawBox = CGRectMake(previousPoint1.x, previousPoint1.y, 0, 0);
        drawBox.origin.x -= self.lineWidth*1.0;
        drawBox.origin.y -= self.lineWidth*1.0;
        drawBox.size.width += self.lineWidth*2.0;
        drawBox.size.height += self.lineWidth*2.0;
        
        [self setNeedsDisplayInRect:drawBox];
        //[self setNeedsDisplay];
    }
    else
    {
        
    }
    
    
    
    
    offscreenImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    
    CGPathRelease(path);
    path = CGPathCreateMutable();
    
    
    dataCenter.isScreenChanged = YES;
}


- (void)drawRect:(CGRect)rect
{
    //NSLog(@"drawRect");
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if(offscreenImage != nil)
    {
        [offscreenImage drawAtPoint:CGPointZero];
    }
    
	CGContextAddPath(context, path);
    
    
    if([dataCenter.currentButtonName isEqualToString:@"pen1"] == YES)
    {
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineWidth(context, self.lineWidth);
        CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
        CGContextStrokePath(context);
    }
    else if([dataCenter.currentButtonName isEqualToString:@"pen2"] == YES)
    {
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineWidth(context, self.lineWidth);
        CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
        CGContextStrokePath(context);
    }
    else if([dataCenter.currentButtonName isEqualToString:@"pen3"] == YES)
    {
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineWidth(context, self.lineWidth);
        CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
        CGContextStrokePath(context);
    }
    else if([dataCenter.currentButtonName isEqualToString:@"pen4"] == YES)
    {
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineWidth(context, self.lineWidth);
        CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
        CGContextStrokePath(context);
    }
    else if([dataCenter.currentButtonName isEqualToString:@"lighter1"] == YES)
    {
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineWidth(context, self.lineWidth);
        CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
        //CGContextSetBlendMode(context, kCGBlendModePlusDarker);
        CGContextSetAlpha(context, 0.3);
        CGContextStrokePath(context);
    }
    else if([dataCenter.currentButtonName isEqualToString:@"lighter2"] == YES)
    {
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineWidth(context, self.lineWidth);
        CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
        //CGContextSetBlendMode(context, kCGBlendModePlusDarker);
        CGContextSetAlpha(context, 0.3);
        CGContextStrokePath(context);
    }
    else if([dataCenter.currentButtonName isEqualToString:@"lighter3"] == YES)
    {
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineWidth(context, self.lineWidth);
        CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
        //CGContextSetBlendMode(context, kCGBlendModePlusDarker);
        CGContextSetAlpha(context, 0.3);
        CGContextStrokePath(context);
    }
    else if([dataCenter.currentButtonName isEqualToString:@"lighter4"] == YES)
    {
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineWidth(context, self.lineWidth);
        CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
        //CGContextSetBlendMode(context, kCGBlendModePlusDarker);
        CGContextSetAlpha(context, 0.3);
        CGContextStrokePath(context);
    }
    else if([dataCenter.currentButtonName isEqualToString:@"eraser"] == YES)
    {
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineWidth(context, self.lineWidth);
        CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
        CGContextSetBlendMode(context, kCGBlendModeClear);
        CGContextStrokePath(context);
        
        if(drawing == YES)
        {
            CGContextSetBlendMode(context, kCGBlendModeNormal);
            CGContextSetAlpha(context, 0.3);
            CGContextMoveToPoint(context, previousPoint1.x, previousPoint1.y);
            CGContextAddLineToPoint(context, previousPoint1.x, previousPoint1.y);
            CGContextStrokePath(context);
        }
    }
    else
    {

    }


}


- (void)clearAll:(id)sender
{
    CGPathRelease(path);
    path = CGPathCreateMutable();
    
    
    if(offscreenImage != nil)
    {
        offscreenImage = nil;
    }
    
    [self setNeedsDisplay];
    return;
}


@end
