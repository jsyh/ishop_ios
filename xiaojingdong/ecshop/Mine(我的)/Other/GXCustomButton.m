//
//  GXCustomButton.m
//  zhonggang
//
//  Created by jinbao on 14-6-9.
//  Copyright (c) 2014年 JIN. All rights reserved.
//

#import "GXCustomButton.h"

@implementation GXCustomButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
#pragma mark 设置Button内部的image的范围
 - (CGRect)imageRectForContentRect:(CGRect)contentRect
 {
     if (!self.titleLabel.text.length)
     {
//        return contentRect;
         return CGRectMake((contentRect.size.width - 24)/2.0, 4.5+(contentRect.size.height - 24)/2.0, 24, 24);
     }
     
     CGFloat imageW = contentRect.size.width;
     CGFloat imageH = contentRect.size.height * 0.6;
     
     return CGRectMake((imageW - 24)/2.0, 4.5+(imageH - 24)/2.0, 24, 24);
    
//        CGFloat imageW = contentRect.size.width;
//        CGFloat imageH = contentRect.size.height * 0.6;
//    
//         return CGRectMake(0, 4.5, imageW, imageH);
     }

 #pragma mark 设置Button内部的title的范围
 - (CGRect)titleRectForContentRect:(CGRect)contentRect
 {
     if (!self.currentImage)
     {
         return contentRect;
     }
         CGFloat titleY = contentRect.size.height *0.6;
         CGFloat titleW = contentRect.size.width;
        CGFloat titleH = contentRect.size.height - titleY;
         return CGRectMake(0, titleY-2, titleW, titleH);
}

@end
