//
//  AppDelegate+DWIntrosPage.m
//  DWIntrosPage
//
//  Created by Dwyane on 2018/9/11.
//  Copyright © 2018年 idwyane. All rights reserved.
//

#import "AppDelegate+DWIntrosPage.h"
#import "DWIntrosPageContentViewController.h"
#import "DWIntrosPagesViewController.h"
#import "HomeViewController.h"

@implementation AppDelegate (DWIntrosPage)

- (UIViewController *)setupDynamicVC {
    
    DWIntrosPageContentViewController *page1 = [DWIntrosPageContentViewController introsPageWithBackgroundImageWithName:@"gif01"];
    DWIntrosPageContentViewController *page2 = [DWIntrosPageContentViewController introsPageWithBackgroundImageWithName:@"gif02"];
    DWIntrosPageContentViewController *page3 = [DWIntrosPageContentViewController introsPageWithBackgroundImageWithName:@"gif03"];
    DWIntrosPagesViewController *introsPage = [DWIntrosPagesViewController dwIntrosPagesWithPageArray:@[page1, page2, page3]];
//    introsPage.showPageControl = YES; //show the pageControl
//    introsPage.canSkip = YES; // show the skipButton
    //    introsPage.skipButton.backgroundColor = [UIColor redColor]; //setup the skipButton
    __weak typeof(self) weakSelf = self;
    introsPage.skipButtonClickedBlock = ^{
        NSLog(@"clicked skip button");
        [weakSelf setupHomeVC];
    };
    return introsPage;
    
}

- (UIViewController *)setupStaticVC {
    DWIntrosPageContentViewController *page1 = [DWIntrosPageContentViewController introsPageWithBackgroundImage:[UIImage imageNamed:@"01"]];
    DWIntrosPageContentViewController *page2 = [DWIntrosPageContentViewController introsPageWithBackgroundImageWithName:@"02.jpg"];
    DWIntrosPageContentViewController *page3 = [DWIntrosPageContentViewController introsPageWithBackgroundImageWithName:@"03"];
    DWIntrosPageContentViewController *page4 = [DWIntrosPageContentViewController introsPageWithBackgroundImageWithName:@"01"];
    DWIntrosPagesViewController *introsPage = [DWIntrosPagesViewController dwIntrosPagesWithPageArray:@[page1, page2, page3, page4]];
//    introsPage.showPageControl = YES; //show the pageControl
//    introsPage.canSkip = YES; // show the skipButton
    //    introsPage.skipButton.backgroundColor = [UIColor redColor]; //setup the skipButton
    __weak typeof(self) weakSelf = self;
    introsPage.skipButtonClickedBlock = ^{
        NSLog(@"clicked skip button");
        [weakSelf setupHomeVC];
    };
    return introsPage;
}

- (void)setupHomeVC {
    HomeViewController *homeVC = [HomeViewController new];
    homeVC.title = @"DWIntrosPage";
    homeVC.view.backgroundColor = [UIColor lightGrayColor];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:homeVC];
}

@end
