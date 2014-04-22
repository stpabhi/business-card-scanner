//
//  PhotoCell.h
//  Tesseract BizScanner
//
//  Created by Abhilash S T P on 4/18/14.
//  Copyright (c) 2014 Abhilash S T P. All rights reserved.
//

#import <UIKit/UIKit.h>
@import AssetsLibrary;
@interface PhotoCell : UICollectionViewCell
@property(nonatomic, strong) ALAsset *asset;

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end
