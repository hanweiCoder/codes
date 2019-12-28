//
//  YTXAddMenuView.m
//  YTXMenu
//
//  Created by 韩微 on 2019/2/22.
//  Copyright © 2019 韩微. All rights reserved.
//

#import "YTXAddMenuView.h"
#import "YTXMenuConfig.h"
#import "YTX_MenuTableViewProxy.h"
#import "YTXAddMenuItem.h"
#import "YTX_MenuSwitchTableViewCell.h"

#define     WIDTH_TABLEVIEW             140.0f
#define     HEIGHT_TABLEVIEW_CELL       45.0f
#define     NAVBAR_HEIGHT               44.0f
#define     STATUSBAR_HEIGHT            (IS_IPHONEX ? 44.0f : 20.0f)
#define     RGBAColor(r, g, b, a)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]
#define     IS_IPHONEX              ([UIScreen mainScreen].bounds.size.width == 375.0f && [UIScreen mainScreen].bounds.size.height == 812.0f)

@interface YTXAddMenuView ()<YTX_MenuSwitchActionDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *data;

@property (nonatomic, strong) YTX_MenuTableViewProxy *tableViewProxy;

@end

@implementation YTXAddMenuView

- (id)init {
    if (self = [super init]) {
        [self setBackgroundColor:[UIColor clearColor]];
       
        UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [self addGestureRecognizer:panGR];
         [self addSubview:self.tableView];
        [self loadData];
        
    }
    return self;
}
- (void)loadData {
    self.data = [YTXMenuConfig sharedConfig].addMenuItems;
    self.tableViewProxy.dataArray = [NSArray arrayWithArray:self.data];
    for (YTXAddMenuItem *item in self.data) {
        switch (item.initalType) {
            case LGCODE:{
                [self.tableView registerClass:NSClassFromString(item.className) forCellReuseIdentifier:item.className];
            }
                break;
            case LGXIB:{
                 [self.tableView registerNib:[UINib nibWithNibName:item.className bundle:nil] forCellReuseIdentifier:item.className];
            }
                break;
            default:
                break;
        }
       
    }
    [self.tableView reloadData];
}
- (void)showInView:(UIView *)view
{
    [view addSubview:self];
    [self setNeedsDisplay];
    [self setFrame:view.bounds];
    
//    CGRect rect = CGRectMake(view.frame.size.width - WIDTH_TABLEVIEW - 5, NAVBAR_HEIGHT + STATUSBAR_HEIGHT + 10, WIDTH_TABLEVIEW, self.data.count * HEIGHT_TABLEVIEW_CELL);
    CGRect rect = CGRectMake(self.frameTable.origin.x, self.frameTable.origin.y, self.frameTable.size.width, self.data.count * HEIGHT_TABLEVIEW_CELL);
    [self.tableView setFrame:rect];
}

- (BOOL)isShow
{
    return self.superview != nil;
}
- (void)dismiss
{
    [UIView animateWithDuration:0.2 animations:^{
        [self setAlpha:0.0f];
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
            [self setAlpha:1.0];
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}

#pragma mark - # Private Methods
- (void)drawRect:(CGRect)rect
{
    CGFloat startX = self.frame.size.width - 27;
    CGFloat startY = STATUSBAR_HEIGHT + NAVBAR_HEIGHT + 3;
    CGFloat endY = STATUSBAR_HEIGHT + NAVBAR_HEIGHT + 10;
    CGFloat width = 6;
    switch (self.menuPointMode) {
        case MenuPointModeTop:
        {
            startX = self.tableView.frame.origin.x + self.tableView.frame.size.width - 20;
            startY = self.tableView.frame.origin.y - width;
            endY = self.tableView.frame.origin.y;
        }
            break;
            case MenuPointModeDown:
        {
            startX = self.tableView.frame.origin.x + self.tableView.frame.size.width / 2 + width / 2;
            startY = self.tableView.frame.size.height + self.tableView.frame.origin.y + width;
            endY = self.tableView.frame.size.height + self.tableView.frame.origin.y;
        }
        default:
            break;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, startX, startY);
    CGContextAddLineToPoint(context, startX + width, endY);
    CGContextAddLineToPoint(context, startX - width, endY);
    CGContextClosePath(context);
    [[self colorBlackForAddMenu] setFill];
    [[self colorBlackForAddMenu] setStroke];
    CGContextDrawPath(context, kCGPathFillStroke);
    
}

#pragma mark -- Getter and Setter

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        [_tableView setScrollEnabled:NO];
        [_tableView setDelegate:self.tableViewProxy];
        [_tableView setDataSource:self.tableViewProxy];
        [_tableView setBackgroundColor:[UIColor blackColor]];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView.layer setMasksToBounds:YES];
        [_tableView.layer setCornerRadius:5.0f];
        
    }
    return _tableView;
}

- (YTX_MenuTableViewProxy *)tableViewProxy {
    if (!_tableViewProxy) {
        _tableViewProxy = [[YTX_MenuTableViewProxy alloc] initWithReuseIdentifier:@"YTX_MemuBaseCell" configuration:^(YTX_MemuBaseCell *cell, id cellData, NSIndexPath *indexPath) {
            if ([cell isKindOfClass:[YTX_MemuBaseCell class]]) {
                [(YTX_MemuBaseCell *)cell configWithData:cellData];
                if ([cell isKindOfClass:[YTX_MenuSwitchTableViewCell class]]) {
                    YTX_MenuSwitchTableViewCell *switchCell = (YTX_MenuSwitchTableViewCell *)cell;
                    switchCell.delegate = self;
                    switchCell.indexP = indexPath;
                }
            }
        } action:^(YTX_MemuBaseCell *cell, id cellData, NSIndexPath *indexPath) {
            YTXAddMenuItem *item = (YTXAddMenuItem *)cellData;
            if (self.itemSelectedAction) {
                self.itemSelectedAction(self, item, indexPath);
            }
            [self dismiss];
        }];
    }
    return _tableViewProxy;
}
#pragma mark - switchControlDelegateMethods -
- (void)ytx_MenuSwitchAction:(id)cellData withInndex:(NSIndexPath *)indexPath {
    YTXAddMenuItem *item = (YTXAddMenuItem *)cellData;
    if (self.itemSelectedAction) {
        self.itemSelectedAction(self, item, indexPath);
    }
//    [self dismiss];
}

- (UIColor *)colorBlackForAddMenu {
    return RGBAColor(71, 70, 73, 1.0);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
