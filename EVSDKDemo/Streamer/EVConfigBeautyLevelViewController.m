//
//  EVConfigBeatyLevelViewController.m
//  EVSDKDemo
//
//  Created by Lcrnice on 2017/6/21.
//  Copyright © 2017年 cloudfocous. All rights reserved.
//

#import "EVConfigBeautyLevelViewController.h"

@interface EVConfigBeautyLevelViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *seg;
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;

@end

@implementation EVConfigBeautyLevelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.seg.selectedSegmentIndex = self.index;
    self.switchBtn.on =
    self.switchBtn.selected =
    self.isBeautyEnable;
    
    self.seg.enabled = self.isBeautyEnable;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


+ (instancetype)instanceVC {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [storyBoard instantiateViewControllerWithIdentifier:@"EVConfigBeautyLevelViewController"];
}
- (IBAction)onBackgroundTouchDown:(id)sender {
    [self dismiss];
}

- (void)showInViewController:(UIViewController *)parentViewController {
    if (self.parentViewController == parentViewController) {
        return;
    }
    
    [parentViewController addChildViewController:self];
    self.view.alpha = 0.0;
    self.view.frame = parentViewController.view.bounds;
    [parentViewController.view addSubview:self.view];
    
    [self didMoveToParentViewController:parentViewController];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.alpha = 1.0;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.25 animations:^{
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self willMoveToParentViewController:nil];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}


- (IBAction)segChanged:(UISegmentedControl *)sender {
    NSInteger index = sender.selectedSegmentIndex;
    !self.segValueChanged ? : self.segValueChanged(index+1);
}
- (IBAction)switchChanged:(UISwitch *)sender {
    sender.selected = !sender.selected;
    BOOL selected = sender.selected;
    self.seg.enabled = selected;
    !self.switchValueChanged ? : self.switchValueChanged(selected);
    if (selected) {
        self.seg.selectedSegmentIndex = 2;
        !self.segValueChanged ? : self.segValueChanged(3);
    }
}

@end
