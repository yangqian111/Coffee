//
//  FMResultSet+HSResultSet.m
//  HotSail
//
//  Created by yangqian on 16/3/28.
//  Copyright © 2016年 NetEase. All rights reserved.
//

#import "FMResultSet+HSResultSet.h"

@implementation FMResultSet (HSResultSet)

- (NSArray *)resultArray
{
    NSMutableArray *array = [NSMutableArray array];
    while ([self next])
    {
        NSDictionary *item = [self resultDictionary];
        if(item)
        {
            [array addObject:item];
        }
    }
    return array;
}

- (NSUInteger)resultCount
{
    NSArray *resultArray = [self resultArray];
    if([resultArray count] == 1)
    {
        NSDictionary* resultDict = [resultArray lastObject];
        if([resultDict isKindOfClass:[NSDictionary class]])
        {
            NSNumber *count = resultDict[@"COUNT(1)"];
            if([count isKindOfClass:[NSNumber class]])
            {
                return [count unsignedIntegerValue];
            }
            count = resultDict[@"COUNT(*)"];
            if([count isKindOfClass:[NSNumber class]])
            {
                return [count unsignedIntegerValue];
            }
        }
    }
    return 0;
}


@end
