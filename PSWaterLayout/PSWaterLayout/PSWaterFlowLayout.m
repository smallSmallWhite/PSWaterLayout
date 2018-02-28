//
//  PSWaterFlowLayout.m
//  PSWaterLayout
//
//  Created by mac on 2018/2/26.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "PSWaterFlowLayout.h"

@interface PSWaterFlowLayout (){
    ///保存每列的高度
    NSMutableArray *_columnHeights;
    ///保存每个cell的属性
    NSMutableArray *_attributes;
}

@end

@implementation PSWaterFlowLayout

#pragma mark ==================initial Methods==================
-(instancetype)init {
    
    self = [super init];
    if (self) {
        
        self.columnCount = 2;
        self.lineSpacing = 10.0;
        self.columnSpacing = 10.0;
        self.sectionInsets = UIEdgeInsetsZero;
    }
    return self;
}

#pragma mark ==================override==================
-(void)prepareLayout {
    
    [super prepareLayout];
    self.delegate = (id<PSWaterFlowLayoutDelegate>)self.collectionView.delegate;
    
    //初始化数组
    _columnHeights = [NSMutableArray array];
    _attributes = [NSMutableArray array];
    
    //初始化默认高度
    for (int i = 0; i < self.columnCount; i++)
    {
        //每列的高度初始化都是0
        _columnHeights[i] = @(0);
    }
    //item的宽度 =（collectionView的宽 - 左边距 - 右边距 - item间的水平间隙 ）/ 列数
    CGFloat itemWidth = (self.collectionView.frame.size.width - self.sectionInsets.left - self.sectionInsets.right - (self.columnCount - 1)*self.columnSpacing)/self.columnCount;
    
    //计算每个item的位置坐标(只考虑一个组的情况)
    //[self.collectionView numberOfItemsInSection:0]返回指定组的item个数
    for (int i = 0; i < [self.collectionView numberOfItemsInSection:0]; i++)
    {
        //获取item大小（调用collectionView的代理方法）
        CGSize size = CGSizeMake(itemWidth, [self.delegate waterFall:self.collectionView waterFallLayout:self heightForItemAt:[NSIndexPath indexPathForItem:i inSection:0]]);
        
        //item的高度
        CGFloat itemHeight;
        //item的x坐标
        CGFloat xOffset;
        //item的y坐标
        CGFloat yOffset;
        
        //现在图片的高度
        /*
         原始H    X
         ---- =  ----- ===>  X = 原始H*现在W/原始W
         原始W    现在W
         */
        itemHeight = size.height * itemWidth / size.width;
        
        //获取列的高度的最小值索引
        NSInteger minIndex = [self minHeightColumnIndex];
        
        NSLog(@"%ld",minIndex);
        
        //item的x坐标 = 与左边间距 + 最小高度索引值*（item宽 + item间水平间隙）
        xOffset = self.sectionInsets.left + minIndex*(itemWidth+self.columnSpacing);
        
        //item的y坐标 = 最小高度 + （item个数如果小于列数）？与顶部间距 ：item间的垂直间隙
        yOffset = [_columnHeights[minIndex] floatValue] + ((i < self.columnCount) ? self.sectionInsets.top : self.lineSpacing);
        
        //item的frame
        CGRect itemFrame = CGRectMake(xOffset, yOffset, itemWidth, itemHeight);
        
        //属性
        UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        attribute.frame = itemFrame;
        
        //添加到数组中
        [_attributes addObject:attribute];
        
        
        //修改当前列的高度
        _columnHeights[minIndex] = @(CGRectGetMaxY(itemFrame));
    }
}
/**
 
 @brief 返回指定区域的cell的属性对象数组
 
 */
- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return _attributes;
}
/**
 
 @brief 返回指定indexPath的item的属性对象
 
 */
-(nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return _attributes[indexPath.item];
}
/**
 
 @brief collectionView的contentSize
 
 */
-(CGSize)collectionViewContentSize
{
    //取最大值的索引
    NSInteger maxIndex = [self maxHeightColumnIndex];
    
    //返回collectionView的contentSize
    return CGSizeMake(self.collectionView.frame.size.width, [_columnHeights[maxIndex] floatValue] + self.sectionInsets.bottom);
}
#pragma mark ==================helper方法==================
/**
 
 @brief 返回高度最大的列的索引
 
 */
- (NSInteger)maxHeightColumnIndex
{
    __block NSInteger index = 0;
    __block CGFloat maxValue = 0;
    
    [_columnHeights enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         //如果从数组里面取出的元素比现有最大值还大，这个元素就是最大值
         if ([obj floatValue] > maxValue)
         {
             //替换最大值
             maxValue = [obj floatValue];
             
             //保存最大值的索引
             index = idx;
         }
     }];
    
    return index;
}
/**
 
 @brief 返回高度最小的列的索引
 
 */
- (NSInteger)minHeightColumnIndex
{
    __block NSInteger index = 0;
    __block CGFloat minValue = MAXFLOAT;
    
    [_columnHeights enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         //如果从数组里面取出的元素比现有最小值还小，这个元素就是最小值
         if ([obj floatValue] < minValue)
         {
             //替换最小值
             minValue = [obj floatValue];
             
             //保存最小值的索引
             index = idx;
         }
     }];
    return index;
}

@end
