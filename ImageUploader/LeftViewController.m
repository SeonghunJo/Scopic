//
//  LeftViewController.m
//  ImageUploader
//
//  Created by 조 성훈 on 2013. 11. 29..
//  Copyright (c) 2013년 Seonghun Jo. All rights reserved.
//

#import "LeftViewController.h"

@interface LeftViewController () <UISearchBarDelegate>

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
    [leftTableView setSeparatorColor:[UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:0.9]];
    [leftTableView setSeparatorInset:UIEdgeInsetsZero];
    //[leftTableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"pattern-menu.png"]]];
    [self.view addSubview:leftTableView];
    
    width = rect.size.width;
    height = rect.size.height;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pattern-menu.png"]];
    
    [leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.view endEditing:YES];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"searchBarDelegate2");
    [searchBar resignFirstResponder];
    [self.navigationController.view endEditing:YES];
    
    [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
        //code
        if ([controller.centerController isKindOfClass:[UINavigationController class]]) {
            UITableViewController* centerViewController = (UITableViewController*)((UINavigationController*)controller.centerController).topViewController;
            
            if([(GalleryViewController *)centerViewController respondsToSelector:@selector(getPhotoWithKeyword:)])
            {
                [(GalleryViewController *)centerViewController performSelector:@selector(getPhotoWithKeyword:) withObject:searchBar.text];
            }
        }
    }];

}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    NSLog(@"searchBarDelegate");
    [searchBar resignFirstResponder];
    [self.navigationController.view endEditing:YES];

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
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static CGFloat cellHeight = 44.0;
    
    if (indexPath.row == 0) // 첫번째 행의 크기를 크게..
    {
        return cellHeight * 2;
    }
    else if (indexPath.row == 1)
    {
        return cellHeight * 2;
    }
    else if (indexPath.row == 6)
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
    UIImageView *iconView;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pattern-menu.png"]];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        labelView = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, 320, 44)];
        labelView.tag = TAG_CELL_TITLE;
        labelView.textColor = [UIColor whiteColor];
        labelView.alpha = 1.0;
        labelView.font = [UIFont systemFontOfSize:13.0f];
        [cell addSubview:labelView];
        
        iconView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 11, 22, 22)];
        [cell addSubview:iconView];
        
        UIView *v = [[UIView alloc] init];
    	v.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.9];
    	cell.selectedBackgroundView = v;

        
        NSLog(@"TAG : %ld", labelView.tag);
    }
    
    if (indexPath.row == 0) {
        
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 33, 320 - 66, 44)];
        [searchBar setPlaceholder:@"검색"];
        searchBar.delegate = self;
        [searchBar setSearchBarStyle:UISearchBarStyleDefault];
        [searchBar setBarStyle:UIBarStyleBlackTranslucent];
        [searchBar setBackgroundImage:[UIImage new]];//[UIImage imageNamed:@"pattern-menu"]];
        [searchBar setTranslucent:YES];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell addSubview:searchBar];
    }
    else if (indexPath.row == 1) {
        [labelView setFrame:CGRectMake(35, 0, 320, 44*2)];
        [labelView setTextAlignment:NSTextAlignmentLeft];
        //labelView.text = @"   프로필";
        labelView.text = @"   TeamCMYK@yahoo.com";
        [iconView setImage:[UIImage imageNamed:@"profile"]];
        [iconView setFrame:CGRectMake(15, 44 * 1 - 11, 22, 22)];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    else if (indexPath.row == 2)
    {
        labelView.text = @"   홈";
        [iconView setImage:[UIImage imageNamed:@"home"]];
    }
    else if (indexPath.row == 3)
    {
        labelView.text = @"   내가 올린 사진";
        [iconView setImage:[UIImage imageNamed:@"upload"]];
    }
    else if (indexPath.row == 4)
    {
        labelView.text = @"   좋아요+1한 사진";
        [iconView setImage:[UIImage imageNamed:@"like"]];
    }
    /*
    else if (indexPath.row == 4)
    {
        labelView.text = @"   로그아웃";
        [iconView setImage:[UIImage imageNamed:@"logout"]];
    }*/
    else if(indexPath.row == 5)
    {
        labelView.text = @"   로그아웃";
        [iconView setImage:[UIImage imageNamed:@"logout"]];
    }
    else
    {
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    labelView.tag = TAG_CELL_TITLE;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
        //code
        if ([controller.centerController isKindOfClass:[UINavigationController class]]) {
            UITableViewController* centerViewController = (UITableViewController*)((UINavigationController*)controller.centerController).topViewController;
            
            GalleryViewController *galleryView = (GalleryViewController *)centerViewController;
            /*
            NSArray *viewsToRemove1 = [tableView cellForRowAtIndexPath:indexPath].subviews;
            UILabel *text;
            for (UILabel *v in viewsToRemove1)
            {
                if (v.tag == 111111) // Cell 의 Label 구해오기
                {text = v;}
            }
             
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
            
            centerViewController.navigationItem.title = titleLabel.text;
            
            if ([centerViewController respondsToSelector:@selector(tableView)]) {
                [centerViewController.tableView deselectRowAtIndexPath:[centerViewController.tableView indexPathForSelectedRow] animated:NO];
            }
            */
            switch (indexPath.row) {
                case 0:
                    break;
                case 1: // PROFILE
                    NSLog(@"is Profile");
                    break;
                case 2: // MAINGALLERY
                    if([(GalleryViewController *)centerViewController respondsToSelector:@selector(getPhotoWithLocation)])
                    {
                        [(GalleryViewController *)centerViewController performSelector:@selector(getPhotoWithLocation)];
                    }
                    break;
                case 3: // UPLOADS
                    if([(GalleryViewController *)centerViewController respondsToSelector:@selector(getPhotoWithUploaded)])
                    {
                        [(GalleryViewController *)centerViewController performSelector:@selector(getPhotoWithUploaded)];
                    }
                    break;
                case 4: // FAVORITES
                    if([(GalleryViewController *)centerViewController respondsToSelector:@selector(getPhotoWithLike)])
                    {
                        [(GalleryViewController *)centerViewController performSelector:@selector(getPhotoWithLike)];
                    }
                    break;
                case 5: // LOGOUT
                    [centerViewController.navigationController popViewControllerAnimated:NO];
                    break;
                default:
                    break;
            }
        }
    }];
}

@end
