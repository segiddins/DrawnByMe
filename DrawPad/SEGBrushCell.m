//
//  SEGBrushCell.m
//  DrawPad
//
//  Created by Samuel E. Giddins on 12/3/12.
//  Copyright (c) 2012 Samuel E. Giddins. All rights reserved.
//

#import "SEGBrushCell.h"

@implementation SEGBrushCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

UIImageView imageView;

[Export ("initWithFrame:")]
public AnimalCell (System.Drawing.RectangleF frame) : base (frame)
{
    BackgroundView = new UIView{BackgroundColor = UIColor.Orange};
    
    SelectedBackgroundView = new UIView{BackgroundColor = UIColor.Green};
    
    ContentView.Layer.BorderColor = UIColor.LightGray.CGColor;
    ContentView.Layer.BorderWidth = 2.0f;
    ContentView.BackgroundColor = UIColor.White;
    ContentView.Transform = CGAffineTransform.MakeScale (0.8f, 0.8f);
    
    imageView = new UIImageView (UIImage.FromBundle ("placeholder.png"));
    imageView.Center = ContentView.Center;
    imageView.Transform = CGAffineTransform.MakeScale (0.7f, 0.7f);
    
    ContentView.AddSubview (imageView);
}

public UIImage Image {
    set {
        imageView.Image = value;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
