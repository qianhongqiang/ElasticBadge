//
//  EBGViewController.m
//  ElasticBadge
//
//  Created by qianhongqiang2012@163.com on 05/16/2017.
//  Copyright (c) 2017 qianhongqiang2012@163.com. All rights reserved.
//

#import "EBGViewController.h"
#import <ElasticBadge/EBGElasticBadge.h>

@interface EBGViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation EBGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *demoView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    demoView.delegate = self;
    demoView.dataSource = self;
    [self.view addSubview:demoView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"demoCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        EBGElasticBadge *redPoint = [[EBGElasticBadge alloc] initWithLocationCenter:CGPointMake(self.view.bounds.size.width - 40, 20) bagdeNumber:200 willDismissCallBack:^(EBGElasticBadge *liquidButton) {
            //do something here
            NSLog(@"I was gone");
        }];
        [cell addSubview:redPoint];
    }
    return cell;
}

@end
