//
//  FileHandler.m
//  ROMan
//
//  Created by Giancarlo Mariot on 27/02/2012.
//  Copyright (c) 2012 Giancarlo Mariot. All rights reserved.
//

#import "FileHandler.h"

@implementation FileHandler

@synthesize fileDetails, comments;

- (void) readRomFileFrom:(NSString*)filePath {
    
    NSString *romPath = [[NSString alloc] initWithFormat:filePath];
    
    NSData *data = [NSData dataWithContentsOfFile:romPath];
    NSUInteger len = [data length];
    Byte *byteData = (Byte*)malloc(len);
    memcpy(byteData, [data bytes], len);
    
    NSNumber *size = [[NSNumber alloc] initWithUnsignedLong:len/2^20];
    
    NSLog(@"%@", size);
    
    switch( ntohl(*(uint32 *)byteData) ) {
            
            // 64 KB
        case 0x28BA61CE:
        case 0x28BA4E50:
            
            fileDetails = @"Mac 128 or Mac 512";
            comments = @"Not supported by Basilisk II";

        break;
            
            // 128 KB
        case 0x4D1EEEE1:
            fileDetails = @"Mac Plus v1 Lonely Hearts";
            comments = @"Not supported by Basilisk II";
            break;
        case 0x4D1EEAE1:
            fileDetails = @"Mac Plus v2 Lonely Heifers";
            comments = @"Not supported by Basilisk II";
            break;
        case 0x4D1F8172:
            fileDetails = @"Mac Plus v3 Loud Harmonicas";
            comments = @"Not supported by Basilisk II\nTry vMac instead!";
            break;
            
            // 256 KB
        case 0xB2E362A8:
        case 0xB306E171:
            fileDetails = @"Mac SE";
            comments = @"Not supported by Basilisk II";
            break;
        case 0xA49F9914:
            fileDetails = @"Mac Classic";
            comments = @"Classic emulation is currently broken.";
            break;
        case 0x97221136:
            fileDetails = @"Mac IIcx";
            comments = @"Not supported by Basilisk II";
            break;
        case 0x9779D2C4:
        case 0x97851DB6:
            fileDetails = @"Mac II";
            comments = @"Not supported by Basilisk II";
            break;
            
            // 512 KB
        case 0x368CADFE:
            fileDetails = @"Mac IIci";
            comments = @"FPU must be enabled.\nAppleTalk is not supported.";
            break;
        case 0x36B7FB6C:
            fileDetails = @"Mac IIsi";
            comments = @"AppleTalk is not supported.";
            break;
        case 0x4147DD77:
            fileDetails = @"Mac IIfx";
            comments = @"FPU must be enabled.\nAppleTalk is not supported.";
            break;
        case 0x35C28C8F:
            fileDetails = @"Mac IIx";
            comments = @"AppleTalk may not be supported.";
            break;
        case 0x4957EB49:
            fileDetails = @"Mac IIvi";
            comments = @"AppleTalk may not be supported.";
            break;
        case 0x350EACF0:
            fileDetails = @"Mac LC";
            comments = @"AppleTalk is not supported.";
            break;
        case 0x35C28F5F:
            fileDetails = @"Mac LC II";
            comments = @"AppleTalk is not supported.";
            break;
        case 0x3193670E:
            fileDetails = @"Mac Classic II";
            comments = @"May require the FPU.\nAppleTalk may not be supported.";
            break;
            
            // 1024 KB
        case 0x49579803:
            fileDetails = @"Mac IIvx";
            break;
        case 0xECBBC41C:
            fileDetails = @"Mac LC III";
            break;
        case 0xECD99DC0:
            fileDetails = @"Mac Color Classic";
            break;
        case 0xFF7439EE:
            fileDetails = @"Quadra 605 or LC/Performa 475/575";
            break;
        case 0xF1A6F343:
            fileDetails = @"Quadra/Centris 610/650/800";
            break;
        case 0xF1ACAD13:	// Mac Quadra 650
            fileDetails = @"Quadra 650";
            break;
        case 0x420DBFF3:
            fileDetails = @"Quadra 700/900";
            comments = @"AppleTalk is not supported.\nThis is the worst known 1MB ROM.";
            break;
        case 0x3DC27823:
            fileDetails = @"Mac Quadra 950";
            comments = @"AppleTalk is not supported.";
            break;
        case 0xE33B2724:
            fileDetails = @"Powerbook 165c";
            break;
        case 0x06684214:
            fileDetails = @"LC/Quadra/Performa 630";
            break;
        case 0x064DC91D:
            fileDetails = @"Performa 580/588";
            comments = @"AppleTalk is reported to work.";
            break;
        case 0xEDE66CBD:
            fileDetails = @"Maybe Performa 450-550";
            break;
            
        default:
            fileDetails = @"Unknown ROM";
            switch([size intValue]) {
                case 16404:
                    fileDetails = @"Unsupported ROM size";
                    comments = @"Is this an Apple ][ ROM??";
                    break;
                case 972893:
                    fileDetails = @"Power Mac (New World ROM)";
                    break;
                case 1048576:
                    break;
                case 524288:
                    fileDetails = @"AppleTalk is not supported.";
                    break;
                case 262144:
                    break;
                    
                case 2097172:
                    fileDetails = @"Power Mac (Old World ROM)";
                    break;
                default:
                    fileDetails = @"Unsupported ROM size";
                    comments = [NSString stringWithFormat: @"%d", [size intValue]];
                break;
            }
            break;
    }
    
    [size release];
    
    [romPath release];
}

//- (void) readDiskFileFrom:(NSString *)filePath {
//    
//}

@end
