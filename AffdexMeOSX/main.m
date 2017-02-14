//
//  main.m
//  AffdexMeOSX
//
//  Created by Boisy Pitre on 11/15/14.
//  Copyright (c) 2014 Affectiva. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AffdexRun.h"

int main(int argc, const char * argv[]) {
     AffdexRun *affdex = [[AffdexRun alloc] init];
    [affdex startDetector];
}
