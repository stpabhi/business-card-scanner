//
//  ViewController.h
//  Tesseract BizScanner
//
//  Created by Abhilash S T P on 3/26/14.
//  Copyright (c) 2014 Abhilash S T P. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TesseractOCR/Tesseract.h>
#import "ImageProcessingProtocol.h"
#import "ImageProcessingImplementation.h"
@import AddressBook;
@import AddressBookUI;
@interface ViewController : UIViewController <TesseractDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,ABNewPersonViewControllerDelegate,ImageProcessingImplementationDelegate>
- (IBAction)accessPhotos:(id)sender;
- (IBAction)openCamera:(id)sender;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *resultViews;
@property (strong, nonatomic) id <ImageProcessingProtocol> imageProcessor;
@end
