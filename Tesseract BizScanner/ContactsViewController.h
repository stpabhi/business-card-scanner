//
//  ContactsViewController.h
//  Tesseract BizScanner
//
//  Created by Abhilash S T P on 4/7/14.
//  Copyright (c) 2014 Abhilash S T P. All rights reserved.
//

#import <UIKit/UIKit.h>
@import AddressBook;
@import AddressBookUI;
@interface ContactsViewController : UIViewController
- (IBAction)saveNewContact:(id)sender;
- (IBAction)cancelContact:(id)sender;
- (ABRecordRef)newContact:(NSMutableArray *)contactData;
@end
