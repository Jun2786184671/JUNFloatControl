//
//  JUNFloatControlMinimiumState.m
//  JUNFloatControl
//
//  Created by Jun Ma on 2023/2/21.
//

#import "JUNFloatControlMinimiumState.h"
#import "JUNFloatControlInteractiveState.h"
#import "JUNFloatControlConfig.h"
#import "JUNFloatControl+Internal.h"
#import "UIView+JUNFloatControl.h"

@interface JUNFloatControlMinimiumState ()

@property(nonatomic, strong) NSValue *prevPanLocationValue;
/// Record position for each location change, this is useful when device orientation change.
@property(nonatomic, strong) NSValue *recordedLocationValue;

@end

@implementation JUNFloatControlMinimiumState

- (void)present:(UIView *)newSuperview {
    JUNFloatControlConfig *config = self.control.config;
    [self setUpControlInitialPositionInSuperview:newSuperview];
    self.control.alpha = 0;
    self.control.transitionView.alpha = 0;
    self.control.cornerView.alpha = 0;
    [UIView animateWithDuration:self.control.config.animDuration animations:^{
        self.control.alpha = 1.0;
        CGPoint center = self.control.center;
        self.control.size = config.thumbSize;
        self.control.center = center;
        self.control.accessoryView.frame = self.control.bounds;
        self.control.cornerView.frame = self.control.accessoryView.frame;
    } completion:^(BOOL finished) {
        [self dockControlToEdge];
    }];
}

- (void)toggle {
    self.control.state = self.control.interactiveState;
    [self handleToggleTransition];
}

- (void)pan:(UIPanGestureRecognizer *)gesture {
    NSParameterAssert(self.control.superview);
    CGPoint panLocation = [gesture locationInView:self.control.superview];
    if (self.prevPanLocationValue) {
        CGPoint prevPanLocation = [self.prevPanLocationValue CGPointValue];
        self.control.left += (panLocation.x - prevPanLocation.x);
        self.control.top += (panLocation.y - prevPanLocation.y);
    }
    self.prevPanLocationValue = [NSValue valueWithCGPoint:panLocation];
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self handlePanBegin];
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        [self handlePanEnd];
    } else if (gesture.state == UIGestureRecognizerStateCancelled) {
        [self handlePanEnd];
    }
}

- (void)orientationChange:(NSNotification *)notification {
    if (!self.recordedLocationValue) return;
    NSParameterAssert(self.control.superview);
    CGFloat animDuration = self.control.config.animDuration;
    CGFloat minDuration = 0.3;
    [UIView animateWithDuration:fmax(animDuration, minDuration) animations:^{
        self.control.alpha = 0;
    } completion:^(BOOL finished) {
        [self setUpControlPositionInSuperview:self.control.superview withRatio:[self.recordedLocationValue CGPointValue]];
        [UIView animateWithDuration:animDuration animations:^{
            self.control.alpha = 1.0;
        }];
    }];
}

#pragma mark - Private

- (void)setUpControlPositionInSuperview:(UIView *)superview withRatio:(CGPoint)positionRatio {
    JUNFloatControlConfig *config = self.control.config;
    self.control.size = config.thumbSize;
    self.control.center = CGPointMake(superview.width * positionRatio.x, superview.height * positionRatio.y);
    if (self.control.top < 0) {
        self.control.top = 0;
    }
    if (self.control.left < 0) {
        self.control.left = 0;
    }
    if (self.control.bottom > superview.height) {
        self.control.bottom = superview.height;
    }
    if (self.control.right > superview.width) {
        self.control.right = superview.width;
    }
}

- (void)setUpControlInitialPositionInSuperview:(UIView *)newSuperview {
    [self setUpControlPositionInSuperview:newSuperview withRatio:self.control.config.initialPositionRatio];
    CGPoint center = self.control.center;
    self.control.size = CGSizeZero;
    self.control.center = center;
}

- (void)handleToggleTransition {
    UIView *transitionView = self.control.transitionView;
    UIView *contentView = self.control.contentView;
    UIView *cornerView = self.control.cornerView;
    UIView *accessoryView = self.control.accessoryView;
    JUNFloatControlConfig *config = self.control.config;
    CGSize contentSize = config.contentSize;
    CGFloat animDuration = config.animDuration;
    
    NSParameterAssert(self.control.superview);
    accessoryView.origin = self.control.origin;
    cornerView.origin = accessoryView.origin;
    self.control.frame = self.control.superview.bounds;
    transitionView.frame = self.control.bounds;
    if (@available(iOS 11.0, *)) {
        contentView.layer.maskedCorners = cornerView.layer.maskedCorners;
    } else {
        // Fallback on earlier versions
    }
    
    [UIView animateWithDuration:animDuration animations:^{
        transitionView.alpha = 1.0;
//        contentView.alpha = 1.0;
    }];
    
    if (accessoryView.top == 0 || accessoryView.bottom == self.control.height) {
        contentView.width = contentSize.width;
        contentView.centerX = accessoryView.centerX;
        if (contentView.left < 0) {
            contentView.left = 0;
        }
        if (contentView.right > self.control.width) {
            contentView.right = self.control.width;
        }
        if (accessoryView.top == 0) {
            contentView.bottom = 0;
            [UIView animateWithDuration:animDuration animations:^{
                contentView.top = 0;
                contentView.height = contentSize.height;
                accessoryView.top = contentView.bottom;
                cornerView.top = accessoryView.top;
            }];
        } else if (accessoryView.bottom == self.control.height) {
            contentView.top = self.control.height;
            [UIView animateWithDuration:animDuration animations:^{
                contentView.height = contentSize.height;
                contentView.bottom = self.control.height;
                accessoryView.bottom = contentView.top;
                cornerView.bottom = accessoryView.bottom;
            }];
        }
    } else if (accessoryView.left == 0 || accessoryView.right == self.control.width) {
        contentView.height = contentSize.height;
        contentView.centerY = accessoryView.centerY;
        if (contentView.top < 0) {
            contentView.top = 0;
        }
        if (contentView.bottom > self.control.height) {
            contentView.bottom = self.control.height;
        }
        if (accessoryView.left == 0) {
            contentView.right = 0;
            [UIView animateWithDuration:animDuration animations:^{
                contentView.left = 0;
                contentView.width = contentSize.width;
                accessoryView.left = contentView.right;
                cornerView.left = accessoryView.left;
            }];
        } else if (accessoryView.right == self.control.width) {
            contentView.left = self.control.width;
            [UIView animateWithDuration:animDuration animations:^{
                contentView.width = contentSize.width;
                contentView.right = self.control.width;
                accessoryView.right = contentView.left;
                cornerView.right = accessoryView.right;
            }];
        }
    } else {
        NSParameterAssert(false);
    }
}

- (void)handlePanBegin {
    [UIView animateWithDuration:self.control.config.animDuration animations:^{
        self.control.cornerView.alpha = 0;
    }];
}

- (void)handlePanEnd {
    [self dockControlToEdge];
    self.prevPanLocationValue = nil;
}

- (void)dockControlToEdge {
    UIView *superview = self.control.superview;
    CGFloat animDuration = self.control.config.animDuration;
    CGFloat marginT = self.control.top;
    CGFloat marginL = self.control.left;
    CGFloat marginB = superview.height - self.control.bottom;
    CGFloat marginR = superview.width - self.control.right;
    CGFloat marginMin = MIN(MIN(marginT, marginB), MIN(marginL, marginR));
    [UIView animateWithDuration:animDuration animations:^{
        if (marginMin >= 0) {
            if (marginMin == marginT) {
                self.control.top = 0;
            } else if (marginMin == marginL) {
                self.control.left = 0;
            } else if (marginMin == marginB) {
                self.control.bottom = self.control.superview.height;
                
            } else if (marginMin == marginR) {
                self.control.right = self.control.superview.width;
            } else {
                NSParameterAssert(false);
            }
            return;
        }
        if (marginT < 0) {
            self.control.top = 0;
        } else if (marginB < 0) {
            self.control.bottom = self.control.superview.height;
        }
        if (marginL < 0) {
            self.control.left = 0;
        } else if (marginR < 0) {
            self.control.right = self.control.superview.width;
        }
    } completion:^(BOOL finished) {
        // handle show corner animation
        [UIView animateWithDuration:animDuration animations:^{
            UIView *cornerView = self.control.cornerView;
            cornerView.alpha = 1.0;
            if (@available(iOS 11.0, *)) {
                cornerView.layer.maskedCorners = 0;
                if (self.control.top == 0) {
                    cornerView.layer.maskedCorners |= ~(kCALayerMinXMaxYCorner | kCALayerMaxXMaxYCorner);
                }
                if (self.control.left == 0) {
                    cornerView.layer.maskedCorners |= ~(kCALayerMaxXMinYCorner | kCALayerMaxXMaxYCorner);
                }
                if (self.control.bottom == self.control.superview.height) {
                    cornerView.layer.maskedCorners |= ~(kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner);
                }
                if (self.control.right == self.control.superview.width) {
                    cornerView.layer.maskedCorners |= ~(kCALayerMinXMinYCorner | kCALayerMinXMaxYCorner);
                }
                cornerView.layer.maskedCorners = ~cornerView.layer.maskedCorners;
            } else {
                // Fallback on earlier versions
            }
        }];
    }];
    CGPoint recordedLocation = CGPointZero;
    if (marginMin >= 0) {
        if (marginMin == marginT) {
            recordedLocation.x = self.control.centerX / superview.width;
        } else if (marginMin == marginL) {
            recordedLocation.y = self.control.centerY / superview.height;
        } else if (marginMin == marginB) {
            recordedLocation = CGPointMake(self.control.centerX / superview.width, 1.0);
        } else if (marginMin == marginR) {
            recordedLocation = CGPointMake(1.0, self.control.centerY / superview.height);
        } else {
            NSParameterAssert(false);
        }
    } else {
        recordedLocation = CGPointMake(self.control.centerX / superview.width, self.control.centerY / superview.height);
        if (marginT < 0) {
            recordedLocation.y = 0;
        } else if (marginB < 0) {
            recordedLocation.y = 1.0;
        }
        if (marginL < 0) {
            recordedLocation.x = 0;
        } else if (marginR < 0) {
            recordedLocation.x = 1.0;
        }
    }
    self.recordedLocationValue = [NSValue valueWithCGPoint:recordedLocation];
}

@end
