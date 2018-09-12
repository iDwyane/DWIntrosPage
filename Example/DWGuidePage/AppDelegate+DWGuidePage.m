//
//  AppDelegate+DWGuidePage.m
//  DWGuidePage
//
//  Created by Dwyane on 2018/9/11.
//  Copyright © 2018年 idwyane. All rights reserved.
//

#import "AppDelegate+DWGuidePage.h"
#import "DWGuidePageContentViewController.h"
#import "DWGuidePagesViewController.h"
#import "HomeViewController.h"

@implementation AppDelegate (DWGuidePage)

- (UIViewController *)setupDynamicVC {
    
    DWGuidePageContentViewController *page1 = [DWGuidePageContentViewController guidePageWithBackgroundImageWithName:@"gif01"];
    DWGuidePageContentViewController *page2 = [DWGuidePageContentViewController guidePageWithBackgroundImageWithName:@"gif02"];
    DWGuidePageContentViewController *page3 = [DWGuidePageContentViewController guidePageWithBackgroundImageWithName:@"gif03"];
    DWGuidePagesViewController *guidePage = [DWGuidePagesViewController dwGuidePagesWithPageArray:@[page1, page2, page3]];
//    guidePage.showPageControl = YES; //show the pageControl
//    guidePage.canSkip = YES; // show the skipButton
    //    guidePage.skipButton.backgroundColor = [UIColor redColor]; //setup the skipButton
    __weak typeof(self) weakSelf = self;
    guidePage.skipButtonClickedBlock = ^{
        NSLog(@"clicked skip button");
        [weakSelf setupHomeVC];
    };
    return guidePage;
    
}

- (UIViewController *)setupStaticVC {
    DWGuidePageContentViewController *page1 = [DWGuidePageContentViewController guidePageWithBackgroundImage:[UIImage imageNamed:@"01"]];
    DWGuidePageContentViewController *page2 = [DWGuidePageContentViewController guidePageWithBackgroundImageWithName:@"021.jpg"];
    DWGuidePageContentViewController *page3 = [DWGuidePageContentViewController guidePageWithBackgroundImageWithName:@"03"];
    DWGuidePageContentViewController *page4 = [DWGuidePageContentViewController guidePageWithBackgroundImageWithName:@"01"];
    DWGuidePagesViewController *guidePage = [DWGuidePagesViewController dwGuidePagesWithPageArray:@[page1, page2, page3, page4]];
//    guidePage.showPageControl = YES; //show the pageControl
//    guidePage.canSkip = YES; // show the skipButton
    //    guidePage.skipButton.backgroundColor = [UIColor redColor]; //setup the skipButton
    __weak typeof(self) weakSelf = self;
    guidePage.skipButtonClickedBlock = ^{
        NSLog(@"clicked skip button");
        [weakSelf setupHomeVC];
    };
    return guidePage;
}

- (void)setupHomeVC {
    HomeViewController *homeVC = [HomeViewController new];
    homeVC.title = @"DWGuidePage";
    homeVC.view.backgroundColor = [UIColor lightGrayColor];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:homeVC];
}

@end
