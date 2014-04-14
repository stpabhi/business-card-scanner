//
//  GeneralContours.cpp
//  Tesseract BizScanner
//
//  Created by Abhilash S T P on 4/5/14.
//  Copyright (c) 2014 Abhilash S T P. All rights reserved.
//

#import "GeneralContours.h"
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/imgproc/imgproc.hpp"
#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#import "UIImage+OpenCV.h"
using namespace cv;
using namespace std;

Mat src; Mat src_gray;
int thresh = 100;
int max_thresh = 255;
RNG rng(12345);

@implementation GeneralContours
void findX(IplImage* imgSrc,int* min, int* max){
    int i;
    int minFound=0;
    CvMat data;
    CvScalar maxVal=cvRealScalar(imgSrc->width * 255);
    CvScalar val=cvRealScalar(0);
    //For each col sum, if sum < width*255 then we find the min
    //then continue to end to search the max, if sum< width*255 then is new max
    for (i=0; i< imgSrc->width; i++){
        cvGetCol(imgSrc, &data, i);
        val= cvSum(&data);
        if(val.val[0] < maxVal.val[0]){
            *max= i;
            if(!minFound){
                *min= i;
                minFound= 1;
            }
        }
    }
}

void findY(IplImage* imgSrc,int* min, int* max){
    int i;
    int minFound=0;
    CvMat data;
    CvScalar maxVal=cvRealScalar(imgSrc->width * 255);
    CvScalar val=cvRealScalar(0);
    //For each col sum, if sum < width*255 then we find the min
    //then continue to end to search the max, if sum< width*255 then is new max
    for (i=0; i< imgSrc->height; i++){
        cvGetRow(imgSrc, &data, i);
        val= cvSum(&data);
        if(val.val[0] < maxVal.val[0]){
            *max=i;
            if(!minFound){
                *min= i;
                minFound= 1;
            }
        }
    }
}
CvRect findBB(IplImage* imgSrc){
    CvRect aux;
    int xmin, xmax, ymin, ymax;
    xmin=xmax=ymin=ymax=0;
    
    findX(imgSrc, &xmin, &xmax);
    findY(imgSrc, &ymin, &ymax);
    
    aux=cvRect(xmin, ymin, xmax-xmin, ymax-ymin);
    
    //printf("BB: %d,%d - %d,%d\n", aux.x, aux.y, aux.width, aux.height);
    
    return aux;
    
}

IplImage preprocessing(IplImage* imgSrc,int new_width, int new_height)
{
    IplImage* result;
    IplImage* scaledResult;
    
    CvMat data;
    CvMat dataA;
    CvRect bb;//bounding box
    CvRect bba;//boundinb box maintain aspect ratio
    
    //Find bounding box
    bb=findBB(imgSrc);
    
    //Get bounding box data and no with aspect ratio, the x and y can be corrupted
    cvGetSubRect(imgSrc, &data, cvRect(bb.x, bb.y, bb.width, bb.height));
    //Create image with this data with width and height with aspect ratio 1
    //then we get highest size betwen width and height of our bounding box
    int size=(bb.width>bb.height)?bb.width:bb.height;
    result=cvCreateImage( cvSize( size, size ), 8, 1 );
    cvSet(result,CV_RGB(255,255,255),NULL);
    //Copy de data in center of image
    int x=(int)floor((float)(size-bb.width)/2.0f);
    int y=(int)floor((float)(size-bb.height)/2.0f);
    cvGetSubRect(result, &dataA, cvRect(x,y,bb.width, bb.height));
    cvCopy(&data, &dataA, NULL);
    //Scale result
    scaledResult=cvCreateImage( cvSize( new_width, new_height ), 8, 1 );
    cvResize(result, scaledResult, CV_INTER_NN);
    
    //Return processed data
    return *scaledResult;
    
}

cv::Point2f computeIntersect(cv::Vec4i a, cv::Vec4i b)
{
    int x1 = a[0], y1 = a[1], x2 = a[2], y2 = a[3];
    int x3 = b[0], y3 = b[1], x4 = b[2], y4 = b[3];
    if (float d = ((float)(x1-x2) * (y3-y4)) - ((y1-y2) * (x3-x4)))
    {
        cv::Point2f pt;
        pt.x = ((x1*y2 - y1*x2) * (x3-x4) - (x1-x2) * (x3*y4 - y3*x4)) / d;
        pt.y = ((x1*y2 - y1*x2) * (y3-y4) - (y1-y2) * (x3*y4 - y3*x4)) / d;
        //-10 is a threshold, the POI can be off by at most 10 pixels
        if(pt.x<min(x1,x2)-10||pt.x>max(x1,x2)+10||pt.y<min(y1,y2)-10||pt.y>max(y1,y2)+10){
            return Point2f(-1,-1);
        }
        if(pt.x<min(x3,x4)-10||pt.x>max(x3,x4)+10||pt.y<min(y3,y4)-10||pt.y>max(y3,y4)+10){
            return Point2f(-1,-1);
        }
        return pt;
    }
    else
        return cv::Point2f(-1, -1);
}
bool comparator(Point2f a,Point2f b){
    return a.x<b.x;
}
void sortCorners(std::vector<cv::Point2f>& corners, cv::Point2f center)
{
    std::vector<cv::Point2f> top, bot;
    for (int i = 0; i < corners.size(); i++)
    {
        if (corners[i].y < center.y)
            top.push_back(corners[i]);
        else
            bot.push_back(corners[i]);
    }
    sort(top.begin(),top.end(),comparator);
    sort(bot.begin(),bot.end(),comparator);
    cv::Point2f tl = top[0];
    cv::Point2f tr = top[top.size()-1];
    cv::Point2f bl = bot[0];
    cv::Point2f br = bot[bot.size()-1];
    corners.clear();
    corners.push_back(tl);
    corners.push_back(tr);
    corners.push_back(br);
    corners.push_back(bl);
}
-(UIImage *)initializeImage:(UIImage *)cvMat
{
    cv::Mat img = [cvMat CVGrayscaleMat];
    cv::Size size = img.size();
    
    cv::bitwise_not(img, img);
    
    std::vector<cv::Vec4i> lines;
    
    cv::HoughLinesP(img, lines, 1, CV_PI/180, 100, size.width/2.f,20);
    
    cv::Mat disp_lines(size, CV_8UC1, cv::Scalar(0, 0, 0));
    double angle = 0.;
    unsigned nb_lines = lines.size();
    for (unsigned i = 0; i < nb_lines; ++i)
    {
        cv::line(disp_lines, cv::Point(lines[i][0], lines[i][1]),
                 cv::Point(lines[i][2], lines[i][3]), cv::Scalar(255, 0 ,0));
        angle += atan2((double)lines[i][3] - lines[i][1],
                       (double)lines[i][2] - lines[i][0]);
    }
    angle /= nb_lines; // mean angle, in radians.
    
    std::cout << angle * 180 / CV_PI << std::endl;
    
    cv::bitwise_not(disp_lines,disp_lines);
    
    std::vector<cv::Point> points;
    cv::Mat_<uchar>::iterator it = disp_lines.begin<uchar>();
    cv::Mat_<uchar>::iterator end = disp_lines.end<uchar>();
    for (; it != end; ++it)
        if (*it)
            points.push_back(it.pos());
    
    cv::RotatedRect box = cv::minAreaRect(cv::Mat(points));
    cv::Mat rot_mat = cv::getRotationMatrix2D(box.center, angle, 1);
    cv::Mat rotated;
    cv::warpAffine(img, rotated, rot_mat, img.size(), cv::INTER_CUBIC);
    
    cv::Size box_size = box.size;
    if (box.angle < -45.)
        std::swap(box_size.width, box_size.height);
    cv::Mat cropped;
    cv::getRectSubPix(rotated, box_size, box.center, cropped);
    
    return [UIImage imageWithCVMat:cropped];
}
- (cv::Mat)cvMatFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels (color channels + alpha)
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}

-(UIImage *)UIImageFromCVMat:(cv::Mat)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //bits per pixel
                                        cvMat.step[0],                            //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );
    
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}
@end