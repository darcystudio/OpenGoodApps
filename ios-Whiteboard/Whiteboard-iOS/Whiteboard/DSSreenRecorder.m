//
//  DSSreenRecorder.m
//  Whiteboard
//
//  Created by darcystudio on 6/24/13.
//
//

#import "DSSreenRecorder.h"

@implementation DSSreenRecorder

@synthesize dataCenter;
@synthesize mainView;


- (id)init
{
    if (!(self = [super init])) return nil;
    

    frameWidth = 1024;
    frameHeight = 768;
    timeScale = 600;
    outputFileName = @"screen.mp4";
    

    audioRecorder = nil;
    
    return self;
}



- (void)dealloc
{
    [assetWriterTimer invalidate];
    assetWriterTimer = nil;
	
    //[assetWriter release];
    assetWriter = nil;
	
    //[assetWriterInput release];
    assetWriterInput = nil;
	
    //[assetWriterPixelBufferAdaptor release];
    assetWriterPixelBufferAdaptor = nil;
}


#pragma mark screenshot
// copied from http://developer.apple.com/library/ios/#qa/qa1703/_index.html ,
// with new imageScale to take Retina-to-320x480 scaling into account
- (UIImage*)screenshot
{
    // Create a graphics context with the target size
    // On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
    // On iOS prior to 4, fall back to use UIGraphicsBeginImageContext

    //CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    CGSize imageSize = CGSizeMake(frameWidth, frameHeight);

	CGFloat imageScale = imageSize.width / frameWidth;
    if (NULL != UIGraphicsBeginImageContextWithOptions)
    {
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, imageScale);
    }
    else
    {
        UIGraphicsBeginImageContext(imageSize);
    }


    CGContextRef context = UIGraphicsGetCurrentContext();

    
//    // Iterate over every window from back to front
//    for (UIWindow *window in [[UIApplication sharedApplication] windows])
//    {
//        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen])
//        {
//            // -renderInContext: renders in the coordinate space of the layer,
//            // so we must first apply the layer's geometry to the graphics context
//            CGContextSaveGState(context);
//            // Center the context around the window's anchor point
//            CGContextTranslateCTM(context, [window center].x, [window center].y);
//            // Apply the window's transform about the anchor point
//            CGContextConcatCTM(context, [window transform]);
//            // Offset by the portion of the bounds left of and above the anchor point
//            CGContextTranslateCTM(context,
//                                  -[window bounds].size.width * [[window layer] anchorPoint].x,
//                                  -[window bounds].size.height * [[window layer] anchorPoint].y);
//
//            // Render the layer hierarchy to the current context
//            [[window layer] renderInContext:context];
//
//            // Restore the context
//            CGContextRestoreGState(context);
//        }
//    }
    
    //[contentView.layer renderInContext:context];
    
    //!! Darcy
    //[self.view.layer renderInContext:context];
	[mainView.layer renderInContext:context];
    
    
    // Retrieve the screenshot image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	
    UIGraphicsEndImageContext();
	
    
//    NSString *imageFileName = [[self pathToDocumentsDirectory] stringByAppendingPathComponent:@"screen.jpg"];
//    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
//    [imageData writeToFile:imageFileName atomically:YES];
//    NSLog(@"Save screen.jpg.");
    
    return image;
}



#pragma mark helpers
- (NSString*)pathToDocumentsDirectory
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	return documentsDirectory;
}


- (void)writeSample: (NSTimer*) _timer
{

    if(dataCenter != nil)
    {
        if(dataCenter.isScreenChanged == NO)
        {
            return;
        }
    }
    
    
	if (assetWriterInput.readyForMoreMediaData)
    {
		// CMSampleBufferRef sample = nil;

		CVReturn cvErr = kCVReturnSuccess;

		// get screenshot image!
		CGImageRef image = (CGImageRef) [[self screenshot] CGImage];
		NSLog (@"made screenshot");

		// prepare the pixel buffer
		CVPixelBufferRef pixelBuffer = NULL;
		CFDataRef imageData= CGDataProviderCopyData(CGImageGetDataProvider(image));
		NSLog (@"copied image data");
		cvErr = CVPixelBufferCreateWithBytes(kCFAllocatorDefault,
											 frameWidth,
											 frameHeight,
											 kCVPixelFormatType_32BGRA,
											 (void*)CFDataGetBytePtr(imageData),
											 CGImageGetBytesPerRow(image),
											 NULL,
											 NULL,
											 NULL,
											 &pixelBuffer);
		NSLog (@"CVPixelBufferCreateWithBytes returned %d", cvErr);

		// calculate the time
		CFAbsoluteTime thisFrameWallClockTime = CFAbsoluteTimeGetCurrent();
        
        if(_timer == nil)
        {
            thisFrameWallClockTime = firstFrameWallClockTime;
        }
        
        
		CFTimeInterval elapsedTime = thisFrameWallClockTime - firstFrameWallClockTime;
		NSLog (@"elapsedTime: %f", elapsedTime);
		CMTime presentationTime =  CMTimeMake (elapsedTime * timeScale, timeScale);
		
		// write the sample
		BOOL appended = [assetWriterPixelBufferAdaptor appendPixelBuffer:pixelBuffer withPresentationTime:presentationTime];
		
		if (appended)
        {
			NSLog (@"appended sample at time %lf", CMTimeGetSeconds(presentationTime));
		}
        else
        {
			NSLog (@"failed to append");
			[self stopRecording];
			//self.startStopButton.selected = NO;
		}
        
        

        dataCenter.isScreenChanged = NO;
        
	}
}



- (void)startRecording
{
    
    dataCenter.isScreenChanged = YES;
    
    //[self CompileFilesToMakeMovie];
    //return;
    
	//	// create the AVComposition
	//	[mutableComposition release];
	//	mutableComposition = [[AVMutableComposition alloc] init];

	// create the AVAssetWriter
	NSString *moviePath = [[self pathToDocumentsDirectory] stringByAppendingPathComponent:outputFileName];
	if ([[NSFileManager defaultManager] fileExistsAtPath:moviePath])
    {
		[[NSFileManager defaultManager] removeItemAtPath:moviePath error:nil];
	}

	NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
	NSError *movieError = nil;
	//[assetWriter release];
	assetWriter = [[AVAssetWriter alloc] initWithURL:movieURL
                                            fileType: AVFileTypeMPEG4  //AVFileTypeQuickTimeMovie
                                               error: &movieError];
	NSDictionary *assetWriterInputSettings = [NSDictionary dictionaryWithObjectsAndKeys:
											  AVVideoCodecH264, AVVideoCodecKey,
											  [NSNumber numberWithInt:1024], AVVideoWidthKey,
											  [NSNumber numberWithInt:768], AVVideoHeightKey,
											  nil];
	assetWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType: AVMediaTypeVideo
														  outputSettings:assetWriterInputSettings];
	assetWriterInput.expectsMediaDataInRealTime = YES;
	[assetWriter addInput:assetWriterInput];

	//[assetWriterPixelBufferAdaptor release];
	assetWriterPixelBufferAdaptor = [[AVAssetWriterInputPixelBufferAdaptor  alloc]
									 initWithAssetWriterInput:assetWriterInput
									 sourcePixelBufferAttributes:nil];
	[assetWriter startWriting];
	
	firstFrameWallClockTime = CFAbsoluteTimeGetCurrent();
	[assetWriter startSessionAtSourceTime: CMTimeMake(0, timeScale)];
	
	// start writing samples to it
	//[assetWriterTimer release];
	assetWriterTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
														target:self
													  selector:@selector(writeSample:)
													  userInfo:nil
													   repeats:YES];
    
    [self writeSample:nil];
    

    [self startRecordingAudio];
    
    NSLog (@"startRecording");
	
}


- (void)stopRecording
{
	[assetWriterTimer invalidate];
	assetWriterTimer = nil;

	[assetWriter finishWriting];
    
    [self stopRecordingAudio];
	NSLog (@"stopRecording");
    
    
    //[self mergeScreenAndAudio];
    [self CompileFilesToMakeMovie];
    //[self performSelector:@selector(CompileFilesToMakeMovie) withObject:self afterDelay:2.0];
}



- (void)startRecordingAudio
{
    NSString *audioFileName = [[self pathToDocumentsDirectory] stringByAppendingPathComponent:@"sound.caf"];
    NSURL *audioURL = [NSURL fileURLWithPath:audioFileName];
    NSMutableDictionary *audioSettings = [NSMutableDictionary dictionary];
    [audioSettings setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    [audioSettings setValue:[NSNumber numberWithInt:44100] forKey:AVSampleRateKey];
    [audioSettings setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    [audioSettings setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    [audioSettings setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    [audioSettings setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    NSError *error;
    audioRecorder = [[AVAudioRecorder alloc] initWithURL:audioURL settings:audioSettings error:&error];
    audioRecorder.delegate = self;
    audioRecorder.meteringEnabled = YES;
    
    [audioRecorder prepareToRecord];
    [audioRecorder record];
}


- (void)stopRecordingAudio
{
    [audioRecorder stop];
    audioRecorder = nil;
}


- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    //
}





- (void)mergeScreenAndAudio
{
    /*
    NSString *audioFileName = [[self pathToDocumentsDirectory] stringByAppendingPathComponent:@"sound.caf"];
    NSURL *audioURL = [NSURL fileURLWithPath:audioFileName];
    
    NSString *videoFileName = [[self pathToDocumentsDirectory] stringByAppendingPathComponent:@"screen.mp4"];
    NSURL *videoURL = [NSURL fileURLWithPath:videoFileName];
    
    AVURLAsset* audioAsset = [[AVURLAsset alloc]initWithURL:audioURL options:nil];
    AVURLAsset* videoAsset = [[AVURLAsset alloc]initWithURL:videoURL options:nil];
    
    AVMutableComposition* mixComposition = [AVMutableComposition composition];
    
    AVMutableCompositionTrack *compositionCommentaryTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    [compositionCommentaryTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioAsset.duration)
                                        ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                                         atTime:kCMTimeZero error:nil];
    
    AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                                   preferredTrackID:kCMPersistentTrackID_Invalid];
    [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
                                   ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                                    atTime:kCMTimeZero error:nil];
    
    AVAssetExportSession *assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                                          presetName:AVAssetExportPresetPassthrough];
    

    
    NSString *outputFileName1 = [[self pathToDocumentsDirectory] stringByAppendingPathComponent:@"output.mp4"];
    NSURL *outputURL = [NSURL fileURLWithPath:outputFileName1];
    //if ([[NSFileManager defaultManager] fileExistsAtPath:exportPath])
    //{
    //    [[NSFileManager defaultManager] removeItemAtPath:exportPath error:nil];
    //}
    
    assetExport.outputFileType = @"com.apple.quicktime-movie";
    //DLog(@"file type %@",_assetExport.outputFileType);
    assetExport.outputURL = outputURL;
    assetExport.shouldOptimizeForNetworkUse = YES;
    
    [assetExport exportAsynchronouslyWithCompletionHandler:^(void )
        {
         // your completion code here
        }
     ];
    
    NSLog (@"mergeScreenAndAudio");
     */
    
    
    NSString *audioFileName = [[self pathToDocumentsDirectory] stringByAppendingPathComponent:@"sound.caf"];
    NSURL *audioURL = [NSURL fileURLWithPath:audioFileName];
    
    NSString *videoFileName = [[self pathToDocumentsDirectory] stringByAppendingPathComponent:@"screen.mp4"];
    NSURL *videoURL = [NSURL fileURLWithPath:videoFileName];
    
    AVURLAsset* audioAsset = [[AVURLAsset alloc]initWithURL:audioURL options:nil];
    AVURLAsset* videoAsset = [[AVURLAsset alloc]initWithURL:videoURL options:nil];
    
    AVMutableComposition* mixComposition = [AVMutableComposition composition];
    
    NSLog(@"audio =%@",audioAsset);
    AVMutableCompositionTrack *compositionCommentaryTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    [compositionCommentaryTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioAsset.duration) ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    
    AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    
    
    AVAssetExportSession* _assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetPassthrough];
    
    //NSString* videoName = @"export.mov";
    
    //NSString *exportPath = [NSTemporaryDirectory() stringByAppendingPathComponent:videoName];
    //NSURL    *exportUrl = [NSURL fileURLWithPath:exportPath];
    NSString *outputFileName1 = [[self pathToDocumentsDirectory] stringByAppendingPathComponent:@"output.mov"];
    NSURL *exportUrl = [NSURL fileURLWithPath:outputFileName1];
    
    //if ([[NSFileManager defaultManager] fileExistsAtPath:exportPath])
    //{
    //    [[NSFileManager defaultManager] removeItemAtPath:exportPath error:nil];
    //}
    
    _assetExport.outputFileType = @"com.apple.quicktime-movie";
    NSLog(@"file type %@",_assetExport.outputFileType);
    _assetExport.outputURL = exportUrl;
    _assetExport.shouldOptimizeForNetworkUse = YES;
    
    
    
    [_assetExport exportAsynchronouslyWithCompletionHandler:
     ^(void )
     {
         
//         NSString  *fileNamePath = @"sound_record.mov";
//         NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//         NSString  *documentsDirectory = [paths  objectAtIndex:0];
//         NSString  *oldappSettingsPath = [documentsDirectory stringByAppendingPathComponent:fileNamePath];
//         
//         
//         //             if ([[NSFileManager defaultManager] fileExistsAtPath:oldappSettingsPath]) {
//         //
//         //                 NSFileManager *fileManager = [NSFileManager defaultManager];
//         //                 [fileManager removeItemAtPath: oldappSettingsPath error:NULL];
//         //
//         //             }
//         NSURL *documentDirectoryURL = [NSURL fileURLWithPath:oldappSettingsPath];
//         [[NSFileManager defaultManager] copyItemAtURL:exportUrl toURL:documentDirectoryURL error:nil];
//         [audioAsset release];
//         [videoAsset release];
//         [_assetExport release];
     }
     ];
}




/*
-(void) writeImagesToMovieAtPath:(NSString *) path withSize:(CGSize) size
{
    NSString *documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectoryPath error:nil];
    for (NSString *tString in dirContents)
    {
        if ([tString isEqualToString:@"essai.mp4"])
        {
            [[NSFileManager defaultManager]removeItemAtPath:[NSString stringWithFormat:@"%@/%@",documentsDirectoryPath,tString] error:nil];
            
        }
    }
    
    NSLog(@"Write Started");
    
    NSError *error = nil;
    
    AVAssetWriter *videoWriter = [[AVAssetWriter alloc] initWithURL:
                                  [NSURL fileURLWithPath:path] fileType:AVFileTypeMPEG4
                                                              error:&error];
    NSParameterAssert(videoWriter);
    
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                   AVVideoCodecH264, AVVideoCodecKey,
                                   [NSNumber numberWithInt:size.width], AVVideoWidthKey,
                                   [NSNumber numberWithInt:size.height], AVVideoHeightKey,
                                   nil];
    
    
    AVAssetWriterInput* videoWriterInput = [[AVAssetWriterInput
                                             assetWriterInputWithMediaType:AVMediaTypeVideo
                                             outputSettings:videoSettings] retain];
    
    
    
    
    AVAssetWriterInputPixelBufferAdaptor *adaptor = [AVAssetWriterInputPixelBufferAdaptor
                                                     assetWriterInputPixelBufferAdaptorWithAssetWriterInput:videoWriterInput
                                                     sourcePixelBufferAttributes:nil];
    
    NSParameterAssert(videoWriterInput);
    
    NSParameterAssert([videoWriter canAddInput:videoWriterInput]);
    videoWriterInput.expectsMediaDataInRealTime = YES;
    [videoWriter addInput:videoWriterInput];
    //Start a session:
    [videoWriter startWriting];
    [videoWriter startSessionAtSourceTime:kCMTimeZero];
    
    
    //Video encoding
    
    CVPixelBufferRef buffer = NULL;
    
    //convert uiimage to CGImage.
    
    int frameCount = 0;
    
    for(int i = 0; i<[m_PictArray count]; i++)
    {
        buffer = [self pixelBufferFromCGImage:[[m_PictArray objectAtIndex:i] CGImage] andSize:size];
        
        
        BOOL append_ok = NO;
        int j = 0;
        while (!append_ok && j < 30)
        {
            if (adaptor.assetWriterInput.readyForMoreMediaData)
            {
                printf("appending %d attemp %d\n", frameCount, j);
                
                CMTime frameTime = CMTimeMake(frameCount,(int32_t) 10);
                
                append_ok = [adaptor appendPixelBuffer:buffer withPresentationTime:frameTime];
                CVPixelBufferPoolRef bufferPool = adaptor.pixelBufferPool;
                NSParameterAssert(bufferPool != NULL);
                
                [NSThread sleepForTimeInterval:0.05];
            }
            else
            {
                printf("adaptor not ready %d, %d\n", frameCount, j);
                [NSThread sleepForTimeInterval:0.1];
            }
            j++;
        }
        if (!append_ok)
        {
            printf("error appending image %d times %d\n", frameCount, j);
        }
        frameCount++;
        CVBufferRelease(buffer);
    }
    
    [videoWriterInput markAsFinished];
    [videoWriter finishWriting];
    
    [videoWriterInput release];
    [videoWriter release];
    
    [m_PictArray removeAllObjects];
    
    NSLog(@"Write Ended"); 
}
*/




-(void)CompileFilesToMakeMovie
{
    AVMutableComposition* mixComposition = [AVMutableComposition composition];
    
    //NSString* audio_inputFileName = @"deformed.caf";
    //NSString* audio_inputFilePath = [Utilities documentsPath:audio_inputFileName];
    //NSURL*    audio_inputFileUrl = [NSURL fileURLWithPath:audio_inputFilePath];
    
    //NSString* video_inputFileName = @"essai.mp4";
    //NSString* video_inputFilePath = [Utilities documentsPath:video_inputFileName];
    //NSURL*    video_inputFileUrl = [NSURL fileURLWithPath:video_inputFilePath];
    
    //NSString* outputFileName = @"outputFile.mov";
    //NSString* outputFilePath = [Utilities documentsPath:outputFileName];
    //NSURL*    outputFileUrl = [NSURL fileURLWithPath:outputFilePath];
    
    NSString *audioFileName = [[self pathToDocumentsDirectory] stringByAppendingPathComponent:@"sound.caf"];
    NSURL *audioURL = [NSURL fileURLWithPath:audioFileName];
    
    NSString *videoFileName = [[self pathToDocumentsDirectory] stringByAppendingPathComponent:@"screen.mp4"];
    NSURL *videoURL = [NSURL fileURLWithPath:videoFileName];
    
    NSString *outputFileName1 = [[self pathToDocumentsDirectory] stringByAppendingPathComponent:@"output.mp4"];
    NSURL *outputURL = [NSURL fileURLWithPath:outputFileName1];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:outputFileName1])
    {
        [[NSFileManager defaultManager] removeItemAtPath:outputFileName1 error:nil];
    }
    
    
    CMTime nextClipStartTime = kCMTimeZero;
    
    AVURLAsset* videoAsset = [[AVURLAsset alloc]initWithURL:videoURL options:nil];
    CMTimeRange video_timeRange = CMTimeRangeMake(kCMTimeZero,videoAsset.duration);
    AVMutableCompositionTrack *a_compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    [a_compositionVideoTrack insertTimeRange:video_timeRange ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:nextClipStartTime error:nil];
    
    //nextClipStartTime = CMTimeAdd(nextClipStartTime, a_timeRange.duration);
    
    AVURLAsset* audioAsset = [[AVURLAsset alloc]initWithURL:audioURL options:nil];
    CMTimeRange audio_timeRange = CMTimeRangeMake(kCMTimeZero, audioAsset.duration);
    AVMutableCompositionTrack *b_compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    [b_compositionAudioTrack insertTimeRange:audio_timeRange ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:nextClipStartTime error:nil];
    
    
    
    AVAssetExportSession* _assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPreset640x480];
    _assetExport.outputFileType = @"com.apple.quicktime-movie";
    _assetExport.outputURL = outputURL;
    
    
    [_assetExport exportAsynchronouslyWithCompletionHandler:
     ^(void ) {
         //[self saveVideoToAlbum:outputFileName1];
         if(UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(outputFileName1) == YES)
         {
             UISaveVideoAtPathToSavedPhotosAlbum(outputFileName1, nil, nil, nil);
         }
         NSLog(@"CompileFilesToMakeMovie Complete.");
     }
     ];
}


@end
