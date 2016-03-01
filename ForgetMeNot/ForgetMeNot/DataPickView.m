//
//  DataPickView.m
//  yijikang
//
//  Created by Limingkai on 15/3/19.
//  Copyright (c) 2015年 SINOSOFT. All rights reserved.
//

#import "DataPickView.h"

#define kDuration 0.5

@interface DataPickView() <UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *dataPickerView;

@end

@implementation DataPickView {
    UIView *_blackView;
    UITapGestureRecognizer *_recognizer;
}

- (id)initWithTitle:(NSString *)title handler:(void (^)(NSInteger seletedIndex))aHandlerBlock {
    self = [[[NSBundle mainBundle] loadNibNamed:@"DataPickView" owner:self options:nil] objectAtIndex:0];
    if (self) {
        self.titleLabel.text = title;
        self.handlerBlock = aHandlerBlock;
        _recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeSheetView:)];
        _dataPickerView.delegate = self;
        _dataPickerView.dataSource = self;
    }
    return self;
}

- (void)showInView:(UIView *)view {
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromTop;
    [self setAlpha:1.0f];
    [self.layer addAnimation:animation forKey:@"DDDataPickerView"];
    
    self.frame = CGRectMake(0, view.frame.size.height - 261.0f, view.frame.size.width, 261.0f);
    _blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    _blackView.backgroundColor = [UIColor clearColor];
    _blackView.tag = 255;
    [_blackView addGestureRecognizer:_recognizer];
    [view addSubview:_blackView];
    [_blackView addSubview:self];
    [_dataPickerView selectRow:_selectIndex inComponent:0 animated:YES];
}

- (NSInteger)selectIndex {
    return [_dataPickerView selectedRowInComponent:0];
}

#pragma mark - Button lifecycle

- (void)closeSheetView:(id)sender {
    
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self setAlpha:0.0f];
    [self.layer addAnimation:animation forKey:@"TSDataPickerView"];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:kDuration];
    [_blackView removeGestureRecognizer:_recognizer];
    [_blackView removeFromSuperview];
}

#pragma mark - IBActions
- (IBAction)cancelButtonPressed:(id)sender {
    [self closeSheetView:nil];
}

- (IBAction)confirmButtonPressed:(id)sender {
    [self closeSheetView:nil];
    if (self.handlerBlock) {
        self.handlerBlock([self.dataPickerView selectedRowInComponent:0]);
    }
}

#pragma mark - UIPickerViewDelegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.pickerArray count];
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if ([self.pickerArray[row] isKindOfClass:[NSString class]]) {
        return self.pickerArray[row];
    }
    return [[self.pickerArray objectAtIndex:row] stringValue];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
