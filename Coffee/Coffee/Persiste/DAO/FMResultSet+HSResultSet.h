//
//  FMResultSet+HSResultSet.h
//  HotSail
//
//  Created by yangqian on 16/3/28.
//  Copyright © 2016年 NetEase. All rights reserved.
//

#import <FMDB/FMDB.h>

@interface FMResultSet (HSResultSet)
- (NSArray *)resultArray;
- (NSUInteger)resultCount;
@end
