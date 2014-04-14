//
//  TesseractSettingsModel.m
//  Tesseract BizScanner
//
//  Created by Abhilash S T P on 4/4/14.
//  Copyright (c) 2014 Abhilash S T P. All rights reserved.
//

#import "TesseractSettingsModel.h"

@implementation TesseractSettingsModel
-(instancetype)init
{
    self = [super init];
    if(self)
    {
        _settingsArray = @[@"About",@"FAQ",@"Contact us"];
    }
    return self;
}
@end
