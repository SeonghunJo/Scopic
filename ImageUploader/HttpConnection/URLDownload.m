//
//  URLDownload.m
//  Triple
//
//  Created by Seong-hun Jo on 12. 4. 19..
//  Copyright (c) 2012년 KMICGLOBAL. All rights reserved.
//

#import "URLDownload.h"

@implementation URLDownload

- (id)initWithRequest:(NSURLRequest *)aRequest delegate:(id)aDelegate selector:(SEL)aSelector
{
    self = [super init];
 
    if (self)
    {
        urlRequest = [NSURLRequest requestWithURL:[aRequest URL]];
        
        connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:NO];
        delegate   = aDelegate;
        selector   = aSelector;
    }
    
    return self;
}

- (void)dealloc
{
}


#pragma mark - overrides for concurrent operation

/*
 * concurrent operation을 위해서는 다음의 메소드를 오버라이드해야 한다.
 *  - isConcurrent
 *  - isExecuting
 *  - isFinished
 *  - start
 */

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

- (void)start
{
    if ([self isCancelled])
    {
         NSLog(@"URLDownload Finished : %@", urlRequest);
        [self willChangeValueForKey:@"isFinished"];
        finished = YES;
        [self didChangeValueForKey:@"isFinished"];
    }
    else
    {
         NSLog(@"URLDownload Executing : %@", urlRequest);
        [self willChangeValueForKey:@"isExecuting"];
        executing = YES;
        [self didChangeValueForKey:@"isExecuting"];
        
        [connection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        //[connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [connection start];
    }
}

#pragma mark - others

/*
 * cancel 메소드를 오버라이드하여 NSURLConnection의 수행을 cancel시키고 operation을 종료한다.
 */
- (void)cancel
{
    //NSLog(@"URLDownload cancel : %@", urlRequest);
    [super cancel];
    [connection cancel];
    
    if ([self isExecuting])
    {
        /*
         * NSOperationQueue의 cancelAllOperations에 의해 cancel될 때
         * [self stop] 을 하면 아직 cancel되지 않은 operation들이 수행을 시작할 수 있기 때문에
         * performSelector:withObject:afterDelay: 메소드를 이용하여 stop시킨다.
         */
        [self performSelector:@selector(stop) withObject:nil afterDelay:0];
    }
}

/*
 * executing과 finished property를 종료 상태로 바꿔주기 위한 편의성 메소드
 */
- (void)stop
{
    //NSLog(@"URLDownload stop : %@", urlRequest);
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    executing = NO;
    finished  = YES;
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

#pragma mark - NSURLConnectionDelegate

/*
 * 응답이 들어오면 데이터를 저장하기 위한 공간을 생성한다.
 */

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    long long length = [response expectedContentLength];
    //NSLog(@"URLDownload didReceiveResponse %lld", length);
    if (length == NSURLResponseUnknownLength)
    {
        length = 0;
    }
    
    data = [[NSMutableData alloc] initWithCapacity:length];
}

/*
 * 데이터가 들어오면 저장해 놓는다.
 */
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)receivedData
{
    //NSLog(@"URLDownload didReceiveData : %@", data);
    [data appendData:receivedData];
}

/*
 * 오류가 발생하면 nil data와 함께 오류를 delegate에 전달하고 operation을 종료한다.
 */
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //NSLog(@"URLDownload didFailWithError : %@", error);
    NSData       *nilData;
    NSInvocation *invocation;
    
    if (![self isCancelled])
    {
        nilData    = nil;
        invocation = [NSInvocation invocationWithMethodSignature:[NSMethodSignature signatureWithObjCTypes:"v@:@@@"]];
        
        [invocation setTarget:delegate];
        [invocation setSelector:selector];
        [invocation setArgument:(void *)self atIndex:2];
        [invocation setArgument:&nilData atIndex:3];
        [invocation setArgument:&error atIndex:4];
        
        [invocation invoke];
    }
    
    [self stop];
}

/*
 * 데이터 로딩이 끝나면 데이터를 delegate에 전달하고 operation을 종료한다.
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError      *nilError;
    NSInvocation *invocation;
    //NSLog(@"URLDownload connectionDidFinishLoading : %@", data);
    if (![self isCancelled])
    {
        nilError   = nil;
        invocation = [NSInvocation invocationWithMethodSignature:[NSMethodSignature signatureWithObjCTypes:"v@:@@@"]];
        
        [invocation setTarget:delegate];
        [invocation setSelector:selector];
        [invocation setArgument:(void *)self atIndex:2];
        [invocation setArgument:&data atIndex:3];
        [invocation setArgument:&nilError atIndex:4];
        
        [invocation invoke];
    }
    
    [self stop];
}

@end
