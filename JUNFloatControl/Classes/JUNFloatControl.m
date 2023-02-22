//
//  JUNFloatControl.m
//  JUNFloatControl
//
//  Created by Jun Ma on 2023/2/21.
//

#import "JUNFloatControl.h"
#import "JUNFloatControl+Internal.h"
#import "JUNFloatControlConfig.h"
#import "JUNFloatControlAbstractState.h"
#import "JUNFloatControlMinimiumState.h"
#import "JUNFloatControlInteractiveState.h"

@interface JUNFloatControl ()

@property(nonatomic, assign) UIDeviceOrientation prevOrientation;

@end

@implementation JUNFloatControl

static NSString * const UIDeviceOrientationRotateAnimatedUserInfoKey = @"UIDeviceOrientationRotateAnimatedUserInfoKey";

- (instancetype)initWithConfig:(JUNFloatControlConfig *)config {
    if (self = [super init]) {
        self.config = config;
        [self addSubview:self.transitionView];
        [self addSubview:self.cornerView];
        [self addSubview:self.accessoryView];
        [self addSubview:self.contentView];
        self.minimiumState = [[JUNFloatControlMinimiumState alloc] initWithControl:self];
        self.interactiveState = [[JUNFloatControlInteractiveState alloc] initWithControl:self];
        self.state = self.minimiumState;
        [self registerDeviceOrientationChangeNotification];
    }
    return self;
}

- (instancetype)init {
    return [self initWithConfig:[JUNFloatControlConfig sharedConfig]];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    [self present:newSuperview];
}

- (void)removeFromSuperview {
    [super removeFromSuperview];
    [self dismiss];
}

#pragma mark - Stateful

- (void)present:(UIView *)newSuperview {
    [self.state present:newSuperview];
}

- (void)dismiss {
    [self.state dismiss];
}

- (void)toggle {
    UIImpactFeedbackGenerator *impact = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
    [impact prepare];
    [impact impactOccurred];
    [self.state toggle];
}

- (void)pan:(UIPanGestureRecognizer *)gesture {
    [self.state pan:gesture];
}

- (void)orientationChange:(NSNotification *)notification {
    BOOL deviceOrientationRotateAnimated = [notification.userInfo[UIDeviceOrientationRotateAnimatedUserInfoKey] boolValue];
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (orientation == UIDeviceOrientationUnknown || orientation == UIDeviceOrientationFaceUp || orientation == UIDeviceOrientationFaceDown) return;
    if (deviceOrientationRotateAnimated && self.prevOrientation) {
        if ([self shouldRefreshControlPosition]) {
            [self.state orientationChange:notification];
        }
    }
    self.prevOrientation = orientation;
}

#pragma mark - Private

- (void)registerDeviceOrientationChangeNotification {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(deviceOrientationOnChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (BOOL)shouldRefreshControlPosition {
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    return [self isDeviceOrientationHorizontal:orientation] ^ [self isDeviceOrientationHorizontal:self.prevOrientation];
}

- (BOOL)isDeviceOrientationHorizontal:(UIDeviceOrientation)orientation {
    NSParameterAssert(orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationPortraitUpsideDown || orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight);
    return orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight;
}

#pragma mark - UI events

- (void)accessoryViewOnTap:(UITapGestureRecognizer *)gesture {
    [self toggle];
}

- (void)accessoryViewOnPan:(UIPanGestureRecognizer *)gesture {
    [self pan:gesture];
}

- (void)transitionViewOnTap:(UITapGestureRecognizer *)gesture {
    [self toggle];
}

- (void)deviceOrientationOnChange:(NSNotification *)notification {
    [self orientationChange:notification];
}

#pragma mark - Lazy load

- (UIView *)transitionView {
    if (!_transitionView) {
        _transitionView = [[UIView alloc] init];
        _transitionView.backgroundColor = self.config.maskColor;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(transitionViewOnTap:)];
        [_transitionView addGestureRecognizer:tap];
    }
    return _transitionView;
}

- (UIView *)cornerView {
    if (!_cornerView) {
        _cornerView = [[UIView alloc] init];
        _cornerView.layer.cornerRadius = self.config.thumbRadius;
        _cornerView.backgroundColor = self.config.thumbColor;
    }
    return _cornerView;
}

- (UIImageView *)accessoryView {
    if (!_accessoryView) {
        _accessoryView = [[UIImageView alloc] initWithImage:self.config.thumbImage];
        _accessoryView.contentMode = UIViewContentModeScaleAspectFit;
        _accessoryView.layer.cornerRadius = self.config.thumbRadius;
        _accessoryView.layer.masksToBounds = true;
        _accessoryView.backgroundColor = self.config.thumbColor;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(accessoryViewOnTap:)];
        [_accessoryView addGestureRecognizer:tap];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(accessoryViewOnPan:)];
        [_accessoryView addGestureRecognizer:pan];
        _accessoryView.userInteractionEnabled = true;
    }
    return _accessoryView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = self.config.contentRadius;
        _contentView.layer.masksToBounds = true;
        _contentView.layer.borderColor = self.config.contentBorderColor.CGColor;
        _contentView.layer.borderWidth = self.config.contentBorderWidth;
        [_contentView addSubview:self.config.content];
    }
    return _contentView;
}

@end
