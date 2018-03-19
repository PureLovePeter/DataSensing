//
//  ViewController.m
//  Pedometer
//
//  Created by peter.zhang on 2017/9/8.
//  Copyright © 2017年 Peter. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface ViewController ()
@property(nonatomic,strong) CMPedometer *stepter;
@property(nonatomic,strong) UILabel *label;

@property(nonatomic,strong) NSNumber *steps;
@property(nonatomic,strong) NSNumber *distance;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _label = [[UILabel alloc]initWithFrame:CGRectMake(10, 300, self.view.frame.size.width - 20 , 40)];
    _label.font = [UIFont systemFontOfSize:14];
    _label.textColor = [UIColor redColor];
    _label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_label];
    
    //判断计步器是否可用
    if (![CMPedometer isStepCountingAvailable]) {
        NSLog(@"计步器不可用");
        return;
    }
    _stepter =[[CMPedometer alloc]init];
    
    //获取当前时间
    NSDate *now = [NSDate date];
    NSLog(@"格林尼治时间: %@", now);
    
    //时间转化格式
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    int year =(int) [dateComponent year];
    int month = (int) [dateComponent month];
    int day = (int) [dateComponent day];
    
    //转化为十分秒
    int hour = (int) [dateComponent hour];
    int minute = (int) [dateComponent minute];
    int second = (int) [dateComponent second];
    NSLog(@"转化为东八区的时间年月日为：%d年%d月%d日%d时%d分%d秒",year,month,day,hour,minute,second);
    
    //今天的0点的相差的时间（TimeInterval）
    NSTimeInterval todayTimeInterval = hour*60*60 + minute*60 + second;
    
    //今天的0点的时间
    NSDate *todyDate = [now dateByAddingTimeInterval:-todayTimeInterval];
    
    //传入start时间
    [_stepter startPedometerUpdatesFromDate:todyDate withHandler:^(CMPedometerData *pedometerData, NSError *error) {
        if(error)
        {
            NSLog(@"error ==%@",error);
        }else
        {
            _steps =pedometerData.numberOfSteps;
            _distance =pedometerData.distance;
            NSLog(@"过去一天你一共走了%@步,一共%@米",_steps,_distance);
            
            NSLog(@"是不是主线程：%d",[NSThread isMainThread]);
            
            [self performSelectorOnMainThread:@selector(loadUI) withObject:nil waitUntilDone:NO];
        }
    }];
}

- (void)loadUI
{
    _label.text = [NSString stringWithFormat:@"过去一天你一共走了%@步,一共%@米",_steps,_distance];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
