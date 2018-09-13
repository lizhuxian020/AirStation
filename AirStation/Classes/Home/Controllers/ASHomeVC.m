//
//  ASHomeVC.m
//  AirStation
//
//  Created by mist on 2018/9/11.
//  Copyright © 2018 mistak1992. All rights reserved.
//

#import "ASHomeVC.h"
#import "AAChartKit.h"

@interface ASHomeVC ()

@property(nonatomic, strong) AAChartView *aaChartView;

@end

@implementation ASHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor greenColor];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    ZXRequest *request = [ZXRequest new]
    .setSubURL(@"https://mistak1992.com/mqttServer/currentStatus")
    .setParams(@{
                 @"node": @"95D0A81CCC28B9C64EA8FE841E1904F4"
                 })
    .setFinishCallback(^(NSDictionary *res){
        NSLog(@"%@", res);
    })
    .setErrorCallback(^(NSString *code, NSString *message){
        NSLog(@"%@", message);
    });
    [request startRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
