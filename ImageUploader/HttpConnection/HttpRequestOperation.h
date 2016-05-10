//
//  TripleChatRoomViewController.h
//  Triple
//
//  Created by Seong-hun Jo on 12. 4. 18..
//  Copyright (c) 2012년 KMICGLOBAL. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface HttpRequestOperation : NSOperation 
{
	NSMutableData *receivedData;
	NSString *result;
    NSURLConnection *connection;
    
	id target;
	SEL selector;
    SEL failSelector;
    
    BOOL executing;
    BOOL finished;
}


- (BOOL)requestUrl:(NSString *)url bodyObject:(NSMutableDictionary *)bodyObject;
- (BOOL)requestUrlByFile:(NSString *)url bodyObject:(NSMutableDictionary *)bodyObject;

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)aResponse;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

- (void)setDelegate:(id)aTarget selector:(SEL)aSelector;
- (void)setDelegate:(id)aTarget success:(SEL)sucSelector failed:(SEL)_failSelector;


@end
