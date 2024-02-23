//
//  guanbixiugaiqi.mm
//  guanbixiugaiqi
//
//  Created by 王立坤 on 2022/10/24.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

// CaptainHook by Ryan Petrich
// see https://github.com/rpetrich/CaptainHook/

#if TARGET_OS_SIMULATOR
#error Do not support the simulator, please use the real iPhone Device.
#endif

#import "VTCommon.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>
#import "CaptainHook/CaptainHook.h"
#include <notify.h> // not required; for examples only
#import <MediaPlayer/MediaPlayer.h>
//#import <WebAds/InterstitialAdViewController.h>

// Objective-C runtime hooking using CaptainHook:
//   1. declare class using CHDeclareClass()
//   2. load class using CHLoadClass() or CHLoadLateClass() in CHConstructor
//   3. hook method using CHOptimizedMethod()
//   4. register hook using CHHook() in CHConstructor
//   5. (optionally) call old method using CHSuper()


@interface guanbixiugaiqi : NSObject
@property (nonatomic, strong) MPVolumeView *volumeView;
@end

@implementation guanbixiugaiqi

+ (guanbixiugaiqi *)shared {
    static guanbixiugaiqi *tool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[guanbixiugaiqi alloc] init];
    });
    return tool;
}

+ (void)load {
    //几秒出悬浮窗
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [guanbixiugaiqi shared];
        
//        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//        [audioSession setCategory:AVAudioSessionCategoryAmbient error:nil];//重点方法
//            
//            [audioSession setActive:YES error:nil];
//            
//            NSError *error;
//            
//            [[AVAudioSession sharedInstance] setActive:YES error:&error];
//            
//        [audioSession addObserver:[guanbixiugaiqi shared] forKeyPath:@"outputVolume" options:NSKeyValueObservingOptionNew context:nil];
//        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    });
}
//
//+ (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
//{
//    if ([keyPath isEqualToString:@"outputVolume"]) {
//        // 获取音量变化的值
//        float volume = [[change objectForKey:NSKeyValueChangeNewKey] floatValue];
//        // 根据音量变化的值进行相应的处理
//        [[guanbixiugaiqi shared] yinLiangDianJi];
//    }
//}
//
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
//{
//    if ([keyPath isEqualToString:@"outputVolume"]) {
//        // 获取音量变化的值
//        float volume = [[change objectForKey:NSKeyValueChangeNewKey] floatValue];
//        // 根据音量变化的值进行相应的处理
//        [self yinLiangDianJi];
//    }
//}

- (void)yinLiangDianJi {
    [VTCommon shared].buttonIsHide = ![VTCommon shared].buttonIsHide;

    NSArray *windows = [UIApplication sharedApplication].windows;
    
    [windows enumerateObjectsUsingBlock:^(UIWindow *window, NSUInteger idx, BOOL *stop) {
        if ([window isKindOfClass:NSClassFromString(@"iGameGod.GameGodWindow")] ||
            [window isKindOfClass:NSClassFromString(@"YYYHookWindow")]) {
            window.hidden = [VTCommon shared].buttonIsHide;
        } else {
            if (!window.hidden) {
                NSArray *views = window.subviews;
                [views enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
                    if ([view isKindOfClass:NSClassFromString(@"FloatButton")]) {
                        view.hidden = [VTCommon shared].buttonIsHide;
                    }
                }];
            }
        }
    }];
}

-(id)init
{
	if ((self = [super init]))
	{
        // 创建 MPVolumeView，并添加到视图层级结构
              self.volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(10000, 0, 0, 0)];
              [[UIApplication sharedApplication].windows.firstObject addSubview:self.volumeView];
              
              // 遍历 MPVolumeView 的 subviews，找到音量滑块
              for (UIView *view in [self.volumeView subviews]){
                  if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
                      UISlider *volumeSlider = (UISlider *)view;
                      
                      // 添加 valueChanged 监听
                      [volumeSlider addTarget:self action:@selector(volumeChanged:) forControlEvents:UIControlEventValueChanged];
                      break;
                  }
              }
	}

    return self;
}

- (void)volumeChanged:(UISlider *)slider {
    // 执行音量点击事件
    [self yinLiangDianJi];
}

@end

#pragma mark -----
CHDeclareClass(UIApplication)
CHOptimizedMethod(2, self, void, UIApplication, motionEnded, UIEventSubtype, motion, withEvent, UIEvent *, event) {
    CHSuper(2, UIApplication, motionEnded, motion, withEvent, event);
    
    if (motion == UIEventSubtypeMotionShake) {
        [[guanbixiugaiqi shared] yinLiangDianJi];
    }
}
CHConstructor {
    CHLoadLateClass(UIApplication);
    CHHook(2, UIApplication, motionEnded, withEvent);
}

@class ClassToHook;

CHDeclareClass(ClassToHook); // declare class

CHOptimizedMethod(0, self, void, ClassToHook, messageName) // hook method (with no arguments and no return value)
{
	// write code here ...
	
	CHSuper(0, ClassToHook, messageName); // call old (original) method
}

CHOptimizedMethod(2, self, BOOL, ClassToHook, arg1, NSString*, value1, arg2, BOOL, value2) // hook method (with 2 arguments and a return value)
{
	// write code here ...

	return CHSuper(2, ClassToHook, arg1, value1, arg2, value2); // call old (original) method and return its return value
}

static void WillEnterForeground(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
	// not required; for example only
}

static void ExternallyPostedNotification(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
	// not required; for example only
}

CHConstructor // code block that runs immediately upon load
{
	@autoreleasepool
	{
		// listen for local notification (not required; for example only)
		CFNotificationCenterRef center = CFNotificationCenterGetLocalCenter();
		CFNotificationCenterAddObserver(center, NULL, WillEnterForeground, CFSTR("UIApplicationWillEnterForegroundNotification"), NULL, CFNotificationSuspensionBehaviorCoalesce);
		
		// listen for system-side notification (not required; for example only)
		// this would be posted using: notify_post("com.vitta.attiv.guanbixiugaiqi.eventname");
		CFNotificationCenterRef darwin = CFNotificationCenterGetDarwinNotifyCenter();
		CFNotificationCenterAddObserver(darwin, NULL, ExternallyPostedNotification, CFSTR("com.vitta.attiv.guanbixiugaiqi.eventname"), NULL, CFNotificationSuspensionBehaviorCoalesce);
		
		// CHLoadClass(ClassToHook); // load class (that is "available now")
		// CHLoadLateClass(ClassToHook);  // load class (that will be "available later")
		
		CHHook(0, ClassToHook, messageName); // register hook
		CHHook(2, ClassToHook, arg1, arg2); // register hook
	}
}
