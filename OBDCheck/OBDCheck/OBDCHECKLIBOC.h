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

/**
 加载bin文件

 @param FileData bin文件内容
 @return 是否加载完毕
 */
-(BOOL)LoadPublicLIB2OCBufP:(NSData * )FileData;


/**
 输入内容进入库解析

 @param InPutCmdP 输入内容
 @param OutPutDataP 输出内容
 @return 1
 */
- (int ) PrsCmdLoadDataOCInput:(NSData  *)InPutCmdP  withOutPut:(NSData *)OutPutDataP;


/**
 国际话语言

 @param StringId erw
 @param String er
 @return rew
 */
- (unsigned int ) ReadFlashStringOCStringID:(unsigned int)StringId WithString:(NSData *)String;


/**
 最后一步  一定要释放
 */
-(void) freeBufOC;


@end
