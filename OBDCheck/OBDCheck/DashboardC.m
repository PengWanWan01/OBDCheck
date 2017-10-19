//
//  DashboardC.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/9/6.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "DashboardC.h"

@implementation DashboardC
-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_infoLabeltext forKey:@"infoLabeltext"];
    [aCoder encodeObject:_innerColor forKey:@"innerColor"];
    [aCoder encodeObject:_outerColor forKey:@"outerColor"];
    [aCoder encodeObject:_Gradientradius forKey:@"Gradientradius"];
    [aCoder encodeObject:_titleColor forKey:@"titleColor"];
    [aCoder encodeObject:_titleFontScale forKey:@"titleFontScale"];
    [aCoder encodeObject:_titlePositon forKey:@"titlePositon"];
    [aCoder encodeBool:_ValueVisible forKey:@"ValueVisible"];
    [aCoder encodeObject:_ValueColor forKey:@"ValueColor"];
    [aCoder encodeObject:_ValueFontScale forKey:@"ValueFontScale"];
    [aCoder encodeObject:_ValuePositon forKey:@"ValuePositon"];
    [aCoder encodeObject:_UnitColor forKey:@"UnitColor"];
    [aCoder encodeObject:_UnitFontScale forKey:@"UnitFontScale"];
    [aCoder encodeObject:_UnitPositon forKey:@"UnitPositon"];
    [aCoder encodeObject:_FrameColor forKey:@"FrameColor"];
    [aCoder encodeObject:_orignx forKey:@"orignx"];
    [aCoder encodeObject:_origny forKey:@"origny"];
    [aCoder encodeObject:_orignwidth forKey:@"orignwidth"];
    [aCoder encodeObject:_orignheight forKey:@"orignheight"];
    [aCoder encodeObject:_minNumber forKey:@"minNumber"];
    [aCoder encodeObject:_maxNumber forKey:@"maxNumber"];
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _infoLabeltext = [aDecoder decodeObjectForKey:@"infoLabeltext"];
        _innerColor = [aDecoder decodeObjectForKey:@"innerColor"];
        _outerColor = [aDecoder decodeObjectForKey:@"outerColor"];
        _Gradientradius = [aDecoder decodeObjectForKey:@"Gradientradius"];
        _titleColor = [aDecoder decodeObjectForKey:@"titleColor"];
        _titleFontScale = [aDecoder decodeObjectForKey:@"titleFontScale"];
        _titlePositon = [aDecoder decodeObjectForKey:@"titlePositon"];
        _ValueVisible = [aDecoder decodeBoolForKey:@"ValueVisible"];
        _ValueColor = [aDecoder decodeObjectForKey:@"ValueColor"];
        _ValueFontScale = [aDecoder decodeObjectForKey:@"ValueFontScale"];
        _ValuePositon = [aDecoder decodeObjectForKey:@"ValuePositon"];
        _UnitColor = [aDecoder decodeObjectForKey:@"UnitColor"];
        _UnitFontScale = [aDecoder decodeObjectForKey:@"UnitFontScale"];
        _UnitPositon = [aDecoder decodeObjectForKey:@"UnitPositon"];
        _FrameColor = [aDecoder decodeObjectForKey:@"FrameColor"];
        _orignx = [aDecoder decodeObjectForKey:@"orignx"];
        _origny = [aDecoder decodeObjectForKey:@"origny"];
        _orignwidth = [aDecoder decodeObjectForKey:@"orignwidth"];
        _orignheight = [aDecoder decodeObjectForKey:@"orignheight"];
        _minNumber = [aDecoder decodeObjectForKey:@"minNumber"];
        _maxNumber = [aDecoder decodeObjectForKey:@"maxNumber"];
    }
    return self;
}
@end
