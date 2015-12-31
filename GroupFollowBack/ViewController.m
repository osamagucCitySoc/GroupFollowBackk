//
//  ViewController.m
//  GroupFollowBack
//
//  Created by Osama Rabie on 12/30/15.
//  Copyright © 2015 Osama Rabie. All rights reserved.
//

#import "ViewController.h"
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import "FollowViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ViewController
{
    __weak IBOutlet UITableView *tableView;
    NSMutableArray* dataSources;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier]isEqualToString:@"followSeg"])
    {
        FollowViewController* dst = (FollowViewController*)[segue destinationViewController];
        [dst setAccount:[dataSources objectAtIndex:tableView.indexPathForSelectedRow.row]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}

-(void)loadData
{
    dataSources = [[NSMutableArray alloc]init];
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error){
        dispatch_async( dispatch_get_main_queue(), ^{
            if (granted) {
                dataSources = [[NSMutableArray alloc]initWithArray:[accountStore accountsWithAccountType:accountType]];
                if(dataSources.count == 0)
                {
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"عفواً" message:@"لا يوجد حسابات تويتر مسجلة في إعدادات الجهاز" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }else
                {
                    [tableView reloadData];
                    [tableView setNeedsDisplay];
                }
            }else
            {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"عفواً" message:@"يجب منح التطبيق حق الوصول لحسابات تويتر لنستطيع إضافة متابعين لك" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            // Add code here to update the UI/send notifications based on the
            // results of the background processing
        });
        
    }];
}
- (IBAction)refreshButtonClicked:(id)sender {
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSources.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableVieww cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellID = @"accountsCell";
    UITableViewCell* cell = [tableVieww dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    [[cell textLabel]setText:[[dataSources objectAtIndex:indexPath.row] username]];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"followSeg" sender:self];
}
@end
