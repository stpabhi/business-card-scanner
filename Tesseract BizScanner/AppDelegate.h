//
//  AppDelegate.h
//  Tesseract BizScanner
//
//  Created by Abhilash S T P on 3/26/14.
//  Copyright (c) 2014 Abhilash S T P. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TesseractSettingsModel.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property TesseractSettingsModel *settingsModel;
@end
