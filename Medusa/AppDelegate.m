//
//  AppDelegate.m
//  Medusa
//
//  Created by Giancarlo Mariot on 10/04/2012.
//  Copyright (c) 2012 Giancarlo Mariot. All rights reserved.
//
//------------------------------------------------------------------------------

#import "AppDelegate.h"
#import "VirtualMachineWindowController.h"  //VM Window
#import "RomManagerWindowController.h"      //Rom Manager Window
#import "DriveManagerWindowController.h"    //Drive Manager Window
#import "PreferencesWindowController.h"     //Preferences Window
#import "IconValueTransformer.h"            //Transforms a coredata integer in an icon
//Models:
#import "VirtualMachinesModel.h"
#import "RomFilesModel.h"

//------------------------------------------------------------------------------

@implementation AppDelegate

@synthesize window = _window;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize managedObjectContext = __managedObjectContext;

//------------------------------------------------------------------------------
// Methods.

/*!
 * @method      dealloc:
 * @discussion  Always in the top of the files!
 */
- (void)dealloc {
    [__persistentStoreCoordinator release];
    [__managedObjectModel release];
    [__managedObjectContext release];
    [super dealloc];
}

//------------------------------------------------------------------------------
// Application methods.

/*!
 * @method      openVirtualMachineWindow:
 * @abstract    Opens the iTunes-like window to control the vm's properties.
 */
- (IBAction)openVirtualMachineWindow:(id)sender{
    
    NSArray *selectedVirtualMachines = [[NSArray alloc] initWithArray:[virtualMachinesArrayController selectedObjects]];
    //The user can select only one in the current interface, but anyway...
    
    VirtualMachinesModel *selectedVirtualMachine;
    
    for (int i = 0; i < [selectedVirtualMachines count]; i++) {
        
        selectedVirtualMachine = [selectedVirtualMachines  objectAtIndex:i];
        
        VirtualMachineWindowController *newWindowController = [
            [VirtualMachineWindowController alloc]
                initWithVirtualMachine: selectedVirtualMachine
                inManagedObjectContext: [self managedObjectContext]
        ];
        
        //[newWindowController setShouldCloseDocument:NO];
        //[self addWindowController:newWindowController];
        [newWindowController showWindow:sender];
        
    }
    
    [selectedVirtualMachines release];
    
}

/*!
 * @method      showNewMachineView:
 * @abstract    Displays the new VM sheet.
 */
- (IBAction)showNewMachineView:(id)sender {
    
    [ NSApp
            beginSheet: newMachineView
        modalForWindow: (NSWindow *)_window
         modalDelegate: self
        didEndSelector: nil
           contextInfo: nil
    ];
    
}

/*!
 * @method      endNewMachineView:
 * @abstract    Closes the new VM sheet.
 */
- (IBAction)endNewMachineView:(id)sender {
    
    [newMachineNameField setStringValue:@""];
    [newMachineModelField selectItemAtIndex:0];
    [NSApp endSheet:newMachineView];
    [newMachineView orderOut:sender];
    
}

/*!
 * @method      saveNewVirtualMachine:
 * @abstract    Saves the new virtual machine created by the user to the
 *              coredata.
 * @discussion  This method is sort of messed. There is a need to check
 *              the existence of the vm model before proceeding and this
 *              leads to a whole new world of lines that I suppose are
 *              not needed. Remember to refactor in the near future.
 */
- (IBAction)saveNewVirtualMachine:(id)sender {

    //Gets the Managed Object Context:
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];

    //Sets a new vm object.
    VirtualMachinesModel *newVirtualMachineObject = [
        NSEntityDescription
            insertNewObjectForEntityForName:@"VirtualMachines"
                     inManagedObjectContext:managedObjectContext
    ];
    

    //--------------------------------------------------------------------------
    
    //Here we have all the fields to be inserted.
    [newVirtualMachineObject setName:[newMachineNameField stringValue]];

    NSLog(@"%@", [romFilesController selectedObjects]);
    
    [newVirtualMachineObject setModel:[[romFilesController selectedObjects] objectAtIndex:0]];
       
    //--------------------------------------------------------------------------
    //Focus in the new item.
    
    //Something is not right here... bollocks.
     
     
    //NSLog(@"%@", [[virtualMachinesArrayController arrangedObjects] lastObject]);
//    [
//        virtualMachinesArrayController
//        setSelectionIndex:0
//        //[[virtualMachinesArrayController arrangedObjects] lastIndex]
//     //[[virtualMachinesArrayController arrangedObjects] las]
////     [managedObject
//    ];
    //Open item's window if user specified.
    //openVirtualMachineWindow
    //--------------------------------------------------------------------------
    
    NSLog(@"Saving...");
    NSError *error;
    if (![managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        NSLog(@"Check 'App Delegate' class.");
    }
    
    [self endNewMachineView:sender];

}

/*!
 * @method      showRomManagerWindow:
 * @abstract    Displays the Rom Manager.
 */
- (IBAction)showRomManagerWindow:(id)sender {
    
    if (!romWindowController) {
        romWindowController = [[RomManagerWindowController alloc] initWithWindowNibName:@"RomManagerWindow"];
    }
    [romWindowController showWindow:self];  
    
}

/*!
 * @method      showDriveManagerWindow:
 * @abstract    Displays the Drive Manager.
 */
- (IBAction)showDriveManagerWindow:(id)sender {
    
    if (!driveWindowController) {
        driveWindowController = [[DriveManagerWindowController alloc] initWithWindowNibName:@"DriveManagerWindow"];
    }
    [driveWindowController showWindow:self];  
    
}

/*!
 * @method      showPreferencesWindow:
 * @abstract    Displays the Preferences.
 */
- (IBAction)showPreferencesWindow:(id)sender {
    
    if (!preferencesWindowController) {
        preferencesWindowController = [[PreferencesWindowController alloc] initWithWindowNibName:@"PreferencesWindow"];
    }
    [preferencesWindowController showWindow:self];  
    
}

//------------------------------------------------------------------------------
// Overwrotten methods.
/*!
 * @method      applicationShouldHandleReopen:hasVisibleWindows:
 * @abstract    Defines if the main window should re-open after a click in the
 *              Dock's icon once all windows are closed.
 */
- (BOOL)applicationShouldHandleReopen:(NSApplication *)app hasVisibleWindows:(BOOL)flag {
    if (!flag) {
        [_window makeKeyAndOrderFront:self];
        return NO;
    } else {
        return YES;
    }
}

//------------------------------------------------------------------------------
// Standard methods.

//The comments are not part of Apple's policies, it seems.. *sigh*

/*!
 * @link Check XCode quick help.
 */
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

/*!
 * @method      applicationFilesDirectory:
 * @abstract    Returns the directory the application uses to store the Core Data
 *              store file.
 * @discussion  This code uses a directory named "Medusa" in the user's Library
 *              directory.
 */
- (NSURL *)applicationFilesDirectory {

    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSURL *libraryURL = [
        [fileManager URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject
    ];
    
    return [libraryURL URLByAppendingPathComponent:@"Medusa"];
}

/*!
 * @method      managedObjectModel:
 * @abstract    Creates if necessary and returns the managed object model for
 *              the application.
 */
- (NSManagedObjectModel *)managedObjectModel {
    
    if (__managedObjectModel) return __managedObjectModel;
	
    NSURL *modelURL = [
        [NSBundle mainBundle] URLForResource:@"Medusa" withExtension:@"momd"
    ];
    
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    
    return __managedObjectModel;

}

/**
 * @abstract    Returns the persistent store coordinator for the application.
 *              This implementation creates and return a coordinator, having
 *              added the store for the application to it. (The directory for
 *              the store is created, if necessary.)
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (__persistentStoreCoordinator) {
        return __persistentStoreCoordinator;
    }

    NSManagedObjectModel *mom = [self managedObjectModel];
    
    if (!mom) {
        NSLog(
              @"%@:%@ No model to generate a store from",
              [self class],
              NSStringFromSelector(_cmd)
        );
        return nil;
    }

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationFilesDirectory = [self applicationFilesDirectory];
    NSError *error = nil;
    
    NSDictionary *properties = [
        applicationFilesDirectory
        resourceValuesForKeys:[
            NSArray arrayWithObject:NSURLIsDirectoryKey
        ]
        error:&error
    ];
        
    if (!properties) {
        
        BOOL ok = NO;
        
        if ([error code] == NSFileReadNoSuchFileError) {
            ok = [fileManager createDirectoryAtPath:[applicationFilesDirectory path] withIntermediateDirectories:YES attributes:nil error:&error];
        }
        if (!ok) {
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
        
    } else {
        
        if ([[properties objectForKey:NSURLIsDirectoryKey] boolValue] != YES) {
            // Customize and localize this error.
            NSString *failureDescription = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).", [applicationFilesDirectory path]]; 
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:failureDescription forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:101 userInfo:dict];
            
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
        
    }
    
    NSURL *url = [applicationFilesDirectory URLByAppendingPathComponent:@"Medusa.storedata"];
    
    NSPersistentStoreCoordinator *coordinator = [[[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom] autorelease];
    
    /*
     This part handles the persistent store upgrade:
     */
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithBool:YES],
                             NSMigratePersistentStoresAutomaticallyOption,
                            [NSNumber numberWithBool:YES],
                             NSInferMappingModelAutomaticallyOption, nil];
    
    /*
     The following code was without 'options'. The value was set to 'nil'.
     */
    if (![coordinator
          addPersistentStoreWithType:NSSQLiteStoreType
                       configuration:nil
                                 URL:url
                             options:options
                               error:&error]) {
        
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    __persistentStoreCoordinator = [coordinator retain];

    return __persistentStoreCoordinator;
}

/**
    Returns the managed object context for the application (which is already
    bound to the persistent store coordinator for the application.) 
 */
- (NSManagedObjectContext *)managedObjectContext {
    if (__managedObjectContext) {
        return __managedObjectContext;
    }

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
        [dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
        NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    __managedObjectContext = [[NSManagedObjectContext alloc] init];
    [__managedObjectContext setPersistentStoreCoordinator:coordinator];

    return __managedObjectContext;
}

/**
    Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
 */
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window {
    return [[self managedObjectContext] undoManager];
}

/**
    Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
 */
- (IBAction)saveAction:(id)sender {
    NSError *error = nil;
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
    }

    if (![[self managedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {

    // Save changes in the application's managed object context before the application terminates.

    if (!__managedObjectContext) {
        return NSTerminateNow;
    }

    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
        return NSTerminateCancel;
    }

    if (![[self managedObjectContext] hasChanges]) {
        return NSTerminateNow;
    }

    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {

        // Customize this code block to include application-specific recovery steps.              
        BOOL result = [sender presentError:error];
        if (result) {
            return NSTerminateCancel;
        }

        NSString *question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert *alert = [[[NSAlert alloc] init] autorelease];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];

        NSInteger answer = [alert runModal];
        
        if (answer == NSAlertAlternateReturn) {
            return NSTerminateCancel;
        }
    }

    return NSTerminateNow;
}




+ (void)initialize {
    IconValueTransformer *transformer = [[IconValueTransformer alloc] init];
    [NSValueTransformer setValueTransformer:transformer forName:@"IconValueTransformer"];
    [transformer release];
}

@end
