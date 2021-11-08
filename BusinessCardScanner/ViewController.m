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
#import "CustomImagePickerController.h"
#import "CustomCameraView.h"
#import "PhotoCell.h"
#import "AppDelegate.h"
//transform values for full screen support
#define CAMERA_TRANSFORM_X 1
#define CAMERA_TRANSFORM_Y 1.12412
//iphone screen dimensions
#define SCREEN_WIDTH  320
#define SCREEN_HEIGTH 481

@interface ViewController ()
@property CustomImagePickerController *customVC;
@property NSInteger assetCount;
@end

@implementation ViewController

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    delegate.contactDataStorage = self.collectionViewCellTag;
    delegate.collectionView = self.collectionView;
    delegate.delegateAssets = self.assetCount;
}
- (void)viewWillAppear:(BOOL)animated
{
    _assets = [@[] mutableCopy];
    __block NSMutableArray *tmpAssets = [@[] mutableCopy];
    // 1
    ALAssetsLibrary *assetsLibrary = [ViewController defaultAssetsLibrary];
    // 2
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if ([@"Tesseract" compare: [group valueForProperty:ALAssetsGroupPropertyName]]==NSOrderedSame) {
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if(result)
                {
                    // 3
                    [tmpAssets addObject:result];
                }
            }];
        }
        // 4
        //NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
        //self.assets = [tmpAssets sortedArrayUsingDescriptors:@[sort]];
        self.assets = tmpAssets;
        
        // 5
        [self.collectionView reloadData];
    } failureBlock:^(NSError *error) {
        NSLog(@"Error loading images %@", error);
    }];
    self.assetCount = self.assets.count;
    NSLog(@"%d",self.collectionViewCellTag.count);
    [self viewAppeared];
}

- (void)viewAppeared
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:self.collectionViewCellTag forKey:@"contactDataStorage"];
            [defaults setInteger:self.assetCount forKey:@"assetCount"];
            [defaults synchronize];
}
+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.starterText.text = @"Tap to Scan";
    self.customVC = [[CustomImagePickerController alloc]init];
    //self.imageProcessor = [[ImageProcessingImplementation alloc]init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"asset count %d",self.assetCount);
    if([defaults objectForKey:@"contactDataStorage"] != nil)
    {
        self.collectionViewCellTag = [defaults objectForKey:@"contactDataStorage"];
        NSLog(@"Loaded data %@",self.collectionViewCellTag);
    }
//    else
//    self.collectionViewCellTag = [[NSMutableArray alloc]init];
}
#pragma mark - collection view data source

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.assets.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCell *cell = (PhotoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    
    ALAsset *asset = self.assets[indexPath.row];
    cell.asset = asset;
//    self.assetCount = self.assets.count;
    [self viewAppeared];
    return cell;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 4;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}

#pragma mark - collection view delegate

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    ALAsset *asset = self.assets[indexPath.row];
//    ALAssetRepresentation *defaultRep = [asset defaultRepresentation];
    //UIImage *image = [UIImage imageWithCGImage:[defaultRep fullScreenImage] scale:[defaultRep scale] orientation:0];
    // Do something with the image
     PhotoCell *cell = (PhotoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    cell.textLabel.hidden = YES;
    cell.textLabel.text = [self.collectionViewCellTag objectAtIndex:indexPath.row];
    NSLog(@"cell phone number %@",[self.collectionViewCellTag objectAtIndex:indexPath.row]);
    
    ABPersonViewController *picker = [[ABPersonViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:picker];
    picker.personViewDelegate = self;
    picker.displayedPerson = (__bridge ABRecordRef)([self findNameForContactWithPhoneNumber:cell.textLabel.text]);
    picker.displayedProperties = [NSArray arrayWithObjects: [NSNumber numberWithInt:kABPersonPhoneProperty], nil];
    picker.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel",nil) style:UIBarButtonItemStylePlain target:self action:@selector(ReturnFromPersonView:)];
    [self presentViewController:navController animated:YES completion:nil];
}

-(void)ReturnFromPersonView:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)accessPhotos:(id)sender {
    self.customVC = [[CustomImagePickerController alloc]init];
    self.customVC.delegate = self;
    self.customVC.allowsEditing = YES;
    
    if([CustomImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        [self presentViewController:self.customVC animated:YES completion:nil];
    }

}

- (IBAction)openCamera:(id)sender {
    //CustomImagePickerController *customVC = [[CustomImagePickerController alloc]init];
    self.customVC.delegate = self;
    
    if([CustomImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        self.customVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        //self.showsCameraControls = NO;
        //customVC.navigationBarHidden = YES;
        //customVC.toolbarHidden = YES;
        self.customVC.allowsEditing = YES;
        
        //self.wantsFullScreenLayout = YES;
//        customVC.cameraViewTransform =
//        CGAffineTransformScale(customVC.cameraViewTransform,
//                               CAMERA_TRANSFORM_X,
//                               CAMERA_TRANSFORM_Y);
        
        CustomCameraView *overlay = [[CustomCameraView alloc]
                                     initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGTH)];
        //set our custom overlay view
        self.customVC.cameraOverlayView = overlay;
        [self presentViewController:self.customVC animated:YES completion:nil];
    }
}

//- (UIImage*)imageWithImage:(UIImage*)image
//              scaledToSize:(CGSize)newSize;
//{
//    UIGraphicsBeginImageContext( newSize );
//    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
//    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    return newImage;
//}
//
//-(UIImage *)resizeImage:(UIImage *)image {
//    
//	CGImageRef imageRef = [image CGImage];
//	CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);
//	CGColorSpaceRef colorSpaceInfo = CGColorSpaceCreateDeviceRGB();
//    
//	if (alphaInfo == kCGImageAlphaNone)
//		alphaInfo = kCGImageAlphaNoneSkipLast;
//    
//	int width, height;
//    
//	width = 640;//[image size].width;
//	height = 640;//[image size].height;
//    
//	CGContextRef bitmap;
//    
//	if (image.imageOrientation == UIImageOrientationUp | image.imageOrientation == UIImageOrientationDown) {
//		bitmap = CGBitmapContextCreate(NULL, width, height, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, alphaInfo);
//        
//	} else {
//		bitmap = CGBitmapContextCreate(NULL, height, width, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, alphaInfo);
//        
//	}
//    
//	if (image.imageOrientation == UIImageOrientationLeft) {
//		NSLog(@"image orientation left");
//		CGContextRotateCTM(bitmap, 90);
//		CGContextTranslateCTM (bitmap, 0, -height);
//        
//	} else if (image.imageOrientation == UIImageOrientationRight) {
//		NSLog(@"image orientation right");
//		CGContextRotateCTM (bitmap, -90);
//		CGContextTranslateCTM (bitmap, -width, 0);
//        
//	} else if (image.imageOrientation == UIImageOrientationUp) {
//		NSLog(@"image orientation up");
//        
//	} else if (image.imageOrientation == UIImageOrientationDown) {
//		NSLog(@"image orientation down");
//		CGContextTranslateCTM (bitmap, width,height);
//		CGContextRotateCTM (bitmap, -180);
//        
//	}
//    
//	CGContextDrawImage(bitmap, CGRectMake(0, 0, width, height), imageRef);
//	CGImageRef ref = CGBitmapContextCreateImage(bitmap);
//	UIImage *result = [UIImage imageWithCGImage:ref];
//    
//	CGContextRelease(bitmap);
//	CGImageRelease(ref);
//    
//	return result;	
//}
@synthesize library = _library;
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self.customVC.activityIndicator startAnimating];
    [self.customVC.view addSubview:self.customVC.activityIndicator];
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    //chosenImage = [self resizeImage:chosenImage];
//    CGRect cropRect = CGRectMake(50,100, 220, 380);
//    
//    CGImageRef imageRef = CGImageCreateWithImageInRect([chosenImage CGImage], cropRect);
//    chosenImage = [UIImage imageWithCGImage:imageRef];
    
         _library = [[ALAssetsLibrary alloc]init];
         [self.library saveImage:chosenImage toAlbum:@"Tesseract" withCompletionBlock:^(NSError *error) {
             if (error!=nil) {
                 NSLog(@"Big error: %@", [error description]);
             }
             
         
        ContactsViewController *contact = [[ContactsViewController alloc]init];
         
        ABNewPersonViewController *newPerson = [[ABNewPersonViewController alloc]init];
        newPerson.newPersonViewDelegate = self;
        NSString *totalString = [self processOCR:chosenImage];
        NSLog(@"%@",totalString);
        NSArray *regularExpressionCollectionValues = @[@"[A-Z]+ [A-Z]+",@"[(]?\\d{3}[-.)]? *\\d{3}[-.]? *\\d{4}",@"[a-zA-Z0-9]?[._a-zA-Z0-9]+@[a-z0-9]+.[a-z0-9]{3}",@"([w|W]{3})+.[a-zA-Z0-9]+.[a-zA-Z0-9]+"];
        //NSArray *regularExpressionCollectionKeys = @[@"phone",@"fax"];
        //NSMutableDictionary *contactDataRegEx = [NSMutableDictionary dictionaryWithObjects:regularExpressionCollectionValues forKeys:regularExpressionCollectionKeys];
        NSMutableArray *contactData =  [[NSMutableArray alloc]init];
        for(NSString *regexValue in regularExpressionCollectionValues)
        {
            NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regexValue options:0 error:NULL];
            if([regexValue isEqualToString:@"[(]?\\d{3}[-.)]? *\\d{3}[-.]? *\\d{4}"])
            {
            NSArray *matches = [regularExpression matchesInString:totalString options:0 range:NSMakeRange(0, [totalString length])];
            
            for(NSTextCheckingResult *match in matches)
            {
                [contactData addObject:[totalString substringWithRange:[match rangeAtIndex:0]]];
            }
            }
            else
            {
                NSTextCheckingResult *match = [regularExpression firstMatchInString:totalString options:0 range:NSMakeRange(0, [totalString length])];
            [contactData addObject:[totalString substringWithRange:[match rangeAtIndex:0]]];
            }
        }
        ABRecordRef newRecord = [contact newContact:contactData];
        [newPerson setDisplayedPerson:newRecord];
        CFRelease(newRecord);
             [self.customVC.activityIndicator stopAnimating];
             [picker dismissViewControllerAnimated:YES completion:^{
                 UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:newPerson];
                 //navController.navigationItem.rightBarButtonItem. = @"Save";
                 
                 [self presentViewController:navController animated:YES completion:nil];
             }];
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

}

- (id)findNameForContactWithPhoneNumber:(NSString *)phoneNumber {
    CFErrorRef error = nil;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(nil, &error);
    
    // Get all contacts in the addressbook
	NSArray *allPeople = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
    
	for (id person in allPeople) {
        // Get all phone numbers of a contact
        ABMultiValueRef phoneNumbers = ABRecordCopyValue((__bridge ABRecordRef)(person), kABPersonPhoneProperty);
        
        // If the contact has multiple phone numbers, iterate on each of them
        for (int i = 0; i < ABMultiValueGetCount(phoneNumbers); i++) {
            NSString *phone = (__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(phoneNumbers, i);
            
            // Remove all formatting symbols that might be in both phone number being compared
            NSCharacterSet *toExclude = [NSCharacterSet characterSetWithCharactersInString:@"/.()- "];
            phone = [[phone componentsSeparatedByCharactersInSet:toExclude] componentsJoinedByString: @""];
            phoneNumber = [[phoneNumber componentsSeparatedByCharactersInSet:toExclude] componentsJoinedByString: @""];
            
            if ([phone isEqualToString:phoneNumber]) {
//                NSString *firstName = (__bridge_transfer NSString*)ABRecordCopyValue((__bridge ABRecordRef)(person), kABPersonFirstNameProperty);
//                NSString *lastName = (__bridge_transfer NSString*)ABRecordCopyValue((__bridge ABRecordRef)(person), kABPersonLastNameProperty);
                return person;
                //return [NSString stringWithFormat:@"%@ %@", firstName, lastName];
            }
        }
    }
    
    return nil;
}

-(void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person
{
    if (person) {
        CFErrorRef error = nil;
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(nil, &error);
        ABAddressBookAddRecord(addressBook, person, nil);
        ABAddressBookSave(addressBook, nil);
        ABMultiValueRef numbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
        NSString *targetNumber = (__bridge NSString *) ABMultiValueCopyValueAtIndex(numbers, 0);
        if(self.collectionViewCellTag.count == 0)
        {
            self.collectionViewCellTag = [[NSMutableArray alloc]init];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:self.collectionViewCellTag forKey:@"contactDataStorage"];
            [defaults setInteger:self.assetCount forKey:@"assetCount"];
            [defaults synchronize];
            
        }
        [self.collectionViewCellTag addObject:targetNumber];
        NSLog(@"added %@",[self.collectionViewCellTag lastObject]);
        [self viewAppeared];
        CFRelease(addressBook);
    }
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
-(BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return YES;
}
@end
