//
//  nbl_log.m
//  分级日志函数的实现
//
//  Created by 何宇 on 16/9/13.
//  Copyright © 2016年 newunity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "nbl_log.h"

// 日志开关
static uint8_t _level_flag = LLEVEL_DEBUG|LLEVEL_INFO|LLEVEL_WARN|LLEVEL_ERROR|LLEVEL_FATAL;

// 设置日志开关
void set_log_level(uint8_t level)
{
    _level_flag = level&0x0f;
}
// 二进制数据格式化成字符串
NSString* hex2str(NSData* data)
{
    if (nil==data) return @"";
    
    NSUInteger count = data.length;
    if (0==count) return @"";
    
    NSMutableString* tmpstr = [[NSMutableString alloc] initWithCapacity:51*(1+(count>>4))];
    NSUInteger Len = 16;
    uint8_t* phead = (uint8_t*)[data bytes];
    for (NSUInteger i=0 ; i<count ; i++)
    {
        if (i>0 && 0==i%(Len/2) && 0!=i%Len) [tmpstr appendString:@"  "];
        if (i>0 && 0==i%Len) [tmpstr appendString:@"\n"];
        
        [tmpstr appendFormat:@"%02x ", *(phead+i)];
    }
    
    return tmpstr;
}

// INFO DEBUG
void log_debug(NSString *format, ...)
{
    if (0==(_level_flag&LLEVEL_DEBUG)) return;
    
    va_list args;
    va_start(args, format);
    NSLogv(format, args);
    va_end(args);
}

// INFO LOG
void log_info(NSString *format, ...)
{
    if (0==(_level_flag&LLEVEL_INFO)) return;
    
    va_list args;
    va_start(args, format);
    NSLogv(format, args);
    va_end(args);
}

// WARN LOG
void log_warn(NSString *format, ...)
{
    if (0==(_level_flag&LLEVEL_WARN)) return;
    
    va_list args;
    va_start(args, format);
    NSLogv(format, args);
    va_end(args);
}

// ERROR LOG
void log_error(NSString *format, ...)
{
    if (0==(_level_flag&LLEVEL_ERROR)) return;
    
    va_list args;
    va_start(args, format);
    NSLogv(format, args);
    va_end(args);
}

// FATAL LOG
void log_fatal(NSString *format, ...)
{
    if (0==(_level_flag&LLEVEL_FATAL)) return;
    
    va_list args;
    va_start(args, format);
    NSLogv(format, args);
    va_end(args);
}
