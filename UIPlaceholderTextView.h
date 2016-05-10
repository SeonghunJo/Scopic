//
//  UIPlaceholderTextView.h
//  Scopic
//
//  Created by 조 성훈 on 2013. 12. 20..
//  Copyright (c) 2013년 Seonghun Jo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIPlaceHolderTextView : UITextView

@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end