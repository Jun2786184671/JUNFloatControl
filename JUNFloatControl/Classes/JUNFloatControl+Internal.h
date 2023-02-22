//
//  JUNFloatControl+Internal.h
//  JUNFloatControl
//
//  Created by Jun Ma on 2023/2/21.
//

#import "JUNFloatControl.h"
@class JUNFloatControlAbstractState;
@class JUNFloatControlMinimiumState;
@class JUNFloatControlInteractiveState;

NS_ASSUME_NONNULL_BEGIN

@interface JUNFloatControl ()

@property(nonatomic, strong) JUNFloatControlConfig *config;
@property(nonatomic, strong) JUNFloatControlAbstractState *state;
@property(nonatomic, strong) JUNFloatControlMinimiumState *minimiumState;
@property(nonatomic, strong) JUNFloatControlInteractiveState *interactiveState;
@property(nonatomic, strong) UIView *cornerView;
@property(nonatomic, strong) UIView *transitionView;
@property(nonatomic, strong) UIImageView *accessoryView;
@property(nonatomic, strong) UIView *contentView;

@end

NS_ASSUME_NONNULL_END
