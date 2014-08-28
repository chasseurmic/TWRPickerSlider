//
//  TWRViewController.m
//  TWRPickerSlider
//
//  Created by Michelangelo Chasseur on 28/08/14.
//  Copyright (c) 2014 Touchware. All rights reserved.
//

#import "TWRViewController.h"
#import "TWRPickerSlider.h"
#import "TWRDemoObject.h"

@interface TWRViewController () <TWRPickerSliderDelegate>

@end

@implementation TWRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    TWRDemoObject *obj1 = [[TWRDemoObject alloc] initWithTitle:@"Object 1"];
    TWRDemoObject *obj2 = [[TWRDemoObject alloc] initWithTitle:@"Object 2"];
    
    // Picker Slider
    TWRPickerSlider *slider = [[TWRPickerSlider alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 200)];
    
    // Colors
    slider.mainColor = [UIColor grayColor];
    slider.secondaryColor = [UIColor whiteColor];
    
    // Objects for picker
    slider.pickerObjects = @[obj1, obj2];
    
    // Texts
    slider.leftText = @"Area anatomica:";
    slider.rightText = @"Seleziona un'opzione";
    
    // Delegate
    slider.delegate = self;
    
    [self.view addSubview:slider];
}

- (void)objectSelected:(id<TWRPickerSliderDataDelegate>)selectedObject {
    NSLog(@"Selected object: %@", [selectedObject pickerTitle]);
}

@end
