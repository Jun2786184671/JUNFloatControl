//
//  JUNFloatControlAbstractState.m
//  JUNFloatControl
//
//  Created by Jun Ma on 2023/2/21.
//

#import "JUNFloatControlAbstractState.h"
#import "JUNFloatControl.h"

#define OAAShouldNotCallAbstractMethod [NSException exceptionWithName:@"OAAAbstractMethodException" reason:@"Abstract method to be implmented." userInfo:nil]

@implementation JUNFloatControlAbstractState

- (instancetype)initWithControl:(JUNFloatControl *)control {
    if (self = [super init]) {
        _control = control;
    }
    return self;
}

- (void)present:(UIView *)newSuperview { @throw OAAShouldNotCallAbstractMethod; }
- (void)dismiss { @throw OAAShouldNotCallAbstractMethod; }
- (void)toggle { @throw OAAShouldNotCallAbstractMethod; }
- (void)pan:(UIPanGestureRecognizer *)gesture { @throw OAAShouldNotCallAbstractMethod; }
- (void)orientationChange:(NSNotification *)notification { @throw OAAShouldNotCallAbstractMethod; }


@end
