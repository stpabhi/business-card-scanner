//
//  SettingsTableViewController.h
//  Tesseract BizScanner
//
//  Created by Abhilash S T P on 4/4/14.
//  Copyright (c) 2014 Abhilash S T P. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TesseractSettingsModel.h"
@import MessageUI;
@interface SettingsTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate,MFMailComposeViewControllerDelegate>
- (IBAction)dismissSettingsViewController:(id)sender;
@end
