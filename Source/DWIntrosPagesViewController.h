//
//  DWIntrosPageContentViewController.h
//  DWIntrosPage
//
//  Created by Dwyane on 2018/9/3.
//  Copyright © 2018年 idwyane. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWIntrosPageContentViewController.h"

typedef void(^SkipButtonClickedBlock)(void);
@interface DWIntrosPagesViewController : UIViewController<IntrosPageContentDelegate>

@property (nonatomic, strong) NSArray *viewControllers;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) UIPageViewController *pageVC;

/** Clicked the the skipButton, the intros page will disappear. */
@property (nonatomic, strong) UIButton *skipButton;

/** If the canSkip is YES, add the skipButton to superview. */
@property (nonatomic, assign) BOOL canSkip;

/** If the showPageControl is YES, add the skipButton to superview. */
@property (nonatomic, assign) BOOL showPageControl;

/** Move right on the last page to make the pages disappear. */
@property (nonatomic, assign) BOOL disappearWhileMoveRihgt;

/** The block about skip button */
@property (nonatomic, copy) SkipButtonClickedBlock skipButtonClickedBlock;

/** Create the pages with each page content view controller. */
+ (instancetype)dwIntrosPagesWithPageArray:(NSArray *)pageArray;
@end
