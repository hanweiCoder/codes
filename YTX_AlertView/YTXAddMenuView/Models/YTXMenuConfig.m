//
//  YTXMenuConfig.m
//  YTXMenu
//
//  Created by 韩微 on 2019/2/22.
//  Copyright © 2019 韩微. All rights reserved.
//

#import "YTXMenuConfig.h"
#import "YTXAddMenuItem.h"
#import "YTX_MenuTitleTableViewCell.h"

@implementation YTXMenuConfig

+ (YTXMenuConfig *)sharedConfig
{
    static YTXMenuConfig *config;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[self alloc] init];
    });
    return config;
}

//- (YTXAddMenuItem *)p_ytxMenuCreatWithTitle:(NSString *)title iconPath:(NSString *)iconPath className:(NSString *)className {
//    YTXAddMenuItem *item = [YTXAddMenuItem createWithTitle:title iconPath:iconPath className:className];
//    return item;
//}
- (void)setFromRoute:(MenuFromRouteMode)fromRoute {
    _fromRoute = fromRoute;
    self.addMenuItems = [[NSArray alloc] init];
    switch (fromRoute) {
        case MenuFromAddress:
        {
            self.addMenuItems = @[
//                [YTXAddMenuItem createWithTitle:@"白板" iconPath:@"" className:@"YTX_MenuTitleTableViewCell"],
//                [YTXAddMenuItem createWithTitle:@"收付款" iconPath:@"" className:@"YTX_MenuTitleTableViewCell"],
//                [YTXAddMenuItem createWithTitle:@"会议加锁" iconPath:@"" className:@"YTX_MenuSwitchTableViewCell"],
                [YTXAddMenuItem createWithTitle:@"发起群聊" iconPath:@"contacts_add_friend" className:@"YTX_MenuIconTextCell" initalType:LGCODE],
            ];
        }
            break;
            case MenuFromChat:
            {
                self.addMenuItems = @[
                    [YTXAddMenuItem createWithTitle:@"发起群聊" iconPath:@"contacts_add_friend" className:@"YTX_MenuIconTextCell" initalType:LGCODE],
                ];
            }
                break;
            case MenuFromConferenceMemberList:
        {
              self.addMenuItems = @[
                                [YTXAddMenuItem createWithTitle:@"群聊" iconPath:@"contacts_add_friend" className:@"YTX_MenuIconTextCell" initalType:LGCODE],
                                [YTXAddMenuItem createWithTitle:@"邀请" iconPath:@"contacts_inviter_friend" className:@"YTX_MenuIconTextCell" initalType:LGCODE],
                            ];
        }
            break;
        default:
            break;
    }
}
#pragma mark - # Getters
//- (NSArray *)addMenuItems{
//    if (!_addMenuItems) {
//        return @[
//            [YTXAddMenuItem createWithTitle:@"白板" iconPath:@"nav_menu_addfriend" className:@"YTX_MenuTitleTableViewCell"],
//            [YTXAddMenuItem createWithTitle:@"收付款" iconPath:@"nav_menu_wallet" className:@"YTX_MenuTitleTableViewCell"],
//            [YTXAddMenuItem createWithTitle:@"会议加锁" iconPath:@"nav_menu_wallet" className:@"YTX_MenuSwitchTableViewCell"],
//            [YTXAddMenuItem createWithTitle:@"添加" iconPath:@"nav_menu_addfriend" className:@"YTX_MenuIconTextCell"],
//        ];
//    }
//    return _addMenuItems;
//}


@end
