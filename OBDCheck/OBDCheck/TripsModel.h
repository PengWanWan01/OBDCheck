//
//  TripsModel.h
//  OBDCheck
//
//  Created by yutaozhao on 2017/9/13.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "Tool_FMDBModel.h"

@interface TripsModel : Tool_FMDBModel<NSCoding>

@property (nonatomic,copy) NSString *distance;
@property (nonatomic,copy) NSString *Fuel;
@property (nonatomic,copy) NSString *FuelEconmy;

@end
