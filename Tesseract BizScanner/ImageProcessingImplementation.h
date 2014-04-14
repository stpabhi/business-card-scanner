//
//  ImageProcessingImplementation.h
//  Tesseract BizScanner
//
//  Created by Abhilash S T P on 4/4/14.
//  Copyright (c) 2014 Abhilash S T P. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ImageProcessingProtocol.h"

@class ImageProcessingImplementation;

@protocol ImageProcessingImplementationDelegate <NSObject>
@optional
- (BOOL)shouldCancelImageRecognitionForTesseract:(ImageProcessingImplementation *)tesseract;
@end

@interface ImageProcessingImplementation : NSObject <ImageProcessingProtocol>
+ (NSString *)version;
@property (nonatomic, strong) NSString* language;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) CGRect rect;

@property (nonatomic, readonly) short progress; // from 0 to 100
@property (nonatomic, readonly) NSString *recognizedText;

@property (nonatomic, weak) id<ImageProcessingImplementationDelegate> delegate;

- (id)initWithLanguage:(NSString*)language;
- (void)setVariableValue:(NSString *)value forKey:(NSString *)key;

- (BOOL)recognize;

- (UIImage*) processImage:(UIImage*) src;
- (NSString*) pathToLangugeFIle;
- (NSString*) OCRImage:(UIImage*)src;
- (UIImage*) processRotation:(UIImage*)src;
- (UIImage*) processHistogram:(UIImage*)src;
- (UIImage*) processFilter:(UIImage*)src;
- (UIImage*) processBinarize:(UIImage*)src;
- (UIImage *) contoursImage:(UIImage *)src;
@end
