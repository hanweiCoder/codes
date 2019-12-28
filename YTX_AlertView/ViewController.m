//
//  ViewController.m
//  YTX_AlertView
//
//  Created by 韩微 on 2019/12/28.
//  Copyright © 2019 韩微. All rights reserved.
//

#import "ViewController.h"
#import "YTX_AlertViewController.h"

@interface ViewController ()
- (IBAction)p_AlertViewAction:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)p_AlertViewAction:(id)sender {
    NSString *subTitle = @"离开并结束会议";
    YTX_AlertViewController *alert = [[YTX_AlertViewController alloc] initWithTitle:@"确定要离开会议吗?" selected:NO message:subTitle];
    [alert addAction:[YTX_Action actionWithTitle:@"取消" action:^{

    }]];
    [alert addAction:[YTX_Action actionWithTitle:@"确定" action:^{
       
        if(alert.isSelect) {
           
        } else {
           
        }
    }]];

    [alert presentFromViewController:self animated:YES completion:NULL];

}
@end
