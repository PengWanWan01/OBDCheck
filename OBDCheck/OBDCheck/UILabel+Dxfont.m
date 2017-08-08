//
//  UILabel+Dxfont.m
//  buyread
//
//  Created by yutaozhao on 2017/7/4.
//  Copyright © 2017年 xiwenjin. All rights reserved.
//

#import "UILabel+Dxfont.h"

@implementation UILabel (Dxfont)
+ (void)load{
    //利用running time运行池的方法在程序启动的时候把两个方法替换 适用Xib建立的label
    Method imp = class_getInstanceMethod([self class], @selector(initWithCoder:));
    Method myImp = class_getInstanceMethod([self class], @selector(myInitWithCoder:));
    method_exchangeImplementations(imp, myImp);  //交换方法
    
    Method frameimp = class_getInstanceMethod([self class], @selector(initWithFrame:));
    Method myframeImp = class_getInstanceMethod([self class], @selector(myInitWithFrame:));
    method_exchangeImplementations(frameimp, myframeImp);  //交换方法
}
- (id)myInitWithFrame:(CGRect)frame{
    [self myInitWithFrame:frame];
    if (self) {
        //部分不像改变字体的 把tag值设置成LabelFontSize值的跳过
        if (IS_IPHONE_6P) {
            
            if(self.tag != LabelFontSize) {
                CGFloat fontSize = self.font.pointSize;
                self.font = [UIFont systemFontOfSize:fontSize*1.2];
            }
        }
    }
    return self;

}

- (id)myInitWithCoder:(NSCoder*)aDecode{
    [self myInitWithCoder:aDecode];
    if (self) {
        //部分不像改变字体的 把tag值设置成LabelFontSize值的跳过
        if (IS_IPHONE_6P) {
            
            if(self.tag != LabelFontSize) {
                CGFloat fontSize = self.font.pointSize;
                self.font = [UIFont systemFontOfSize:fontSize*1.2];
            }   
        }
    }
    return self;
}
@end
