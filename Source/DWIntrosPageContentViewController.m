//
//  DWIntrosPageContentViewController.m
//  DWIntrosPage
//
//  Created by Dwyane on 2018/8/31.
//  Copyright © 2018年 idwyane. All rights reserved.
//

#import "DWIntrosPageContentViewController.h"
#import "DWIntrosPagesViewController.h"

// 移位：eg:1<<i的结果是1乘以2的i次方
#define dw_FOUR_shift(c1,c2,c3,c4) ((uint32_t)(((c4) << 24) | ((c3) << 16) | ((c2) << 8) | (c1)))

static NSString *_imagePathExtension(CFDataRef data) {
    if (!data) return @"";
    uint64_t length = CFDataGetLength(data);
    if (length < 16) return @"";
    
    const char *bytes = (char *)CFDataGetBytePtr(data);
    
    uint32_t magic4 = *((uint32_t *)bytes);
    switch (magic4) {
        case dw_FOUR_shift('G', 'I', 'F', '8'): { // gif
            return @"GIF";
        } break;
        
        case dw_FOUR_shift(0x89, 'P', 'N', 'G'): {  // PNG
            uint32_t tmp = *((uint32_t *)(bytes + 4));
            if (tmp == dw_FOUR_shift('\r', '\n', 0x1A, '\n')) {
                return @"PNG";
            }
        } break;
    }
    
    // JPG             FF D8 FF
    if (memcmp(bytes,"\377\330\377",3) == 0) return @"JPG";
    
    return @"";
    
}

@interface DWIntrosPageContentViewController ()
{
    UIView *view;
}
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, assign) CGFloat bgImgWidth;
@property (nonatomic, assign) CGFloat bgImgHeight;
@end

@implementation DWIntrosPageContentViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.delegate) {
        [self.delegate setNextPage:self];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.delegate) {
        [self.delegate setCurrentPage:self];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

}


+ (instancetype)introsPageWithBackgroundImage:(UIImage *)bgImage {
    return [[self alloc] initWithBackgroundImage:bgImage];
}

+ (instancetype)introsPageWithBackgroundImageWithName:(NSString *)imgName {
    if ([imgName.pathExtension isEqualToString:@"jpg"] || [imgName.pathExtension isEqualToString:@"png"]) {
        return [[self alloc] initWithBackgroundImageWithName:imgName];
    }
    NSData *data = [self gainFullImageWithName:imgName];
    if ([_imagePathExtension((__bridge CFDataRef)(data)) isEqualToString:@"GIF"]) {
        //    return [[self alloc] initWithData:data];
        return [[self alloc] initWithBackgroundGIFWithData:data];
    }else if([_imagePathExtension((__bridge CFDataRef)(data)) isEqualToString:@"JPG"]) {
        return [[self alloc] initWithBackgroundNormalImageWithData:data];
    }
    return [[self alloc] initWithBackgroundImageWithName:imgName];
}

- (instancetype)initWithBackgroundNormalImageWithData:(NSData *)data {
    
    self.bgImageView = [[UIImageView alloc] init];
    UIImage *image = [UIImage imageWithData:data];
    self.bgImageView.image = image;
    self.bgImageView.frame = self.view.frame;
    [self.view addSubview:self.bgImageView];
    return self;
}


- (instancetype)initWithBackgroundImage:(UIImage *)bgImage {
    
    self.bgImageView = [[UIImageView alloc] initWithImage:bgImage];
    self.bgImageView.frame = self.view.frame;
    [self.view addSubview:self.bgImageView];
    return self;
}

- (instancetype)initWithBackgroundImageWithName:(NSString *)normalImgName {
    self.bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:normalImgName]];
    self.bgImageView.frame = self.view.frame;
    [self.view addSubview:self.bgImageView];
    return self;
}

- (instancetype)initWithBackgroundGIFWithData:(NSData *)data {

    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    webView.scalesPageToFit = YES;
    webView.scrollView.bounces = NO;
    [webView loadData:data MIMEType:@"image/gif" textEncodingName:@"" baseURL:[NSURL URLWithString:@""]];
    webView.backgroundColor = [UIColor clearColor];
    webView.opaque = NO;
    [self.view addSubview:webView];
    return self;
}

- (void)updateAlpha:(CGFloat)alpha {
    self.bgImageView.alpha = alpha;
}

+ (NSData *)gainFullImageWithName:(NSString *)name {
    if (name.length == 0) return nil;
    
    NSString *res = name.stringByDeletingPathExtension;
    NSString *ext = name.pathExtension;
    NSString *path = nil;
    NSArray *exts = ext.length > 0 ? @[ext] : @[@"", @"png", @"jpeg", @"jpg", @"gif", @"webp", @"apng"];
    for (NSString *e in exts) {
        path = [[NSBundle mainBundle] pathForResource:res ofType:e];
        if (path) break;
    }
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (data.length == 0) return nil;
    return data;

}


@end
