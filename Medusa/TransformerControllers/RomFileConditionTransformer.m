//
//  RomFileConditionTransformer.m
//  Medusa
//
//  Created by Giancarlo Mariot on 03/09/2013.
//  Copyright (c) 2013 Giancarlo Mariot. All rights reserved.
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

#import "RomFileConditionTransformer.h"
#import "RomFilesEntityModel.h"

@implementation RomFileConditionTransformer

+ (Class)transformedValueClass {
    return [NSString class]; 
}

+ (BOOL)allowsReverseTransformation { 
    return NO; 
}

//PerfectSheepNew        = 1,
//PerfectSheepOld        = 2,
//PerfectBasilisk        = 3,
//NoAppleTalk            = 4,
//FPURequired            = 5,
//NoAppleTalkFPURequired = 6,
//PerfectVMac            = 7,
//Unsupported            = 8

//enum EmulatorTypes {
//    vMacStandard = 1
//    , vMacModelCompilation
//    , BasiliskII
//    , vMacStandardAndBasiliskII
//    , vMacModelCompilationAndBasiliskII
//    , Sheepshaver
//    , EmulatorUnsupported
//};
//
//enum RomConditions {
//    NormalCondition = 1
//    , NoAppleTalk
//    , FPURequired
//    , NoAppleTalkAndFPURequired
//    , PPCOldWorld
//    , PPCNewWorld
//};

- (id)transformedValue:(id)value {
    
    long conditionValue = [value integerValue];
    
    switch (conditionValue) {

        case NormalCondition:
            return @"Basilisk II should work fine";

        case NoAppleTalk:
            return @"Appletalk unavailable";

        case FPURequired:
            return @"Needs to use FPU";

        case NoAppleTalkAndFPURequired:
            return @"Needs to use FPU and Appletalk is unavailable";

        case UnsupportedRom:
            return @"Unsupported ROM";

        default:
            return @"";
    }

}

@end
