//
//  ViewController.m
//  Tesseract BizScanner
//
//  Created by Abhilash S T P on 3/26/14.
//  Copyright (c) 2014 Abhilash S T P. All rights reserved.
//

#import "ViewController.h"
#import "ContactsViewController.h"
#import "ImageProcessingImplementation.h"
#import "TestViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
//    self.navigationItem.leftBarButtonItem.title = @"\u2699";
//    UIFont *customFont = [UIFont fontWithName:@"Helvetica" size:24.0];
//    NSDictionary *fontDictionary = @{NSFontAttributeName : customFont};
//    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:fontDictionary forState:UIControlStateNormal];
    
    //self.navigationController.navigationBar.backgroundColor = [UIColor darkTextColor];
    //self.view.backgroundColor = [UIColor colorWithRed:128/255.0f green:128/255.0f blue:128/255.0f alpha:1.0];
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0f green:219/255.0f blue:76/255.0f alpha:1.0];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
//    
//    
//    Tesseract* tesseract = [[Tesseract alloc] initWithLanguage:@"eng"];
//    tesseract.delegate = self;
//    
//    //[tesseract setVariableValue:@"0123456789" forKey:@"tessedit_char_whitelist"]; //limit search
//    [tesseract setImage:[UIImage imageNamed:@"3.jpg"]]; //image to check
//    
//    [tesseract recognize];
//    
//    NSLog(@"%@", [tesseract recognizedText]);
//    
//    tesseract = nil; //deallocate and free all memory
    self.imageProcessor = [[ImageProcessingImplementation alloc]init];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)accessPhotos:(id)sender {
    UIImagePickerController *imgPicker = [UIImagePickerController new];
    imgPicker.delegate = self;
    imgPicker.allowsEditing = YES;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
         imgPicker.navigationBar.tintColor = [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0];
      
    //imgPicker.navigationItem.rightBarButtonItem.tintColor = [UIColor grayColor];
        [self presentViewController:imgPicker animated:YES completion:nil];
    }

}

- (IBAction)openCamera:(id)sender {
    NSLog(@"Boom Camera Opened!");
    UIImagePickerController *imgPicker = [UIImagePickerController new];
    imgPicker.delegate = self;
    //imgPicker.allowsEditing = YES;
   
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imgPicker.navigationBar.tintColor = [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0];
        
//        imgPicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
//        imgPicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
//        imgPicker.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:imgPicker animated:YES completion:nil];
    }
}

- (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(UIImage *)resizeImage:(UIImage *)image {
    
	CGImageRef imageRef = [image CGImage];
	CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);
	CGColorSpaceRef colorSpaceInfo = CGColorSpaceCreateDeviceRGB();
    
	if (alphaInfo == kCGImageAlphaNone)
		alphaInfo = kCGImageAlphaNoneSkipLast;
    
	int width, height;
    
	width = 640;//[image size].width;
	height = 640;//[image size].height;
    
	CGContextRef bitmap;
    
	if (image.imageOrientation == UIImageOrientationUp | image.imageOrientation == UIImageOrientationDown) {
		bitmap = CGBitmapContextCreate(NULL, width, height, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, alphaInfo);
        
	} else {
		bitmap = CGBitmapContextCreate(NULL, height, width, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, alphaInfo);
        
	}
    
	if (image.imageOrientation == UIImageOrientationLeft) {
		NSLog(@"image orientation left");
		CGContextRotateCTM(bitmap, 90);
		CGContextTranslateCTM (bitmap, 0, -height);
        
	} else if (image.imageOrientation == UIImageOrientationRight) {
		NSLog(@"image orientation right");
		CGContextRotateCTM (bitmap, -90);
		CGContextTranslateCTM (bitmap, -width, 0);
        
	} else if (image.imageOrientation == UIImageOrientationUp) {
		NSLog(@"image orientation up");
        
	} else if (image.imageOrientation == UIImageOrientationDown) {
		NSLog(@"image orientation down");
		CGContextTranslateCTM (bitmap, width,height);
		CGContextRotateCTM (bitmap, -180);
        
	}
    
	CGContextDrawImage(bitmap, CGRectMake(0, 0, width, height), imageRef);
	CGImageRef ref = CGBitmapContextCreateImage(bitmap);
	UIImage *result = [UIImage imageWithCGImage:ref];
    
	CGContextRelease(bitmap);
	CGImageRelease(ref);
    
	return result;	
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
   
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    //chosenImage = [self imageWithImage:chosenImage scaledToSize:CGSizeMake(320, 320)];
//        NSMutableArray *tmpImages = [NSMutableArray arrayWithArray:self.resultViews];
//        [tmpImages addObjectsFromArray:@[chosenImage]];
//        self.resultViews = tmpImages;
//    for(UIImageView *imageView in self.resultViews)
//    {
//        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10,150,300)];
//        imgView.image = imageView.image;
//        [self.view addSubview:imgView];
//        
//    }
//    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20,200,300)];
//    imgView.image = chosenImage;
//    imgView.userInteractionEnabled = YES;
//    
//    [self.view addSubview:imgView];
//    UIImageView *firstImageView = (UIImageView *)self.resultViews.firstObject;
//    CGFloat xPos = firstImageView.frame.origin.x;
//    CGFloat yPos = firstImageView.frame.origin.x;
//    CGFloat width = firstImageView.frame.size.width;
//    CGFloat height = firstImageView.frame.size.height;
    
//    for (int i = 1;i<sef.resultViews.count;i++)
//    {
//        
//    }
//    for(UIImageView *imageView in self.resultViews)
//    {
//      UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, yPos,width,height)];
//        imageView.image = chosenImage;
//        
//    }
//

//    imageView.image = chosenImage;
//
//
//    [self.view addSubview:imageView];
    [picker dismissViewControllerAnimated:YES completion:^{
//        ContactsViewController *contactVC = [[ContactsViewController alloc] init];
//        //UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:contactVC];
//        [self presentViewController:contactVC animated:YES completion:nil];
      

        ContactsViewController *contact = [[ContactsViewController alloc]init];
        
        ABNewPersonViewController *newPerson = [[ABNewPersonViewController alloc]init];
        newPerson.newPersonViewDelegate = self;
        NSString *totalString = [self processOCR:chosenImage];
        NSLog(@"%@",totalString);
        NSArray *regularExpressionCollectionValues = @[@"[A-Z]+ [A-Z]+",@"[P|p][h|H][o|O][n|N][e|E][ ]*[(\\d)]+[ ]+[\\d-]+",@"[F|f][a|A][x|X][ ]*[(\\d)]+[ ]+[\\d-]+",@"[a-zA-Z]+_[a-zA-Z]+@[a-z]+.[a-z]{3}",@"([w]{3})+.[a-zA-Z]+.[a-z]{3}"];
        //NSArray *regularExpressionCollectionKeys = @[@"phone",@"fax"];
        //NSMutableDictionary *contactDataRegEx = [NSMutableDictionary dictionaryWithObjects:regularExpressionCollectionValues forKeys:regularExpressionCollectionKeys];
        NSMutableArray *contactData =  [[NSMutableArray alloc]init];
        for(NSString *regexValue in regularExpressionCollectionValues)
        {
            NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regexValue options:nil error:NULL];
            
            NSTextCheckingResult *match = [regularExpression firstMatchInString:totalString options:0 range:NSMakeRange(0, [totalString length])];
            // [match rangeAtIndex:1] gives the range of the group in parentheses
            [contactData addObject:[totalString substringWithRange:[match rangeAtIndex:0]]];// gives the first captured group in this example
        }

        ABRecordRef newRecord = [contact newContact:contactData];
        [newPerson setDisplayedPerson:newRecord];
        CFRelease(newRecord);
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:newPerson];
        //navController.navigationItem.rightBarButtonItem. = @"Save";
        
        [self presentViewController:navController animated:YES completion:nil];
        
    }];
    
}
-(NSString *)processOCR:(UIImage *)image
{
        Tesseract* tesseract = [[Tesseract alloc] initWithLanguage:@"eng"];
        tesseract.delegate = self;
    
        [tesseract setVariableValue:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@_.(),-&/" forKey:@"tessedit_char_whitelist"];
        [tesseract setImage:image]; //image to check
    
        [tesseract recognize];
    
        return [tesseract recognizedText];
    
        tesseract = nil; //deallocate and free all memory
//
//    ImageProcessingImplementation* tesseract = [[ImageProcessingImplementation alloc] initWithLanguage:@"eng"];
//    tesseract.delegate = self;
//    
//    [tesseract setVariableValue:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@_.(),-&/" forKey:@"tessedit_char_whitelist"]; //limit search
//    
//    
//    [tesseract setImage:[tesseract processImage:image]];
//    // [tesseract recognize];
    return [tesseract recognizedText];

}
-(void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person
{
    if (person) {
        CFErrorRef error = nil;
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(nil, &error);
        ABAddressBookAddRecord(addressBook, person, nil);
        ABAddressBookSave(addressBook, nil);
        CFRelease(addressBook);
    }
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
@end
