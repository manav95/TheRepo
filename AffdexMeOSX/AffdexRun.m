//
//  AffdexRun.m
//  AffdexMe
//
//  Created by Manav Duttas on 2/12/17.
//  Copyright © 2017 tee-boy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"
#import "ClassifierModel.h"
#import "AffdexRun.h"
#import "ViewController.h"
#import "NSImage+Extensions.h"

//#define VIDEO_TEST
@interface AffdexRun ()

@end

@implementation AffdexRun
#pragma mark -
#pragma mark AFDXDetectorDelegate Methods

- (void)detector:(AFDXDetector *)detector hasResults:(NSMutableDictionary *)faces forImage:(NSImage *)image atTime:(NSTimeInterval)time;
{
    
#if 0
    static BOOL frameCount = 0;
    if (frameCount++ % 1 != 0)
    {
        return;
    }
#endif
    
    totalFiles += 1.0;
    if (nil == faces)
    {
        [self unprocessedImageReady:detector image:image atTime:time];
    }
    else
    {
        [self processedImageReady:detector image:image faces:faces atTime:time];
    }
}
NSString* emotion;
float totalFiles;
NSInteger* percentAccuracy;
float accurateFiles;
BOOL isOver;

- (void)detector:(AFDXDetector *)detector didStartDetectingFace:(AFDXFace *)face;
{
    NSMutableArray *viewControllers = [NSMutableArray array];
    
    NSUInteger count = [[[NSUserDefaults standardUserDefaults] objectForKey:kMaxClassifiersShownKey] integerValue];
    for (int i = 0; i < count; i++)
    {
        ExpressionViewController *vc = [[ExpressionViewController alloc] initWithClassifier:nil];
        [viewControllers addObject:vc];
    }
    
    face.userInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:viewControllers, @"viewControllers",
                     [NSNumber numberWithInt:AFDX_EMOJI_NONE], @"dominantEmoji",
                     nil];
    
}

- (void)detector:(AFDXDetector *)detector didStopDetectingFace:(AFDXFace *)face;
{
    NSMutableArray *viewControllers = [face.userInfo objectForKey:@"viewControllers"];
    for (ExpressionViewController *vc in viewControllers)
    {
        vc.metric = 0.0;
        [vc.view removeFromSuperview];
    }
    
    face.userInfo = nil;
}

// Convenience method to work with processed images.
- (void)processedImageReady:(AFDXDetector *)detector image:(NSImage *)image faces:(NSDictionary *)faces atTime:(NSTimeInterval)time;
{
        AFDXFace *face = [faces allValues][0];
        CGFloat* pArray = (CGFloat*)malloc(8 * sizeof(CGFloat));
        pArray[0] = face.emotions.joy;
        pArray[1] = face.emotions.anger;
       pArray[2] = face.emotions.sadness;
       pArray[3] = face.emotions.fear;
    pArray[4] = face.emotions.surprise;
    pArray[5] = face.emotions.contempt;
    pArray[6] = face.emotions.disgust;
    float emotionScore = pArray[0];
    NSArray *emotionArray = @[
                              @"joy",
                              @"anger",
                              @"sadness",
                              @"fear",
                              @"surprise",
                              @"contempt",
                              @"disgust"];
    NSString *emot = @"joy";
    for (int i = 1; i < 7; i++) {
        if (pArray[i] > emotionScore) {
            emotionScore = pArray[i];
            emot = emotionArray[i];
        }
    }
    if (emotionScore <= 20) {
        emot = @"neutral";
    }
    if ([emot isEqualToString: emotion]) {
        accurateFiles += 1.0;
    }
    if (isOver) {
        float value = accurateFiles/totalFiles;
        printf("Value is %f", value);
    }
}



// Convenience method to work with unprocessed images.
- (void)unprocessedImageReady:(AFDXDetector *)detector image:(NSImage *)image atTime:(NSTimeInterval)time;
{
    // This is an unprocessed frame... do something with it...
}


- (void)startDetector;
{
    self.detector = [[AFDXDetector alloc] initWithDelegate:self
                                        discreteImages:true
                                              maximumFaces:1
                                                  faceMode: LARGE_FACES];
    
    
     [self.detector setDetectAllEmotions:YES];
     [self.detector setDetectAllExpressions:YES];
     [self.detector setDetectEmojis:YES];
     self.detector.maxProcessRate = 35;
     isOver = false;
     NSError *error = [self.detector start];
     NSArray *emotionArray = @[
                          @"contempt",
                          @"neutral",
                          @"anger",
                          @"disgust",
                          @"fear",
                          @"happy",
                          @"sadness",
                          @"surprise"];
    for (NSString* currentString in emotionArray) {
      emotion = currentString;
      NSString* currPath = [@"/Users/manavdutta1/Downloads/kf/raw_images/" stringByAppendingString:currentString];
      NSArray* dirs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath: currPath error:NULL];
      NSMutableArray *imageFiles = [[NSMutableArray alloc] init];
      [dirs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
         NSString *filename = (NSString *)obj;
         NSString *extension = [[filename pathExtension] lowercaseString];
         if ([extension isEqualToString:@"png"]) {
             [imageFiles addObject:[currPath stringByAppendingPathComponent:filename]];
         }
      }];
        NSInteger currentIndex = 0;
        NSInteger currLength = [imageFiles count];
        for (NSString * filename in imageFiles) {
             NSImage *image = [[NSImage alloc]initWithContentsOfFile:filename];
            [self.detector processImage:image];
            currentIndex += 1;
            if ([emotion isEqualToString: @"surprise"] && currentIndex == currLength) {
                isOver = true;
            }
        }
    }
       
    
    
    
    //if (error == nil) {
    //   NSError *error = [self.detector stop];
    //   printf("Hello, World!");
    //}
    
}


@end