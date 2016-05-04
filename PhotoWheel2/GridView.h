//
//  GridView.h
//  PhotoWheel2
//
//  Created by Tyler Bird on 4/11/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GridViewCell;
@protocol GridViewDataSource;
@class ImageGridViewCell;

@interface GridView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet id<GridViewDataSource> dataSource;
@property (nonatomic, assign) BOOL allowsMultipleSelection;

-(id)dequeueReusableCell;
-(void)reloadData;
-(GridViewCell *)cellAtIndex:(NSInteger)index;
-(NSInteger)indexForSelectedCell;
-(NSArray *)indexesForSelectedCells;

@end

@protocol GridViewDataSource <NSObject>
@required
-(NSInteger)gridViewNumberOfCells:(GridView *)gridView;
-(ImageGridViewCell *)gridView:(GridView *) gridView cellAtIndex:(NSInteger)index;
-(CGSize)gridViewCellSize:(GridView *)gridView;

@optional
-(NSInteger)gridViewCellsPerRow:(GridView *)gridView;
-(void)gridView:(GridView *)gridView didSelectCellAtIndex:(NSInteger)index;
-(void)gridView:(GridView *)gridView didDeselectCellAtIndex:(NSInteger)index;
@end

@interface GridViewCell : UIView
@property (nonatomic, assign, getter = isSelected) BOOL selected;
@end
