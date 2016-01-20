# EASlider
A slider control like font slider in iPhone's Settings.app

![image](https://raw.githubusercontent.com/fdddf/EASlider/master/screenshot.png)

# Installation
### Using CocoaPods
```
pod 'EASlider'
```
In you code include it like this:
```objc
#import <EASlider/EASlider.h>
```
### Directly with code source
copy EASlider.(h, m) and EAThumb.(h, m) under EASlider/Classes to your project.
And include it in code:
```objc
#import "EASlider.h"
```
# Usage
```objc
EASlider *slider = [[EASlider alloc] initWithLabels:@[
            [self labelWithFont:[UIFont systemFontOfSize:10.f] text:@"A"],
            [self labelWithFont:nil text:@""],
            [self labelWithFont:nil text:@""],
            [self labelWithFont:nil text:@""],
            [self labelWithFont:nil text:@""],
            [self labelWithFont:[UIFont systemFontOfSize:30.f] text:@"A"],
        ]];
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
```

# Deployment
EASlider requires iOS7+,  tested in iPhone6 Plus and iPhone5, works fine.

# License
- MIT License 
- Welcome any pull request or open issues.


# Credits 
ShadyElyaski/ios-filter-control
https://github.com/ShadyElyaski/ios-filter-control
