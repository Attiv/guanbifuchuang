//
//  VTCommon.m
//  neigou
//
//  Created by 王立坤 on 2022/3/24.
//

#import "VTCommon.h"

@implementation VTCommon
+ (VTCommon *)shared {
    static VTCommon *tool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[VTCommon alloc] init];
    });
    return tool;
}

+(void)setneiGouSetting:(NSInteger)neiGouSetting {
    [NSUserDefaults.standardUserDefaults setInteger:neiGouSetting forKey:kNeiGouKey];
    [NSUserDefaults.standardUserDefaults synchronize];
}
+(NSInteger)neiGouSetting {
    return [NSUserDefaults.standardUserDefaults integerForKey: kNeiGouKey];
}

-(NSInteger)neiGouSetting {
    return [NSUserDefaults.standardUserDefaults integerForKey: kNeiGouKey];
}

@end
