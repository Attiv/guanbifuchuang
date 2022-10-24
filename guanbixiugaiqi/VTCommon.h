//
//  VTCommon.h
//  neigou
//
//  Created by 王立坤 on 2022/3/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
static NSString *kNeiGouKey = @"nei_gou_key";
@interface VTCommon : NSObject
@property(nonatomic, assign)BOOL buttonIsHide;

+(void)setneiGouSetting:(NSInteger)neiGouSetting;
+(NSInteger)neiGouSetting;
+ (VTCommon *)shared;
-(NSInteger)neiGouSetting;
@end

NS_ASSUME_NONNULL_END
