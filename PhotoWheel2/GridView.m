//
//  GridView.m
//  PhotoWheel2
//
//  Created by Tyler Bird on 4/11/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

#import "GridView.h"
#import "ImageGridViewCell.h"

@interface GridViewCell ()
@property (nonatomic, assign) NSInteger indexInGrid;
@end

@implementation GridViewCell
@end

@interface GridView ()

@property (nonatomic, strong) NSMutableSet * reusableViews;
@property (nonatomic, assign) NSInteger firstVisibleIndex;
@property (nonatomic, assign) NSInteger lastVisibleIndex;
@property (nonatomic, assign) NSInteger previousItemsPerRow;
@property (nonatomic, strong) NSMutableSet * selectedCellIndexes;

@end

@implementation GridView

-(void)commonInit
{
    self.reusableViews = [[NSMutableSet alloc] init];
    
    [self setFirstVisibleIndex:NSIntegerMax];
    [self setLastVisibleIndex:NSIntegerMin];
    [self setPreviousItemsPerRow:NSIntegerMin];
    
    [self setDelaysContentTouches:YES];
    [self setClipsToBounds:YES];
    [self setAlwaysBounceVertical:YES];
    
    [self setAllowsMultipleSelection:NO];
    
    self.selectedCellIndexes = [[NSMutableSet alloc] init];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    
    [self addGestureRecognizer:tap];
}

-(id)init
{
    self = [super init];
    
    if ( self )
    {
        [self commonInit];
    }
    
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if ( self )
    {
        [self commonInit];
    }
    
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if ( self )
    {
        [self commonInit];
    }
    
    return self;
}

-(id)dequeueReusableCell
{
    id view = [[self reusableViews] anyObject];
    
    if ( view != nil )
    {
        [[self reusableViews] removeObject:view];
    }
    
    return view;
}

-(void)queueReusableCells
{
    for(UIView * view in [self subviews] )
    {
        if ( [view isKindOfClass:[ImageGridViewCell class]] )
        {
            [[self reusableViews] addObject:view];
            [view removeFromSuperview];
        }
    }
    
    [self setFirstVisibleIndex:NSIntegerMax];
    [self setLastVisibleIndex:NSIntegerMin];
    [[self selectedCellIndexes] removeAllObjects];
}

-(void)reloadData
{
    [self queueReusableCells];
    [self setNeedsLayout];
}

-(ImageGridViewCell *)cellAtIndex:(NSInteger)index
{
    ImageGridViewCell * cell = nil;
    
    if ( index >= [self firstVisibleIndex] && index <= [self lastVisibleIndex] )
    {
        for( id view in [self subviews] )
        {
            if ( [view isKindOfClass:[ImageGridViewCell class]] )
            {
                if ( [view indexInGrid] == index )
                {
                    cell = view;
                    break;
                }
            }
        }
    }
    
    if ( cell == nil )
    {
        cell = [[self dataSource] gridView:self cellAtIndex:index];
    }
    
    return cell;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect visibleBounds = [self bounds];
    
    NSInteger visibleWidth = visibleBounds.size.width;
    NSInteger visibleHeight = visibleBounds.size.height;
 
    CGSize viewSize = [[self dataSource] gridViewCellSize:self];
    
    
    NSInteger itemsPerRow = NSIntegerMin;
    
    if ( [[self dataSource] respondsToSelector:@selector(gridViewCellsPerRow:)] )
    {
        itemsPerRow = [[self dataSource] gridViewCellsPerRow:self];
    }
    
    if ( itemsPerRow == NSIntegerMin )
    {
        itemsPerRow = floor(visibleWidth / viewSize.height );
    }
    
    if ( itemsPerRow != [self previousItemsPerRow] )
    {
        [self queueReusableCells];
    }
    
    [self setPreviousItemsPerRow:itemsPerRow];
    
    NSInteger minimumSpace = 5;
    
    if ( visibleWidth - itemsPerRow * viewSize.width < minimumSpace )
    {
        itemsPerRow--;
    }
    
    if ( itemsPerRow < 1 ) itemsPerRow = 1;
    
    NSInteger spaceWidth = round((visibleWidth - viewSize.width * itemsPerRow) / ( itemsPerRow + 1 ) );
    
    NSInteger spaceHeight = spaceWidth;
    
    NSInteger viewCount = [[self dataSource] gridViewNumberOfCells:self];
    
    NSInteger rowCount = ceil(viewCount / (float)itemsPerRow);
    
    NSInteger rowHeight = viewSize.height + spaceHeight;
    
    CGSize contentSize = CGSizeMake(visibleWidth, (rowHeight * rowCount + spaceHeight));
    
    [self setContentSize:contentSize];
    
    NSInteger numberOfVisibleRows = visibleHeight / rowHeight;
    
    NSInteger topRow = MAX(0, floorf(visibleBounds.origin.y / rowHeight));
    
    NSInteger bottomRow = topRow + numberOfVisibleRows;
    
    CGRect extendedVisibleBounds = CGRectMake(visibleBounds.origin.x, MAX(0, visibleBounds.origin.y), visibleBounds.size.width, visibleBounds.size.height + rowHeight);
    
    for(UIView * view in [self subviews] )
    {
        if ( [view isKindOfClass:[ImageGridViewCell class]] )
        {
            CGRect viewFrame = [view frame];
            
            if ( ! CGRectIntersectsRect(viewFrame, extendedVisibleBounds) )
            {
                [[self reusableViews] addObject:view];
                [view removeFromSuperview];
            }
        }
    }
    
    // lay out subviews
    
    NSInteger startAtIndex = MAX(0, topRow * itemsPerRow);
    NSInteger stopAtIndex = MIN(viewCount, (bottomRow * itemsPerRow) + itemsPerRow);
    
    NSInteger x = spaceWidth;
    NSInteger y = spaceHeight + ( topRow * rowHeight );
    
    for(NSInteger index = startAtIndex; index < stopAtIndex; index++)
    {
        ImageGridViewCell * view = (ImageGridViewCell *)[self cellAtIndex:index];
        
        CGRect newFrame = CGRectMake(x, y, viewSize.width, viewSize.height);
        
        [view setFrame:newFrame];
        
        BOOL isViewMissing = !(index >= [self firstVisibleIndex] && index < [self lastVisibleIndex]);
        
        if ( isViewMissing )
        {
            BOOL selected = [[self selectedCellIndexes] containsObject:[NSNumber numberWithInteger:index]];
            
            [view setSelected:selected];
            [view setIndexInGrid:index];
            [self addSubview:view];
        }
        
        if ( (index + 1) % itemsPerRow == 0 )
        {
            x = spaceWidth;
            y += viewSize.height + spaceWidth;
        }
        else
        {
            x += viewSize.width + spaceWidth;
        }
    }
    
    
    [self setFirstVisibleIndex:startAtIndex];
    [self setLastVisibleIndex:stopAtIndex];
}

-(void)didTap:(UITapGestureRecognizer *)recognizer
{
    CGPoint touchPoint = [recognizer locationInView:self];
    
    for ( id view in [self subviews] )
    {
        if ( [view isKindOfClass:[ImageGridViewCell class]] )
        {
            if ( CGRectContainsPoint([view frame], touchPoint) )
            {
                NSInteger previousIndex = -1;
                NSInteger selectedIndex = -1;
                
                
                NSMutableSet * selectedCellIndexes = [self selectedCellIndexes];
                
                if ( [self allowsMultipleSelection] == NO )
                {
                    if ( [selectedCellIndexes count] > 0 )
                    {
                        previousIndex = [[selectedCellIndexes anyObject] integerValue];
                        [[self cellAtIndex:previousIndex] setSelected:NO];
                        [selectedCellIndexes removeAllObjects];
                    }
                    
                    selectedIndex = [view indexInGrid];
                    
                    [view setSelected:YES];
                    
                    [selectedCellIndexes addObject:[NSNumber numberWithInteger:selectedIndex]];
                    
                    
                }
                else
                {
                    NSInteger indexInGrid = [view indexInGrid];
                    
                    NSNumber * numberIndexInGrid = [NSNumber numberWithInteger:indexInGrid];
                    
                    if ( [selectedCellIndexes containsObject:numberIndexInGrid] )
                    {
                        previousIndex = indexInGrid;
                        [view setSelected:NO];
                        [selectedCellIndexes removeObject:numberIndexInGrid];
                    }
                    else
                    {
                        selectedIndex = indexInGrid;
                        [view setSelected:YES];
                        [selectedCellIndexes addObject:numberIndexInGrid];
                    }
                    
                }
                
                
                id<GridViewDataSource> dataSource = [self dataSource];
                
                if ( previousIndex >= 0 )
                {
                    if ( [dataSource respondsToSelector:@selector(gridView:didDeselectCellAtIndex:)] )
                    {
                        [dataSource gridView:self didDeselectCellAtIndex:previousIndex];
                    }
                }
                
                if ( selectedIndex >= 0 )
                {
                    if ( [dataSource respondsToSelector:@selector(gridView:didSelectCellAtIndex:)] )
                    {
                        [dataSource gridView:self didSelectCellAtIndex:selectedIndex];
                    }
                }
                
                break;
                
            }
        }
    }
}

-(NSInteger)indexForSelectedCell
{
    NSInteger selectedIndex = -1;
    
    NSMutableSet * selectedCellIndexes = [self selectedCellIndexes];
    
    if ( [selectedCellIndexes count] > 0 )
    {
        selectedIndex = [[selectedCellIndexes anyObject] integerValue];
    }
    
    return selectedIndex;
}


-(NSArray *)indexesForSelectedCells
{
    NSArray * selectedIndexes = nil;
    
    NSMutableSet * selectedCellIndexes = [self selectedCellIndexes];
    
    if ( [selectedCellIndexes count] > 0 )
    {
        NSSortDescriptor * sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
        
        selectedIndexes = [selectedCellIndexes sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    }
    
    return selectedIndexes;
}

@end
