//
//  JUNFloatControlInteractiveState.m
//  JUNFloatControl
//
//  Created by Jun Ma on 2023/2/21.
//

#import "JUNFloatControlInteractiveState.h"
#import "JUNFloatControlMinimiumState.h"
#import "JUNFloatControl+Internal.h"
#import "UIView+JUNFloatControl.h"
#import "JUNFloatControlConfig.h"

@interface JUNFloatControlInteractiveState ()

@end

@implementation JUNFloatControlInteractiveState

- (void)toggle {
    self.control.state = self.control.minimiumState;
    [self handleToggleTransition];
}

- (void)pan:(UIPanGestureRecognizer *)gesture {
    //TODO: to develop
}

- (void)orientationChange:(NSNotification *)notification {
    [self toggle];
    [self.control.state orientationChange:notification];
    [self.control.contentView setNeedsLayout];
}

- (void)handleToggleTransition {
    [UIView animateWithDuration:self.control.config.animDuration animations:^{
        self.control.transitionView.alpha = 0;
//        self.control.contentView.alpha = 0;
        self.control.accessoryView.size = self.control.config.thumbSize;
        if (self.control.contentView.bottom == self.control.accessoryView.top) {
            self.control.contentView.height = 0;
            self.control.accessoryView.top = self.control.contentView.bottom;
            self.control.cornerView.top = self.control.accessoryView.top;
        } else if (self.control.contentView.right == self.control.accessoryView.left) {
            self.control.contentView.width = 0;
            self.control.accessoryView.left = self.control.contentView.right;
            self.control.cornerView.left = self.control.accessoryView.left;
        } else if (self.control.contentView.top == self.control.accessoryView.bottom) {
            self.control.contentView.top = self.control.contentView.bottom;
            self.control.contentView.height = 0;
            self.control.accessoryView.bottom = self.control.contentView.top;
            self.control.cornerView.bottom = self.control.accessoryView.bottom;
        } else if (self.control.contentView.left == self.control.accessoryView.right) {
            self.control.contentView.left = self.control.contentView.right;
            self.control.contentView.width = 0;
            self.control.accessoryView.right = self.control.contentView.left;
            self.control.cornerView.right = self.control.accessoryView.right;
        } else {
            NSParameterAssert(false);
        }
    } completion:^(BOOL finished) {
        self.control.frame = self.control.accessoryView.frame;
        self.control.accessoryView.origin = CGPointZero;
        self.control.cornerView.origin = self.control.accessoryView.origin;
    }];
}

@end
