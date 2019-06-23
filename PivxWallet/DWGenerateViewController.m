//
//  DWGenerateViewController.m
//  dashwallet
//
//  Created by Quantum Explorer on 10/11/17.
//  Copyright © 2017 Dash Foundation. All rights reserved.
//

#import "DWGenerateViewController.h"
#import "BREventManager.h"
#import "BRWalletManager.h"
#import "pivxwallet-Swift.h"

@interface DWGenerateViewController ()

//@property (nonatomic, strong) IBOutlet UIView *wallpaper, *wallpaperContainer;
@property (nonatomic, strong) IBOutlet UIButton *generateButton, *showButton;
@property (nonatomic, strong) IBOutlet UILabel *startLabel, *recoverLabel, *warningLabel;
@property (nonatomic, strong) UINavigationController *seedNav;

-(IBAction)generateRecoveryPhrase:(id)sender;
-(IBAction)show:(id)sender;

@end

@implementation DWGenerateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.generateButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    self.generateButton.titleLabel.adjustsLetterSpacingToFitWidth = YES;
#pragma clang diagnostic pop
    
    
    NSTextAttachment *noEye = [NSTextAttachment new], *noKey = [NSTextAttachment new];
    NSMutableAttributedString *s = [[NSMutableAttributedString alloc]
                                    initWithAttributedString:self.warningLabel.attributedText];
    
    noEye.image = [UIImage imageNamed:@"no-eye"];
    [s replaceCharactersInRange:[s.string rangeOfString:@"%no-eye%"]
           withAttributedString:[NSAttributedString attributedStringWithAttachment:noEye]];
    noKey.image = [UIImage imageNamed:@"no-key"];
    [s replaceCharactersInRange:[s.string rangeOfString:@"%no-key%"]
           withAttributedString:[NSAttributedString attributedStringWithAttachment:noKey]];
    
    [s replaceCharactersInRange:[s.string rangeOfString:@"WARNING"] withString:NSLocalizedString(@"WARNING", nil)];
    [s replaceCharactersInRange:[s.string rangeOfString:@"\nDO NOT let anyone see your recovery\nphrase or they can spend your PIV.\n"]
                     withString:NSLocalizedString(@"DO NOT let anyone see your recovery phrase or they can spend your PIV.", nil)];
    [s replaceCharactersInRange:[s.string rangeOfString:@"\nNEVER type your recovery phrase into\npassword managers or elsewhere.\nOther devices may be infected.\n"]
                     withString:NSLocalizedString(@"NEVER type your recovery phrase into password managers or elsewhere. Other devices may be infected.", nil)];
    self.warningLabel.attributedText = s;
    //self.generateButton.superview.backgroundColor = [UIColor clearColor];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:FALSE animated:FALSE];
    UIColor *color = [UIColor rgb:85 green:71 blue:108 alpha:1];
    //UIColor *color = [UIColor colorWithRed:85.0f/255.0f green:71.0f/255.0f blue:188/255.0f alpha:1.0f];
    [[self.navigationController navigationBar] setTranslucent:FALSE];
    [[self.navigationController navigationBar] setShadowImage:[UIImage imageNamed:@""]];
    [[self.navigationController navigationBar] setBarTintColor: color];
    [[self.navigationController navigationBar] setBackgroundImage:[UIImage imageNamed:@""] forBarMetrics: UIBarMetricsDefault];
    self.navigationItem.title = NSLocalizedString(@"Create recovery phrase", nil);
    self.navigationItem.hidesBackButton = TRUE;
    UIImage *image = [UIImage imageNamed:@"icBack"];
    self.navigationItem.hidesBackButton = TRUE;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:image
                                                                   style:UIBarButtonItemStylePlain target:self action:@selector(tappedBackButton)];
    [backButton setTintColor: UIColor.whiteColor];
    self.navigationItem.leftBarButtonItem = backButton;
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(BOOL)prefersStatusBarHidden {
    return FALSE;
}

-(void)tappedBackButton{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)generateRecoveryPhrase:(id)sender {
    [BREventManager saveEvent:@"welcome:generate"];
    
    if (! [BRWalletManager sharedInstance].passcodeEnabled) {
        [BREventManager saveEvent:@"welcome:passcode_disabled"];
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:NSLocalizedString(@"Turn device passcode on", nil)
                                     message:NSLocalizedString(@"A device passcode is needed to safeguard your wallet. Go to settings and turn passcode on to continue.", nil)
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* okButton = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Ok", nil)
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction * action) {
                                   }];
        [alert addAction:okButton];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    [self.navigationController.navigationBar.topItem setHidesBackButton:YES animated:YES];
    [sender setEnabled:NO];
    self.seedNav = [self.storyboard instantiateViewControllerWithIdentifier:@"SeedNav"];
    self.warningLabel.hidden = self.showButton.hidden = NO;
    self.warningLabel.alpha = self.showButton.alpha = 0.0;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.warningLabel.alpha = self.showButton.alpha = 1.0;
        self.navigationController.navigationBar.topItem.titleView.alpha = 0.33*0.5;
        self.startLabel.alpha = self.recoverLabel.alpha = 0.33;
        self.generateButton.alpha = 0.33;
    }];
}

- (IBAction)show:(id)sender
{
    [BREventManager saveEvent:@"welcome:show"];
    
    [self.navigationController presentViewController:self.seedNav animated:YES completion:^{
        self.warningLabel.hidden = self.showButton.hidden = YES;
        self.navigationController.navigationBar.topItem.titleView.alpha = 1.0;
        self.startLabel.alpha = self.recoverLabel.alpha = 1.0;
        self.generateButton.alpha = 1.0;
        self.generateButton.enabled = YES;
        self.navigationController.navigationBar.topItem.hidesBackButton = NO;
        self.generateButton.superview.backgroundColor = [UIColor whiteColor];
    }];
}

@end
