//
//  DashboardA.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/9/2.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "DashboardA.h"

@implementation DashboardA
-(void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:_infoLabeltext forKey:@"infoLabeltext"];
    [aCoder encodeObject:_StartAngle forKey:@"StartAngle"];
    [aCoder encodeObject:_endAngle forKey:@"endAngle"];
    [aCoder encodeObject:_ringWidth forKey:@"ringWidth"];

    [aCoder encodeObject:_maLength forKey:@"maLength"];
    [aCoder encodeObject:_maWidth forKey:@"maWidth"];
    [aCoder encodeObject:_maColor forKey:@"maColor"];
    [aCoder encodeObject:_miLength forKey:@"miLength"];
    [aCoder encodeObject:_miWidth forKey:@"miWidth"];
    [aCoder encodeObject:_miColor forKey:@"miColor"];
    [aCoder encodeObject:_innerColor forKey:@"innerColor"];
    [aCoder encodeObject:_outerColor forKey:@"outerColor"];
    
    [aCoder encodeObject:_titleColor forKey:@"titleColor"];
    [aCoder encodeObject:_titleFontScale forKey:@"titleFontScale"];
    [aCoder encodeObject:_titlePosition forKey:@"titlePosition"];
    [aCoder encodeBool:_ValueVisble forKey:@"ValueVisble"];
    [aCoder encodeObject:_ValueColor forKey:@"ValueColor"];
    [aCoder encodeObject:_ValueFontScale forKey:@"ValueFontScale"];
    [aCoder encodeObject:_ValuePosition forKey:@"ValuePosition"];
    [aCoder encodeObject:_UnitColor forKey:@"UnitColor"];
    
    [aCoder encodeObject:_UnitFontScale forKey:@"UnitFontScale"];
    [aCoder encodeObject:_UnitVerticalPosition forKey:@"UnitVerticalPosition"];
    [aCoder encodeObject:_UnitHorizontalPosition forKey:@"UnitHorizontalPosition"];
    [aCoder encodeBool:_LabelVisble forKey:@"LabelVisble"];
    [aCoder encodeBool:_LabelRotate forKey:@"LabelRotate"];
    [aCoder encodeObject:_LabelFontScale forKey:@"LabelFontScale"];
    [aCoder encodeObject:_LabelOffest forKey:@"LabelOffest"];
    [aCoder encodeBool:_PointerVisble forKey:@"PointerVisble"];
    
    [aCoder encodeObject:_PointerWidth forKey:@"PointerWidth"];
    [aCoder encodeObject:_PointerLength forKey:@"PointerLength"];
    [aCoder encodeObject:_PointerColor forKey:@"PointerColor"];
    [aCoder encodeObject:_KNOBRadius forKey:@"KNOBRadius"];
    [aCoder encodeObject:_KNOBColor forKey:@"KNOBColor"];
    [aCoder encodeObject:_FillstartAngle forKey:@"FillstartAngle"];
    [aCoder encodeBool:_Fillenabled forKey:@"Fillenabled"];
    [aCoder encodeObject:_FillstartAngle forKey:@"FillstartAngle"];
    
    [aCoder encodeObject:_FillEndAngle forKey:@"FillEndAngle"];
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
         _StartAngle = [aDecoder decodeObjectForKey:@"StartAngle"];
         _ringWidth = [aDecoder decodeObjectForKey:@"ringWidth"];
         _maLength = [aDecoder decodeObjectForKey:@"maLength"];
         _maWidth = [aDecoder decodeObjectForKey:@"maWidth"];
        
        _maColor = [aDecoder decodeObjectForKey:@"maColor"];
        _miLength = [aDecoder decodeObjectForKey:@"miLength"];
        _miWidth = [aDecoder decodeObjectForKey:@"miWidth"];
        _innerColor = [aDecoder decodeObjectForKey:@"innerColor"];
        _outerColor = [aDecoder decodeObjectForKey:@"outerColor"];
        
        _titleColor = [aDecoder decodeObjectForKey:@"titleColor"];
        _titleFontScale = [aDecoder decodeObjectForKey:@"titleFontScale"];
        _titlePosition = [aDecoder decodeObjectForKey:@"titlePosition"];
        _ValueVisble = [aDecoder decodeBoolForKey:@"ValueVisble"];
        _ValueColor = [aDecoder decodeObjectForKey:@"ValueColor"];
        _ValueFontScale = [aDecoder decodeObjectForKey:@"ValueFontScale"];
        _ValuePosition = [aDecoder decodeObjectForKey:@"ValuePosition"];
        _UnitColor = [aDecoder decodeObjectForKey:@"UnitColor"];
        _UnitFontScale = [aDecoder decodeObjectForKey:@"UnitFontScale"];
        _UnitVerticalPosition = [aDecoder decodeObjectForKey:@"UnitVerticalPosition"];
  
        _UnitHorizontalPosition = [aDecoder decodeObjectForKey:@"UnitHorizontalPosition"];
        _LabelVisble = [aDecoder decodeBoolForKey:@"LabelVisble"];
        _LabelRotate = [aDecoder decodeBoolForKey:@"LabelRotate"];
        _LabelFontScale = [aDecoder decodeObjectForKey:@"LabelFontScale"];
        _LabelOffest = [aDecoder decodeObjectForKey:@"LabelOffest"];
        _PointerVisble = [aDecoder decodeBoolForKey:@"PointerVisble"];
        _PointerWidth = [aDecoder decodeObjectForKey:@"PointerWidth"];
        _PointerLength = [aDecoder decodeObjectForKey:@"PointerLength"];
        _PointerColor = [aDecoder decodeObjectForKey:@"PointerColor"];
        
        _KNOBRadius = [aDecoder decodeObjectForKey:@"KNOBRadius"];
        _KNOBColor = [aDecoder decodeObjectForKey:@"KNOBColor"];
        _Fillenabled = [aDecoder decodeBoolForKey:@"Fillenabled"];
        _FillstartAngle = [aDecoder decodeObjectForKey:@"FillstartAngle"];
        _FillEndAngle = [aDecoder decodeObjectForKey:@"FillEndAngle"];
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
