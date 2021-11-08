//
//  CustomImagePickerController.m
//  Tesseract BizScanner
//
//  Created by Abhilash S T P on 4/16/14.
//  Copyright (c) 2014 Abhilash S T P. All rights reserved.
//

#import "CustomImagePickerController.h"
#import "ContactsViewController.h"
#import "CustomCameraView.h"
#import "ViewController.h"


@interface CustomImagePickerController ()

@end

@implementation CustomImagePickerController

-(id)init
{
    self = [super init];
    if(self)
    {
        _activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityIndicator.center = self.view.center;
        
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

@end
