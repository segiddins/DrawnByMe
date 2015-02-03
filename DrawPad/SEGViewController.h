//
//  SEGViewController.h
//  DrawPad
//
//  Created by Samuel E. Giddins on 11/26/12.
//  Copyright (c) 2012 Samuel E. Giddins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import "SEGSettingsViewController.h"
#import "SEGAppDelegate.h"

@interface SEGViewController : UIViewController  <SEGSettingsViewControllerDelegate, UIActionSheetDelegate, UIAlertViewDelegate> {
    
    CGPoint lastPoint;
    //CGRect  realBounds;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat brush;
    CGFloat opacity;
    BOOL mouseSwiped;
    brushType currentBrushType;
    brushImage currentBrushImage;
    UIImage *brushImageImage;
    NSDate *lastStampDraw;
}

@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UIImageView *tempDrawImage;
- (IBAction)pencilPressed:(id)sender;
- (IBAction)eraserPressed:(id)sender;
- (IBAction)reset:(id)sender;
- (IBAction)settings:(id)sender;
- (IBAction)save:(id)sender;

@end
