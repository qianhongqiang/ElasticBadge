//
//  HQliquidButton.h
//  HQliquidView
//
//  Created by qianhongqiang on 15/5/29.
//  Copyright (c) 2015年 QianHongQiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HQliquidButton : UIView

@property (nonatomic, assign, readonly) int bagdeNumber;
@property (nonatomic, strong) UIColor *HQ_textColor;

-(instancetype)initWithLocationCenter:(CGPoint)center bagdeNumber:(int)badgeNumber willDismissCallBack:(void(^)(HQliquidButton *liquidButton))dismiss;

@end
