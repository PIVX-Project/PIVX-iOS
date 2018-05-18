//
//  WOCSignOutCell.m
//  Wallofcoins
//
//  Created by Genitrust on 24/01/18.
//  Copyright (c) 2018 Wallofcoins. All rights reserved.
//

#import "WOCSignOutCell.h"

@implementation WOCSignOutCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
        
    [self setShadowOnMainView:self.mainView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setShadowOnMainView:(UIView *)view {
    view.layer.cornerRadius = 3.0;
    view.layer.masksToBounds = YES;
    
    view.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(0, 0);
    view.layer.shadowRadius = 1;
    view.layer.shadowOpacity = 1;
    view.layer.masksToBounds = NO;
}

@end
