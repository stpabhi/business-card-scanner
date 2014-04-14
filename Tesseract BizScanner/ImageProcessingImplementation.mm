//
//  ImageProcessingImplementation.m
//  Tesseract BizScanner
//
//  Created by Abhilash S T P on 4/4/14.
//  Copyright (c) 2014 Abhilash S T P. All rights reserved.
//

#import "ImageProcessingImplementation.h"
#import "ImageProcessor.h"
#import "UIImage+OpenCV.h"
#import "GeneralContours.h"
#import "baseapi.h"
#import "environ.h"
#import "pix.h"
#import "ocrclass.h"

namespace tesseract {
	class TessBaseAPI;
};

@interface ImageProcessingImplementation () {
    NSString* _dataPath;
    NSString* _language;
    NSMutableDictionary* _variables;
	tesseract::TessBaseAPI* _tesseract;
	uint32_t* _pixels;
    ETEXT_DESC *_monitor;
}

@end
@implementation ImageProcessingImplementation
+ (NSString *)version {
	return [NSString stringWithFormat:@"%s", tesseract::TessBaseAPI::Version()];
}

- (id)init {
    
    self = [self initWithLanguage:nil];
    if (self) {
    }
    return self;
}

- (id)initWithLanguage:(NSString*)language {
    
    self = [self initPrivateWithDataPath:nil language:language];
    if (self) {
    }
    return self;
}

- (void)dealloc {
    if (_monitor != nullptr) {
        free(_monitor);
        _monitor = nullptr;
    }
    if (_pixels != nullptr) {
        free(_pixels);
        _monitor = nullptr;
    }
    if (_tesseract != nullptr) {
        // There is no needs to call Clear() and End() explicitly.
        // End() is sufficient to free up all memory of TessBaseAPI.
        // End() is called in destructor of TessBaseAPI.
        delete _tesseract;
        _tesseract = nullptr;
    }
}

- (id)initWithDataPath:(NSString *)dataPath language:(NSString *)language {
    return [self initPrivateWithDataPath:nil language:language];
}

- (id)initPrivateWithDataPath:(NSString *)dataPath language:(NSString *)language {
    
	self = [super init];
	if (self) {
		_dataPath = dataPath;
		_language = language;
        
        _monitor = new ETEXT_DESC();
        _monitor->cancel = (CANCEL_FUNC)[self methodForSelector:@selector(tesserackCallbackFunction:)];
        _monitor->cancel_this = (__bridge void*)self;
        
		_variables = [[NSMutableDictionary alloc] init];
		
        if (dataPath)
            [self copyDataToDocumentsDirectory];
        else
            [self setUpTesseractToSearchTrainedDataInTrainedDataFolderOfTheApplicatinBundle];
        
		_tesseract = new tesseract::TessBaseAPI();
		
		BOOL success = [self initEngine];
		if (!success)
            self = nil;
	}
	return self;
}

- (void)setUpTesseractToSearchTrainedDataInTrainedDataFolderOfTheApplicatinBundle {
    
    NSString *datapath = [NSString stringWithFormat:@"%@/",
                          [NSString stringWithString:[[NSBundle mainBundle] bundlePath]]
                          ];
    setenv("TESSDATA_PREFIX", datapath.UTF8String, 1);
}

- (BOOL)initEngine {
	int returnCode = _tesseract->Init([_dataPath UTF8String], [_language UTF8String]);
	return (returnCode == 0) ? YES : NO;
}

- (void)copyDataToDocumentsDirectory {
	
	// Useful paths
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentPath = ([documentPaths count] > 0) ? [documentPaths objectAtIndex:0] : nil;
	NSString *dataPath = [documentPath stringByAppendingPathComponent:_dataPath];
	
	//	NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"grc" ofType:@"traineddata"];
	//
	NSLog(@"DATAPATH %@", dataPath);
	
	// Copy data in Doc Directory
	if (![fileManager fileExistsAtPath:dataPath])
	{
		[fileManager createDirectoryAtPath:dataPath withIntermediateDirectories:YES attributes:nil error:NULL];
	}
    
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    for (NSString *l in [_language componentsSeparatedByString:@"+"]) {
        NSString *tessdataPath = [bundle pathForResource:l ofType:@"traineddata"];
        
        NSString *destinationPath = [dataPath stringByAppendingPathComponent:[tessdataPath lastPathComponent]];
        
        if(![fileManager fileExistsAtPath:destinationPath])
        {
            if (tessdataPath)
            {
                NSError *error = nil;
                NSLog(@"found %@", tessdataPath);
                NSLog(@"coping in %@", destinationPath);
                [fileManager copyItemAtPath:tessdataPath toPath:destinationPath error:&error];
                
                if(error)
                    NSLog(@"ERROR! %@", error.description);
            }
        }
    }
	
	setenv("TESSDATA_PREFIX", [[documentPath stringByAppendingString:@"/"] UTF8String], 1);
}

- (void)setVariableValue:(NSString *)value forKey:(NSString *)key {
	/*
	 * Example:
	 * _tesseract->SetVariable("tessedit_char_whitelist", "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ");
	 * _tesseract->SetVariable("language_model_penalty_non_freq_dict_word", "0");
	 * _tesseract->SetVariable("language_model_penalty_non_dict_word ", "0");
	 */
	
	[_variables setValue:value forKey:key];
	_tesseract->SetVariable([key UTF8String], [value UTF8String]);
}

- (void)loadVariables {
	for (NSString* key in _variables) {
		NSString* value = [_variables objectForKey:key];
		_tesseract->SetVariable([key UTF8String], [value UTF8String]);
	}
}

#pragma mark - Getters and setters

- (void)setLanguage:(NSString *)language {
    
	_language = language;
	BOOL result = [self initEngine];
	
	/*
	 * "WARNING: On changing languages, all Tesseract parameters
	 * are reset back to their default values."
	 */
	if (result)
        [self loadVariables];
}

- (void)setImage:(UIImage *)src {
    
//    if (_pixels != nullptr) {
//        free(_pixels);
//        _pixels = nullptr;
//    }
//	
//	CGSize size = [image size];
//	int width = size.width;
//	int height = size.height;
//	
//	if (width <= 0 || height <= 0) {
//        NSLog(@"WARNING: Image has not size!");
//		return;
//	}
//	
//	_pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
//	
//	// Clear the pixels so any transparency is preserved
//	memset(_pixels, 0, width * height * sizeof(uint32_t));
//	
//	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//	
//	// Create a context with RGBA _pixels
//	CGContextRef context = CGBitmapContextCreate(_pixels, width, height, 8, width * sizeof(uint32_t), colorSpace,
//                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
//	
//	// Paint the bitmap to our context which will fill in the _pixels array
//	CGContextDrawImage(context, CGRectMake(0, 0, width, height), [image CGImage]);
//	
//	// We're done with the context and color space
//	CGContextRelease(context);
//	CGColorSpaceRelease(colorSpace);
	  
	//_tesseract->SetImage((const unsigned char *) _pixels, width, height, sizeof(uint32_t), width * sizeof(uint32_t));
    cv::Mat toOCR=[src CVGrayscaleMat];
    _tesseract->SetImage((uchar*)toOCR.data, toOCR.size().width, toOCR.size().height, toOCR.channels(), (int)toOCR.step1());
    _tesseract->Recognize(NULL);

}


- (void)setRect:(CGRect)rect {
    
	_tesseract->SetRectangle(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
}

- (NSString *)recognizedText {
	char* utf8Text = _tesseract->GetUTF8Text();
	if (!utf8Text) {
		NSLog(@"No recognized text. Check that -[Tesseract setImage:] is passed an image bigger than 0x0.");
		return nil;
	}
    NSString *text = [NSString stringWithUTF8String:utf8Text];
    delete[] utf8Text;
    return text;
}

- (short)progress {
    
    return _monitor->progress;
}

#pragma mark - Other functions

- (void)clear {
    // Free up all memory in dealloc.
    NSLog(@"clear is deprecated. Free up all memory in dealloc.");
}

- (BOOL)recognize {
    
	int returnCode = _tesseract->Recognize(_monitor);
	return (returnCode == 0) ? YES : NO;
}

- (BOOL)tesserackCallbackFunction:(int)words {
    
    if (_monitor->ocr_alive == 1)
        _monitor->ocr_alive = 0;
    
    SEL selector = @selector(shouldCancelImageRecognitionForTesseract:);
    return [self.delegate respondsToSelector:selector] ? [self.delegate shouldCancelImageRecognitionForTesseract:self] : NO;
}

- (NSString*) pathToLangugeFIle{
    
    // Set up the tessdata path. This is included in the application bundle
    // but is copied to the Documents directory on the first run.
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = ([documentPaths count] > 0) ? [documentPaths objectAtIndex:0] : nil;
    
    NSString *dataPath = [documentPath stringByAppendingPathComponent:@"tessdata"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // If the expected store doesn't exist, copy the default store.
    if (![fileManager fileExistsAtPath:dataPath]) {
        // get the path to the app bundle (with the tessdata dir)
        NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
        NSString *tessdataPath = [bundlePath stringByAppendingPathComponent:@"tessdata"];
        if (tessdataPath) {
            [fileManager copyItemAtPath:tessdataPath toPath:dataPath error:NULL];
        }
    }
    
    setenv("TESSDATA_PREFIX", [[documentPath stringByAppendingString:@"/"] UTF8String], 1);
    
    return dataPath;
}


- (UIImage*) processImage:(UIImage*) src{
    
    
    /**
     *  PRE-PROCESSING OF THE IMAGE
     **/
    ImageProcessor processor;
    
    UIImage * processed= [UIImage imageWithCVMat:processor.processImage([src CVGrayscaleMat], src.size.height)];
    
    return processed;
    
}

- (UIImage *)contoursImage:(UIImage *)src
{
    GeneralContours *gc = [[GeneralContours alloc]init];
    return [gc initializeImage:src];
}
//- (NSString*) OCRImage{
//    // init the tesseract engine.
//    //tesseract::TessBaseAPI *tesseract = new tesseract::TessBaseAPI();
//    
//    
//    //tesseract->Init([[self pathToLangugeFIle] cStringUsingEncoding:NSUTF8StringEncoding], "eng");
//    
//    //Pass the UIIMage to cvmat and pass the sequence of pixel to tesseract
//    
//    cv::Mat toOCR=[src CVGrayscaleMat];
//    
//    NSLog(@"%d", toOCR.channels());
//    
//    tesseract->SetImage((uchar*)toOCR.data, toOCR.size().width, toOCR.size().height, toOCR.channels(), (int)toOCR.step1());
//    
//    tesseract->Recognize(NULL);
//    
//    //char* utf8Text = tesseract->GetUTF8Text();
//    char *boxText = tesseract->GetBoxText(0);
//    return [NSString stringWithUTF8String:boxText];
//    
//}


- (UIImage*) processRotation:(UIImage*)src{
    
    ImageProcessor processor;
    cv::Mat source=[src CVGrayscaleMat];
    processor.correctRotation(source, source, src.size.height);
    UIImage *rotated=[UIImage imageWithCVMat:source];
    return rotated;
    
}

- (UIImage*) processHistogram:(UIImage*)src{
    
    ImageProcessor processor;
    cv::Mat source=[src CVGrayscaleMat];
    cv::Mat output=processor.equalize(source);
    UIImage *equalized=[UIImage imageWithCVMat:output];
    return equalized;
    
}

- (UIImage*) processFilter:(UIImage*)src{
    
    ImageProcessor processor;
    cv::Mat source=[src CVGrayscaleMat];
    cv::Mat output=processor.filterMedianSmoot(source);
    UIImage *filtered=[UIImage imageWithCVMat:output];
    return filtered;
    
}

- (UIImage*) processBinarize:(UIImage*)src{
    
    ImageProcessor processor;
    cv::Mat source=[src CVGrayscaleMat];
    cv::Mat output=processor.binarize(source);
    UIImage *binarized=[UIImage imageWithCVMat:output];
    return binarized;
}

@end
