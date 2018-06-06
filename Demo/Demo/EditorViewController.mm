//
//  EditorViewController.m
//  Demo
//
//  Created by Xingjian on 2018/6/3.
//  Copyright © 2018年 Programmers. All rights reserved.
//

#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>
#import "EditorViewController.h"
#import "UIImage+Direction.h"

@interface EditorViewController ()
{
    cv::Mat cvImage;
}
@property (weak, nonatomic) IBOutlet UIImageView *showImage;

@end

@implementation EditorViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
        _selectImage = [[UIImage alloc]init];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Edit";
    
    UIImage *image = [self.selectImage fixOrientation];
    
    self.showImage.image = image;
    self.showImage.contentMode = UIViewContentModeScaleAspectFit; //In order to keep the scale of the original photo
}


- (IBAction)colorChange:(UIButton *)sender {
    
    UIImageToMat(self.showImage.image, cvImage);

    if(!cvImage.empty()){
        cv::Mat gray;
        // Convert image to grayscale (color optional)
        cv::cvtColor(cvImage,gray,CV_RGB2GRAY);
        // Apply a Gaussian filter to remove small edges
        cv::GaussianBlur(gray, gray, cv::Size(5,5), 1.2,1.2);
        // Calculation of the canvas edges
        cv::Mat edges;
        cv::Canny(gray, edges, 0, 50);
        // Fill with white color
        cvImage.setTo(cv::Scalar::all(225));
        // Modify the edge color
        cvImage.setTo(cv::Scalar(0,128,255,255),edges);
        // Convert Mat to UIImage of Xcode to show

        

        self.showImage.image = MatToUIImage(cvImage);
    }
    
}
- (IBAction)bitChange:(UIButton *)sender {
    
  
    UIImageToMat(self.showImage.image, cvImage);
    
    if(!cvImage.empty()){
        
        cv::Mat image_copy;
        cvtColor(cvImage, image_copy, cv::COLOR_BGR2GRAY);
        //Image inversion (black pixels will be black, black will be white)
        bitwise_not(image_copy, image_copy);
        cv::Mat bgr;
        
        //The original picture is 3 primary colors (3 channels) converted into 4 channels
        //gray-> RGB -> ARGB
        //b4:RGB->ARGB
        cvtColor(image_copy, bgr, cv::COLOR_GRAY2BGR);
        //Set data from our original image
        //Put our modified frame picture on the preview picture
        //Gray->RGB
        cvtColor(bgr, cvImage, cv::COLOR_BGR2BGRA);
        
        self.showImage.image = MatToUIImage(cvImage);
    }
    
    
    
}
- (IBAction)saveImage:(UIButton *)sender {
    
    UIImageWriteToSavedPhotosAlbum(self.showImage.image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    //Return after saving successfully
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
