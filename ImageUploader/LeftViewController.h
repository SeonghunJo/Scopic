//
//  LeftViewController.h
//  ImageUploader
//
//  Created by 조 성훈 on 2013. 11. 29..
//  Copyright (c) 2013년 Seonghun Jo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IIViewDeckController.h"

@interface LeftViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    CGFloat width, height;
    UITableView *leftTableView;
}

@end
