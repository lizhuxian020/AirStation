//
//  TWDate.h
//  Telework
//
//  Created by mist on 2018/5/3.
//  Copyright © 2018 tsta. All rights reserved.
//

#import <Foundation/Foundation.h>
// 允许最大的时间误差(秒)
#define kMaximumTimeStampOffset 5

@interface DateTools : NSObject

#pragma mark - 时间管理者单例
+ (instancetype)dateManager;

#pragma mark - 获取计算偏移后的时间
+ (NSDate *)date;

#pragma mark - 获取计算偏移前的时间
+ (NSDate *)dateWithoutFix;

#pragma mark - 获取时间戳
+ (NSTimeInterval)timeInterval;

#pragma mark - 获取时间字符串
+ (NSString *)getTimeStringWithDateFormatString:(NSString *)dateFormatString;
+ (NSString *)getTimeStringWithDateFormatString:(NSString *)dateFormatString date:(NSDate *)date;
+ (NSString *)getTimeStringWithDateFormatString:(NSString *)dateFormatString timeZone:(NSTimeZone *)timeZone;
+ (NSString *)getTimeStringWithDateFormatString:(NSString *)dateFormatString date:(NSDate *)date timeZone:(NSTimeZone *)timeZone;

#pragma mark - 获取时间
+ (NSDate *)getDateWithDateFormatString:(NSString *)dateFormatString timeString:(NSString *)timeString;
+ (NSDate *)getDateWithDateFormatString:(NSString *)dateFormatString timeZone:(NSTimeZone *)timeZone timeString:(NSString *)timeString;

#pragma mark - 转换时间字符串
+ (NSString *)convertTimeStringWithInputDateFormatString:(NSString *)InputdateFormatString inputTimeString:(NSString *)inputTimeString outputdateFormatString:(NSString *)outputdateFormatString;
+ (NSString *)convertTimeStringWithInputDateFormatString:(NSString *)InputdateFormatString inputTimeString:(NSString *)inputTimeString outputdateFormatString:(NSString *)outputdateFormatString timeZone:(NSTimeZone *)timeZone;
+ (NSString *)convertTimeStringWithInputDateFormatString:(NSString *)InputdateFormatString inputTimeZone:(NSTimeZone *)inputTimeZone inputTimeString:(NSString *)inputTimeString outputdateFormatString:(NSString *)outputdateFormatString outputTimeZone:(NSTimeZone *)outputTimeZone;

#pragma mark - 比较时间
+ (NSDateComponents *)compareDateWithPastDate:(NSDate *)pastDate futureDate:(NSDate *)futureDate;
+ (NSDateComponents *)compareDateWithPastDateStr:(NSString *)pastDateStr futureDateStr:(NSString *)futureDateStr;
+ (NSDateComponents *)compareDateWithPastDateStr:(NSString *)pastDateStr futureDateStr:(NSString *)futureDateStr dateFormatString:(NSString *)dateFormatString;
+ (NSDateComponents *)compareDateWithPastDateStr:(NSString *)pastDateStr pastDateFormatString:(NSString *)pastDateFormatString futureDateStr:(NSString *)futureDateStr futureDateFormatString:(NSString *)futureDateFormatString;

#pragma mark - 同步服务器时间
- (void)syncServerDate;

#pragma mark - 同步NTP时间
- (void)syncNTPDate;

#pragma mark - 记录时间到userInfo
- (void)recordDate;

#pragma mark - 判断时间是否有被篡改
- (BOOL)isCorrectDate;

@end
