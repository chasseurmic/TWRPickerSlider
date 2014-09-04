//
//  TWRPickerSlider.m
//  TWRPickerSlider
//
//  Created by Michelangelo Chasseur on 28/08/14.
//  Copyright (c) 2014 Touchware. All rights reserved.
//

#import "TWRPickerSlider.h"
#import "TWRPickerSliderHeaderView.h"

#define PICKER_CUSTOM_HEIGHT 200
#define PICKER_DATE_HEIGHT 250

@interface TWRPickerSlider () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (assign, nonatomic) NSUInteger visibleHeight;
@property (strong, nonatomic) UIButton *button;

@property (strong, nonatomic) UIPickerView *picker;
@property (strong, nonatomic) UIDatePicker *datePicker;

@property (strong, nonatomic) TWRPickerSliderHeaderView *header;
@property (assign, nonatomic) BOOL open;

@property (strong, nonatomic) id<TWRPickerSliderDatasource> selectedObject;
@property (strong, nonatomic) NSDate *selectedDate;

@property (assign, nonatomic) TWRPickerSliderType pickerType;

@end

@implementation TWRPickerSlider

- (id)init {
    self = [self initWithFrame:CGRectZero visibleHeight:PICKER_DEFAULT_VISIBLE_HEIGHT];
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [self initWithFrame:frame visibleHeight:PICKER_DEFAULT_VISIBLE_HEIGHT];
    if (self) {
        // Initialization code
    }
    return self;
}

- (instancetype)initWithType:(TWRPickerSliderType)type {
    self = [self init];
    if (self) {
        self.pickerType = type;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame visibleHeight:(NSUInteger)visibleHeight {
    self = [super initWithFrame:frame];
    if (self) {
        self.open = NO;
        self.visibleHeight = visibleHeight;
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (!newSuperview) {
        return;
    }
    newSuperview.userInteractionEnabled = YES;
    self.backgroundColor = self.mainColor;
    
    // Header
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TWRPickerSliderHeaderView class])
                                                      owner:self
                                                    options:nil];
    self.header = [nibViews objectAtIndex:0];
    self.header.leftLabel.text = self.leftText;
    self.header.rightLabel.text = self.rightText;
    self.header.leftLabel.textColor = self.leftTextColor ? self.leftTextColor : self.secondaryColor;
    self.header.rightLabel.textColor = self.rightTextColor ? self.rightTextColor : self.secondaryColor;
    
    UIImage *headerImage = [[UIImage imageNamed:@"input_icon_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.header.imageView setImage:headerImage];
    self.header.imageView.tintColor = self.secondaryColor;
    
    // Button
    self.button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(newSuperview.frame), self.visibleHeight)];
    [self.button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    // Add a small delay to prevent adding to view before init has finished
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        switch (self.position) {
                //*** BOTTOM ***//
            case TWRPickerSliderPositionBottom: {
                
                // Picker
                CGRect rect = CGRectMake(0, self.visibleHeight, CGRectGetWidth(newSuperview.frame), CGRectGetHeight(self.frame) - self.visibleHeight);
                switch (self.type) {
                    case TWRPickerSliderTypeCustomObjects: {
                        self.frame = CGRectMake(CGRectGetMinX(newSuperview.frame), CGRectGetHeight(newSuperview.frame) - self.visibleHeight, CGRectGetWidth(newSuperview.frame), PICKER_CUSTOM_HEIGHT);
                        [self configurePickerWithRect:rect];
                    }
                        break;
                        
                    case TWRPickerSliderTypeDatePicker: {
                        self.frame = CGRectMake(CGRectGetMinX(newSuperview.frame), CGRectGetHeight(newSuperview.frame) - self.visibleHeight, CGRectGetWidth(newSuperview.frame), PICKER_DATE_HEIGHT);
                        [self configureDatePickerWithRect:rect];
                    }
                        break;
                        
                    default:
                        break;
                }
            }
                break;
                
                //*** TOP ***//
            case TWRPickerSliderPositionTop: {
                
                // Picker
                CGRect rect = CGRectMake(0, 0, CGRectGetWidth(newSuperview.frame), CGRectGetHeight(self.frame) - self.visibleHeight);
                switch (self.type) {
                    case TWRPickerSliderTypeCustomObjects: {
                        self.frame = CGRectMake(CGRectGetMinX(newSuperview.frame), 44 - PICKER_CUSTOM_HEIGHT, CGRectGetWidth(newSuperview.frame), PICKER_CUSTOM_HEIGHT);
                        [self configurePickerWithRect:rect];
                    }
                        break;
                        
                    case TWRPickerSliderTypeDatePicker: {
                        self.frame = CGRectMake(CGRectGetMinX(newSuperview.frame), 44 - PICKER_DATE_HEIGHT, CGRectGetWidth(newSuperview.frame), PICKER_DATE_HEIGHT);
                        [self configureDatePickerWithRect:rect];
                    }
                        break;
                        
                    default:
                        break;
                }
                
                self.header.frame = CGRectMake(CGRectGetMinX(newSuperview.frame), CGRectGetHeight(self.frame) - 44, CGRectGetWidth(newSuperview.frame), self.visibleHeight);
                self.button.frame = CGRectMake(CGRectGetMinX(newSuperview.frame), CGRectGetHeight(self.frame) - 44, CGRectGetWidth(newSuperview.frame), self.visibleHeight);
                
            }
                break;
                
            default:
                break;
        }
    });
    [self addSubview:self.header];
    [self addSubview:self.button];
}

- (void)configurePickerWithRect:(CGRect)rect {
    // Picker View
    self.picker = [[UIPickerView alloc] initWithFrame:rect];
    self.picker.dataSource = self;
    self.picker.delegate = self;
    self.picker.tintColor = self.secondaryColor;
    [self addSubview:self.picker];
}

- (void)configureDatePickerWithRect:(CGRect)rect {
    // Date Picker
    self.datePicker = [[UIDatePicker alloc] initWithFrame:rect];
    [self.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self addSubview:self.datePicker];
}

- (void)buttonPressed:(id)sender {
    switch (self.position) {
        case TWRPickerSliderPositionBottom: {
            if (!self.open) {
                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.transform = CGAffineTransformMakeTranslation(0, -CGRectGetHeight(self.frame) + self.visibleHeight);
                } completion:^void(BOOL finished) {
                    self.open = !self.open;
                }];
            } else {
                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.transform = CGAffineTransformIdentity;
                } completion:^void(BOOL finished) {
                    self.open = !self.open;
                    [self sendDelegateMessage];
                }];
            }
        }
            break;
        case TWRPickerSliderPositionTop: {
            if (!self.open) {
                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.frame) - self.visibleHeight);
                } completion:^void(BOOL finished) {
                    self.open = !self.open;
                }];
            } else {
                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.transform = CGAffineTransformIdentity;
                } completion:^void(BOOL finished) {
                    self.open = !self.open;
                    if ([self.delegate respondsToSelector:@selector(objectSelected:sender:)]) {
                        [self.delegate objectSelected:self.selectedObject sender:self];
                    }
                }];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)sendDelegateMessage {
    switch (self.type) {
        case TWRPickerSliderTypeCustomObjects: {
            if ([self.delegate respondsToSelector:@selector(objectSelected:sender:)]) {
                [self.delegate objectSelected:self.selectedObject sender:self];
            }
        }
            break;
        case TWRPickerSliderTypeDatePicker: {
            if ([self.delegate respondsToSelector:@selector(dateSelected:sender:)]) {
                [self.delegate dateSelected:self.selectedDate sender:self];
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Picker View Datasource / Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.pickerObjects.count + 1;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (row == 0) {
        if (!self.secondaryColor) {
            self.secondaryColor = [UIColor blackColor];
        }
        return [[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName:[self secondaryColor]}];
    } else {
        id<TWRPickerSliderDatasource>object = [self.pickerObjects objectAtIndex:row - 1];
        if ([[object class] conformsToProtocol:@protocol(TWRPickerSliderDatasource)]) {
            return [[NSAttributedString alloc] initWithString:[object twr_pickerTitle] attributes:@{NSForegroundColorAttributeName:[self secondaryColor]}];
        } else {
            [[NSException exceptionWithName:@"TWRPickerSliderDataDelegateException" reason:@"Objects provided as the picker datasource should be conformant to TWRPickerSliderDataDelegate protocol!" userInfo:nil] raise];
        }
    }
    
    // fallback
    return [[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName:[self secondaryColor]}];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (row == 0) {
        return;
    }
    id<TWRPickerSliderDatasource>object = [self.pickerObjects objectAtIndex:row - 1];
    self.selectedObject = object;
    self.header.rightLabel.text = [object twr_pickerTitle];
}

#pragma mark - Date picker

- (void)dateChanged:(UIDatePicker *)sender {
    //    NSLog(@"date: %@", sender.date);
    self.selectedDate = sender.date;
    NSDateFormatter *df = [NSDateFormatter new];
    [df setTimeStyle:NSDateFormatterNoStyle];
    [df setDateStyle:NSDateFormatterMediumStyle];
    self.header.rightLabel.text = [df stringFromDate:sender.date];
}

@end
