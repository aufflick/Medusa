//
//  RomFilesModel.h
//  Medusa
//
//  Created by Giancarlo Mariot on 18/05/2012.
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

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

enum RomConditions {
    PerfectSheepNew        = 1,
    PerfectSheepOld        = 2,
    PerfectBasilisk        = 3,
    NoAppleTalk            = 4,
    FPURequired            = 5,
    NoAppleTalkFPURequired = 6,
    PerfectVMac            = 7,
    Unsupported            = 8
};

enum RomSizes {
    romNull  = 0,
    rom64KB  = 1,
    rom128KB = 2,
    rom256KB = 3,
    rom512KB = 4,
    rom1MB   = 5,
    rom2MB   = 6,
    rom3MB   = 7,
    rom4MB   = 8
};

@class VirtualMachinesModel;

@interface RomFilesModel : NSManagedObject

@property (nonatomic, retain) NSString * comments;
@property (nonatomic, retain) NSString * emulator;
@property (nonatomic, retain) NSString * filePath;
@property (nonatomic, retain) NSString * modelName;
@property (nonatomic, retain) NSNumber * romCondition;
@property (nonatomic, retain) NSNumber * mac68kOld;
@property (nonatomic, retain) NSNumber * mac68kNew;
@property (nonatomic, retain) NSNumber * macPPCOld;
@property (nonatomic, retain) NSNumber * macPPCNew;
@property (nonatomic, retain) NSNumber * romSize;
@property (nonatomic, retain) NSSet    * machines;

//@property (nonatomic) BOOL mac68k;
//@property (nonatomic) BOOL macPPC;


@end

@interface RomFilesModel (CoreDataGeneratedAccessors)

- (void)addMachinesObject:(VirtualMachinesModel *)value;
- (void)removeMachinesObject:(VirtualMachinesModel *)value;
- (void)addMachines:(NSSet *)values;
- (void)removeMachines:(NSSet *)values;

@end
