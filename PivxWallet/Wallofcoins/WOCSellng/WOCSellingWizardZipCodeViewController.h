//
//  WOCSellingWizardZipCodeViewController.h
//  Wallofcoins
//
//  Created by Genitrust on 23/01/18.
//  Copyright (c) 2018 Wallofcoins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WOCBaseViewController.h"

////WOCSellingWizardZipCodeViewController

// Enter ZipCode
@interface WOCSellingWizardZipCodeViewController : WOCBaseViewController

@property (weak, nonatomic) IBOutlet UITextField *txtZipCode;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (assign, nonatomic) BOOL isZipCodeBlank;

- (IBAction)nextClicked:(id)sender;

@end
