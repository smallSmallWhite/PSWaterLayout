//
//  ViewController.m
//  PSWaterLayout
//
//  Created by mac on 2018/2/26.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "ViewController.h"
#import "PSWaterFlowLayout.h"

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,PSWaterFlowLayoutDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
}

#pragma mark -- UICollectionViewDataSource
/** 每组cell的个数*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 15;
}

/** cell的内容*/
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    cell.contentView.clipsToBounds      = true;
    cell.contentView.layer.cornerRadius = 5;
    return cell;
}

#pragma mark ==================PSWaterFlowLayoutDelegate==================
-(CGFloat)waterFall:(UICollectionView *)collectionView waterFallLayout:(PSWaterFlowLayout *)waterFallLayout heightForItemAt:(NSIndexPath *)indexPath {
    
    return 200 + arc4random() % 100;
}

#pragma mark ==================懒加载==================
-(UICollectionView *)collectionView {
    if (_collectionView == nil) {
        PSWaterFlowLayout *layout = [[PSWaterFlowLayout alloc] init];
        // 设置collectionView的滚动方向，需要注意的是如果使用了collectionview的headerview或者footerview的话， 如果设置了水平滚动方向的话，那么就只有宽度起作用了了
        layout.columnCount = 3;
        layout.sectionInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        layout.delegate = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
