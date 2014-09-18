//
//  FinanceTableViewController.m
//  Rubic's Cube No StoryBoard
//
//  Created by SINA on 14-9-18.
//  Copyright (c) 2014年 weichao. All rights reserved.
//

#import "FinanceTableViewController.h"
#import "FinanceDemoViewController.h"

@interface FinanceTableViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)FinanceDemoViewController *demoController;
@end

@implementation FinanceTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    CGFloat height = 0;
    if (9 == indexPath.row) {
        height = 449;
    }
    else
    {
        height = 100;
    }
    return height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(9 == indexPath.row)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"demo"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"demo"];
            cell.clipsToBounds = YES;
        }
        cell.backgroundColor = [UIColor whiteColor];
        UIView *demoView = [cell.contentView viewWithTag:1003];
        if (demoView) {
                [_demoController startAnimation:nil];
        }
        else
        {
            _demoController = [[FinanceDemoViewController alloc] initWithNibName:@"FinanceDemoViewController" bundle:nil];
            _demoController.view.tag = 1003;
            [cell.contentView addSubview:_demoController.view];
        }
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"normal"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"normal"];
            cell.clipsToBounds = YES;
        }
        cell.backgroundColor = [UIColor greenColor];
        cell.textLabel.text = [NSString stringWithFormat:@"%i",indexPath.row];
        return cell;
    }

}
@end
