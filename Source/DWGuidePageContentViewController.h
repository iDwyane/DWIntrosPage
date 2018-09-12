//
//  DWGuidePageContentViewController.h
//  DWGuidePage
//
//  Created by Dwyane on 2018/8/31.
//  Copyright © 2018年 idwyane. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DWGuidePageContentViewController;
@class DWGuidePagesViewController;
@protocol GuidePageContentDelegate <NSObject>
@optional
- (void)setCurrentPage:(DWGuidePageContentViewController *)currentPage;
- (void)setNextPage:(DWGuidePageContentViewController *)nextPage;
@end

@interface DWGuidePageContentViewController : UIViewController

@property (nonatomic, weak) DWGuidePagesViewController<GuidePageContentDelegate> *delegate;

+ (instancetype)guidePageWithBackgroundImage:(UIImage *)bgimage;

+ (instancetype)guidePageWithBackgroundImageWithName:(NSString *)imgName;

- (instancetype)initWithBackgroundGIFWithData:(NSData *)gifData;
- (instancetype)initWithBackgroundNormalImageWithData:(NSData *)data;
/** Update the alpha. */
- (void)updateAlpha:(CGFloat)alpha;
@end
