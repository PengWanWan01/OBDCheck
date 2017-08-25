//
//  gradientView.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/15.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "gradientView.h"

@implementation gradientView
- (void)drawRect:(CGRect)rect {
    self.layer.cornerRadius = ViewWidth/2;
    self.layer.masksToBounds = YES;
    [self test:rect start:_gradientColor end:[_gradientColor down:SXColorTypeAlpha num:255]withradius:self.frame.size.width/2 - (3.0/300)*self.frame.size.width];
}
- (void)test:(CGRect)rect start:(UIColor *)startColor end:(UIColor *)endColor withradius:(CGFloat)radius{
    CGPoint _c = CGPointMake(self.frame.size.width/2 , self.frame.size.width/2);
    CGFloat _r = radius;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef imgCtx = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(imgCtx, _c.x,_c.y);
    CGContextSetFillColor(imgCtx, CGColorGetComponents([UIColor blackColor].CGColor));
    CGContextAddArc(imgCtx, _c.x, _c.y, _r,  M_PI/2, -3*M_PI/2, 1);
    CGContextFillPath(imgCtx);
    
    CGContextSetLineCap(imgCtx, kCGLineCapRound);
    CGContextSetLineWidth(imgCtx, 63.0);
    
    //save the context content into the image mask
    CGImageRef mask = CGBitmapContextCreateImage(UIGraphicsGetCurrentContext());
    UIGraphicsEndImageContext();
    CGContextClipToMask(ctx, self.bounds, mask);
    
    UIColor *colors[2] = {startColor,endColor};
    CGFloat components[2*4];
    for (int i = 0; i < 2; i++) {
        CGColorRef tmpcolorRef = colors[i].CGColor;
        const CGFloat *tmpcomponents = CGColorGetComponents(tmpcolorRef);
        for (int j = 0; j < 4; j++) {
            components[i * 4 + j] = tmpcomponents[j];
        }
    }
    
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(space, components, NULL,2);
    CGColorSpaceRelease(space),space=NULL;//release
    
    CGPoint start = _c;
    CGPoint end = _c;
    CGFloat startRadius = 0.0f;
    CGFloat endRadius = _r;
    CGContextRef graCtx = UIGraphicsGetCurrentContext();
    CGContextDrawRadialGradient(graCtx, gradient, start, startRadius, end, endRadius, 0);
    CGGradientRelease(gradient),gradient=NULL;//release
}

@end
