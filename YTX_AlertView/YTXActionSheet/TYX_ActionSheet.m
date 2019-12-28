//
//  TYX_ActionSheet.m
//  YouHui
//
//  Created by 韩微 on 2019/12/23.
//  Copyright © 2019 wwl. All rights reserved.
//

#import "TYX_ActionSheet.h"
#import "YTX_ActionSheetCell.h"

#define isIPhoneX ([[UIScreen mainScreen] bounds].size.height == 812 || [[UIScreen mainScreen] bounds].size.height == 896)
static NSString * const YTX_ActionViewCollectionViewCellReuseIdentifier = @"YTX_ActionViewCollectionViewCellReuseIdentifier";

static const CGFloat kRowHeight = 48.0f;
static const CGFloat kRowLineHeight = 0.5f;
static const CGFloat kSeparatorHeight = 6.0f;
static const CGFloat kTitleFontSize = 14.0f;
static const CGFloat kButtonTitleFontSize = 18.0f;
static const NSTimeInterval kAnimateDuration = 0.3f;

@interface TYX_ActionSheet ()<UICollectionViewDelegate, UICollectionViewDataSource, YTX_ActionSheetCollectionViewCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionViewLayout;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSArray *itemList;
@property (nonatomic, strong) NSArray *itemPathList;
@property (nonatomic, strong) NSArray *itemHiglitPathList;

/** block回调 */
@property (copy, nonatomic) YTXActionSheetBlock actionSheetBlock;
/** 背景图片 */
@property (strong, nonatomic) UIView *backgroundView;
/** 弹出视图 */
@property (strong, nonatomic) UIView *actionSheetView;

/**
 * 收起视图
 */
- (void)dismiss;
/**
 * 通过颜色生成图片
 */
- (UIImage *)imageWithColor:(UIColor *)color;

@end

@implementation TYX_ActionSheet
// 弹出collection的actionsheet
- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle itemList:(NSArray *)itemList
                 itemPathList:(NSArray *)itemPathList
               itemHiglitPath:(NSArray *)itemHiglitPath

                      handler:(YTXActionSheetBlock)actionSheetBlock
{
    self = [super initWithFrame:CGRectZero];
    if (self)
    {
        self.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        _actionSheetBlock = actionSheetBlock;
        
        CGFloat actionSheetHeight = 0;
        
        _backgroundView = [[UIView alloc] initWithFrame:self.frame];
        _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
        _backgroundView.alpha = 0;
        [self addSubview:_backgroundView];
        
        _actionSheetView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 0)];
        _actionSheetView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        _actionSheetView.backgroundColor = [UIColor colorWithRed:238.0f/255.0f green:238.0f/255.0f blue:238.0f/255.0f alpha:1.0f];
        [self addSubview:_actionSheetView];
        
        UIImage *normalImage = [self imageWithColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];
        UIImage *highlightedImage = [self imageWithColor:[UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
        
        if (title && title.length > 0)
        {
            actionSheetHeight += kRowLineHeight;
            
            CGFloat titleHeight = ceil([title boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kTitleFontSize]} context:nil].size.height) + 15*2;
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, actionSheetHeight, self.frame.size.width, titleHeight)];
            titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            titleLabel.text = title;
            titleLabel.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
//            titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = [UIFont systemFontOfSize:kTitleFontSize];
            titleLabel.numberOfLines = 0;
            [_actionSheetView addSubview:titleLabel];
            
            actionSheetHeight += titleHeight;
        }
        
        // TODO collectionview
        self.itemList = [NSArray arrayWithArray:itemList];
        self.itemPathList = [NSArray arrayWithArray:itemPathList];
        self.itemHiglitPathList = [NSArray arrayWithArray:itemHiglitPath];
        [self createCollectionViewLayout];
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, actionSheetHeight, self.frame.size.width, 100) collectionViewLayout:_collectionViewLayout];
        [_actionSheetView addSubview:self.collectionView];
        self.collectionView.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.showsVerticalScrollIndicator = NO;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        [self.collectionView registerClass:[YTX_ActionSheetCell class] forCellWithReuseIdentifier:YTX_ActionViewCollectionViewCellReuseIdentifier];
        [self.collectionView reloadData];
        actionSheetHeight += 100;
        
        if (cancelButtonTitle && cancelButtonTitle.length > 0)
        {
            actionSheetHeight += kSeparatorHeight;
            
            UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
            cancelButton.frame = CGRectMake(0, actionSheetHeight, self.frame.size.width, kRowHeight);
            cancelButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            cancelButton.tag = 0;
            cancelButton.titleLabel.font = [UIFont systemFontOfSize:kButtonTitleFontSize];
            [cancelButton setTitle:cancelButtonTitle ?: @"取消" forState:UIControlStateNormal];
//            [cancelButton setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
            [cancelButton setBackgroundImage:normalImage forState:UIControlStateNormal];
            [cancelButton setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
            [cancelButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_actionSheetView addSubview:cancelButton];
            
            actionSheetHeight += kRowHeight;
            
            if (isIPhoneX) {
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, actionSheetHeight, self.frame.size.width, 30)];
                view.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
                [_actionSheetView addSubview:view];
                actionSheetHeight += 30;
            }
            
        }
        
        _actionSheetView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, actionSheetHeight);
    }
    
    return self;
}
+ (void)showActionSheetWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles handler:(YTXActionSheetBlock)actionSheetBlock
{
    TYX_ActionSheet *ytx_ActionSheet = [[self alloc] initActionSheetWithTitle:title cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:otherButtonTitles handler:actionSheetBlock];
    [ytx_ActionSheet show];
}
// 弹出actionsheet
- (instancetype)initActionSheetWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles handler:(YTXActionSheetBlock)actionSheetBlock {
    self = [super initWithFrame:CGRectZero];
    if (self)
    {
        self.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        _actionSheetBlock = actionSheetBlock;
        
        CGFloat actionSheetHeight = 0;
        
        _backgroundView = [[UIView alloc] initWithFrame:self.frame];
        _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
        _backgroundView.alpha = 0;
        [self addSubview:_backgroundView];
        
        _actionSheetView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 0)];
        _actionSheetView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        _actionSheetView.backgroundColor = [UIColor colorWithRed:238.0f/255.0f green:238.0f/255.0f blue:238.0f/255.0f alpha:1.0f];
        [self addSubview:_actionSheetView];
        
        UIImage *normalImage = [self imageWithColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];
        UIImage *highlightedImage = [self imageWithColor:[UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
        
        if (title && title.length > 0)
        {
            actionSheetHeight += kRowLineHeight;
            
            CGFloat titleHeight = ceil([title boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kTitleFontSize]} context:nil].size.height) + 15*2;
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, actionSheetHeight, self.frame.size.width, titleHeight)];
            titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            titleLabel.text = title;
            titleLabel.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
//            titleLabel.textColor = [UIColor colorWithHexString:@"#999999"];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = [UIFont systemFontOfSize:kTitleFontSize];
            titleLabel.numberOfLines = 0;
            [_actionSheetView addSubview:titleLabel];
            
            actionSheetHeight += titleHeight;
        }
        
        if (destructiveButtonTitle && destructiveButtonTitle.length > 0)
        {
            actionSheetHeight += kRowLineHeight;
            
            UIButton *destructiveButton = [UIButton buttonWithType:UIButtonTypeCustom];
            destructiveButton.frame = CGRectMake(0, actionSheetHeight, self.frame.size.width, kRowHeight);
            destructiveButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            destructiveButton.tag = -1;
            destructiveButton.titleLabel.font = [UIFont systemFontOfSize:kButtonTitleFontSize];
            [destructiveButton setTitle:destructiveButtonTitle forState:UIControlStateNormal];
//            [destructiveButton setTitleColor:[UIColor colorWithHexString:@"#F45B5B"] forState:UIControlStateNormal];
            [destructiveButton setBackgroundImage:normalImage forState:UIControlStateNormal];
            [destructiveButton setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
            [destructiveButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_actionSheetView addSubview:destructiveButton];
            
            actionSheetHeight += kRowHeight;
        }
        
        if (otherButtonTitles && [otherButtonTitles count] > 0)
        {
            for (int i = 0; i < otherButtonTitles.count; i++)
            {
                actionSheetHeight += kRowLineHeight;
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(0, actionSheetHeight, self.frame.size.width, kRowHeight);
                button.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                button.tag = i+1;
                button.titleLabel.font = [UIFont systemFontOfSize:kButtonTitleFontSize];
                [button setTitle:otherButtonTitles[i] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor colorWithRed:64.0f/255.0f green:64.0f/255.0f blue:64.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
                [button setBackgroundImage:normalImage forState:UIControlStateNormal];
                [button setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
                [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [_actionSheetView addSubview:button];
                
                actionSheetHeight += kRowHeight;
            }
        }
        
        if (cancelButtonTitle && cancelButtonTitle.length > 0)
        {
            actionSheetHeight += kSeparatorHeight;
            
            UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
            cancelButton.frame = CGRectMake(0, actionSheetHeight, self.frame.size.width, kRowHeight);
            cancelButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            cancelButton.tag = 0;
            cancelButton.titleLabel.font = [UIFont systemFontOfSize:kButtonTitleFontSize];
            [cancelButton setTitle:cancelButtonTitle ?: @"取消" forState:UIControlStateNormal];
//            [cancelButton setTitleColor:[UIColor colorWithHexString:@"#212121"] forState:UIControlStateNormal];
            [cancelButton setBackgroundImage:normalImage forState:UIControlStateNormal];
            [cancelButton setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
            [cancelButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_actionSheetView addSubview:cancelButton];
            
            actionSheetHeight += kRowHeight;
        }
        
        _actionSheetView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, actionSheetHeight);
    }
    
    return self;
}

+ (instancetype)actionSheetWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle itemList:(NSArray *)itemList
                        itemPathList:(NSArray *)itemPathList
                      itemHiglitPath:(NSArray *)itemHiglitPath
                             handler:(YTXActionSheetBlock)actionSheetBlock
{
    return [[self alloc] initWithTitle:title cancelButtonTitle:cancelButtonTitle itemList:itemList itemPathList:itemPathList itemHiglitPath:itemHiglitPath handler:actionSheetBlock];
}
+ (void)showActionSheetWithTitle:(NSString *)title
               cancelButtonTitle:(NSString *)cancelButtonTitle
                        itemList:(NSArray *)itemList
                    itemPathList:(NSArray *)itemPathList
                  itemHiglitPath:(NSArray *)itemHiglitPath
                         handler:(YTXActionSheetBlock)actionSheetBlock {
    TYX_ActionSheet *ytx_ActionSheet = [self actionSheetWithTitle:title cancelButtonTitle:cancelButtonTitle itemList:itemList itemPathList:itemPathList itemHiglitPath:itemHiglitPath handler:actionSheetBlock];
    [ytx_ActionSheet show];
}

#pragma mark - Private
- (void)createCollectionViewLayout {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //设置item尺寸
    CGFloat itemW = (self.frame.size.width - 70) / 6;
    CGFloat itemH = itemW + 20;
    flowLayout.itemSize = CGSizeMake(itemW, itemH);
    CGFloat minmuInter = 10;
    flowLayout.minimumLineSpacing= 10;
    flowLayout.minimumInteritemSpacing= minmuInter;
    //    flowLayout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
    // 设置水平滚动方向
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionViewLayout = flowLayout;
}
#pragma mark - Custom Accessor
- (void)filterMaterialView:(UIButton *)filterBtnView didScrollToIndex:(NSUInteger)index {
    if (self.actionSheetBlock)
    {
        self.actionSheetBlock(self, index);
    }
    [self dismiss];
    
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YTX_ActionSheetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:YTX_ActionViewCollectionViewCellReuseIdentifier forIndexPath:indexPath];
    cell.titleLabelStr = self.itemList[indexPath.row];
    cell.iconPath = self.itemPathList[indexPath.item];
    cell.iconSelectPath = self.itemHiglitPathList[indexPath.item];
    cell.selectBtn.tag = indexPath.item;
    cell.delegate = self;
    [cell configWithData:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)show
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
        for (UIWindow *window in frontToBackWindows)
        {
            BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
            BOOL windowIsVisible = !window.hidden && window.alpha > 0;
            BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
            
            if(windowOnMainScreen && windowIsVisible && windowLevelNormal)
            {
                [window addSubview:self];
                break;
            }
        }
        
        [UIView animateWithDuration:kAnimateDuration delay:0 usingSpringWithDamping:0.7f initialSpringVelocity:0.7f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.backgroundView.alpha = 1.0f;
            self.actionSheetView.frame = CGRectMake(0, self.frame.size.height-self.actionSheetView.frame.size.height, self.frame.size.width, self.actionSheetView.frame.size.height);
        } completion:nil];
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:kAnimateDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.backgroundView.alpha = 0.0f;
        self.actionSheetView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.actionSheetView.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.backgroundView];
    if (!CGRectContainsPoint(self.actionSheetView.frame, point))
    {
        if (self.actionSheetBlock)
        {
            self.actionSheetBlock(self, 9999);
        }
        
        [self dismiss];
    }
}

- (void)buttonClicked:(UIButton *)button
{
    if (self.actionSheetBlock)
    {
        self.actionSheetBlock(self, 9999);
    }
    
    [self dismiss];
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


- (void)dealloc
{
#ifdef DEBUG
    NSLog(@"TYX_ActionSheet dealloc");
#endif
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
