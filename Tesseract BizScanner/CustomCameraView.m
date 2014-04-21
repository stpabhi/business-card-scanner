//
//  CustomCameraView.m
//  Tesseract BizScanner
//
//  Created by Abhilash S T P on 4/16/14.
//  Copyright (c) 2014 Abhilash S T P. All rights reserved.
//

#import "CustomCameraView.h"

@implementation CustomCameraView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //clear the background color of the overlay
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        self.frame = frame;
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    
    //sets the current graphics context to CGContextRef object
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //sets line width to 2.0f
    CGContextSetLineWidth(context, 2.0);
    
    //creates a rectangle with the specified co-ordinates and assigns to the rectangle object
    CGRect rectangle = CGRectMake(50,100, 220, 380);
    
    //Adds a rectangle to the current path
    CGContextAddRect(context, rectangle);
    //Sets fill color to yellow-gold
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.0f].CGColor);
//    //sets the stroke colot to black
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:255/255.0f green:219/255.0f blue:76/255.0f alpha:1.0].CGColor);
    //draws the current path i.e. rectangle
    CGContextDrawPath(context, kCGPathFillStroke);
}
@end
