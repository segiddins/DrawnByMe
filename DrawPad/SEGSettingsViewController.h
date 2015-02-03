//
//  SEGSettingsViewController.h
//  DrawPad
//
//  Created by Samuel E. Giddins on 11/26/12.
//  Copyright (c) 2012 Samuel E. Giddins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SEGBrushCollectionViewController.h"


@protocol SEGSettingsViewControllerDelegate <NSObject>

- (void)closeSettings:(id)sender;

@end

@interface SEGSettingsViewController : UIViewController <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate, SEGBrushCollectionViewControllerDelegate>

@property (nonatomic, weak) id<SEGSettingsViewControllerDelegate> delegate;

@property CGFloat brush;
@property CGFloat opacity;

@property brushType currentBrushType;
@property brushImage currentBrushImage;
@property UIImage *brushImageImage;

@property CGFloat red;
@property CGFloat green;
@property CGFloat blue;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *useImageButtom;
@property UIImage *chosenImage;

- (IBAction)closeSettings:(id)sender;
@property (weak, nonatomic) IBOutlet UISlider *brushControl;
@property (weak, nonatomic) IBOutlet UISlider *opacityControl;
@property (weak, nonatomic) IBOutlet UIImageView *brushPreview;
@property (weak, nonatomic) IBOutlet UIImageView *opacityPreview;
@property (weak, nonatomic) IBOutlet UILabel *brushValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *opacityValueLabel;

@property (weak, nonatomic) IBOutlet UISlider *redControl;
@property (weak, nonatomic) IBOutlet UISlider *greenControl;
@property (weak, nonatomic) IBOutlet UISlider *blueControl;

@property (weak, nonatomic) IBOutlet UILabel *redLabel;
@property (weak, nonatomic) IBOutlet UILabel *greenLabel;
@property (weak, nonatomic) IBOutlet UILabel *blueLabel;
@property (weak, nonatomic) IBOutlet UILabel *rgbLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *useImageButton;
- (IBAction)erase:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *eraser;

@end
