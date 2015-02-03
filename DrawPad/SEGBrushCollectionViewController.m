//
//  MasterViewController.m
//  CollectionView
//
//  Created by Yashesh Chauhan on 11/09/12.
//  Copyright (c) 2012 Yashesh Chauhan. All rights reserved.
//

#import "SEGBrushCollectionViewController.h"

#import "CollectionViewCell.h"

#import "BrushInfo.h"


#define NUMCELLS 14

@interface SEGBrushCollectionViewController () {
    NSMutableArray *_objects;
}
@end

@implementation SEGBrushCollectionViewController
@synthesize arrRecords;

- (void)awakeFromNib
{
    [super awakeFromNib];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.arrRecords = [[NSMutableArray alloc] init];
    noOfSection = 3;
    if (self.view.frame.size.width > 400) {
        noOfSection = 7;
    }
    for (int i = 0; i < NUMCELLS; i++) {
        switch (i) {
                
            case 0:
                [self.arrRecords addObject:[[BrushInfo alloc] initWithBrushImage:[UIImage imageNamed:@"Brush Image"] andBrushName:@"Normal"]];
                break;
                
            case 1:
                [self.arrRecords addObject:[[BrushInfo alloc] initWithBrushImage:[UIImage imageNamed:@"b"] andBrushName:@"b"]];
                break;
                
            case 2:
                [self.arrRecords addObject:[[BrushInfo alloc] initWithBrushImage:[UIImage imageNamed:@"Sparkle"] andBrushName:@"Sparkle"]];
                break;
                                
            case 3:
                [self.arrRecords addObject:[[BrushInfo alloc] initWithBrushImage:[UIImage imageNamed:@"Setting-1"] andBrushName:@"Gears"]];
                break;
                
            case 4:
                [self.arrRecords addObject:[[BrushInfo alloc] initWithBrushImage:[UIImage imageNamed:@"Pallet"] andBrushName:@"Pallet"]];
                break;
                
            case 5:
                [self.arrRecords addObject:[[BrushInfo alloc] initWithBrushImage:[UIImage imageNamed:@"smiley"] andBrushName:@"Smile :)"]];
                break;
                
            case 6:
                [self.arrRecords addObject:[[BrushInfo alloc] initWithBrushImage:[UIImage imageNamed:@"frowny"] andBrushName:@"Frown :("]];
                break;
                
            default:
                [self.arrRecords addObject:[[BrushInfo alloc] initWithBrushImage:nil andBrushName:@""]];
                break;
        }
    }
    
	self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView reloadData];
    // Do any additional setup after loading the view, typically from a nib.
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{

    return FALSE;
}

/*- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    if ((toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)) {
        noOfSection = 4;
    }else{
        noOfSection = 3;
    }
    [self.collectionView reloadData];
}*/

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return NUMCELLS / noOfSection;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return noOfSection;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"brushCell" forIndexPath:indexPath];
    BrushInfo *brushInfo = [self.arrRecords objectAtIndex:indexPath.section * noOfSection + indexPath.row];
    
    if (brushInfo.isMale) {
        [cell.imgProfile setImage:[UIImage imageNamed:@"User-Executive-Green-icon.png"]];
    }else{
        [cell.imgProfile setImage:[UIImage imageNamed:@"User-Administrator-Blue-icon.png"]];
    }
    

        [cell.imgProfile setImage:brushInfo.brushImageImage];
        cell.lblTitle.text = brushInfo.brushName;

    cell.imgNotification.hidden = TRUE;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = (indexPath.section)*noOfSection + indexPath.row;
    switch (index) {
        case 0:
            self.currentBrushType= btNormal;
            self.currentBrushImage = biNone;
            break;
            
        default:
            self.currentBrushImage = index;
            self.currentBrushType = btStamp;
            break;
    }
    if (index > 6) {
        return;
    }
    NSLog(@"dismissed w/ item index: %d", index);
    [self.delegate closeBrushSelector:self];
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)closeBrushSelector:(id)sender;
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
