//
//  TestViewController.h
//  Tesseract BizScanner
//
//  Created by Abhilash S T P on 4/4/14.
//  Copyright (c) 2014 Abhilash S T P. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageProcessingProtocol.h"
#import "ImageProcessingImplementation.h"
@interface TestViewController : UIViewController <ImageProcessingImplementationDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *resultView;
@property (strong,nonatomic) UIImage *processedImage;
@property (strong, nonatomic) id <ImageProcessingProtocol> imageProcessor;
@property NSString * totalText;
- (IBAction)rotate:(id)sender;
- (IBAction)histogram:(id)sender;
- (IBAction)filter:(id)sender;
- (IBAction)binarize:(id)sender;

@end
