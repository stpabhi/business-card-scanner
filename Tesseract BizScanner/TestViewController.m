//
//  TestViewController.m
//  Tesseract BizScanner
//
//  Created by Abhilash S T P on 4/4/14.
//  Copyright (c) 2014 Abhilash S T P. All rights reserved.
//

#import "TestViewController.h"
#import "ImageProcessingImplementation.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageProcessor = [[ImageProcessingImplementation alloc]init];
    //[self OCRBaby];
    // Do any additional setup after loading the view.
}

- (void)OCRBaby
{
    ImageProcessingImplementation* tesseract = [[ImageProcessingImplementation alloc] initWithLanguage:@"eng"];
    tesseract.delegate = self;
    
    [tesseract setVariableValue:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@_.(),-&/" forKey:@"tessedit_char_whitelist"]; //limit search
    
    //[tesseract setImage:src]; //image to check
    UIImage *image = [UIImage imageNamed:@"5.jpg"];
//    UIImage *result = [self.imageProcessor processFilter:image];
//    result = [self.imageProcessor processHistogram:result];
    self.resultView.image = [tesseract contoursImage:image];
    //self.resultView.image = image;
    [tesseract setImage:self.resultView.image];
    // [tesseract recognize];
    NSLog(@"_totalText.text=%@", [tesseract recognizedText]);
    NSString *_n = [NSString stringWithFormat:@"_totalText.text= %@", [tesseract recognizedText]];
    NSArray *n = [_n componentsSeparatedByString:@"-"];
    NSLog(@"%@",n);
    NSLog(@"%@",n[0]);
    NSLog(@"%@",n[2]);
    NSLog(@"%@",n[8]);
    NSLog(@"%@",n[9]);
    NSLog(@"%@",n[10]);
    
    tesseract = nil; //deallocate and free all memory
    
  // NSLog(@"%@",[self.imageProcessor OCRImage:src]);
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)rotate:(id)sender {
    self.processedImage = [self.imageProcessor processRotation:[UIImage imageNamed:@"6.jpg"]];
    self.resultView.image=[self processedImage];
    //[self OCRBaby:self.processedImage];
}

- (IBAction)histogram:(id)sender {
    self.processedImage = [self.imageProcessor processHistogram:[UIImage imageNamed:@"4.jpg"]];
    self.resultView.image=[self processedImage];
    //[self OCRBaby:self.processedImage];
}

- (IBAction)filter:(id)sender {
    self.processedImage = [self.imageProcessor processFilter:[UIImage imageNamed:@"4.jpg"]];
    self.resultView.image=[self processedImage];
    NSLog(@"%@",[self.imageProcessor OCRImage:self.processedImage]);
   
}

- (IBAction)binarize:(id)sender {
    self.processedImage = [self.imageProcessor processBinarize:[UIImage imageNamed:@"4.jpg"]];
    self.resultView.image=[self processedImage];
    //[self OCRBaby:self.processedImage];
}
@end
