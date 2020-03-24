//
//  YTX_AddMenuView.m
//  YouHui
//
//  Created by 韩微 on 2020/1/15.
//  Copyright © 2020 wwl. All rights reserved.
//

#import "YTX_AddMenuView.h"
#import "YTX_MemuBaseCell.h"
#import "YTX_MenuSwitchTableViewCell.h"

#define     WIDTH_TABLEVIEW             140.0f
#define     HEIGHT_TABLEVIEW_CELL       45.0f
#define     NAVBAR_HEIGHT               44.0f
#define     STATUSBAR_HEIGHT            (isFullScreen ? 44.0f : 20.0f)

static const NSTimeInterval kAnimateDuration = 0.3f;

@interface YTX_AddMenuItem ()


@end

@implementation YTX_AddMenuItem

+ (YTX_AddMenuItem *)createWithTitle:(NSString *)title
 iconPath:(NSString *)iconPath
className:(NSString *)className initalType:(RowProtocolInitalType)initalType switchIsOn:(BOOL)switchIsOn
   property:(NSDictionary *)propertyDic
                     withUnreadCount:(NSInteger)unreadCount {
    YTX_AddMenuItem *item = [[YTX_AddMenuItem alloc] init];
    item.className = className;
    item.title = title;
    item.iconPath = iconPath;
    item.initalType = initalType;
    item.switchIsOn = switchIsOn;
    item.attributesDic = propertyDic;
    item.unreadCount = unreadCount;
        
    return [self ytx_objectWithJson:propertyDic withItem:item];
}

+ (YTX_AddMenuItem *)ytx_objectWithJson:(NSDictionary *)json withItem:(YTX_AddMenuItem *)item{
    unsigned int count;
    Ivar *ivars = class_copyIvarList([YTX_AddMenuItem class], &count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        NSMutableString *name = [NSMutableString stringWithUTF8String:ivar_getName(ivar)];
        [name deleteCharactersInRange:NSMakeRange(0, 1)];
        id value = json[name];
        if (value) {
            [item setValue:value forKey:name];
        }
    }
    free(ivars);
    return item;
}

@end

@interface YTX_AddMenuView ()<UITableViewDelegate, UITableViewDataSource, YTX_MenuSwitchActionDelegate>

/** block回调 */
@property (copy, nonatomic) YTXAddMebuActionSheetBlock actionSheetBlock;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *data;

//三角朝向
@property (nonatomic, assign) MenuPointMode menuPointMode;

/**
 * 收起视图
 */
- (void)dismiss;

@end

@implementation YTX_AddMenuView

+ (void)showAddMenuViewActionSheetWithItemLists:(NSArray *)items
                                       withFrame:(CGRect)frameTable
                                        withTableBackColor:(UIColor *)tableViewColor
                                        withAlpha:(CGFloat)alpha withMenuPointMode:(MenuPointMode)menuPointMode
                                        handler:(YTXAddMebuActionSheetBlock)actionSheetBlock {
    YTX_AddMenuView *ytx_AddMenuView = [[self alloc] initWithItemLists:items withFrame:frameTable withTableBackColor:tableViewColor withAlpha:alpha  withMenuPointMode:menuPointMode handler:actionSheetBlock];
    [ytx_AddMenuView show];
    
}

- (instancetype)initWithItemLists:(NSArray *)items withFrame:(CGRect)frameTable
        withTableBackColor:(UIColor *)tableViewColor
                              withAlpha:(CGFloat)alpha
                          withMenuPointMode:(MenuPointMode)menuPointMode
                          handler:(YTXAddMebuActionSheetBlock)actionSheetBlock {
    if (self = [super init]) {
        
        [self setBackgroundColor:[UIColor clearColor]];
        self.backgroundColor = [UIColor colorWithWhite:0.2f alpha:alpha];
        //        UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        //        [self addGestureRecognizer:panGR];
//        self.superViewColor = [UIColor clearColor];
//        self.tableViewColor = [UIColor colorWithHexString:@"#000000"];
        _actionSheetBlock = actionSheetBlock;
        _menuPointMode = menuPointMode;
        [self addSubview:self.tableView];
        
        CGRect rect = CGRectMake(frameTable.origin.x, frameTable.origin.y, frameTable.size.width, items.count * HEIGHT_TABLEVIEW_CELL);
        [self.tableView setFrame:rect];
        self.tableView.backgroundColor = tableViewColor;
        
        self.data = [[NSArray alloc] initWithArray:items];
        [self loadDataMore:items];
        
    }
    return self;
}
#pragma mark - dataMethods -
- (void)loadDataMore:(NSArray *)items {
    for (YTX_AddMenuItem *item in items) {
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
#pragma UIView setAlpha Methods -
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
                    [self setAlpha:1.0];
         } completion:^(BOOL finished) {
             
         }];
    }];
    
    [self setFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    
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
/*
 1.点击导航栏不消失，响应事件nil
 2.点击tabBar, 消失，响应事件nil
 3.点击self, 消失 响应事件 self;
 4.点击cell, 响应事件super
 */
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    //1.
//    CGRect frameTop = CGRectMake(0, 0, kMainScreenWidth, kMainNavBarHeight);
//    if (CGRectContainsPoint(frameTop, point)) {
//        return nil;
//    }
//
//    // 2.
//    CGRect frameTab = CGRectMake(0, kMainScreenHeight-kMainTabBarHeight, kMainScreenWidth, kMainTabBarHeight);
//    if (CGRectContainsPoint(frameTab, point)) {
//        [self dismiss];
//        return nil;
//    }
//    // 4
//    CGRect frameTableRect = CGRectMake(self.tableView.origin.x, self.tableView.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height);
//    if (CGRectContainsPoint(frameTableRect, point)) {
//        return  [super hitTest:point withEvent:event];
//    }
//    [self dismiss];
//
//    return [super hitTest:point withEvent:event];
//}
#pragma tableView Delegate methods -
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    YTX_AddMenuItem *item = self.data[indexPath.row];
//    BOOL ishave = [[item.attributesDic objectForKey:[NSNumber numberWithInt:isHaveSwitch]] boolValue];
    BOOL ishave = item.isHaveSwitch;
    if (ishave) {
    } else {
        if (self.actionSheetBlock)
        {
            self.actionSheetBlock(self, indexPath.row, nil);
        }
    }
    [self dismiss];
}

#pragma mark tableview data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YTX_AddMenuItem *item = self.data[indexPath.row];
    YTX_MemuBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:item.className forIndexPath:indexPath];
    if (!cell) {
        cell = [[YTX_MemuBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:item.className];
    }
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    BOOL isHaveCardLineView = [VALUE(item.attributesDic, TO_INT(NON_CardLineView)) boolValue];
    BOOL isHaveCardLineView = item.none_CardLineView;
    if ((indexPath.row != [tableView numberOfRowsInSection:indexPath.section] - 1) && isHaveCardLineView == YES) {
        cell.borders = BOTTOM;
    }
    else {
        cell.borders = NONE;
    }
    if ([cell isKindOfClass:[YTX_MemuBaseCell class]]) {
        if ([cell isKindOfClass:[YTX_MenuSwitchTableViewCell class]]) {
            YTX_MenuSwitchTableViewCell *switchCell = (YTX_MenuSwitchTableViewCell *)cell;
            switchCell.delegate = self;
            switchCell.indexP = indexPath;
        }
    }
    [cell configWithData:item];
    return cell;
}
#pragma mark - switchControlDelegateMethods -
- (void)ytx_MenuSwitchAction:(id)cellData withInndex:(NSIndexPath *)indexPath switchView:(JTMaterialSwitch *)switchView {
//    YTXAddMenuItem *item = (YTXAddMenuItem *)cellData;
    if (self.actionSheetBlock)
       {
           self.actionSheetBlock(self, indexPath.row, switchView);
       }
    [self dismiss];
}

#pragma mark - setters -
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        [_tableView setScrollEnabled:NO];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView.layer setMasksToBounds:YES];
        [_tableView.layer setCornerRadius:5.0f];
        
    }
    return _tableView;
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
            width = 10;
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
    [[self.tableView backgroundColor] setFill];
    [[UIColor clearColor] setStroke];
    CGContextDrawPath(context, kCGPathFillStroke);
    
}
- (UIColor *)colorBlackForAddMenu {
    return [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255.0/255.0 alpha:1];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
