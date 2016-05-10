//
//  TripleChatRoomViewController.m
//  Triple
//
//  Created by Seong-hun Jo on 12. 3. 29..
//  Copyright (c) 2012년 KMICGLOBAL. All rights reserved.
//

#import "HttpRequestOperation.h"


@implementation HttpRequestOperation

- (BOOL)requestUrl:(NSString *)url bodyObject:(NSMutableDictionary *)bodyObject
{
	// URL Request 객체 생성
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
													   cachePolicy:NSURLRequestUseProtocolCachePolicy
													   timeoutInterval:5.0f];
	NSLog(@"URL : %@", url);
	// 통신방식 정의 (POST, GET)
	[request setHTTPMethod:@"POST"];
	
	// bodyObject의 객체가 존재할 경우 QueryString형태로 변환
	if(bodyObject)
	{
		// 임시 변수 선언
		NSMutableArray *parts = [NSMutableArray array];
		NSString *part;
		NSString *value;
		// 값을 하나하나 변환
		for (NSString *key in bodyObject)
		{
			value = [bodyObject objectForKey:key];
			part = [NSString stringWithFormat:@"%@=%@", [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
					[value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            NSLog(@"%@", part);
			[parts addObject:part];
			
		}
		
		// 값들을 &로 연결하여 Body에 사용
        
		[request setHTTPBody:[[parts componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding]];
	}
	
	// Request를 사용하여 실제 연결을 시도하는 NSURLConnection 인스턴스 생성
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
	
	return YES;
}

/**
 bodyObject rule
 user_id : NSString*
 temp_file_name : NSString*
 file_param_name : NSString*
 url : NSString*
 file_data : NSData*
 */
- (BOOL)requestUrlByFile:(NSString *)url bodyObject:(NSMutableDictionary *)bodyObject
{
	// URL Request 객체 생성
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
														   cachePolicy:NSURLRequestUseProtocolCachePolicy
													   timeoutInterval:10.0f];
	// 통신방식 정의 (POST, GET)
	[request setHTTPMethod:@"POST"];
	
	NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
	[request addValue:contentType forHTTPHeaderField:@"Content-Type"];
	
	//begin line --- POST 
	NSMutableData *body = [NSMutableData data];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]]; 
    
    // 값을 하나하나 변환
    for (NSString *key in bodyObject)
    {
        id val = [bodyObject objectForKey:key];
        if ([val isKindOfClass:[NSData class]]) {
            //Image file 
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", key, @"temp.jpg"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[NSData dataWithData:val]];
        }
        else {
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@", key, val] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
        }
    }

	//finish line --- POST 
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[request setHTTPBody:body];
	
	 // Request를 사용하여 실제 연결을 시도하는 NSURLConnection 인스턴스 생성
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
    return YES;
}

#pragma mark override for current operation
- (BOOL)isConcurrent
{
    return YES;
}

- (BOOL)isExecuting
{
    return executing;
}

- (BOOL)isFinished
{
    return finished;
}

- (void) start
{
    if ([self isCancelled]) {
        [self willChangeValueForKey:@"isFinished"];
        finished = YES;
        [self didChangeValueForKey:@"isFinished"];
    }
    else {
        [self willChangeValueForKey:@"isExecuting"];
        executing = YES;
        [self didChangeValueForKey:@"isExecuting"];
    }
}

- (void) cancel
{
    [super cancel];
    [connection cancel];
    if ([self isExecuting]) {
        [self performSelector:@selector(stop) withObject:nil afterDelay:0];
    }
}
- (void) stop
{
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    executing = NO;
    finished = YES;
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}


#pragma mart nsurlconnection implement method
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)aResponse
{
    if (receivedData == nil) {
        long long length = [aResponse expectedContentLength];
        if (length == NSURLResponseUnknownLength) {
            length = 0;
        }
        
        receivedData = [[NSMutableData alloc] initWithCapacity:length];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	// 데이터를 전송받는 도중에 호출되는 메서드, 여러번에 나누어 호출될 수 있으므로 appendData를 사용한다.
    if (receivedData == nil) {
        receivedData = [[NSMutableData alloc] init];
    }
	[receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	// 에러가 발생되었을 경우 호출되는 메서드
    if (![self isCancelled]) {
        if (target && [target respondsToSelector:failSelector]) {
            // ARC를 사용하는 개발환경에서 "performSelector may cause a leak because its selector is unknown". 워닝이 발생하여 해당 에러 처리.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [target performSelector:failSelector withObject:[error localizedDescription]];
#pragma clang diagnostic pop
        }
    }
    [self stop];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	// 데이터 전송이 끝났을 때 호출되는 메서드, 전송받은 데이터를 NSString형태로 변환한다.
    if (![self isCancelled]) {
        //  utf8
        result = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
        //  euc-kr
        if (!result) {
            result = [[NSString alloc] initWithData:receivedData encoding:0x80000000 + kCFStringEncodingDOSKorean];
        }
        //  ascii
        if (!result) {
            result = [[NSString alloc] initWithData:receivedData encoding:NSASCIIStringEncoding];
        }

        // 델리게이트가 설정되어있다면 실행한다.
        if(target && [target respondsToSelector:selector])
        {
            // ARC를 사용하는 개발환경에서 "performSelector may cause a leak because its selector is unknown". 워닝이 발생하여 해당 에러 처리.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [target performSelector:selector withObject:result];
#pragma clang diagnostic pop
        }
        
    }
    [self stop];
}

- (void)setDelegate:(id)aTarget selector:(SEL)aSelector
{
	// 데이터 수신이 완료된 이후에 호출될 메서드의 정보를 담고 있는 셀렉터 설정
	target = aTarget;
	selector = aSelector;
}


- (void)setDelegate:(id)aTarget success:(SEL)sucSelector failed:(SEL)_failSelector
{
    target = aTarget;
    selector = sucSelector;
    failSelector = _failSelector;
}



- (void)dealloc
{
    /*
    [connection release];
	[receivedData release];

	[result release];
	
	[super dealloc];
     */
}

@end
