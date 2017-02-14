//
//  XCodeOutput.m
//  AutismAffectiva
//
//  Created by Manav Duttas on 2/12/17.
//  Copyright © 2017 Manav Duttas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"
#import "ClassifierModel.h"
#import "NSImage+Extensions.h"

//#define VIDEO_TEST

static NSString *kSelectedCameraKey = @"selectedCamera";
static NSString *kFacePointsKey = @"drawFacePoints";
static NSString *kFaceBoxKey = @"drawFaceBox";
static NSString *kDrawDominantEmojiKey = @"drawDominantEmoji";
static NSString *kDrawAppearanceIconsKey = @"drawAppearanceIcons";
static NSString *kDrawFrameRateKey = @"drawFrameRate";
static NSString *kDrawFramesToScreenKey = @"drawFramesToScreen";
static NSString *kPointSizeKey = @"pointSize";
static NSString *kProcessRateKey = @"maxProcessRate";
static NSString *kLogoSizeKey = @"logoSize";
static NSString *kLogoOpacityKey = @"logoOpacity";
static NSString *kSmallFaceModeKey = @"smallFaceMode";

