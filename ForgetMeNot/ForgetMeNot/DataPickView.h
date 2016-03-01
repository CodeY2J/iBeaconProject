//
//  DataPickView.h
//  yijikang
//
//  Created by Limingkai on 15/3/19.
//  Copyright (c) 2015年 SINOSOFT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataPickView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (copy, nonatomic) NSArray *pickerArray;
@property (copy, nonatomic) void(^handlerBlock)(NSInteger seletedIndex);
@property (nonatomic,assign) NSInteger selectIndex;

- (id)initWithTitle:(NSString *)title handler:(void (^)(NSInteger seletedIndex))aHandlerBlock;
- (void)showInView:(UIView *)aView;

@end
