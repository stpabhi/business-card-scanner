//
//  ImageProcessingProtocol.h
//  Tesseract BizScanner
//
//  Created by Abhilash S T P on 4/4/14.
//  Copyright (c) 2014 Abhilash S T P. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ImageProcessingProtocol <NSObject>
- (UIImage*) processImage:(UIImage*) src;
- (NSString*) pathToLangugeFIle;
- (UIImage*) processRotation:(UIImage*)src;
- (UIImage*) processHistogram:(UIImage*)src;
- (UIImage*) processFilter:(UIImage*)src;
- (UIImage*) processBinarize:(UIImage*)src;
- (void) contoursImage:(UIImage *)src;
@end
