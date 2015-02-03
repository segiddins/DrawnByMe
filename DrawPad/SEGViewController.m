//
//  SEGViewController.m
//  DrawPad
//
//  Created by Samuel E. Giddins on 11/26/12.
//  Copyright (c) 2012 Samuel E. Giddins. All rights reserved.
//

#import "SEGViewController.h"
#import <Crashlytics/Crashlytics.h>

@interface SEGViewController ()

@property id imageObserver;

@end

@implementation SEGViewController {
    UIPopoverController *activityPopover;
}

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    red = 0.0;
    green = 0.0;
    blue = 0.0;
    brush = 10.0;
    opacity = 1.0;
    currentBrushType = btNormal;
    currentBrushImage = biNone;
    lastStampDraw = [NSDate dateWithTimeIntervalSinceNow:0];

    self.imageObserver = (id)[[NSNotificationCenter defaultCenter] addObserverForName:@"New Image" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        UIImage *image = note.object;
        if (image != nil) {
            self.photoImage.image = image;
            CLSNSLog(@"new image set");
        }
    }];


    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    //realBounds = CGRectMake(0.0, 0.0, 0.0, 0.0);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self.imageObserver];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Drawing

- (IBAction)pencilPressed:(id)sender {
    UIButton * PressedButton = (UIButton*)sender;
    currentBrushType = btNormal;

    switch(PressedButton.tag)
    {
        case 0:
            red = 0.0/255.0;
            green = 0.0/255.0;
            blue = 0.0/255.0;
            break;
        case 1:
            red = 105.0/255.0;
            green = 105.0/255.0;
            blue = 105.0/255.0;
            break;
        case 2:
            red = 255.0/255.0;
            green = 0.0/255.0;
            blue = 0.0/255.0;
            break;
        case 3:
            red = 0.0/255.0;
            green = 0.0/255.0;
            blue = 255.0/255.0;
            break;
        case 4:
            red = 102.0/255.0;
            green = 204.0/255.0;
            blue = 0.0/255.0;
            break;
        case 5:
            red = 102.0/255.0;
            green = 255.0/255.0;
            blue = 0.0/255.0;
            break;
        case 6:
            red = 51.0/255.0;
            green = 204.0/255.0;
            blue = 255.0/255.0;
            break;
        case 7:
            red = 160.0/255.0;
            green = 82.0/255.0;
            blue = 45.0/255.0;
            break;
        case 8:
            red = 255.0/255.0;
            green = 102.0/255.0;
            blue = 0.0/255.0;
            break;
        case 9:
            red = 255.0/255.0;
            green = 255.0/255.0;
            blue = 0.0/255.0;
            break;
    }
}

- (IBAction)eraserPressed:(id)sender {
    red = 255.0/255.0;
    green = 255.0/255.0;
    blue = 255.0/255.0;
    opacity = 1.0;
    currentBrushType = btEraser;
}

- (IBAction)reset:(id)sender {
    UIAlertView *resetPrompt = [[UIAlertView alloc] initWithTitle:@"Reset?" message:@"Are you sure you want to trash your beautiful work?" delegate:self cancelButtonTitle:@"Don't Reset" otherButtonTitles:@"Reset All", @"Reset Drawing", nil];
    [resetPrompt show];
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self doReset];
    } else if (buttonIndex == 2) {
        self.mainImage.image = nil;
    }
}

- (void)doReset
{
    red = 0.0;
    green = 0.0;
    blue = 0.0;
    opacity = 1.0;
    brush = 10.0;
    self.mainImage.image = nil;
    self.photoImage.image = nil;
}

- (IBAction)settings:(id)sender {
}

- (IBAction)save:(id)sender {
    /*UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Save to Camera Roll", @"Tweet it!", nil];
    [actionSheet showInView:self.view];*/
    UIGraphicsBeginImageContextWithOptions(self.mainImage.bounds.size, NO, 1.0);
    [self.photoImage.image drawInRect:CGRectMake(0, 0, self.mainImage.frame.size.width, self.mainImage.frame.size.height)];
    [self.mainImage.image drawInRect:CGRectMake(0, 0, self.mainImage.frame.size.width, self.mainImage.frame.size.height)];
    UIImage *saveImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSString *textToShare = @"This was DrawnByMe!";
    NSURL *urlToShare = [NSURL URLWithString:@"http://segiddins.me/DrawnByMe"];
    NSArray *activityItems = @[textToShare, saveImage, urlToShare];
    NSArray *appActivities = nil;
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:appActivities];
    activityVC.excludedActivityTypes = @[UIActivityTypePostToWeibo, UIActivityTypeMessage];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        activityPopover = [[UIPopoverController alloc] initWithContentViewController:activityVC];
        [activityPopover presentPopoverFromRect:((UIButton*)sender).frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:true];
    }
    else {
        [self presentViewController:activityVC animated:TRUE completion:nil];
    }

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIGraphicsBeginImageContextWithOptions(self.mainImage.bounds.size, NO, 1.0);
    [self.mainImage.image drawInRect:CGRectMake(0, 0, self.mainImage.frame.size.width, self.mainImage.frame.size.height)];
    UIImage *saveImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    if (buttonIndex == 1) {
        //Tweet!
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
            SLComposeViewController *twit = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            [twit addImage:saveImage];
            [twit setInitialText:@"I drew this pic in @segiddins new app!"];
            [self presentViewController:twit animated:YES completion:nil];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter post failed" message:@"Darn!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    }

    if (buttonIndex == 0) {
        //Save!
        UIImageWriteToSavedPhotosAlbum(saveImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (void)image:(UIImage *) image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error != NULL) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Image could not be saved. Please try again"  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Close", nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Image was successfully saved to camera roll"  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Close", nil];
        [alert show];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    mouseSwiped = NO;
    UITouch *touch = [touches anyObject];
    lastPoint = [touch locationInView:self.view];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    mouseSwiped = YES;
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.view];

    if (currentBrushType == btNormal || currentBrushType == btEraser) {
        UIGraphicsBeginImageContext(self.view.frame.size);
        [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        if (currentBrushType == btEraser) {
            [self.mainImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
        }
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush);
        if (currentBrushType == btNormal) {
            CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
            CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeNormal);
            CGContextStrokePath(UIGraphicsGetCurrentContext());
            self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
            [self.tempDrawImage setAlpha:opacity];
        } else if (currentBrushType == btEraser) {
            CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), [[UIColor clearColor] CGColor]);
            CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [[UIColor clearColor] CGColor]);
            CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
            CGContextStrokePath(UIGraphicsGetCurrentContext());
            self.mainImage.image = UIGraphicsGetImageFromCurrentImageContext();
        }
        UIGraphicsEndImageContext();
    }

    if (currentBrushType == btStamp) {
        NSDate *now = [NSDate dateWithTimeIntervalSinceNow:0];
        if ([now timeIntervalSinceDate:lastStampDraw] > .2 ) {
            lastStampDraw = [NSDate dateWithTimeIntervalSinceNow:0];
            NSLog(@"trying to draw stamp");
            UIGraphicsBeginImageContext(self.view.frame.size);
            UIImage *stampImage = brushImageImage;
            [stampImage drawInRect:CGRectMake(currentPoint.x - brush / 2, currentPoint.y - brush / 2, brush, brush)];
            CGContextFlush(UIGraphicsGetCurrentContext());
            self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
            [self.tempDrawImage setAlpha:opacity];
            UIGraphicsEndImageContext();


            UIGraphicsBeginImageContext(self.mainImage.frame.size);
            [self.mainImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
            [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:opacity];
            self.mainImage.image = UIGraphicsGetImageFromCurrentImageContext();
            self.tempDrawImage.image = nil;
            UIGraphicsEndImageContext();
        }
    }

    lastPoint = currentPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!mouseSwiped) {
        if (currentBrushType == btNormal || currentBrushType == btEraser) {
            UIGraphicsBeginImageContext(self.view.frame.size);
            CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
            CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush);
            if (currentBrushType == btNormal) {
                [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
                CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, opacity);
            } else if (currentBrushType == btEraser) {
                [self.mainImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
                CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), [[UIColor clearColor] CGColor]);
            }
            CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
            CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
            if (currentBrushType == btNormal) {
                CGContextStrokePath(UIGraphicsGetCurrentContext());
                CGContextFlush(UIGraphicsGetCurrentContext());
                self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
            } else if (currentBrushType == btEraser) {
                CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), [[UIColor clearColor] CGColor]);
                CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [[UIColor clearColor] CGColor]);
                CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
                CGContextStrokePath(UIGraphicsGetCurrentContext());
                self.mainImage.image = UIGraphicsGetImageFromCurrentImageContext();
            }
            UIGraphicsEndImageContext();
        }
        if (currentBrushType == btStamp) {
            NSLog(@"trying to draw stamp");
            UIGraphicsBeginImageContext(self.view.frame.size);
            UIImage *stampImage = brushImageImage;
            [stampImage drawInRect:CGRectMake(lastPoint.x - brush / 2, lastPoint.y - brush / 2, brush, brush)];
            CGContextFlush(UIGraphicsGetCurrentContext());
            self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
    }


    if (currentBrushType == btNormal || currentBrushType == btStamp) {
        UIGraphicsBeginImageContext(self.mainImage.frame.size);
        [self.mainImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
        [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:opacity];
        self.mainImage.image = UIGraphicsGetImageFromCurrentImageContext();
        self.tempDrawImage.image = nil;
        UIGraphicsEndImageContext();
    } else if (currentBrushType == btEraser) {
        /*[self.mainImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
        [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeSourceAtop alpha:opacity];*/
    }

}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SEGSettingsViewController *settingsVC = (SEGSettingsViewController *)segue.destinationViewController;
    settingsVC.delegate = self;
    settingsVC.brush = brush;
    settingsVC.opacity = opacity;
    settingsVC.red = red;
    settingsVC.green = green;
    settingsVC.blue = blue;
    settingsVC.currentBrushType = self->currentBrushType;
    settingsVC.currentBrushImage = currentBrushImage;
    settingsVC.brushImageImage = brushImageImage;
    NSLog(@"%d", currentBrushType);
}

#pragma mark - SEGSettingsViewControllerDelegate methods

- (void)closeSettings:(id)sender
{
    brush = ((SEGSettingsViewController*)sender).brush;
    opacity = ((SEGSettingsViewController*)sender).opacity;
    red = ((SEGSettingsViewController*)sender).red;
    green = ((SEGSettingsViewController*)sender).green;
    blue = ((SEGSettingsViewController*)sender).blue;
    currentBrushType = ((SEGSettingsViewController*)sender).currentBrushType;
    currentBrushImage = ((SEGSettingsViewController*)sender).currentBrushImage;
    brushImageImage = ((SEGSettingsViewController*)sender).brushImageImage;
    /*switch (currentBrushImage) {
        case biB:
            brushImageImage = [UIImage imageNamed:@"b.png"];
            break;

        case biGears:
            brushImageImage = [UIImage imageNamed:@"Setting-1.png"];
            break;

        case biSparkle:
            brushImageImage = [UIImage imageNamed:@"Sparkle"];
            break;

        default:
            currentBrushType = btNormal;
            break;
    }*/
    if (nil != ((SEGSettingsViewController*)sender).chosenImage) {
      self.photoImage.image = ((SEGSettingsViewController*)sender).chosenImage;
      NSLog(@"main image reset");
    }
    else
        NSLog(@"chosenImage was nil");
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
