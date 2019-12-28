//
//  YTX_AlertViewController.m
//  YTX_AlertView
//
//  Created by 韩微 on 2019/12/28.
//  Copyright © 2019 韩微. All rights reserved.
//

#import "YTX_AlertViewController.h"
#import <Masonry/Masonry.h>
#import "UIButton+ExtendTouchRect.h"

@implementation YTX_Action

- (id)initWithTitle:(NSString *)title action:(dispatch_block_t)action {
    self = [super init];
    if (self) {
        _title = title;
        _action = action;
    }
    return self;
}

+ (YTX_Action *)actionWithTitle:(NSString *)title action:(dispatch_block_t)action {
    YTX_Action *ac = [[YTX_Action alloc] initWithTitle:title action:action];
    return ac;
}

@end

static UIWindow *alertWindow;
@interface YTX_AlertViewController ()
@property (nonatomic, weak) UIViewController *fromController;
@end

CGFloat backViewH = 160;
CGFloat backViewW = 300;

@implementation YTX_AlertViewController
{
    NSString            *_title;
    NSString            *_message;
    
    UIView              *_backView;
    
    UILabel             *_titleLbl;
    UIButton         *_selectButton;
    UILabel             *_messageLbl;
    
    UIButton            *_cancel;
    UIButton            *_send;
    
    UIView              *_hLine;
    UIView              *_vLine;
    
    //    CGFloat             _backBottom;
    
    NSMutableArray      *_actions;
    
}

- (id)initWithTitle:(NSString *)title selected:(BOOL)selected message:(NSString *)message {
    self = [super init];
    if (self) {
        _title = title;
        _isSelect = selected;
        _message = message;
        _actions = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.1];
    
    //    _backBottom = -(CGRectGetHeight(self.view.frame) - backViewH) / 2.;
    //背景视图
    _backView = [[UIView alloc] initWithFrame:CGRectZero];
    _backView.translatesAutoresizingMaskIntoConstraints = false;
    _backView.backgroundColor = [UIColor whiteColor];
    _backView.layer.cornerRadius = 5;
    _backView.layer.masksToBounds = true;
    [self.view addSubview:_backView];
    
    //标题
    _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLbl.translatesAutoresizingMaskIntoConstraints = false;
    _titleLbl.textColor = [UIColor blackColor];
    _titleLbl.font = [UIFont boldSystemFontOfSize:16];
    _titleLbl.textAlignment = NSTextAlignmentCenter;
    _titleLbl.text = _title;
    [_backView addSubview:_titleLbl];
    
    // 选项按钮
    _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backView addSubview:_selectButton];
    _selectButton.selected = _isSelect;
    _selectButton.hidden = _titleLbl.hidden;
    _selectButton.backgroundColor = [UIColor clearColor];
    [_selectButton setImage:[UIImage imageNamed:@"ytx_yhweixuan"] forState:UIControlStateNormal];
    [_selectButton setImage:[UIImage imageNamed:@"ytx_yhyixuan"] forState:UIControlStateSelected];
    [_selectButton addTarget:self action:@selector(shbClickedSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    //副标题
    _messageLbl = [[UILabel alloc] initWithFrame:CGRectZero];
    _messageLbl.translatesAutoresizingMaskIntoConstraints = false;
    _messageLbl.textColor = [UIColor lightGrayColor];
    _messageLbl.font = [UIFont systemFontOfSize:14];
    _messageLbl.text = _message;
    _messageLbl.numberOfLines = 0;
    [_backView addSubview:_messageLbl];
    if (!_message) {
        _messageLbl.hidden = YES;
        _selectButton.hidden = YES;
    } else {
        _messageLbl.hidden = NO;
        _selectButton.hidden = NO;
    }
    NSDictionary *attributs = @{NSFontAttributeName: _messageLbl.font};
    CGSize bubbleSize = [_message boundingRectWithSize:CGSizeMake(backViewW-20, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributs context:nil].size;
     _selectButton.touchExtendInset = UIEdgeInsetsMake(-100, -100, -100, -100);
    
    UIColor *lineColor = [UIColor lightGrayColor];
    
    _hLine = [[UIView alloc] initWithFrame:CGRectZero];
    _hLine.translatesAutoresizingMaskIntoConstraints = false;
    _hLine.backgroundColor = lineColor;
    [_backView addSubview:_hLine];
    
    _vLine = [[UIView alloc] initWithFrame:CGRectZero];
    _vLine.translatesAutoresizingMaskIntoConstraints = false;
    _vLine.backgroundColor = lineColor;
    [_backView addSubview:_vLine];
    
    _cancel = [UIButton buttonWithType:UIButtonTypeSystem];
    _cancel.translatesAutoresizingMaskIntoConstraints = false;
    NSString *cancel = [(YTX_Action *)_actions[0] title];
    [_cancel setTitle:cancel forState:UIControlStateNormal];
    [_cancel setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _cancel.titleLabel.font = [UIFont systemFontOfSize:16];
    [_cancel addTarget:self action:@selector(shbClickedBtn:) forControlEvents:UIControlEventTouchUpInside];
    _cancel.tag = 100;
    [_backView addSubview:_cancel];
    
    _send = [UIButton buttonWithType:UIButtonTypeSystem];
    _send.translatesAutoresizingMaskIntoConstraints = false;
    NSString *send = [(YTX_Action *)_actions[1] title];
    [_send setTitle:send forState:UIControlStateNormal];
    [_send setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _send.titleLabel.font = [UIFont systemFontOfSize:16];
    [_send addTarget:self action:@selector(shbClickedBtn:) forControlEvents:UIControlEventTouchUpInside];
    _send.tag = 200;
    [_backView addSubview:_send];
    
    //    if (IsPortrait) {
    //        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
    //            make.top.mas_equalTo((kMainScreenHeight-backViewH)*2 / 5);
    //            make.centerX.equalTo(self.view);
    //            make.size.mas_equalTo(CGSizeMake(backViewW, backViewH));
    //        }];
    //    }  else {
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(backViewW, backViewH));
    }];
    //    }
    
    if (_messageLbl.hidden) {
        [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_backView);
            make.top.equalTo(_backView.mas_top).offset((backViewH-50-25)/2);
            make.width.equalTo(_backView.mas_width);
            make.height.mas_equalTo(25);
        }];
    } else {
        [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_backView);
            make.top.mas_equalTo(_backView.mas_top).offset(30);
            make.width.equalTo(_backView.mas_width);
            make.height.mas_equalTo(25);
        }];
        
        [_selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_backView).offset((backViewW-bubbleSize.width-20)/2);
            make.top.equalTo(_titleLbl.mas_bottom).offset(0);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        [_messageLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_selectButton.mas_right).offset(-10);
            make.top.equalTo(_titleLbl.mas_bottom).offset(0);
            make.width.mas_equalTo(backViewW/2);
            make.height.mas_equalTo(40);
        }];
    }
    
    [_hLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_backView);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(_backView.mas_bottom).offset(-50);
    }];
    [_vLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_backView);
        make.width.mas_equalTo(1);
        make.top.mas_equalTo(_hLine.mas_bottom);
        make.bottom.mas_equalTo(_backView.mas_bottom);
    }];
    
    [_cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_backView);
        make.bottom.mas_equalTo((_backView.mas_bottom));
        make.top.mas_equalTo((_hLine.mas_bottom));
        make.width.mas_equalTo(backViewW / 2 - 1);
    }];
    
    [_send mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_backView);
        make.bottom.mas_equalTo((_backView.mas_bottom));
        make.top.mas_equalTo((_hLine.mas_bottom));
        make.width.mas_equalTo(backViewW / 2 - 1);
    }];
    self.view.layer.shouldRasterize = true;
    self.view.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
}

- (void)shbClickedBtn:(UIButton *)btn {
    if (btn.tag == 100) {
        YTX_Action *action = _actions[0];
        if (action.action) {
            action.action();
        }
    } else {
        YTX_Action *action = _actions[1];
        if (action.action) {
            action.action();
        }
    }
    [self dismiss];
}
- (void)shbClickedSelectBtn:(UIButton *)btn {
    _isSelect = btn.selected = !btn.selected;
}
- (void)addAction:(YTX_Action *)action {
    [_actions addObject:action];
}

#pragma mark -
- (void)presentFromViewController:(UIViewController *)fromViewController animated:(BOOL)flag completion:(void (^)(void))completion{
    if (fromViewController == nil) {
        NSLog(@"error: fromViewController is nil! ");
        return;
    }
    self.fromController = fromViewController;
    
    if (alertWindow == nil) {
        alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        alertWindow.backgroundColor = [UIColor clearColor];
        alertWindow.windowLevel = UIWindowLevelAlert - 1;
    }
    
    alertWindow.rootViewController = self;
    
//    _backView.transform = CGAffineTransformMakeScale(1.1, 1.1);
//    [UIView animateWithDuration:0.25 animations:^{
//        _backView.transform = CGAffineTransformMakeScale(1.0, 1.0);
//    }];
    
    [alertWindow makeKeyAndVisible];
    
}

- (void)dismissWithAnimation:(BOOL)flag completion:(void (^)(void))completion{
    
    [_backView removeFromSuperview];
    [self.fromController.view.window makeKeyAndVisible];
    alertWindow.hidden = YES;
    self.fromController = nil;
    
}
- (void)show {
//    UIViewController *result = [self getCurrentVC];
//    [result addChildViewController:self];
//    [result.view addSubview:self.view];
}

- (void)dismiss {
    //    __weak typeof(self) YTX = self;
    //    [UIView animateWithDuration:0.1 animations:^{
    //        [YTX.view removeFromSuperview];
    //        [YTX removeFromParentViewController];
    //    } completion:^(BOOL finished) {
    //    }];
    [self dismissWithAnimation:YES completion:NULL];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
