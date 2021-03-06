//
//  ViewController.m
//  LCPickerViewSample
//
//  Created by Leo Chang on 10/21/13.
//  Copyright (c) 2013 MountainStar Inc. All rights reserved.
//

#import "ViewController.h"
#import "LCTableViewPickerControl.h"

@interface ViewController () <LCItemPickerDelegate>

@property (nonatomic, strong) UIView *maskView;
@property (weak) id pickValue;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)show:(id)sender
{
    LCTableViewPickerControl *pickerView = [[LCTableViewPickerControl alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, kPickerControlWidth, kPickerControlAgeHeight) title:@"Please pick an item" value:_pickValue items:@[@"item1",@"item2",@"item3",@"item4",@"item5",@"item6"]];
    [pickerView setDelegate:self];
    [pickerView setTag:0];
    
    [self.view addSubview:pickerView];
    
    [pickerView show];
}

- (void)dismissPickerControl:(LCTableViewPickerControl*)view
{
    [view dismiss];
}

#pragma mark - LCTableViewPickerDelegate


- (void)selectControl:(LCTableViewPickerControl*)view didSelectWithItem:(id)item
{
    /*
     Check item is NSString or NSNumber , if it is necessary
     */
    if (view.tag == 0)
    {
        if ([item isKindOfClass:[NSString class]])
        {
            
        }
        else if ([item isKindOfClass:[NSNumber class]])
        {
            
        }
    }
    
    self.pickValue = item;
    [_resultLabel setText:[NSString stringWithFormat:@"%@", item]];
    
    [self dismissPickerControl:view];
}

- (void)selectControl:(LCTableViewPickerControl *)view didCancelWithItem:(id)item
{
    
    [self dismissPickerControl:view];
}
@end
