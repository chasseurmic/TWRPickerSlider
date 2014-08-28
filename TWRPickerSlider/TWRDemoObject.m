//
//  TWRDemoObject.m
//  TWRPickerSlider
//
//  Created by Michelangelo Chasseur on 28/08/14.
//  Copyright (c) 2014 Touchware. All rights reserved.
//

#import "TWRDemoObject.h"

@interface TWRDemoObject ()

@property (strong, nonatomic) NSString *title;

@end

@implementation TWRDemoObject

- (instancetype)initWithTitle:(NSString *)title {
    self = [super init];
    if (self) {
        self.title = title;
    }
    return self;
}

- (NSString *)twr_pickerTitle {
    return self.title;
}

@end
