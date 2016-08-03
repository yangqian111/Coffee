//
//  CFCollectionViewFlowLayout.m
//  Coffee
//
//  Created by 羊谦 on 16/7/28.
//  Copyright © 2016年 yangqian. All rights reserved.
//

#import "CFCollectionViewFlowLayout.h"

@implementation CFCollectionViewFlowLayout

- (CGSize)collectionViewContentSize {
    CGSize size = [super collectionViewContentSize];
    CGSize size1 = CGSizeMake(_contentSizeWidth, size.height);
    return size1;
}

//-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
//    NSArray *layout =  [super layoutAttributesForElementsInRect:rect];
//    NSMutableArray *arr = [NSMutableArray array];
//    for (UICollectionViewLayoutAttributes *att in layout) {
//        UICollectionViewLayoutAttributes *atta = [[UICollectionViewLayoutAttributes alloc] init];
//        atta = [att copy];
////        [atta setValue:att.representedElementKind forKey:@"representedElementKind"];
//        CGRect fra = CGRectMake(0, 0, 100, 100);
//        atta.frame = fra;
//        [arr addObject:atta];
//    }
//    return [arr copy];
//}
//
//-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
//    UICollectionViewLayoutAttributes *att = [[UICollectionViewLayoutAttributes alloc] init];
//    CGRect fra = CGRectMake(0, 0, 100, 100);
//    att.frame = fra;
//    return att;
//}


@end
