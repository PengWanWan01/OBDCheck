//
//  OC.h
//  Project
//
//  Created by Admin on 18/3/8.
//  Copyright © 2018年 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#define LibFileMaxSize (32*1024*1024)
#define CmdDataSetSize (1024)
#define StringMaxSize  (1024)

@interface OBDCHECKLIBOC : NSObject
-(BOOL)LoadPublicLIB2OCBufP:(NSData * )FileData;
- (int ) PrsCmdLoadPublicBufOCInput:(Byte  *)InPutCmdP  withOutPut:(Byte *)OutPutDataP;
- (unsigned int ) ReadFlashStringOCStringID:(unsigned int)StringId WithString:(Byte *)String;
-(void) freeBufOC;
-(void) MainOC;
-(void) SendMessgaeOC;
-(void) GetMessgaeOCWaitTime: (unsigned int) mS;



@end
