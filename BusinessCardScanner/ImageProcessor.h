//
//  ImageProcessor.h
//  Tesseract BizScanner
//
//  Created by Abhilash S T P on 4/4/14.
//  Copyright (c) 2014 Abhilash S T P. All rights reserved.
//

#ifndef Tesseract_BizScanner_ImageProcessor_h
#define Tesseract_BizScanner_ImageProcessor_h

class ImageProcessor {
    
    typedef struct{
        int contador;
        double media;
    }cuadrante;
    
    
public:
    /*
     To test the implementation I perform a canny on a black white image
     */
    cv::Mat processImage(cv::Mat source, float height);
    /*
     Filter the image with a median filter to redue the salt&pepper noise,
     then apply the smooth operator to reduce noise.
     */
    cv::Mat filterMedianSmoot(const cv::Mat &source);
    
    /*
     Filter with a gaussian
     */
    
    cv::Mat filterGaussian(const cv::Mat&source);
    
    /*
     Histogram equalization on 1 channel image
     */
    cv::Mat equalize(const cv::Mat&source);
    
    /*
     Binarization made using a mobile median treshold,
     adapted using the image dimension
     */
    cv::Mat binarize(const cv::Mat&source);
    
    
    /*
     Detect if an image is rotated and correct to the proper orientation
     of the text
     */
    int correctRotation (cv::Mat &image, cv::Mat &output, float height);
    
    /*
     Implements the rotation of the image according to the angle passed
     as parameter
     */
    cv::Mat rotateImage(const cv::Mat& source, double angle);
    
    cv::Mat deskew(const cv::Mat& src, double angle);
};

#endif
