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
    
    if (nil == faces)
    {
        [self unprocessedImageReady:detector image:image atTime:time];
    }
    else
    {
        [self processedImageReady:detector image:image faces:faces atTime:time];
    }
}

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
    for (AFDXFace *face in [faces allValues])
    {
        if (isnan(face.emotions.joy) == NO)
        {
            printf("%f", face.emotions.joy);
        }
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
    for (NSString * filename in imageFiles) {
           NSImage *image = [[NSImage alloc]initWithContentsOfFile:filename];
          [self.detector processImage:image];
       }
    }
       
    
    
    
    //if (error == nil) {
    //   NSError *error = [self.detector stop];
    //   printf("Hello, World!");
    //}
    
}


@end