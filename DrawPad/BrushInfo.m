//
//  UserInfo.m
//  CollectionView
//
//  Created by Yashesh Chauhan on 11/09/12.
//  Copyright (c) 2012 Yashesh Chauhan. All rights reserved.
//

#import "BrushInfo.h"

@implementation BrushInfo
@synthesize isMale;
@synthesize isNotification;

- (id) initWithMale:(BOOL)male isNotification:(BOOL )notification{
    
    if (self = [super init]) {
        self.isMale = male;
        self.isNotification = notification;
    }
    return self;
    
}

- (id) initWithBrushImage: (UIImage *)brushImage andBrushName: (NSString *)brushName
{
    if (self = [super init]) {
        self.brushImageImage = brushImage;
        self.brushName = brushName;
    }
    return self;
}
@end
