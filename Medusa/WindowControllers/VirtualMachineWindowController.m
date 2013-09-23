//
//  VirtualMachineWindowController.m
//  Medusa
//
//  Created by Giancarlo Mariot on 10/04/2012.
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

#import "VirtualMachineWindowController.h"
#import "TableLineInformationController.h"  //Generic table lines object.
#import "PreferencesModel.h"                //Object to handle coredata information.
#import "RelationshipVirtualMachinesDrivesModel.h" //Model for coredata entity.
#import "VirtualMachinesModel.h"
#import "RomFilesModel.h"
#import "RomModel.h"
#import "DrivesModel.h"

//------------------------------------------------------------------------------
// Lumberjack logger
#import "DDLog.h"
#import "DDASLLogger.h"
#import "DDTTYLogger.h"
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
@implementation VirtualMachineWindowController

//------------------------------------------------------------------------------
// Standard variables synthesizers.
@synthesize menuObjectsArray;
@synthesize virtualMachine;

//------------------------------------------------------------------------------
// Application synthesizers.
//@synthesize subviewsArray;
@synthesize windowTitle;
@synthesize currentPathOption;

//------------------------------------------------------------------------------
// Manual getters

/*!
 * @method      managedObjectContext:
 * @abstract    Manual getter.
 */
- (NSManagedObjectContext *)managedObjectContext {
    return managedObjectContext;
}

/*!
 * @method      virtualMachine:
 * @abstract    Manual getter.
 */
- (VirtualMachinesModel *)virtualMachine {
    return virtualMachine;
}

// Manual setters

/*!
 * @method      setManagedObjectContext:
 * @abstract    Manual setter.
 */
- (void)setManagedObjectContext:(NSManagedObjectContext *)value {
    managedObjectContext = value;
}

/*!
 * @method      setVirtualMachine:
 * @abstract    Manual setter.
 */
- (void)setVirtualMachine:(VirtualMachinesModel *)value {
    virtualMachine = value;
}

//------------------------------------------------------------------------------
// Methods.

#pragma mark – Dealloc

/*!
 * @method      dealloc:
 * @discussion  Always in the top of the files!
 */
- (void)dealloc {
    [managedObjectContext release];
    [virtualMachine release];
    [menuObjectsArray release];
    [subviewsArray release];
    
    [super dealloc];
}

//------------------------------------------------------------------------------

#pragma mark – Methods

//------------------------------------------------------------------------------
// View change methods
#pragma mark – View change methods

/*!
 * @method      changeRightView:
 * @abstract    Changes the right pane according to the selected item in the
 *              left pane menu.
 * @discussion  Oh man...
 */
- (IBAction)changeRightView:(id)sender {
    
}

- (IBAction)displayGeneralView:(id)sender {
    [[[placeholderView subviews] objectAtIndex:0] removeFromSuperview];
    [placeholderView addSubview: subViewConfiguration];
}

- (IBAction)displayDisksView:(id)sender {
    [[[placeholderView subviews] objectAtIndex:0] removeFromSuperview];
    [placeholderView addSubview: subViewDrives];
}

- (IBAction)displayDisplayView:(id)sender {
    [[[placeholderView subviews] objectAtIndex:0] removeFromSuperview];
    [placeholderView addSubview: subViewDisplay];
}

- (IBAction)displayShareView:(id)sender {
    [[[placeholderView subviews] objectAtIndex:0] removeFromSuperview];
    [placeholderView addSubview: subViewSharing];
}

- (IBAction)displayAdvancedView:(id)sender {
    [[[placeholderView subviews] objectAtIndex:0] removeFromSuperview];
    [placeholderView addSubview: subViewAdvanced];
}

//------------------------------------------------------------------------------
// Interface action methods
#pragma mark – Interface action methods

/*!
 * @method      useSelectedDisks:
 * @abstract    Checks the selected disks in the drives list and adds to the vm.
 * @discussion  This is the action of the button with the same name in the
 *              drives subview in the vm interface.
 */
- (IBAction)useSelectedDisks:(id)sender {
    
    /// Must move everything here to a new coredata class!
    
    NSArray * currentSelectedDrives = [availableDisksController selectedObjects];
    //The current selection
    
    NSMutableArray *selectedDrives = [
        [NSMutableArray alloc] initWithCapacity:[currentSelectedDrives count]
    ];
    //The filtered selection
    
    NSMutableSet *newDriveRelationships = [NSMutableSet set];
    //The object to update
    
    NSMutableSet *oldDriveRelationships = [NSMutableSet setWithSet:[virtualMachine drives]];
    //Warning: this is a set of relationship objects, not drives.
    //The old value updated
    
    BOOL allowed = YES;
    //Used in the filter
    
    // Filter:
    if ( [currentSelectedDrives count] > 0 ) {
        for (DrivesModel * currentDrive in currentSelectedDrives) {
            
        //for (id object in firstSelectedDrives) {
            allowed = YES;
            
            for (RelationshipVirtualMachinesDrivesModel * oldDriveRelationship in oldDriveRelationships) {
                
                if ([[currentDrive filePath] isEqual:[[oldDriveRelationship drive] filePath]]) {
                    allowed = NO;
                }

            }
            
            if (allowed) {
                [selectedDrives addObject:currentDrive];
            }
        }
    }
    
    // New updated data:
    
    for (int i = 0; i < [selectedDrives count]; i++) {
        
        // Create new relationship.
        
        RelationshipVirtualMachinesDrivesModel *newDriveRelationship = [
            NSEntityDescription
                insertNewObjectForEntityForName:@"RelationshipVirtualMachinesDrives"
                         inManagedObjectContext:managedObjectContext
        ];

        [newDriveRelationship setDrive:[selectedDrives objectAtIndex:i]];
        [newDriveRelationship setVirtualMachine:virtualMachine];
        
        [newDriveRelationships addObject:newDriveRelationship];
        
    }

    //Finally:
    
    [newDriveRelationships unionSet:oldDriveRelationships];
    [virtualMachine setValue:newDriveRelationships forKey:@"drives"]; //Re-set the value.
    
    [self savePreferences];
    
    [selectedDrives release];

}

/*!
 * @method      makeDriveBootable:
 * @abstract    Set a drive as boot drive.
 * @discussion  Iterates through all drives of the current VM and set all of
 *              them to not-bootable, then it sets the first selected to
 *              bootable.
 */
- (IBAction)makeDriveBootable:(id)sender {
    
    NSArray * selectedDrives = [usedDisksController selectedObjects]; //Selected drives
    NSArray * allDrives      = [usedDisksController arrangedObjects]; //All drives
    
    // Iterate through all drives and set them to NO.
    for (int i = 0; i < [allDrives count]; i++) {
        [[allDrives objectAtIndex:i] setValue:[NSNumber numberWithBool:NO] forKey:@"bootable"];
    }
    
    // Set first selected to YES.
    [[selectedDrives objectAtIndex:0] setValue:[NSNumber numberWithBool:YES] forKey:@"bootable"];
    
    [self savePreferences];
    
}

/*!
 * @method      deleteUsedDrive:
 * @abstract    Deletes a drive.
 * @discussion  Iterates through all selected drives of the current VM
 *              and delete them.
 */
- (IBAction)deleteUsedDrive:(id)sender {
    
    NSArray *selectedDrives = [usedDisksController selectedObjects]; //Selected drives
    
    // Iterate through all drives and set to NO.
    for (int i = 0; i < [selectedDrives count]; i++) {
        [managedObjectContext deleteObject:[selectedDrives objectAtIndex:i]];
    }
    
    [self savePreferences];
    
}

//------------------------------------------------------------------------------
// Sharing

/*!
 * @method      changeSharedFolderPath:
 * @abstract    Changes share folder options.
 * @discussion  Checks the value of the NSMatrix in the currentPathOption
 *              variable, saves new data in the datamodel and changes interface
 *              details accordinly.
 */
- (IBAction)changeShareType:(id)sender {
    
    if ( currentPathOption == useStandardPathOption ) {          
        [openSharePathButton setEnabled:NO];
        [sharePathLabel setStringValue:
            [
                [NSUserDefaults standardUserDefaults] stringForKey:@"StandardSharePath"
            ]
        ];
        
        [virtualMachine setShareEnabled:[NSNumber numberWithBool:YES]];
        [virtualMachine setUseDefaultShare:[NSNumber numberWithBool:YES]];
        
    }else
        if ( currentPathOption == usePersonalPathOption ) {
        [openSharePathButton setEnabled:YES];
        if ([virtualMachine sharedFolder] == nil ) {
            [sharePathLabel setStringValue:@"Path not defined"];
        }else{
            [sharePathLabel setStringValue:
                [virtualMachine sharedFolder]
            ];
        }
        
        [virtualMachine setShareEnabled:[NSNumber numberWithBool:YES]];
        [virtualMachine setUseDefaultShare:[NSNumber numberWithBool:NO]];
        
    }else{
        [openSharePathButton setEnabled:NO];
        [sharePathLabel setStringValue:@"None"];

        [virtualMachine setShareEnabled:[NSNumber numberWithBool:NO]];
        [virtualMachine setUseDefaultShare:[NSNumber numberWithBool:NO]];
        
    }
    
    [self savePreferences];
    
}

/*!
 * @method      run:
 * @abstract    Saves preferences and lauches emulator.
 * @discussion  aa
 */
- (IBAction)run:(id)sender {
    
    PreferencesModel *preferences = [[PreferencesModel alloc] init];
    NSArray *data = [preferences getVirtualMachineData:virtualMachine];
    NSURL * emulatorPath; // = [[NSURL alloc] init];
    NSMutableString * preferencesFilePath; // = [[NSMutableString alloc] init];

    if ([[[virtualMachine romFile] emulator] isEqualTo:@"Basilisk"]) {
        preferencesFilePath = [NSMutableString stringWithFormat:@"%@/%@", NSHomeDirectory(), @".basilisk_ii_prefs"];
        emulatorPath = [[NSUserDefaults standardUserDefaults] URLForKey: @"BasiliskPath"];
    }else{
        preferencesFilePath = [NSMutableString stringWithFormat:@"%@/%@", NSHomeDirectory(), @".sheepshaver_prefs"];
        emulatorPath = [[NSUserDefaults standardUserDefaults] URLForKey:@"SheepshaverPath"];
    }
        
    DDLogVerbose(@"%@", preferencesFilePath);
    DDLogVerbose(@"%@", emulatorPath);
    
    [preferences savePreferencesFile:data ForFile:preferencesFilePath];
    [[NSWorkspace sharedWorkspace] openURL:emulatorPath];
    
//    [preferencesFilePath release];
//    [emulatorPath release];
    [preferences release];

}

/*!
 * @method      savePreferencesFromView:
 * @abstract    Saves all preferences in current object context.
 */
- (IBAction)savePreferencesFromView:(id)sender {
    [self savePreferences];
}

/*!
 * @method      savePreferencesFromView:
 * @abstract    Saves all preferences in current object context.
 */
- (void)savePreferences {
    DDLogVerbose(@"Saving...");
    NSError * error;
    if (![managedObjectContext save:&error]) {
        DDLogError(@"Whoops, couldn't save: %@", [error localizedDescription]);
        DDLogVerbose(@"Check 'vm window controller' class. (savePreferences)");
    }
}

//------------------------------------------------------------------------------
// Open file methods
#pragma mark – Open file methods

/*!
 * @method      openSharePath:
 * @abstract    Displays open panel to select the folder to be shared.
 * @discussion  Maybe I should replace it with a shared folder preference?
 */
- (IBAction)openSharePath:(id)sender {
        
    NSArray * selectedFiles = [[[NSArray alloc] init] autorelease];
    
    NSOpenPanel * openDialog = [NSOpenPanel openPanel]; //File open dialog class.
    
    //Dialog options:
    [openDialog setCanChooseFiles:NO];
    [openDialog setCanChooseDirectories:YES];
    [openDialog setCanCreateDirectories:YES];
    [openDialog setAllowsMultipleSelection:NO];
    
    //Display it and trace OK button:
    if ([openDialog runModal] == NSOKButton) {
        selectedFiles = [openDialog URLs];        
    }
    
    if ([selectedFiles count] == 1) {
        DDLogVerbose(@"%@", selectedFiles);
        
        [virtualMachine setSharedFolder: [[selectedFiles objectAtIndex:0] path]];
        
    }
    
    DDLogVerbose(@"Saving...");
    NSError *error;
    if (![managedObjectContext save:&error]) {
        DDLogError(@"Whoops, couldn't save: %@", [error localizedDescription]);
        DDLogVerbose(@"Check 'vm window controller' class; openSharePath");
    }
    
    [sharePathLabel setStringValue:
        [[selectedFiles objectAtIndex:0] path]
    ];
    
}

/*!
 * @method      openRunPath:
 * @abstract    Displays open panel to select the ROM image to be used.
 */
- (IBAction)openRomPath:(id)sender {
    
    NSArray       * selectedFiles = [[[NSArray alloc] init] autorelease];
    NSOpenPanel   * openDialog = [NSOpenPanel openPanel]; //File open dialog class.
    RomModel      * RomModelObject = [[RomModel alloc] init];
    RomFilesModel * currentRom = [[RomFilesModel alloc] init];
    
    //Dialog options:
    [openDialog setCanChooseFiles:YES];
    [openDialog setCanChooseDirectories:NO];
    [openDialog setCanCreateDirectories:NO];
    [openDialog setAllowsMultipleSelection:NO];
    
    //Display it and trace OK button:
    if ([openDialog runModal] == NSOKButton) {
        selectedFiles = [openDialog URLs];        
    }
    
    if ([selectedFiles count] == 1) {
        DDLogVerbose(@"Selected files: %@", selectedFiles);
        currentRom = [
            RomModelObject
            parseSingleRomFileAndSave:[[selectedFiles objectAtIndex:0] path]
                      inObjectContext:managedObjectContext
        ];
    }
    
    [virtualMachine setRomFile:currentRom];
    
    [currentRom release];    
    
}


//------------------------------------------------------------------------------
// Init methods
#pragma mark – Init methods

/*!
 * @method      initWithVirtualMachine:inManagedObjectContext:
 * @abstract    Init method.
 */
- (id)initWithVirtualMachine:(VirtualMachinesModel *)aVirtualMachine
      inManagedObjectContext:(NSManagedObjectContext *)theManagedObjectContext {
    
    //    BOOL displayAllTabs = [[NSUserDefaults standardUserDefaults] boolForKey:@"displayAllTabs"];
    
    //----------------------------------------------------------
    //VM details
    DDLogVerbose(@"%@", aVirtualMachine);
    
    //----------------------------------------------------------
    //Interface view
    
    self = [super initWithWindowNibName:@"VirtualMachineWindow"];
    
    if (self) {

    }
    
    [self setManagedObjectContext:theManagedObjectContext];
    [self setVirtualMachine:aVirtualMachine];
    [self setWindowTitle:[NSString stringWithFormat:@"%@ Settings", [virtualMachine name]]];
    
    //----------------------------------------------------------
    //Interface subviews
    
    // -- Share tab
    
    //Handle the status of the open path button in the share area:
    
    BOOL enabledShare = [[virtualMachine shareEnabled] boolValue] == YES;
    BOOL shareDefault = [[virtualMachine useDefaultShare] boolValue] == YES;
    
    if ( enabledShare &  shareDefault ) {          
        currentPathOption = useStandardPathOption;
    }else if ( enabledShare & !shareDefault ) {
        currentPathOption = usePersonalPathOption;
    }else if ( !enabledShare & !shareDefault ) {
        currentPathOption = useNoSharedPathOption;
    }
    
    //----------------------------------------------------------
    
    return self;
    
}

/*!
 * @method      initWithWindow:
 * @abstract    Standard init method.
 */
- (id)initWithWindow:(NSWindow *)window {
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

/*!
 * @method      windowDidLoad:
 * @abstract    Sent after the window owned by the receiver has been loaded.
 * @discussion  Refer to official documentation.
 */
- (void)windowDidLoad {
    [super windowDidLoad];
    
    //----------------------------------------------------------
    //Interface view
    
    [placeholderView addSubview:subViewConfiguration];
    
    //----------------------------------------------------------
    //Interface subviews
    
    // -- Share tab
    
    //Handle the status of the open path button in the share area:
    
    BOOL enabledShare = [[virtualMachine shareEnabled]    boolValue] == YES;
    BOOL shareDefault = [[virtualMachine useDefaultShare] boolValue] == YES;
    
    if ( enabledShare &  shareDefault ) {          
        [openSharePathButton setEnabled:NO];
        [sharePathLabel setStringValue:
            [ [NSUserDefaults standardUserDefaults] stringForKey:@"StandardSharePath" ]
        ];
    } else if ( enabledShare & !shareDefault ) {
        [openSharePathButton setEnabled:YES];
        [sharePathLabel setStringValue:
            [virtualMachine sharedFolder]
        ];
    } else if ( !enabledShare & !shareDefault ) {
        [openSharePathButton setEnabled:NO];
        [sharePathLabel setStringValue:@"None"];
    }

    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
    [settingsToolbar setSelectedItemIdentifier:@"generalButton"];
    
    
}

//- (IBAction)changeCurrentRom:(id)sender {
//    DDLogVerbose(@"It wooooooooooorks!");
//}

///*!
// * @method      observeValueForKeyPath:
// *              ofObject:
// *              change:
// *              context:
// * @abstract    Observer method.
// */
//- (void)observeValueForKeyPath:(NSString *)keyPath 
//                      ofObject:(id)object 
//                        change:(NSDictionary *)change 
//                       context:(void *)context {
//    DDLogVerbose(@" OBS: %@ ", keyPath);
////    if ([keyPath isEqualToString:@"lastRomParsed"]) {
////        DDLogVerbose(@"Yay observer works!");
////    }
//    
//    
//}

@end
