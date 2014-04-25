//
//  DetailSettingsViewController.m
//  Tesseract BizScanner
//
//  Created by Abhilash S T P on 4/4/14.
//  Copyright (c) 2014 Abhilash S T P. All rights reserved.
//

#import "DetailSettingsViewController.h"

@interface DetailSettingsViewController ()

@end

@implementation DetailSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSString *path;
    if([self.navigationItem.title isEqualToString:@"About"])
    {
        path = [[NSBundle mainBundle] pathForResource:@"license" ofType:@"rtf"];
    }
    else if([self.navigationItem.title isEqualToString:@"FAQ"])
    {
        path = [[NSBundle mainBundle] pathForAuxiliaryExecutable:@"faq.rtf"];
    }
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:path];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:fileURL];
    [self.detailSettingsText loadRequest:requestObj];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.detailSettingsText.delegate = self;
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
