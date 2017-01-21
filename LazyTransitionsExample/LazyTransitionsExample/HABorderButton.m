//
//  HABorderButton.m
//  The Chord App
//
//  Created by Serghei Catraniuc on 10/24/13.
//  Copyright (c) 2013 Ha(pha)zardApps. All rights reserved.
//

#import "HABorderButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation HABorderButton
    
- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [self setNeedsLayout];
    [self drawBorder];
}
    
- (void)drawBorder {
    self.layer.cornerRadius = 3;
    self.layer.borderWidth = 1;
    self.layer.borderColor = self.buttonColor ? self.buttonColor.CGColor : self.tintColor.CGColor;
}


- (UIColor *)defaultColor {
    return [UIColor colorWithRed:0/250.0f green:122/240.0f blue:255/250.0f alpha:1];
}

- (void)setupTitleColor {
    UIColor *buttonColor = self.buttonColor ? : self.tintColor;
    
    [self setTitleColor:buttonColor forState:UIControlStateNormal];
}


- (void)tintColorDidChange {
    [self drawBorder];
    [self setupTitleColor];
}


- (void)setButtonColor:(UIColor *)buttonColor {
    _buttonColor = buttonColor;
    [self setupTitleColor];
    [self drawBorder];
}


-(void)setTitle:(NSString *)title forState:(UIControlState)state {
    [self drawBorder];
    [self setupTitleColor];
}

@end
