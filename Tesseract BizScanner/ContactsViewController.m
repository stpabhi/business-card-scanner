//
//  ContactsViewController.m
//  Tesseract BizScanner
//
//  Created by Abhilash S T P on 4/7/14.
//  Copyright (c) 2014 Abhilash S T P. All rights reserved.
//

#import "ContactsViewController.h"

@interface ContactsViewController ()

@end

@implementation ContactsViewController

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
- (ABRecordRef)newContact:(NSMutableArray *)contactData
{
    CFErrorRef error = nil;
    ABAddressBookRef iPhoneAddressBook = ABAddressBookCreateWithOptions(nil, &error);

    ABRecordRef newPerson = ABPersonCreate();
    ABMutableMultiValueRef phoneNumberMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    NSRegularExpression *regularExpression = nil;
    NSTextCheckingResult *match = nil;
    for(int i=0;i<contactData.count;i++)
    {
        
        switch (i) {
            case 0:
            {
                NSLog(@"%@",contactData[i]);
                NSArray *names = [contactData[i] componentsSeparatedByString:@" "];
                ABRecordSetValue(newPerson, kABPersonFirstNameProperty,(__bridge CFStringRef)names[0], &error);
                ABRecordSetValue(newPerson, kABPersonLastNameProperty,(__bridge CFStringRef)names[1], &error);
                break;
            }
            case 1:
            {
                NSLog(@"%@",contactData[i]);
                regularExpression = [NSRegularExpression regularExpressionWithPattern:@"[(\\d)]+[ ]+[\\d-]+" options:NSRegularExpressionCaseInsensitive error:NULL];
                match = [regularExpression firstMatchInString:contactData[i] options:0 range:NSMakeRange(0, [contactData[i] length])];
                NSString *phoneNumber = [contactData[i] substringWithRange:[match rangeAtIndex:0]];
                ABMultiValueAddValueAndLabel(phoneNumberMultiValue, (__bridge CFTypeRef)(phoneNumber),kABWorkLabel,NULL);
                break;
            }
            case 2:
            {
                NSLog(@"%@",contactData[i]);
                regularExpression = [NSRegularExpression regularExpressionWithPattern:@"[(\\d)]+[ ]+[\\d-]+" options:NSRegularExpressionCaseInsensitive error:NULL];
                
                match = [regularExpression firstMatchInString:contactData[i] options:0 range:NSMakeRange(0, [contactData[i] length])];
                NSString *faxNumber = [contactData[i] substringWithRange:[match rangeAtIndex:0]];
                
                ABMultiValueAddValueAndLabel(phoneNumberMultiValue, (__bridge CFTypeRef)(faxNumber), kABPersonPhoneWorkFAXLabel, NULL);
                break;
            }
            case 3:
            {
                NSLog(@"%@",contactData[i]);
                regularExpression = [NSRegularExpression regularExpressionWithPattern:@"[a-zA-Z]+_[a-zA-Z]+@[a-z]+.[a-z]{3}" options:NSRegularExpressionCaseInsensitive error:NULL];
                
                match = [regularExpression firstMatchInString:contactData[i] options:0 range:NSMakeRange(0, [contactData[i] length])];
                NSString *email = [contactData[i] substringWithRange:[match rangeAtIndex:0]];
                ABMutableMultiValueRef emailMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
                ABMultiValueAddValueAndLabel(emailMultiValue, (__bridge CFTypeRef)(email), kABWorkLabel, NULL);
                ABRecordSetValue(newPerson, kABPersonEmailProperty,emailMultiValue, &error);
                break;
            }
            case 4:
            {
                NSLog(@"%@",contactData[i]);
                regularExpression = [NSRegularExpression regularExpressionWithPattern:@"[([w]{3})+.[a-zA-Z]+.[a-z]{3}" options:NSRegularExpressionCaseInsensitive error:NULL];
                
                match = [regularExpression firstMatchInString:contactData[i] options:0 range:NSMakeRange(0, [contactData[i] length])];
                NSString *url = [contactData[i] substringWithRange:[match rangeAtIndex:0]];
                ABMutableMultiValueRef urlMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
                ABMultiValueAddValueAndLabel(urlMultiValue, (__bridge CFTypeRef)(url), kABPersonHomePageLabel, NULL);
                ABRecordSetValue(newPerson, kABPersonURLProperty,urlMultiValue, &error);
                break;
            }
            default:
                break;
        }
        
    }
        
//        else if([addressFields rangeOfString:@"Phone" options:NSCaseInsensitiveSearch].location != NSNotFound)
//        {
//            NSLog(@"%@",addressFields);
//            NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"[(\\d)]+[ ]+[\\d-]+" options:NSRegularExpressionCaseInsensitive error:NULL];
//            
//            NSTextCheckingResult *match = [regularExpression firstMatchInString:addressFields options:0 range:NSMakeRange(0, [addressFields length])];
//            NSString *phoneNumber = [addressFields substringWithRange:[match rangeAtIndex:0]];
//            
//            
//            ABMultiValueAddValueAndLabel(phoneNumberMultiValue, (__bridge CFTypeRef)(phoneNumber), kABPersonPhoneMobileLabel, NULL);
//
//        }
//        else if ([addressFields rangeOfString:@"Fax" options:NSCaseInsensitiveSearch].location != NSNotFound)
//        {
//            NSLog(@"%@",addressFields);
//            NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"[(\\d)]+[ ]+[\\d-]+" options:NSRegularExpressionCaseInsensitive error:NULL];
//            
//            NSTextCheckingResult *match = [regularExpression firstMatchInString:addressFields options:0 range:NSMakeRange(0, [addressFields length])];
//            NSString *faxNumber = [addressFields substringWithRange:[match rangeAtIndex:0]];
//            
//            ABMultiValueAddValueAndLabel(phoneNumberMultiValue, (__bridge CFTypeRef)(faxNumber), kABPersonPhoneWorkFAXLabel, NULL);
//          
//        }
//        else if ([addressFields rangeOfString:@"@" options:NSCaseInsensitiveSearch].location != NSNotFound)
//        {
//            NSLog(@"%@",addressFields);
//            NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"[a-zA-Z]+_[a-zA-Z]+@[a-z]+.[a-z]{3}" options:NSRegularExpressionCaseInsensitive error:NULL];
//            
//            NSTextCheckingResult *match = [regularExpression firstMatchInString:addressFields options:0 range:NSMakeRange(0, [addressFields length])];
//            NSString *email = [addressFields substringWithRange:[match rangeAtIndex:0]];
//            ABMutableMultiValueRef emailMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
//            ABMultiValueAddValueAndLabel(emailMultiValue, (__bridge CFTypeRef)(email), kABWorkLabel, NULL);
//            ABRecordSetValue(newPerson, kABPersonEmailProperty,emailMultiValue, &error);
//        }
    //}
    
    ABRecordSetValue(newPerson, kABPersonPhoneProperty,phoneNumberMultiValue, &error);

    //ABRecordSetValue(newPerson, kABPersonFirstNameProperty,(__bridge CFStringRef)name, &error);
    //ABRecordSetValue(newPerson, kABPersonLastNameProperty, people.lastname, &error);
    //ABAddressBookAddRecord(iPhoneAddressBook, newPerson, &error);
    
   
    //CFRelease(newPerson);
    CFRelease(iPhoneAddressBook);
    
    return newPerson;

}
- (IBAction)saveNewContact:(id)sender {
    NSLog(@"boom");
    CFErrorRef error = nil;
    ABAddressBookRef iPhoneAddressBook = ABAddressBookCreateWithOptions(nil, &error);
    if (nil == iPhoneAddressBook) {
        NSLog(@"error: %@", error);
        return;
    }
    ABAuthorizationStatus stat = ABAddressBookGetAuthorizationStatus();
    if (stat==kABAuthorizationStatusDenied ||
        stat==kABAuthorizationStatusRestricted) {
        NSLog(@"%@", @"no access");
        return;
    }
    
    ABRecordRef newPerson = ABPersonCreate();
    
    ABRecordSetValue(newPerson, kABPersonFirstNameProperty, CFSTR("Boom"), &error);
    //ABRecordSetValue(newPerson, kABPersonLastNameProperty, people.lastname, &error);
    ABAddressBookAddRecord(iPhoneAddressBook, newPerson, &error);

    ABAddressBookSave(iPhoneAddressBook, &error);
    CFRelease(newPerson);
    CFRelease(iPhoneAddressBook);
    if (error != NULL)
    {
        CFStringRef errorDesc = CFErrorCopyDescription(error);
        NSLog(@"Contact not saved: %@", errorDesc);
        CFRelease(errorDesc);
    }
}

- (IBAction)cancelContact:(id)sender {
}
@end
