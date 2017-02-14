#import <AVFoundation/AVFoundation.h>
#import "PreferencesWindowController.h"
#import "ExpressionViewController.h"
#import <Affdex/Affdex.h>

@interface AffdexRun : NSViewController <AFDXDetectorDelegate>

- (void)startDetector;
@property (strong) AFDXDetector *detector;

@end