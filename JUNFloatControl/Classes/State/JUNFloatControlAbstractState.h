//
//  JUNFloatControlAbstractState.h
//  JUNFloatControl
//
//  Created by Jun Ma on 2023/2/21.
//

#import <UIKit/UIKit.h>
@class JUNFloatControl;

NS_ASSUME_NONNULL_BEGIN

@interface JUNFloatControlAbstractState : NSObject

@property(nonatomic, strong, readonly) JUNFloatControl *control;
- (instancetype)initWithControl:(JUNFloatControl *)control;

#pragma mark - abstract methods
- (void)present:(UIView *)newSuperview;
- (void)dismiss;
- (void)toggle;
- (void)pan:(UIPanGestureRecognizer *)gesture;
- (void)orientationChange:(NSNotification *)notification;

@end

NS_ASSUME_NONNULL_END
