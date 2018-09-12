//
//  DWIntrosPagesViewController.m
//  DWIntrosPage
//
//  Created by Dwyane on 2018/9/3.
//  Copyright © 2018年 idwyane. All rights reserved.
//

#import "DWIntrosPagesViewController.h"

static CGFloat const kPageControlHeight = 35;
static CGFloat const kSkipButtonWidth = 100;
static CGFloat const kSkipButtonHeight = 35;


@interface DWIntrosPagesViewController ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIScrollViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) CGFloat historyX;

@property (nonatomic, strong) DWIntrosPageContentViewController *currentPage;
@property (nonatomic, strong) DWIntrosPageContentViewController *nextPage;
/** block has called */
@property (nonatomic, assign) BOOL calledBlock;
@end

@implementation DWIntrosPagesViewController

//Lazy method.
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
}

+ (instancetype)dwIntrosPagesWithPageArray:(NSArray *)pageArray {
    return [[self alloc] initWithPageArray:pageArray];
}

- (instancetype)initWithPageArray:(NSArray *)pageArray {
    self.viewControllers = pageArray;
    
    //create pageControl
    self.pageControl = [UIPageControl new];
    self.pageControl.numberOfPages = self.viewControllers.count;
    self.pageControl.userInteractionEnabled = NO;
    
    //create skipButton(跳过)
    self.skipButton = [UIButton new];
    [self.skipButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.skipButton setTitle:@"Skip" forState:UIControlStateNormal];
    [self.skipButton addTarget:self action:@selector(skipButtonCliked) forControlEvents:UIControlEventTouchUpInside];
    self.skipButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.skipButton.hidden = YES;
    return self;
}

- (void)setupView {
    
    _pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    _pageVC.delegate = self;
    _pageVC.dataSource = self;
    [_pageVC didMoveToParentViewController:self];
    
    // Add the pageVC and it's view.
    [self addChildViewController:_pageVC];
    [self.view addSubview:_pageVC.view];
    
    [self.view addSubview:self.skipButton];
    if (_canSkip) {
        self.skipButton.hidden = NO;
    }
    
    if (_showPageControl) {
        // Add the pageControl dots.
        [self.view addSubview:_pageControl];
    }
    
    for (UIView *view in self.pageVC.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            [(UIScrollView *)view setDelegate:self];
        }
    }
    
    for (UIViewController *vc in self.viewControllers) {
        if ([vc isKindOfClass:[DWIntrosPageContentViewController class]]) {
            DWIntrosPageContentViewController *contentVC = (DWIntrosPageContentViewController *)vc;
            contentVC.delegate = self;
        }
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGFloat safedUnderPageControlPadding = 40;
    if (@available(iOS 11.0, *)) {
        safedUnderPageControlPadding += [self.view safeAreaInsets].bottom;
    }
    
    if (self.viewControllers.count < 1) {
        @throw [NSException exceptionWithName:@"views.count"
                                       reason:@"Must have one childViewController at least"
                                     userInfo:nil];
    }
    [self.dataSource addObjectsFromArray:self.viewControllers];
    
    _currentPage = [self.viewControllers firstObject];
    // Set visible view controllers.
    [_pageVC setViewControllers:@[_currentPage] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    self.skipButton.frame = CGRectMake(CGRectGetMaxX(self.view.frame) - kSkipButtonWidth, CGRectGetMaxY(self.view.frame) - safedUnderPageControlPadding - kSkipButtonHeight, kSkipButtonWidth, kSkipButtonHeight);
    self.pageControl.frame = CGRectMake(0, CGRectGetMaxY(self.view.frame) - safedUnderPageControlPadding - kPageControlHeight, self.view.frame.size.width, kPageControlHeight);
}

#pragma mark ------ UIPageViewControllerDelegate && DataSource ------
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
   
    if (viewController == [self.viewControllers firstObject]) {
        return nil; // Return 'nil' to indicate that no more progress can be made in the given direction. （表示已经不能继续往左）
    }else {
        NSInteger lastPageIndex = [self.viewControllers indexOfObject:viewController] - 1;
        NSLog(@"%ld", (long)lastPageIndex);
        return [self.viewControllers objectAtIndex:lastPageIndex];
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    if (viewController == [self.viewControllers lastObject]) {
        return nil; // (表示已经不能继续往右）
    }else {
        NSInteger nextPageIndex = [self.viewControllers indexOfObject:viewController] + 1;
//        NSLog(@"%ld", (long)nextPageIndex);
        return self.viewControllers[nextPageIndex];
    }
}


- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    // We need to confirm the transition completed and to do other things.
    // 确保转换完成才改变底下的小圆点
    if (completed) {
        _currentPage = [pageViewController.viewControllers lastObject];
        NSInteger currentIndex = [self.viewControllers indexOfObject:_currentPage];
        [self.pageControl setCurrentPage:currentIndex];
    }
}


#pragma mark ------ UIScrollViewDelegate ------

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // Record the scrollView's contentOffset at the begining.
    self.historyX = scrollView.contentOffset.x;
    NSLog(@"historyX = %f", self.historyX);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Calculate the ratio of the current interface that has slipped.
    // 计算滑过的界面比例
//    scrollView.contentOffset.x/pageWidth
    CGFloat ratio = fabs(scrollView.contentOffset.x - self.view.frame.size.width) / self.view.frame.size.width;
    
    // Change the alpha of some view.渐变
    [self changeAlphaWithRatio:ratio scrollView:scrollView];
}

#pragma mark ------ changeAlpha ------
- (void)changeAlphaWithRatio:(CGFloat)ratio scrollView:(UIScrollView *)scrollView {

    if (ratio == 0) {
        return;
    }
   
    // figure out alpha
    // next page alpha equals to the ratio
    CGFloat nextPageAlpha = ratio;
    CGFloat currentPageAlpha = 1 - ratio;
    
    // warning: don't mix up the order of the two sentences
    //注意： 不要弄乱下面两句顺序
    [self.nextPage updateAlpha:nextPageAlpha];
    [self.currentPage updateAlpha:currentPageAlpha];
    
    // change the alpha of skip button and pageControl dots
    if (_nextPage == [self.viewControllers lastObject] ) {
        self.skipButton.alpha = currentPageAlpha;
        self.pageControl.alpha = currentPageAlpha;
    }
    if (_currentPage == [self.viewControllers lastObject]) {
        self.skipButton.alpha = nextPageAlpha;
        self.pageControl.alpha = nextPageAlpha;
        // The last page will not show the skill button and page dots.
        // 最后一页往右也不能出现下面两个按钮
        if ((scrollView.contentOffset.x > self.historyX)) {
            self.skipButton.alpha = 0;
            self.pageControl.alpha = 0;
            if (scrollView.contentOffset.x - self.historyX > 45) {
                [self skipButtonCliked];
            }
        }
    }

}

#pragma mark ------ IntrosPageContentDelegate ------
- (void)setCurrentPage:(DWIntrosPageContentViewController *)currentPage {
    _currentPage = currentPage;
}
- (void)setNextPage:(DWIntrosPageContentViewController *)nextPage {
    _nextPage = nextPage;
}

#pragma mark ------ Click EVent ------
- (void)skipButtonCliked {
    if (self.calledBlock) {
        return; //如果已经回调一次，就不要继续回调了。
    }
    self.calledBlock = YES;
    //点击skipBtn
    _skipButtonClickedBlock();
}
@end
