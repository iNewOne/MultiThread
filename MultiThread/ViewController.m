//
//  ViewController.m
//  MultiThread
//
//  Created by Xujiangfei on 2018/5/15.
//  Copyright © 2018年 Xujiangfei. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "ThreadViewController.h"
#import "GCDViewController.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) Person *person;
@property (weak, nonatomic) IBOutlet UITableView *mainTB;



@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.person = [[Person alloc]init];
    [NSThread detachNewThreadSelector:@selector(sayHello:) toTarget:self.person withObject:@"Jim"];
    //崩溃，self没有sayHello方法
    //    [NSThread detachNewThreadSelector:@selector(sayHello:) toTarget:self withObject:@"Jim"];
    
    NSThread *thread = [[NSThread alloc]initWithTarget:self.person selector:@selector(sayHello:) object:@"Sam"];
    //崩溃，self没有sayHello方法
    //    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(sayHello:) object:@"Sam"];
    [thread start];
    
}






- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"NSThread";
            break;
            
        case 1:
            cell.textLabel.text = @"NSOperation";
            break;
        
        case 2:
            cell.textLabel.text = @"GCD";
            break;

        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        ThreadViewController *vc = [[ThreadViewController alloc]initWithNibName:@"ThreadViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row == 2) {
//        GCDViewController *vc = [[GCDViewController alloc]initWithNibName:@"GCDViewController" bundle:nil];
//        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row == 2) {
        GCDViewController *vc = [[GCDViewController alloc]initWithNibName:@"GCDViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
