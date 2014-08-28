//
//  TWRPickerSlider.h
//  TWRPickerSlider
//
//  Created by Michelangelo Chasseur on 28/08/14.
//  Copyright (c) 2014 Touchware. All rights reserved.
//

#define PICKER_DEFAULT_VISIBLE_HEIGHT 44

#import <UIKit/UIKit.h>
@class TWRPickerSlider;

@protocol TWRPickerSliderDatasource <NSObject>
- (NSString *)twr_pickerTitle;
@end

@protocol TWRPickerSliderDelegate <NSObject>
- (void)objectSelected:(id<TWRPickerSliderDatasource>)selectedObject sender:(TWRPickerSlider *)sender;
@end

@interface TWRPickerSlider : UIView

// Objects for the data picker that should conform to TWRPickerSliderDataDelegate
@property (strong, nonatomic) NSArray *pickerObjects;
@property (strong, nonatomic) UIColor *mainColor;
@property (strong, nonatomic) UIColor *secondaryColor;
@property (strong, nonatomic) id<TWRPickerSliderDelegate> delegate;

// Strings for header view
@property (strong, nonatomic) NSString *leftText;
@property (strong, nonatomic) NSString *rightText;

@end
