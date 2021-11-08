//
//  PhotoCell.m
//  Tesseract BizScanner
//
//  Created by Abhilash S T P on 4/18/14.
//  Copyright (c) 2014 Abhilash S T P. All rights reserved.
//

#import "PhotoCell.h"

@interface PhotoCell ()

@end

@implementation PhotoCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) setAsset:(ALAsset *)asset
{
    // 2
    _asset = asset;
    self.photoImageView.image = [UIImage imageWithCGImage:[asset thumbnail]];
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
