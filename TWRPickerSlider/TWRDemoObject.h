//
//  TWRDemoObject.h
//  TWRPickerSlider
//
//  Created by Michelangelo Chasseur on 28/08/14.
//  Copyright (c) 2014 Touchware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWRPickerSlider.h"

@interface TWRDemoObject : NSObject <TWRPickerSliderDatasource>

- (instancetype)initWithTitle:(NSString *)title;

@end
