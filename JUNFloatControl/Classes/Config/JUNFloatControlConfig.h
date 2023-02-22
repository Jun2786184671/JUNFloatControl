//
//  JUNFloatControlConfig.h
//  JUNFloatControl
//
//  Created by Jun Ma on 2023/2/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JUNFloatControlConfig : NSObject

+ (instancetype)sharedConfig;
@property(nonatomic, assign) CGSize thumbSize;
@property(nonatomic, assign) CGFloat thumbRadius;
@property(nonatomic, strong) UIImage *thumbImage;
@property(nonatomic, strong) UIColor *thumbColor;
@property(nonatomic, assign) CGSize contentSize;
@property(nonatomic, assign) CGFloat contentRadius;
@property(nonatomic, strong) UIColor *contentBorderColor;
@property(nonatomic, assign) CGFloat contentBorderWidth;
@property(nonatomic, strong) UIView *content;
@property(nonatomic, assign) CGPoint initialPositionRatio;
@property(nonatomic, assign) CGFloat animDuration;
@property(nonatomic, strong) UIColor *maskColor;

@end

NS_ASSUME_NONNULL_END
