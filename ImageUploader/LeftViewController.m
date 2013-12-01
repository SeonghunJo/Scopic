//
//  LeftViewController.m
//  ImageUploader
//
//  Created by 조 성훈 on 2013. 11. 29..
//  Copyright (c) 2013년 Seonghun Jo. All rights reserved.
//

#import "LeftViewController.h"

@interface LeftViewController ()

@end

@implementation LeftViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    
    NSLog(@"%f, %f", rect.size.width, rect.size.height);
    NSLog(@"%f, %f", applicationFrame.size.width, applicationFrame.size.height);
    
    leftTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    
    [leftTableView setDelegate:self];
    [leftTableView setDataSource:self];
    [leftTableView setScrollEnabled:NO];
    
    [leftTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [leftTableView setBackgroundColor:[UIColor clearColor]];
    [leftTableView setAlpha:0.5f];
    [self.view addSubview:leftTableView];
    
    width = rect.size.width;
    height = rect.size.height;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 - (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
 {
 NSLog(@"%d열 %d행 번째",indexPath.section,[indexPath row]);
 [tableView deselectRowAtIndexPath:indexPath animated:YES];  // 해제
 
 [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
 if ([controller.centerController isKindOfClass:[UINavigationController class]]) {
 UITableViewController* cc = (UITableViewController*)((UINavigationController*)controller.centerController).topViewController;
 
 NSArray *viewsToRemove1 = [tableView cellForRowAtIndexPath:indexPath].subviews;
 UILabel *text;
 for (UILabel *v in viewsToRemove1)
 {
 if (v.tag == 111111) // Cell 의 Label 구해오기
 {text = v;}
 }
 
 cc.navigationItem.title = text.text;
 
 if ([cc respondsToSelector:@selector(tableView)]) {
 [cc.tableView deselectRowAtIndexPath:[cc.tableView indexPathForSelectedRow] animated:NO];
 }
 }
 [NSThread sleepForTimeInterval:(300+arc4random()%700)/1000000.0]; // mimic delay... not really necessary
 }];
 }
 [출처] [IOS] ViewDeck Storyboard Example(사용법)|작성자 물먹고하자
 */

/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *testView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 260, 10)];
    testView.backgroundColor = [UIColor blackColor];
    testView.textColor = [UIColor whiteColor];
    switch (section) {
        default:
            testView.text =@"";
            break;
    }
    
    return testView;
}
*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static CGFloat cellHeight = 44.0;
    
    if (indexPath.row == 0) // 첫번째 행의 크기를 크게..
    {
        return cellHeight * 4;
    }
    
    if (indexPath.row == 4)
    {
        return height - cellHeight * 4 - cellHeight * 3;
    }
    
    return cellHeight;
}

#define TAG_CELL_TITLE 1000

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    UILabel *labelView;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        labelView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        labelView.tag = TAG_CELL_TITLE;
        [cell addSubview:labelView];
        
        NSLog(@"TAG : %d", labelView.tag);
    }
    
    if (indexPath.row == 0) {
        labelView.text = @"   프로필";
    }
    else if (indexPath.row == 1)
    {
        labelView.text = @"   홈";
    }
    else if (indexPath.row == 2)
    {
        labelView.text = @"   내가업로드한사진";
    }
    else if (indexPath.row == 3)
    {
        labelView.text = @"   내가좋아한사진";
    }
    else if (indexPath.row == 4)
    {
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    labelView.tag = TAG_CELL_TITLE;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            NSLog(@"is Profile");
            break;
        case 1:
            break;
        case 2:
            break;
        case 3:
            break;
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
        //code
        if ([controller.centerController isKindOfClass:[UINavigationController class]]) {
            UITableViewController* cc = (UITableViewController*)((UINavigationController*)controller.centerController).topViewController;
            
            /*
            NSArray *viewsToRemove1 = [tableView cellForRowAtIndexPath:indexPath].subviews;
            UILabel *text;
            for (UILabel *v in viewsToRemove1)
            {
                if (v.tag == 111111) // Cell 의 Label 구해오기
                {text = v;}
            }
            */
            NSArray *viewsInCell = [tableView cellForRowAtIndexPath:indexPath].subviews;
            UILabel *titleLabel;
            for (UILabel *v in viewsInCell)
            {
                NSLog(@"tag : %d", v.tag);
                if (v.tag == TAG_CELL_TITLE)
                {
                    NSLog(@"Find IT");
                    titleLabel = v;
                }
            }
            
            cc.navigationItem.title = titleLabel.text;
            
            
            if ([cc respondsToSelector:@selector(tableView)]) {
                [cc.tableView deselectRowAtIndexPath:[cc.tableView indexPathForSelectedRow] animated:NO];
            }
            
        }
    }];
}

@end
