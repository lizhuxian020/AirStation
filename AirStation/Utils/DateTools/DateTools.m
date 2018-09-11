//
//  TWDate.m
//  Telework
//
//  Created by mist on 2018/5/3.
//  Copyright © 2018 tsta. All rights reserved.
//

#import "DateTools.h"

#import <ios-ntp.h>

static DateTools *manager = nil;
// 时间偏移量
static NSTimeInterval offset = 0;
// 时区
static NSTimeZone *currentTimeZone = nil;

@interface DateTools () <NetAssociationDelegate>

@property (nonatomic, strong) NetAssociation *netAssociation;

@end

@implementation DateTools

#pragma mark - 获取修正过的date对象
+ (NSDate *)date{
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    timeStamp += offset;
    return [NSDate dateWithTimeIntervalSince1970:timeStamp];
}

#pragma mark - 获取计算偏移前的时间
+ (NSDate *)dateWithoutFix{
    return [NSDate date];
}

#pragma mark - 获取修正过时间戳
+ (NSTimeInterval)timeInterval{
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    timeStamp += offset;
    return timeStamp;
}

#pragma mark - 获取时间字符串
+ (NSString *)getTimeStringWithDateFormatString:(NSString *)dateFormatString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [self currentTimeZone];
    dateFormatter.dateFormat = dateFormatString;
    NSString *timeString = [dateFormatter stringFromDate:[DateTools date]];
    return timeString;
}

#pragma mark - 获取时间字符串
+ (NSString *)getTimeStringWithDateFormatString:(NSString *)dateFormatString date:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [self currentTimeZone];
    dateFormatter.dateFormat = dateFormatString;
    NSString *timeString = [dateFormatter stringFromDate:date];
    return timeString;
}

#pragma mark - 获取时间字符串
+ (NSString *)getTimeStringWithDateFormatString:(NSString *)dateFormatString timeZone:(NSTimeZone *)timeZone{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = timeZone;
    dateFormatter.dateFormat = dateFormatString;
    NSString *timeString = [dateFormatter stringFromDate:[DateTools date]];
    return timeString;
}

#pragma mark - 获取时间字符串
+ (NSString *)getTimeStringWithDateFormatString:(NSString *)dateFormatString date:(NSDate *)date timeZone:(NSTimeZone *)timeZone{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = timeZone;
    dateFormatter.dateFormat = dateFormatString;
    NSString *timeString = [dateFormatter stringFromDate:date];
    return timeString;
}

#pragma mark - 获取时间
+ (NSDate *)getDateWithDateFormatString:(NSString *)dateFormatString timeString:(NSString *)timeString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [self currentTimeZone];
    dateFormatter.dateFormat = dateFormatString;
    NSDate *date = [dateFormatter dateFromString:timeString];
    return date;
}

#pragma mark - 获取时间
+ (NSDate *)getDateWithDateFormatString:(NSString *)dateFormatString timeZone:(NSTimeZone *)timeZone timeString:(NSString *)timeString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = timeZone;
    dateFormatter.dateFormat = dateFormatString;
    NSDate *date = [dateFormatter dateFromString:timeString];
    return date;
}

#pragma mark - 转换时间字符串
+ (NSString *)convertTimeStringWithInputDateFormatString:(NSString *)InputdateFormatString inputTimeString:(NSString *)inputTimeString outputdateFormatString:(NSString *)outputdateFormatString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [self currentTimeZone];
    dateFormatter.dateFormat = InputdateFormatString;
    NSDate *date = [dateFormatter dateFromString:inputTimeString];
    dateFormatter.dateFormat = outputdateFormatString;
    NSString *outputTimeString = [dateFormatter stringFromDate:date];
    return outputTimeString;
}

#pragma mark - 转换时间字符串
+ (NSString *)convertTimeStringWithInputDateFormatString:(NSString *)InputdateFormatString inputTimeString:(NSString *)inputTimeString outputdateFormatString:(NSString *)outputdateFormatString timeZone:(NSTimeZone *)timeZone{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = timeZone;
    dateFormatter.dateFormat = InputdateFormatString;
    NSDate *date = [dateFormatter dateFromString:inputTimeString];
    dateFormatter.dateFormat = outputdateFormatString;
    NSString *outputTimeString = [dateFormatter stringFromDate:date];
    return outputTimeString;
}

#pragma mark - 转换时间字符串
+ (NSString *)convertTimeStringWithInputDateFormatString:(NSString *)InputdateFormatString inputTimeZone:(NSTimeZone *)inputTimeZone inputTimeString:(NSString *)inputTimeString outputdateFormatString:(NSString *)outputdateFormatString outputTimeZone:(NSTimeZone *)outputTimeZone{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = inputTimeZone;
    dateFormatter.dateFormat = InputdateFormatString;
    NSDate *date = [dateFormatter dateFromString:inputTimeString];
    dateFormatter.timeZone = outputTimeZone;
    dateFormatter.dateFormat = outputdateFormatString;
    NSString *outputTimeString = [dateFormatter stringFromDate:date];
    return outputTimeString;
}

#pragma mark - 比较时间
+ (NSDateComponents *)compareDateWithPastDate:(NSDate *)pastDate futureDate:(NSDate *)futureDate{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateCom = [calendar components:unit fromDate:pastDate toDate:futureDate options:0];
    return dateCom;
}

#pragma mark - 比较时间
+ (NSDateComponents *)compareDateWithPastDateStr:(NSString *)pastDateStr futureDateStr:(NSString *)futureDateStr{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.timeZone = [self currentTimeZone];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *futureDate = [dateFormatter dateFromString:futureDateStr];
    NSDate *pastDate = [dateFormatter dateFromString:pastDateStr];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateCom = [calendar components:unit fromDate:pastDate toDate:futureDate options:0];
    return dateCom;
}

#pragma mark - 比较时间
+ (NSDateComponents *)compareDateWithPastDateStr:(NSString *)pastDateStr futureDateStr:(NSString *)futureDateStr dateFormatString:(NSString *)dateFormatString{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.timeZone = [self currentTimeZone];
    dateFormatter.dateFormat = dateFormatString;
    NSDate *futureDate = [dateFormatter dateFromString:futureDateStr];
    NSDate *pastDate = [dateFormatter dateFromString:pastDateStr];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateCom = [calendar components:unit fromDate:pastDate toDate:futureDate options:0];
    return dateCom;
}

#pragma mark - 比较时间
+ (NSDateComponents *)compareDateWithPastDateStr:(NSString *)pastDateStr pastDateFormatString:(NSString *)pastDateFormatString futureDateStr:(NSString *)futureDateStr futureDateFormatString:(NSString *)futureDateFormatString{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.timeZone = [self currentTimeZone];
    dateFormatter.dateFormat = futureDateFormatString;
    NSDate *futureDate = [dateFormatter dateFromString:futureDateStr];
    dateFormatter.dateFormat = pastDateFormatString;
    NSDate *pastDate = [dateFormatter dateFromString:pastDateStr];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:pastDate toDate:futureDate options:0];
    return dateCom;
}

#pragma mark - 与后台同步时间
- (void)syncServerDate{
    // 获取准确时间
    [self syncNTPDate];
}

#pragma mark - NTP同步懒加载
- (NetAssociation *)netAssociation{
    if (_netAssociation == nil) {
        _netAssociation = [[NetAssociation alloc] initWithServerName:@"edu.ntp.org.cn"];
        _netAssociation.delegate = self;
    }
    return _netAssociation;
}

#pragma mark - 与NTP同步时间
- (void)syncNTPDate{
    [self.netAssociation sendTimeQuery];
}

#pragma mark - NTP代理
- (void)reportFromDelegate{
    [_netAssociation finish];
    LOG_DEBUGv(@"%lf", self.netAssociation.offset);
    NSTimeInterval timeOffset = self.netAssociation.offset;
    if (self.netAssociation.trusty == NO || isfinite(timeOffset) == NO) {
        return;
    }
    if (fabs(timeOffset) < kMaximumTimeStampOffset) {
        offset = 0;
    }else{
        offset = - timeOffset;
    }
}

#pragma mark - 记录时间到userInfo
- (void)recordDate{
    NSTimeInterval currentTimeStamp = [DateTools timeInterval];
    [NSUserDefaults setValue:[NSString stringWithFormat:@"%lf", currentTimeStamp] forKey:@"lastRecordTime"];
}

#pragma mark - 判断时间是否有被篡改
- (BOOL)isCorrectDate{
    NSTimeInterval lastTimeStamp = [[NSUserDefaults valueForKey:@"lastRecordTime"] doubleValue];
    NSTimeInterval currentTimeStamp = [DateTools timeInterval];
    if (currentTimeStamp > lastTimeStamp) {
        return YES;
    }else{
        return NO;
    }
}

+ (NSTimeZone *)currentTimeZone{
    // 根据经纬度获取时区(未来的计划)
    // http://api.geonames.org/timezoneJSON?lat=22&lng=114&username=tsta
    if (currentTimeZone == nil) {
        currentTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"Asia/Shanghai"];
    }
    return currentTimeZone;
}

#pragma mark - 单例
+ (instancetype)dateManager{
    if (manager == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            manager = [[DateTools alloc] init];
        });
    }
    return manager;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    if (zone == nil) {
        manager = [super allocWithZone:zone];
        return manager;
    }
    return nil;
}

+ (id)copyWithZone:(struct _NSZone *)zone{
    if (zone == nil) {
        manager = [super copyWithZone:zone];
        return manager;
    }
    return nil;
}

+ (id)mutableCopyWithZone:(struct _NSZone *)zone{
    if (zone == nil) {
        manager = [super mutableCopyWithZone:zone];
        return manager;
    }
    return nil;
}

@end
