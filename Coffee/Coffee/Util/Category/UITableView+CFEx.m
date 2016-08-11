//
//  UITableView+CFEx.m
//  Coffee
//
//  Created by 羊谦 on 16/8/10.
//  Copyright © 2016年 yangqian. All rights reserved.
//

#import "UITableView+CFEx.h"

@implementation UITableView (CFEx)

- (void)cf_scrollToBottom:(BOOL)animation
{
    if (self.contentSize.height + self.contentInset.top > self.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, self.contentSize.height - self.frame.size.height);
        [self setContentOffset:offset animated:animation];
    }
}

@end
