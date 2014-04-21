//
//  ImageCollectionViewController.h
//  Tesseract BizScanner
//
//  Created by Abhilash S T P on 4/18/14.
//  Copyright (c) 2014 Abhilash S T P. All rights reserved.
//

#import <UIKit/UIKit.h>
@import AssetsLibrary;
#import "PhotoCell.h"
@interface ImageCollectionViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property(nonatomic, strong) NSArray *assets;
@end
