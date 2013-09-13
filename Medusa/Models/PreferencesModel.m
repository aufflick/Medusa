//
//  CoreDataModel.m
//  Medusa
//
//  Created by Giancarlo Mariot on 04/05/2012.
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

#import "PreferencesModel.h"
#import "RelationshipVirtualMachinesDrivesModel.h"
#import "DrivesModel.h"
#import "VirtualMachinesModel.h"
#import "RomFilesModel.h"

@implementation PreferencesModel

//------------------------------------------------------------------------------
// Manual getters

/*!
 * @method      managedObjectContext:
 * @abstract    Manual getter.
 */
- (NSManagedObjectContext *)managedObjectContext {
    return managedObjectContext;
}

// Manual setters

/*!
 * @method      setManagedObjectContext:
 * @abstract    Manual setter.
 */
- (void)setManagedObjectContext:(NSManagedObjectContext *)value {
    managedObjectContext = value;
}

//------------------------------------------------------------------------------

- (void)insertNewVirtualMachineWithData:(NSDictionary*)newData{
    //Do something
}

- (void)insertNewData:(NSDictionary*)newData inVirtualMachine:(NSManagedObject*)virtualMachine{
    //Do something
}

- (void)savePreferencesFile:(NSArray *)dataToSave ForFile:(NSString*)filePath {
    NSLog(@"Save data: %@", dataToSave);
    
    //NSString *filePath = [[NSString alloc] initWithFormat:@"%@%@", NSHomeDirectory(), @".basilisk_ii_prefs"];
    
    NSMutableString * newContent = [[NSMutableString alloc] init];
    
    for (NSDictionary * pedaco in dataToSave) {
        for(id key in pedaco){
            NSLog(@"key=%@ value=%@", key, [pedaco objectForKey:key]);
            [newContent appendString:[NSString stringWithFormat:@"%@ %@", key, [pedaco objectForKey:key]]];
            [newContent appendString:@"\n"];
        }
    }
    NSLog(@"%@", filePath);
    [newContent writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    [newContent release];
    
}

- (NSMutableArray*)getVirtualMachineData:(VirtualMachinesModel *)virtualMachine {
    
    //The idea here is to return an array with dictionaries inside.
    //The returning object is the array that follows.
    
    NSMutableArray * allData = [[NSMutableArray alloc] initWithCapacity:1]; //Return object.

    //First we need the managed object context.
    [self setManagedObjectContext:[virtualMachine managedObjectContext]];
    
    //Now the requests.
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    NSError * error = nil;
    
    //--------------------------------------------------------------------------
    //1. The Macintosh Model
    
    int modelId = [[virtualMachine macModel] intValue];
    
    NSDictionary * macModelSettings = [[NSDictionary alloc]
        initWithObjectsAndKeys:
            [NSString stringWithFormat:@"%ld", modelId], @"modelid",
            nil
    ];
    
    [allData addObject:macModelSettings];
    [macModelSettings release];

    //--------------------------------------------------------------------------
    //2. The processor
    
//    processorType
//    cpu 1/2/3/0

    int processorId = [[virtualMachine processorType] intValue];
    
    NSDictionary * macProcessorType = [[NSDictionary alloc]
        initWithObjectsAndKeys:
            [NSString stringWithFormat:@"%ld", processorId], @"cpu",
            nil
    ];
    
    [allData addObject:macProcessorType];
    [macProcessorType release];

    
//    jitEnabled
//    jit <true/false>

    if ( [[virtualMachine jitEnabled] boolValue] ) {
    
        NSDictionary * macJitEnabled = [[NSDictionary alloc]
            initWithObjectsAndKeys:
                @"true", @"jit",
                nil
        ];
        
        [allData addObject:macJitEnabled];
        [macJitEnabled release];
   
    
//    lazyCacheEnabled
//    jitlazyflush <"true" or "false">

        if ( [[virtualMachine lazyCacheEnabled] boolValue] ) {
            NSDictionary * macLazyCache = [[NSDictionary alloc]
                initWithObjectsAndKeys:
                    @"true", @"jitlazyflush",
                    nil
            ];
            
            [allData addObject:macLazyCache];
            [macLazyCache release];
        }

    
//    fpuEnabled
//    fpu
        if ( [[virtualMachine fpuEnabled] boolValue] ) {
            NSDictionary * macFpu = [[NSDictionary alloc]
                initWithObjectsAndKeys:
                    @"true", @"fpu",
                    nil
            ];
            
            [allData addObject:macFpu];
            [macFpu release];
        }


//    jitCacheSize
//    jitcachesize <size>
    
        int chacheKbSize = [[virtualMachine processorType] intValue];
        
        if (chacheKbSize != 8192 && chacheKbSize > 2048) {
        
            NSDictionary * macJitCache = [[NSDictionary alloc]
                initWithObjectsAndKeys:
                    [NSString stringWithFormat:@"%ld", chacheKbSize], @"jitcachesize",
                    nil
            ];
            
            [allData addObject:macJitCache];
            [macJitCache release];

        }

    }
    
    //--------------------------------------------------------------------------
    //2. The bootable drives
    
    NSEntityDescription *vmDrivesRelationship = [
        NSEntityDescription
                 entityForName:@"RelationshipVirtualMachinesDrives"
        inManagedObjectContext:managedObjectContext
    ];
    
    //Need to set the vm object in relationship table:
    NSPredicate *predicate = [
        NSPredicate
        predicateWithFormat: @"virtualMachine = %@ AND bootable = 1",
        virtualMachine
    ];
    
    
    [request setEntity:    vmDrivesRelationship];
    [request setPredicate: predicate];
    NSArray *bootableDriveResult = [managedObjectContext executeFetchRequest:request error:&error];
    
    //NSLog(@"%@", bootableDriveResult);
    
    for (RelationshipVirtualMachinesDrivesModel * object in bootableDriveResult) {
        DrivesModel * bootableDriveObject = [object drive];
        NSDictionary * bootableDrive = [[NSDictionary alloc]
            initWithObjectsAndKeys:
                [bootableDriveObject filePath], @"disk",
                nil
        ];
        
        [allData addObject:bootableDrive];
        [bootableDrive release];
    }
    
    //--------------------------------------------------------------------------
    //3. The unbootable drives
    
    //vmDrivesRelationship set in step 1.
    
    //Need to set the vm object in relationship table:
    predicate = [
        NSPredicate
        predicateWithFormat: @"virtualMachine = %@ AND bootable = 0",
        virtualMachine
    ];
    
    //[request setEntity:    vmDrivesRelationship];
    [request setPredicate: predicate];
    NSArray *unbootableDriveResult = [managedObjectContext executeFetchRequest:request error:&error];
    
    for (RelationshipVirtualMachinesDrivesModel * object in unbootableDriveResult) {
        DrivesModel * unbootableDriveObject = [object drive];
        NSDictionary * unbootableDrive = [[NSDictionary alloc]
            initWithObjectsAndKeys:
                [unbootableDriveObject filePath], @"disk",
                nil
        ];
        
        [allData addObject:unbootableDrive];
        [unbootableDrive release];
    }

    //--------------------------------------------------------------------------
    //4. Shares

    if ( [[virtualMachine shareEnabled] boolValue] == YES) {
    
        if ( [[virtualMachine useDefaultShare] boolValue] ) {

            //Get path from preferences:
            NSDictionary * shareSettings = [[NSDictionary alloc]
                initWithObjectsAndKeys:
                    [[NSUserDefaults standardUserDefaults]
                      stringForKey:@"StandardSharePath"
                    ], @"extfs",
                    nil
            ];
            
            [allData addObject:shareSettings];
            [shareSettings release];
            
        }else{
            
            if ([virtualMachine sharedFolder] != nil ) {
                //Get file from datamodel:
                NSDictionary * shareSettings = [[NSDictionary alloc]
                    initWithObjectsAndKeys:
                        [virtualMachine sharedFolder], @"extfs",
                        nil
                ];
                
                [allData addObject:shareSettings];
                [shareSettings release];
            }
            
        }
        
    }
    
    //--------------------------------------------------------------------------
    //5. SCSI data
    
    //--------------------------------------------------------------------------
    //6. Display data
    
    NSString * fullScreen = [[NSString alloc] initWithFormat:@"win"];
    NSNumber * screenWidth = [virtualMachine displayWidth];
    NSNumber * screenHeight = [virtualMachine displayHeight];

    if ([[virtualMachine fullScreen] intValue] > 0) { //Yeah... this rubbish is a NSNumber! =P
        
        NSRect screenRect = [[[NSScreen screens] objectAtIndex:0] frame];
        
        fullScreen   = @"dga";        
        screenWidth  = [NSNumber numberWithFloat: screenRect.size.width];
        screenHeight = [NSNumber numberWithFloat: screenRect.size.height];
        
    }
    
    NSDictionary * screenSettings = [[NSDictionary alloc]
        initWithObjectsAndKeys:
            [NSString stringWithFormat:@"%@/%@/%@/%d",
             fullScreen,
             screenWidth,
             screenHeight, 32
            ], @"screen",
            nil
    ];

    [allData addObject:screenSettings];
    [screenSettings release];
    [fullScreen release];
    
    //--------------------------------------------------------------------------
    //7. Serial data
    
    //--------------------------------------------------------------------------
    //8. ROM information
    
    NSDictionary * romSettings = [[NSDictionary alloc]
        initWithObjectsAndKeys:
            [NSString stringWithFormat: [[virtualMachine romFile] filePath]], @"rom",
            nil
    ];
    
    [allData addObject:romSettings];
    [romSettings release];
    
    //--------------------------------------------------------------------------
    //9. Memory information
    //Default is 8 MB
    
    int totalMemory = [[virtualMachine memory] intValue]*1024*1024;
    
    NSDictionary * memorySettings = [[NSDictionary alloc]
        initWithObjectsAndKeys:
            [NSString stringWithFormat:@"%d", totalMemory], @"ramsize",
            nil
    ];
    
    [allData addObject:memorySettings];
    [memorySettings release];
    
    //--------------------------------------------------------------------------
    //10. Advanced information
    
//    NSDictionary * screenSettings = [[NSDictionary alloc]
//        initWithObjectsAndKeys:
//            [NSString stringWithFormat:@"win/%d/%d/%d", 512, 384, 16], @"screen",
//            nil
//    ];
//    
//    [allData addObject:screenSettings];

    [request release];
    //End of requests.
    
    
    
    return [allData autorelease];
    
    
    //NSLog(@"%@", [[virtualMachine objectID] URIRepresentation]);

    
}

- (void)savePreferencesFile:(NSString *)preferencesFilePath ForVirtualMachine:(VirtualMachinesModel *)virtualMachine {    
    NSArray  * currentVmData = [self getVirtualMachineData: virtualMachine];
    [self savePreferencesFile:currentVmData ForFile: preferencesFilePath];
}

@end
