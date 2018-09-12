//
//  DWIntrosPageContentViewController.m
//  DWIntrosPage
//
//  Created by Dwyane on 2018/8/31.
//  Copyright © 2018年 idwyane. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DWIntrosPageContentViewController;
@class DWIntrosPagesViewController;
@protocol IntrosPageContentDelegate <NSObject>
@optional
- (void)setCurrentPage:(DWIntrosPageContentViewController *)currentPage;
- (void)setNextPage:(DWIntrosPageContentViewController *)nextPage;
@end

@interface DWIntrosPageContentViewController : UIViewController

@property (nonatomic, weak) DWIntrosPagesViewController<IntrosPageContentDelegate> *delegate;

+ (instancetype)introsPageWithBackgroundImage:(UIImage *)bgimage;

+ (instancetype)introsPageWithBackgroundImageWithName:(NSString *)imgName;

- (instancetype)initWithBackgroundGIFWithData:(NSData *)gifData;
- (instancetype)initWithBackgroundNormalImageWithData:(NSData *)data;
/** Update the alpha. */
- (void)updateAlpha:(CGFloat)alpha;
@end
