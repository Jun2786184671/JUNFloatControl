//
//  JUNViewController.m
//  JUNFloatControl
//
//  Created by Jun Ma on 02/22/2023.
//  Copyright (c) 2023 Jun Ma. All rights reserved.
//

#import "JUNViewController.h"
#import <JUNFloatControl/JUNFloatControl.h>
#import <JUNFlex/JUNFlex.h>

@interface JUNViewController ()

@end

@implementation JUNViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    JUNFloatControlConfig *config = [[JUNFloatControlConfig alloc] init];
    config.content = [self getExampleContent];
    JUNFloatControl *control = [[JUNFloatControl alloc] initWithConfig:config];
    [self.view addSubview:control];
}

- (UIView *)getExampleContent {
    return
    JUNFlex.list
    .itemSize(140, 40)
    .itemSpacing(16)
    .count(10, ^id _Nonnull(NSUInteger i) {
        return
        JUNFlex.hstack
        .children(@[
            JUNFlex.item
            .align(-1, 0)
            .size(80, CGFLOAT_MAX)
            .text(
                [NSString stringWithFormat:@"option %zd", i],
                [UIFont systemFontOfSize:14],
                nil
            ),
            [[UISwitch alloc] init],
        ]);
    });
}

@end
