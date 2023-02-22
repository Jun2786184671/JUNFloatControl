# JUNFloatControl

[![Version](https://img.shields.io/cocoapods/v/JUNFloatControl.svg?style=flat)](https://cocoapods.org/pods/JUNFloatControl)
[![License](https://img.shields.io/cocoapods/l/JUNFloatControl.svg?style=flat)](https://cocoapods.org/pods/JUNFloatControl)
[![Platform](https://img.shields.io/cocoapods/p/JUNFloatControl.svg?style=flat)](https://cocoapods.org/pods/JUNFloatControl)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

JUNFloatControl is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'JUNFloatControl'
```
## Example
<video width="320" height="240" controls>
  <source src="JUNFloatControl.mov" type="video/mp4">
</video>

## Usage
```objc
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    JUNFloatControlConfig *config = [[JUNFloatControlConfig alloc] init]; // Here use default config.
    config.content = [self customizeYourContentHere]; // Customize your content here, any UIView.
    JUNFloatControl *control = [[JUNFloatControl alloc] initWithConfig:config];
    [self.view addSubview:control];
}
```

## Configuration
```objc
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
```

## Author

Jun Ma, maxinchun5@gmail.com

## License

JUNFloatControl is available under the MIT license. See the LICENSE file for more info.
