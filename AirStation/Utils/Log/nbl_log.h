//
//  nbl_log.h
//  两套分级日志定义： 宏定义一套，函数定义一套
//
//  Created by 何宇 on 16/9/13.
//  Copyright © 2016年 newunity. All rights reserved.
//

#define TWLOG(x) NSLog(x)
#define TWLOGv(x, ...) NSLog(x, __VA_ARGS__)

#ifndef nbl_log_h
#define nbl_log_h


/*
 * 调试信息输出 宏定义
 * 调试信息不是程序的固定日志输出，完成调试后应及时关闭
 */

//// 调试宏定义
//#ifdef NBL_DEBUG_OPEN
//#define LOG_DEBUG(x) log_debug(x)//NSLog(x)
//#define LOG_DEBUGv(x, ...) log_debug(x, __VA_ARGS__)//NSLog(x, __VA_ARGS__)
//#endif
//#ifndef NBL_DEBUG_OPEN
//#define LOG_DEBUG(x) ;
//#define LOG_DEBUGv(x, ...) ;
//#endif


/*
 * 分级日志 宏定义
 * 分为四个级别：
 *     信息 -- 程序运行的正常状态信息，供分析程序逻辑
 *     警告 -- 程序可能遇到了异常或非期望的状态
 *     错误 -- 程序运行发生了错误，但不影响程序继续提供服务
 *     致命 -- 程序发生致命错误，可能崩溃，无法继续提供服务
 */

// 日志开关
#define NBL_LOG_DEBUG
#define NBL_LOG_INFO
#define NBL_LOG_WARN
#define NBL_LOG_ERROR
#define NBL_LOG_FATAL

// 日志分级

// DEBUG
#ifdef NBL_LOG_DEBUG
#define LOG_DEBUG(x) TWLOG(x)
#define LOG_DEBUGv(x, ...) TWLOGv(x, __VA_ARGS__)
#endif
#ifndef NBL_LOG_DEBUG
#define LOG_DEBUG(x) ;
#define LOG_DEBUGv(x, ...) ;
#endif
// INFO
#ifdef NBL_LOG_INFO
#define LOG_INFO(x) NSLog(x)
#define LOG_INFOv(x, ...) NSLog(x, __VA_ARGS__)
#endif
#ifndef NBL_LOG_INFO
#define LOG_INFO(x) ;
#define LOG_INFOv(x, ...) ;
#endif
// WARNING
#ifdef NBL_LOG_WARN
#define LOG_WARN(x) NSLog(x)
#define LOG_WARNv(x, ...) NSLog(x, __VA_ARGS__)
#endif
#ifndef NBL_LOG_WARN
#define LOG_WARN(x) ;
#define LOG_WARNv(x, ...) ;
#endif
// ERROR
#ifdef NBL_LOG_ERROR
#define LOG_ERROR(x) NSLog(x)
#define LOG_ERRORv(x, ...) NSLog(x, __VA_ARGS__)
#endif
#ifndef NBL_LOG_ERROR
#define LOG_ERROR(x) ;
#define LOG_ERRORv(x, ...) ;
#endif
// FATAL
#ifdef NBL_LOG_FATAL
#define LOG_FATAL(x) NSLog(x)
#define LOG_FATALv(x, ...) NSLog(x, __VA_ARGS__)
#endif
#ifndef NBL_LOG_FATAL
#define LOG_FATAL(x) ;
#define LOG_FATALv(x, ...) ;
#endif




/*
 * 分级日志 函数定义
 * 分为四个级别：
 *     信息 -- 程序运行的正常状态信息，供分析程序逻辑
 *     警告 -- 程序可能遇到了异常或非期望的状态
 *     错误 -- 程序运行发生了错误，但不影响程序继续提供服务
 *     致命 -- 程序发生致命错误，可能崩溃，无法继续提供服务
 */

// 日志级别
#define LLEVEL_DEBUG    0x01
#define LLEVEL_INFO    0x02
#define LLEVEL_WARN    0x04
#define LLEVEL_ERROR   0x08
#define LLEVEL_FATAL   0x10

// 日志开关，默认
void set_log_level(uint8_t level);
// 二进制数据格式化成字符串
NSString* hex2str(NSData* data);

// INFO DEBUG
FOUNDATION_EXPORT void log_debug(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);
// INFO LOG
FOUNDATION_EXPORT void log_info(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);
// WARN LOG
FOUNDATION_EXPORT void log_warn(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);
// ERROR LOG
FOUNDATION_EXPORT void log_error(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);
// FATAL LOG
FOUNDATION_EXPORT void log_fatal(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);


#endif /* nbl_log_h */
