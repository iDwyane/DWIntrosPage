
# DWIntrosPage
[![Travis](https://img.shields.io/badge/pod-v1.0.1-blue.svg)](https://www.jianshu.com/u/bb2db3428fff)
[![Travis](https://img.shields.io/badge/platform-iOS-red.svg)](https://developer.apple.com/)
[![Travis](https://img.shields.io/badge/简书-DWyane_Coding-green.svg)](https://www.jianshu.com/u/bb2db3428fff)
[![Travis](https://img.shields.io/badge/license-mit-orange.svg)](https://doge.mit-license.org/)

![Image text](https://github.com/iDwyane/DWIntrosPage/blob/master/Example/DWIntrosPage/Images/gif01.gif)
![Image text](https://github.com/iDwyane/DWIntrosPage/blob/master/Example/DWIntrosPage/Images/gif02.gif)
![Image text](https://github.com/iDwyane/DWIntrosPage/blob/master/Example/DWIntrosPage/Images/gif03.gif)
![Image text](https://github.com/iDwyane/DWIntrosPage/blob/master/Example/DWIntrosPage/Images/introsPage.gif)
### Introduce（项目介绍）
**An iOS framework to easily create a beautiful and powerful intros page with only a few lines of code.**
>* DWIntrosPage supports both static and dynamic images with only low memory.
>* DWIntrosPage Support for gradient switching and high customization.
>* And then we're going to support video.
Thank you for attention


### Usage（使用）
```
    DWIntrosPageContentViewController *page1 = [DWIntrosPageContentViewController introsPageWithBackgroundImageWithName:@"gif01"];
    DWIntrosPageContentViewController *page2 = [DWIntrosPageContentViewController introsPageWithBackgroundImageWithName:@"gif02"];
    DWIntrosPageContentViewController *page3 = [DWIntrosPageContentViewController introsPageWithBackgroundImageWithName:@"gif03"];
    DWIntrosPagesViewController *introsPage = [DWIntrosPagesViewController dwIntrosPagesWithPageArray:@[page1, page2, page3]];
//  introsPage.showPageControl = YES; //show the pageControl
//  introsPage.canSkip = YES; // show the skipButton
//  introsPage.skipButton.backgroundColor = [UIColor redColor]; //setup the skipButton
    __weak typeof(self) weakSelf = self;
    introsPage.skipButtonClickedBlock = ^{
        NSLog(@"clicked skip button");
        [weakSelf setupHomeVC];
    };
 ```


### Installation（安装教程）

DWIntrosPage is available through CocoaPods. To install it, simply add the following line to your Podfile:
```
pod 'DWIntrosPage'
```
also supports the method for installing the library in a project.



### Community
Questions, comments, issues, and pull requests welcomed!!

### Author
Dwyane
