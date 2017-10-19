//
//  DashboardB.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/9/6.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "DashboardB.h"

@implementation DashboardB
-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_infoLabeltext forKey:@"infoLabeltext"];
     [aCoder encodeObject:_backColor forKey:@"backColor"];
     [aCoder encodeObject:_GradientRadius forKey:@"GradientRadius"];
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
    [aCoder encodeObject:_pointerColor forKey:@"pointerColor"];
    [aCoder encodeObject:_Pointerwidth forKey:@"Pointerwidth"];
    [aCoder encodeBool:_FillEnable forKey:@"FillEnable"];
    [aCoder encodeObject:_FillColor forKey:@"FillColor"];
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
        _backColor = [aDecoder decodeObjectForKey:@"backColor"];
        _GradientRadius = [aDecoder decodeObjectForKey:@"GradientRadius"];
        _titleColor = [aDecoder decodeObjectForKey:@"titleColor"];
        _titleFontScale = [aDecoder decodeObjectForKey:@"titleFontScale"];
        _titlePositon = [aDecoder decodeObjectForKey:@"titlePositon"];
        _ValueVisible = [aDecoder decodeObjectForKey:@"ValueVisible"];
        _ValueColor = [aDecoder decodeObjectForKey:@"ValueColor"];
        _ValueFontScale = [aDecoder decodeObjectForKey:@"ValueFontScale"];
        _ValuePositon = [aDecoder decodeObjectForKey:@"ValuePositon"];
        _UnitColor = [aDecoder decodeObjectForKey:@"UnitColor"];
        _UnitFontScale = [aDecoder decodeObjectForKey:@"UnitFontScale"];
        _UnitPositon = [aDecoder decodeObjectForKey:@"UnitPositon"];
        _pointerColor = [aDecoder decodeObjectForKey:@"pointerColor"];
        _Pointerwidth = [aDecoder decodeObjectForKey:@"Pointerwidth"];
        _FillEnable = [aDecoder decodeBoolForKey:@"FillEnable"];
        _FillColor = [aDecoder decodeObjectForKey:@"FillColor"];
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
