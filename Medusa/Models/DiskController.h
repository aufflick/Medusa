//
//  DriveModel.h
//  Medusa
//
//  Created by Giancarlo Mariot on 22/09/2013.
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

#import <Foundation/Foundation.h>

@class DiskFilesEntityModel, VirtualMachinesEntityModel;

@interface DiskController : NSObject {
    NSString * fileName;
    NSUInteger diskFormat;
    NSUInteger diskSize;
    NSUInteger capacity;
    NSUInteger totalPartitions;
    BOOL bootable;
}

@property (readonly, strong, nonatomic) DiskFilesEntityModel * currentDriveObject;

- (id)parseSingleDriveFileAndSave:(NSString *)filePath inObjectContext:(NSManagedObjectContext *)currentContext;
- (void)parseDriveFileAndSave:(NSString *)filePath;
- (void)parseDriveFilesAndSave:(NSArray *)filesList;
- (BOOL)checkIfDiskImageIsBootable:(NSString *)filePath;
- (BOOL)checkIfDiskImageIsBootable:(NSString *)filePath startingAt:(int)readingStartPoint;
- (void)readDiskFileFrom:(NSString *)filePath;

//+ (void)blockDisksFor:(VirtualMachinesEntityModel *)virtualMachine;
@end
