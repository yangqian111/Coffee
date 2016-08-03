//
//  NSArray+HSEx.m
//  HotSail
//
//  Created by yangqian on 16/3/28.
//  Copyright © 2016年 NetEase. All rights reserved.
//

#import "NSArray+HSEx.h"

@implementation NSArray (HSEx)

- (NSString *)queryIdString
{
    if ([self count] == 0)
    {
        return @"";
    }
    
    NSString *idsString = [self componentsJoinedByString:@"','"];
    NSString *queryString = [[@"'" stringByAppendingString:idsString] stringByAppendingString:@"'"];
    return queryString;
}

@end
