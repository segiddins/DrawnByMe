//
//  MasterViewController.h
//  CollectionView
//
//  Created by Yashesh Chauhan on 11/09/12.
//  Copyright (c) 2012 Yashesh Chauhan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    btNormal,
    btEraser,
    btTapered,
    btStamp
} brushType;

typedef enum {
    biNone,
    biB,
    biSparkle,
    biGears,
    biPallet,
    biSmile,
    biFrown,
    biStar
} brushImage;

@protocol SEGBrushCollectionViewControllerDelegate <NSObject>

- (void)closeBrushSelector:(id)sender;

@end

@interface SEGBrushCollectionViewController : UICollectionViewController{
    
    NSMutableArray *arrRecords;
    int noOfSection;
}

@property (nonatomic, retain) NSMutableArray *arrRecords;
@property brushType currentBrushType;
@property brushImage currentBrushImage;
@property (nonatomic, weak) id<SEGBrushCollectionViewControllerDelegate> delegate;

@end
