//
//  PSWaterFlowLayout.h
//  PSWaterLayout
//
//  Created by mac on 2018/2/26.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PSWaterFlowLayout;
@protocol PSWaterFlowLayoutDelegate <NSObject>

/**
 每个item的高度
 */
- (CGFloat)waterFall:(UICollectionView *)collectionView
     waterFallLayout:(PSWaterFlowLayout *)waterFallLayout
     heightForItemAt:(NSIndexPath *)indexPath;


@end

@interface PSWaterFlowLayout : UICollectionViewLayout

///代理
@property (nonatomic,readwrite,weak) id <PSWaterFlowLayoutDelegate> delegate;
///列数
IB_DESIGNABLE @property (nonatomic,readwrite,assign) CGFloat columnCount;
///行间距
IB_DESIGNABLE @property (nonatomic,readwrite,assign) CGFloat lineSpacing;
///列间距
IB_DESIGNABLE @property (nonatomic,readwrite,assign) CGFloat columnSpacing;
///顶部距离
IB_DESIGNABLE @property (nonatomic,readwrite,assign) CGFloat sectionTop;
///底部的距离
IB_DESIGNABLE @property (nonatomic,readwrite,assign) CGFloat sectionBottom;
///左边的距离
IB_DESIGNABLE @property (nonatomic,readwrite,assign) CGFloat sectionLeft;
///右边的距离
IB_DESIGNABLE @property (nonatomic,readwrite,assign) CGFloat sectionRight;
///section的Insets
@property (nonatomic,readwrite,assign) UIEdgeInsets sectionInsets;
-(instancetype)init;

@end
