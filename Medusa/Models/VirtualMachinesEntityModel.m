//
//  VirtualMachinesEntityModel.m
//  Medusa
//
//  Created by Giancarlo Mariot on 12/06/2012.
//  Copyright (c) 2012 Giancarlo Mariot. All rights reserved.
//
//------------------------------------------------------------------------------
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  - Redistributions of source code must retain the above copyright notice,
//    this list of conditions and the following disclaimer.
//  - Redistributions in binary form must reproduce the above copyright notice,
//    this list of conditions and the following disclaimer in the documentation
//    and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.
//
//------------------------------------------------------------------------------

#import "VirtualMachinesEntityModel.h"
#import "RelationshipVirtualMachinesDiskFilesEntityModel.h"
#import "RomFilesEntityModel.h"


@implementation VirtualMachinesEntityModel

@dynamic uniqueName;
@dynamic displayColourDepth;
@dynamic displayDynamicUpdate;
@dynamic displayFrameSkip;
@dynamic displayHeight;
@dynamic displayWidth;
@dynamic fullScreen;
@dynamic memory;
@dynamic name;
@dynamic sharedFolder;
@dynamic macModel;
@dynamic shareEnabled;
@dynamic useDefaultShare;
@dynamic drives;
@dynamic romFile;
@dynamic emulator;
@dynamic processorType;
@dynamic jitEnabled;
@dynamic lazyCacheEnabled;
@dynamic fpuEnabled;
@dynamic jitCacheSize;

- (NSNumber *)icon {
    
    // PerfectSheepNew        = 1,
    // PerfectSheepOld        = 2,
    // PerfectBasilisk        = 3,
    // NoAppleTalk            = 4,
    // FPURequired            = 5,
    // NoAppleTalkFPURequired = 6,
    // Unsupported            = 7
    
    // 0 = New VM
    // 1 = Happy mac B&W
    // 2 = Happy mac colour
    // 3 = No disk B&W
    // 4 = No disk colour
    // 5 = Sad mac
    
    int value = 0;
    
    long iconValue = [[[self romFile] romCondition] integerValue];
    NSInteger totalDisks = [[self drives] count];
    
    if (iconValue < 7 && iconValue > 0)
        if (iconValue > 2)
            if (totalDisks > 0) value = 1;
            else value = 3;
        else
            if (totalDisks > 0) value = 2;
            else value = 4;
    else
        if (totalDisks > 0) value = 5;
    
    return [NSNumber numberWithInt:value];
}

- (BOOL)canRun {
    int icon = [[self icon] intValue];
    if ( icon == 1 || icon == 2) return YES;
    else return NO;
}

- (NSNumber *)nextDiskIndex {
    return [NSNumber numberWithUnsignedInteger:[[self drives] count]];
}

@end
