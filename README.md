TWRPickerSlider
=================

## TWRPickerSlider

A custom view component that gives the user the ability to stack picker views.

[![TWRPickerSlider Demo](http://cocoahunter-blog.s3.amazonaws.com/TWRPickerSlider/TWRPickerSlider_screenshot.png)](http://cocoahunter-blog.s3.amazonaws.com/TWRPickerSlider/TWRPickerSlider.mp4)

## Usage

Add the dependency to your `Podfile`:

```ruby
platform :bios
pod 'TWRPickerSlider’, ‘~> 1.0’
...
```

Run `pod install` to install the dependencies.

Next, import the header file wherever you want to use the picker:

```objc
#import "TWRSliderStackedView.h"
#import "TWRPickerSlider.h"
```

You should first initialize your `TWRPickerSlider` as such:

```objc
TWRPickerSlider *slider1 = [[TWRPickerSlider alloc] init];
```

…and assign some objects for the picker:

```
slider1.pickerObjects = @[obj1, obj2, obj3];
```

Objects passed to the picker can be of any type, provided they conform to the `TWRPickerSliderDatasource` protocol. Said protocol only requires the user to implement the following method, which returns the string that the picker will display for the object:

```objc
- (NSString *)twr_pickerTitle;
```

Then set the picker delegate to be your view controller and implement the `TWRPickerSliderDelegate` protocol:

```objc
// Set Delegate
slider1.delegate = self;

// TWRPickerSliderDelegate
- (void)objectSelected:(id<TWRPickerSliderDatasource>)selectedObject sender:(TWRPickerSlider *)sender{
    NSLog(@"Selected object: %@", [selectedObject twr_pickerTitle]);
}
```

Finally add you `TWRPickerSlider` instance to your view. It will automatically position itself at the bottom of the view and animate / slide when pressed.

## Stacking pickers

Alternatively, if you have or want to display more than one picker at a time, you can instantiate a `TWRSliderStackedView` object and assign it an array of `TWRPickerSlider`.

```objc
TWRSliderStackedView *stack = [[TWRSliderStackedView alloc] init];
stack.sliders = @[slider1, slider2, slider3];
[self.view addSubview:stack];
```

Again, the stacked view will position itself at the bottom of the current view. If you’re working inside a tab bar controller, or if you don’t want the stacked view to stick at the bottom of the view controller, you can use one of the following two methods:

```objc
- (instancetype)initWithBottomPadding:(NSUInteger)padding;
- (instancetype)initWithTabBar;
```

See the demo project for more details.

## Requirements

`TWRPickerSlider ` requires iOS 7.x or greater.


## License

Usage is provided under the [MIT License](http://opensource.org/licenses/mit-license.php).  See LICENSE for the full details.