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

- (instancetype)initWithCoder:(NSCoder *)coder {
        self = [super initWithCoder:coder];
        if (self) {
            [self adjustFrameForTitle];
            [self drawBorder];
        }
        return self;
    }
    
- (void)awakeFromNib {
    [super awakeFromNib];
    [self adjustFrameForTitle];
    [self drawBorder];
}
    
- (void)layoutSubviews {
    [super layoutSubviews];
    [self adjustFrameForTitle];
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
    
    [self adjustFrameForTitle];
    [self drawBorder];
    [self setupTitleColor];
}
    
- (void)adjustFrameForTitle {
    CGPoint center = self.center;
    
    CGSize stringSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font];
    CGRect frame = self.frame;
    frame.size = CGSizeMake(stringSize.width + 10, stringSize.height + 10);
    self.frame = frame;
    self.center = center;
}

@end
