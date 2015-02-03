//
//  SEGSettingsViewController.m
//  DrawPad
//
//  Created by Samuel E. Giddins on 11/26/12.
//  Copyright (c) 2012 Samuel E. Giddins. All rights reserved.
//

#import "SEGSettingsViewController.h"

@interface SEGSettingsViewController () {
    UIPopoverController *pop;
}

@end

@implementation SEGSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //[self sliderChanged:self.brushControl];
    //[self sliderChanged:self.opacityControl];
    
    self.chosenImage = nil;
    //UIImage *gdot = [UIImage imageNamed:@"GDot.png"];
    //UIImage *rdot = [UIImage imageNamed:@"RDot"];
    //UIImage *bdot = [UIImage imageNamed:@"BDot"];
    //[_greenControl setThumbImage:gdot forState:UIControlStateNormal];
    //[_blueControl setThumbImage:bdot forState:UIControlStateNormal];
    //[_redControl setThumbImage:rdot forState:UIControlStateNormal];
    [_greenControl setThumbTintColor:[UIColor colorWithRed:138/255.0 green:187/255.0 blue:92/255.0 alpha:1]];
    [_blueControl setThumbTintColor:[UIColor colorWithRed:54/255.0 green:162/255.0 blue:210/255.0 alpha:1]];
    [_redControl setThumbTintColor:[UIColor colorWithRed:221/255.0 green:102/255.0 blue:86/255.0 alpha:1]];
    
    //UIImage *sliderImage = [UIImage imageNamed:@"GSlider"];
    //UIImage *minImage=[sliderImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 0)];
    //UIImage *maxImage=[sliderImage stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0];
    //[_greenControl setMaximumTrackImage:maxImage forState:UIControlStateNormal];
    [_greenControl setMinimumTrackTintColor:[UIColor colorWithRed:137.0/255 green:184/255.0 blue:91/255.0 alpha:1]];
    [_greenControl setMaximumTrackTintColor:[UIColor colorWithRed:166.0/255 green:226/255.0 blue:105/255.0 alpha:.5]];
    [self.greenLabel setTextColor:[UIColor colorWithRed:138/255.0 green:187/255.0 blue:92/255.0 alpha:1]];
    
    [_redControl setMinimumTrackTintColor:[UIColor colorWithRed:227.0/255 green:104/255.0 blue:88/255.0 alpha:1]];
    [_redControl setMaximumTrackTintColor:[UIColor colorWithRed:245.0/255 green:148/255.0 blue:135/255.0 alpha:.5]];
    [self.redLabel setTextColor:[UIColor colorWithRed:221/255.0 green:102/255.0 blue:86/255.0 alpha:1]];

    [_blueControl setMinimumTrackTintColor:[UIColor colorWithRed:54.0/255 green:162/255.0 blue:210/255.0 alpha:1]];
    [_blueControl setMaximumTrackTintColor:[UIColor colorWithRed:103.0/255 green:202/255.0 blue:246/255.0 alpha:.5]];
    [self.blueLabel setTextColor:[UIColor colorWithRed:54/255.0 green:162/255.0 blue:210/255.0 alpha:1]];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    brushType temp = self.currentBrushType;
    int redIntValue = self.red * 255.0;
    self.redControl.value = redIntValue;
    [self sliderChanged:nil];
    
    int greenIntValue = self.green * 255.0;
    self.greenControl.value = greenIntValue;
    [self sliderChanged:nil];
    
    int blueIntValue = self.blue * 255.0;
    self.blueControl.value = blueIntValue;
    [self sliderChanged:nil];
    
    self.brushControl.value = self.brush;
    [self sliderChanged:self.brushControl];
    
    self.opacityControl.value = self.opacity;
    [self sliderChanged:self.opacityControl];
    
    if (self.view.frame.size.width > 400 || self.currentBrushType == btStamp) {
        [self.brushControl setMaximumValue:120];
        if (self.view.frame.size.width > 400 && self.currentBrushType == btStamp) {
            [self.brushControl setMaximumValue:150];
        }
    }
    else {
        [self.brushControl setMaximumValue:80];
    }
    
    if (temp == btEraser) {
        self.eraser.on = true;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)useImage:(UIBarButtonItem *)sender {
    UIActionSheet *getImage = [[UIActionSheet alloc] initWithTitle:@"Pick an Image"
                                                          delegate:self
                                                 cancelButtonTitle:@"Cancel"
                                            destructiveButtonTitle:nil
                                                 otherButtonTitles:@"Use Existing Image", @"Take a Photo", nil];
    [getImage setTag:0];
    [getImage showFromBarButtonItem:self.useImageButtom animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 0) {
        NSLog(@"%d", buttonIndex);
        if (buttonIndex == 0) { //use existing
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            [imagePicker setDelegate:self];
            [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
                pop = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
                [pop presentPopoverFromBarButtonItem:self.useImageButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                NSLog(@"presenting");
            }
            else {
                [self presentViewController:imagePicker animated:YES completion:NULL];
            }
        } else if(buttonIndex == 1 && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            [imagePicker setDelegate:self];
            [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
            [self presentViewController:imagePicker animated:YES completion:NULL];
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.chosenImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    NSLog(@"%@\n%@", [info valueForKey:UIImagePickerControllerOriginalImage], self.chosenImage);
    [picker dismissViewControllerAnimated:YES completion:nil];
    [pop dismissPopoverAnimated:TRUE];
    NSLog(@"dismissing");
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    NSLog(@"pop dismissed");
}

- (IBAction)closeSettings:(id)sender {
    [self.delegate closeSettings:self];
}

- (IBAction)sliderChanged:(id)sender {
    UISlider * changedSlider = (UISlider*)sender;
    
    if(changedSlider == self.brushControl) {
        
        self.brush = self.brushControl.value;
        self.brushValueLabel.text = [NSString stringWithFormat:@"%d", (NSInteger)self.brush];
        
    } else if(changedSlider == self.opacityControl) {
        
        self.opacity = self.opacityControl.value;
        self.opacityValueLabel.text = [NSString stringWithFormat:@"%.1f", self.opacity];
        
    } else if(changedSlider == self.redControl) {
        
        self.currentBrushType = btNormal;
        
        
    } else if(changedSlider == self.greenControl){
        
        self.currentBrushType = btNormal;
        
        
    } else if (changedSlider == self.blueControl){
        
        self.currentBrushType = btNormal;
        
        
    }
    self.blue = self.blueControl.value/255.0;
    self.blueLabel.text = [NSString stringWithFormat:@"Blue: %d", (int)self.blueControl.value];
    self.green = self.greenControl.value/255.0;
    self.greenLabel.text = [NSString stringWithFormat:@"Green: %d", (int)self.greenControl.value];
    self.red = self.redControl.value/255.0;
    self.redLabel.text = [NSString stringWithFormat:@"Red: %d", (int)self.redControl.value];
    //Draw previews
    if (self.currentBrushType == btNormal || self.currentBrushType == btEraser) {
        UIGraphicsBeginImageContext(self.brushPreview.frame.size);
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(),self.brush);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), self.red, self.green, self.blue, 1.0);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 60, 60);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 60, 60);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        self.brushPreview.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UIGraphicsBeginImageContext(self.opacityPreview.frame.size);
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(),self.brush);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), self.red, self.green, self.blue, self.opacity);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(),60, 60);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(),60, 60);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        self.opacityPreview.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.rgbLabel.hidden = self.greenControl.hidden = self.greenLabel.hidden = self.redControl.hidden = self.redLabel.hidden = self.blueControl.hidden = self.blueLabel.hidden = FALSE;
    }
    else if (self.currentBrushType == btStamp) {
        UIGraphicsBeginImageContext(self.brushPreview.frame.size);
        UIImage *stampImage = self.brushImageImage;
        [stampImage drawInRect:CGRectMake(self.brushPreview.frame.size.width /2 - self.brush/2, self.brushPreview.frame.size.height/2 - self.brush/2, self.brush, self.brush)];
        CGContextFlush(UIGraphicsGetCurrentContext());
        self.brushPreview.image = UIGraphicsGetImageFromCurrentImageContext();
        [self.brushPreview setAlpha:1];
        UIGraphicsEndImageContext();
        
        UIGraphicsBeginImageContext(self.opacityPreview.frame.size);
        [stampImage drawInRect:CGRectMake(self.opacityPreview.frame.size.width /2 - self.brush/2, self.opacityPreview.frame.size.height/2 - self.brush/2, self.brush, self.brush)];
        CGContextFlush(UIGraphicsGetCurrentContext());
        self.opacityPreview.image = UIGraphicsGetImageFromCurrentImageContext();
        [self.opacityPreview setAlpha:self.opacity];
        UIGraphicsEndImageContext();
        
        self.rgbLabel.hidden = self.greenControl.hidden = self.greenLabel.hidden = self.redControl.hidden = self.redLabel.hidden = self.blueControl.hidden = self.blueLabel.hidden = TRUE;
    }

    if (self.currentBrushType == 1) {
        self.eraser.on = true;
    } else {
        self.eraser.on = false;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SEGBrushCollectionViewController *brushCol = (SEGBrushCollectionViewController *)segue.destinationViewController;
    brushCol.currentBrushImage = self.currentBrushImage;
    brushCol.currentBrushType = self.currentBrushType;
    brushCol.delegate = self;
}

#pragma mark - Delegate methods

- (void)closeBrushSelector:(id)sender;
{
    SEGBrushCollectionViewController *brushCol = (SEGBrushCollectionViewController *)sender;
    self.currentBrushType = brushCol.currentBrushType;
    self.currentBrushImage = brushCol.currentBrushImage;
    
    switch (self.currentBrushImage) {
        case biB:
            self.brushImageImage = [UIImage imageNamed:@"b.png"];
            break;
            
        case biGears:
            self.brushImageImage = [UIImage imageNamed:@"Setting-1.png"];
            break;
            
        case biSparkle:
            self.brushImageImage = [UIImage imageNamed:@"Sparkle"];
            break;
            
        case biPallet:
            self.brushImageImage = [UIImage imageNamed:@"Pallet"];
            break;
            
        case biSmile:
            self.brushImageImage = [UIImage imageNamed:@"smiley"];
            break;
            
        case biFrown:
            self.brushImageImage = [UIImage imageNamed:@"frowny"];
            break;
            
        default:
            self.currentBrushType = btNormal;
            self.brushImageImage = nil;
            break;
    }
    
    [self sliderChanged:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)erase:(id)sender {
    UISwitch *control = (UISwitch *)sender;
    if (control.on) {
        self.currentBrushType = btEraser;
        
        self.red = 1.0;
        self.green = 1.0;
        self.blue = 1.0;
        
    } else {
        self.currentBrushType = btNormal;
        
        self.red = 0.0;
        self.green = 0.0;
        self.blue = 0.0;
    }

    [self sliderChanged:nil];


}
@end
