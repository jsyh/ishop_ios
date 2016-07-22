//
//  PersonalInfoModel.m
//  ecshop
//
//  Created by Jin on 15/12/21.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import "PersonalInfoModel.h"

@implementation PersonalInfoModel
-(void)setModel:(PersonalInfoModel *)model{
    model.user_id = _user_id;
    model.nick_name = _nick_name;
    model.sex = _sex;
    model.address = _address;
    model.mobile = _mobile;
    model.integration = _integration;
    model.attention = _attention;
    model.user_money = _user_money;
    model.birthday = _birthday;
}
@end
