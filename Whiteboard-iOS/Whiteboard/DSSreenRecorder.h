//
//  DSSreenRecorder.h
//  Whiteboard
//
//  Created by darcystudio on 6/24/13.
//
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import <MediaPlayer/MediaPlayer.h>
#import "DSDataCenter.h"


@interface DSSreenRecorder : NSObject <AVAudioRecorderDelegate>
{
    DSDataCenter *__unsafe_unretained dataCenter;
    
    
    NSTimer *assetWriterTimer;
    AVMutableComposition *mutableComposition;
    AVAssetWriter *assetWriter;
    AVAssetWriterInput *assetWriterInput;
    AVAssetWriterInputPixelBufferAdaptor *assetWriterPixelBufferAdaptor;
    CFAbsoluteTime firstFrameWallClockTime;
    CGFloat frameWidth;
    CGFloat frameHeight;
    CGFloat timeScale;
    NSString *outputFileName;

    
    UIView *mainView;
    
    
    AVAudioRecorder *audioRecorder;
}


@property (unsafe_unretained) DSDataCenter *dataCenter;
@property (nonatomic, strong) UIView *mainView;


- (void)startRecording;
- (void)stopRecording;


@end
