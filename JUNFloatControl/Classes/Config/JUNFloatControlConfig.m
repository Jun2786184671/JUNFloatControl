//
//  JUNFloatControlConfig.m
//  JUNFloatControl
//
//  Created by Jun Ma on 2023/2/21.
//

#import "JUNFloatControlConfig.h"

@implementation JUNFloatControlConfig

+ (instancetype)sharedConfig {
    static JUNFloatControlConfig *config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[self alloc] init];
    });
    return config;
}

- (instancetype)init {
    if (self = [super init]) {
        self.thumbSize = CGSizeMake(48.0, 48.0);
        self.thumbRadius = 24.0;
        self.thumbImage = [self getDemoThumbImage];
        self.thumbColor = [UIColor colorWithRed:102/255.0f green:195/255.0f blue:85/255.0f alpha:1.0];
        self.contentSize = CGSizeMake(180.0, 200.0);
        self.contentRadius = 8.0;
        self.contentBorderColor = [UIColor lightGrayColor];
        self.contentBorderWidth = 1.0;
        self.initialPositionRatio = CGPointMake(0, 0.5);
        self.animDuration = 0.3;
        self.maskColor = [UIColor colorWithRed:0xaa/255.0f green:0xaa/255.0f blue:0xaa/255.0f alpha:0.6];
    }
    return self;
}

- (UIImage *)getDemoThumbImage {
    if (@available(iOS 13.0, *)) {
        return [UIImage systemImageNamed:@"globe.asia.australia.fill"];
    } else {
        return [self getImageFromResourceBundle:@"demo"];
    }
}

- (NSBundle *)getResourcesBundle {
    NSBundle *podBundle = [NSBundle bundleForClass:[self class]];
    NSURL *bundleUrl = [podBundle URLForResource:@"JUNFloatControl" withExtension:@"bundle"];
    return [NSBundle bundleWithURL:bundleUrl];
}


- (UIImage *)getImageFromResourceBundle:(NSString *)imageName {
    NSBundle *bundle = [self getResourcesBundle];
    NSString *imageFileName = [NSString stringWithFormat:@"%@.png",imageName];
    UIImage *image = [UIImage imageNamed:imageFileName inBundle:bundle compatibleWithTraitCollection:nil];
    return image;
}

@end
