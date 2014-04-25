//
//  ViewController.h
//  Tesseract BizScanner
//
//  Created by Abhilash S T P on 3/26/14.
//  Copyright (c) 2014 Abhilash S T P. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TesseractOCR/Tesseract.h>
@import AssetsLibrary;
#import "ImageProcessingProtocol.h"
#import "ImageProcessingImplementation.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
@import AddressBook;
@import AddressBookUI;
@interface ViewController : UIViewController <TesseractDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,ABNewPersonViewControllerDelegate,ImageProcessingImplementationDelegate,ABPersonViewControllerDelegate>
- (IBAction)accessPhotos:(id)sender;
- (IBAction)openCamera:(id)sender;
-(NSString *)processOCR:(UIImage *)image;
@property (strong, atomic) ALAssetsLibrary* library;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *resultViews;
@property (strong, nonatomic) id <ImageProcessingProtocol> imageProcessor;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property(nonatomic, strong) NSArray *assets;
@property NSMutableArray *collectionViewCellTag;
@property (weak, nonatomic) IBOutlet UILabel *starterText;

@end
