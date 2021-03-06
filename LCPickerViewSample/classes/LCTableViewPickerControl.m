//
//  LCTableViewPickerControl.m
//  InsurancePig
//
//  Created by Leo Chang on 10/21/13.
//  Copyright (c) 2013 Good-idea Consunting Inc. All rights reserved.
//

#import "LCTableViewPickerControl.h"

#define kNavBarHeight 44
#define cellIdentifier @"itemPickerCellIdentifier"

@interface LCTableViewPickerControl () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSArray *items;
@property (weak) id currentVale;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UINavigationBar *navBar;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UITableView *aTableView;
@end

@implementation LCTableViewPickerControl

- (id)initWithFrame:(CGRect)frame title:(NSString*)title value:(id)value items:(NSArray *)array
{
    if (self = [super initWithFrame:frame])
    {
        self.currentVale = value;
        self.items = [NSArray arrayWithArray:array];
        self.title = title;
        [self initializeControlWithFrame:frame];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initializeControlWithFrame:(CGRect)frame
{
    /*
     create navigation bar
     */
    self.navBar = [[UINavigationBar alloc] init];
    UINavigationItem *topItem = [[UINavigationItem alloc] initWithTitle:_title];
    [_navBar setFrame:CGRectMake(0, 0, frame.size.width, 44)];
    if ([_navBar respondsToSelector:@selector(setBarTintColor:)])
    {
        _navBar.barTintColor = kPickerTitleBarColor;
    }
    else
    {
        _navBar.tintColor = kPickerTitleBarColor;
    }
    /*
     create dismissItem
     */
    _navBar.items = [NSArray arrayWithObject:topItem];
    
    
    self.aTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, frame.size.width, frame.size.height - kNavBarHeight) style:UITableViewStylePlain];
    [_aTableView setDelegate:self];
    [_aTableView setDataSource:self];
    [self addSubview:_navBar];
    [self addSubview:_aTableView];
    
    //add UIPanGesture
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelegate:self];
    [_navBar addGestureRecognizer:panRecognizer];
    
}

- (void)show
{
    UIViewController *parentView = (UIViewController*)_delegate;
    //add mask
    self.maskView = [[UIView alloc] initWithFrame:parentView.view.bounds];
    [_maskView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0]];
    [parentView.view insertSubview:_maskView atIndex:2];
    
    [UIView animateWithDuration:kAnimationDuration delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        [self setFrame:CGRectMake(0, parentView.view.frame.size.height - kPickerControlAgeHeight, kPickerControlWidth, kPickerControlAgeHeight)];
        [_maskView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6]];
    } completion:^(BOOL finished){
        //scroll to currentValue
        NSInteger index = [_items indexOfObject:_currentVale];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [_aTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }];
}

- (void)dismiss
{
    UIViewController *parentView = (UIViewController*)_delegate;
    
    //animation to dismiss
    [UIView animateWithDuration:kAnimationDuration delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        [self setFrame:CGRectMake(0, parentView.view.frame.size.height, kPickerControlAgeHeight, kPickerControlWidth)];
        [_maskView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0]];
    } completion:^(BOOL finished){
        [self removeFromSuperview];
        [_maskView removeFromSuperview];
    }];

}

- (void)dismissPickerView:(id)sender
{
    /*
     if press cancel button
     */
    [self.delegate selectControl:self didSelectWithItem:[NSString stringWithFormat:@""]];
}

#pragma mark - handle PanGesture
- (void)move:(UIPanGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [gestureRecognizer translationInView:self];
        
        if(translation.y < 0)
            return;
        
        CGPoint translatedCenter = CGPointMake([self center].x, [self center].y + translation.y);
        NSLog(@"y:%f", translation.y);
        [self setCenter:translatedCenter];
        [gestureRecognizer setTranslation:CGPointZero inView:self];
    }
    if ([gestureRecognizer state] == UIGestureRecognizerStateEnded)
    {
        CGPoint translation = [gestureRecognizer translationInView:self];
        if(translation.y < 0)
            return;
        [self.delegate selectControl:self didSelectWithItem:[NSString stringWithFormat:@""]];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_items count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSInteger row = [indexPath row];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    id item = [_items objectAtIndex:row];
    
    if ([_currentVale isKindOfClass:[NSString class]])
    {
        if ([item isEqualToString:_currentVale])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else if ([_currentVale isKindOfClass:[NSNumber class]])
    {
        if ([item isEqualToNumber:_currentVale])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    [cell.textLabel setText:[NSString stringWithFormat:@"%@",[_items objectAtIndex:row]]];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate selectControl:self didSelectWithItem:[_items objectAtIndex:indexPath.row]];
}




@end
