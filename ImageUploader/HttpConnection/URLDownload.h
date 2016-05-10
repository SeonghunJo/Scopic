//
//  URLDownload.h
//  Triple
//
//  Created by Seong-hun Jo on 12. 4. 19..
//  Copyright (c) 2012년 KMICGLOBAL. All rights reserved.
//

// http://han9kin.tistory.com/37

#import <Foundation/Foundation.h>

@interface URLDownload : NSOperation <NSURLConnectionDelegate>
{
    NSURLConnection *connection;
    NSMutableData   *data;
    
    NSURLRequest *urlRequest;
    
    BOOL executing;
    BOOL finished;
    
    id delegate;
    SEL selector;
}

/*
 * delegate method의 signature는 다음과 같다.
 *  - 리턴타입:    void
 *  - 첫번째 인자: download operation 객체 (URLDownload *)
 *  - 두번째 인자: 다운받은 데이터 객체 (NSData *)
 *  - 세번째 인자: 에러 객체 (NSError *)
 */
- (id)initWithRequest:(NSURLRequest *)aRequest delegate:(id)aDelegate selector:(SEL)aSelector;

@end

/*
 How to use this class
    
 - (NSOperationQueue *)operationQueue
 {
 return operationQueue; // NSOperationQueue를 적절하게 미리 만들어 두어야 한다.
 }
 
 - (void)downloadDataWithURL:(NSURL *)aURL
 {
 URLDownload *download;
 
 download = [[URLDownload alloc] initWithRequest:[NSURLRequent requestWithURL:aURL] delegate:self selector:@selector(urlDownload:data:error:)];
 [[self operationQueue] addOperation:download];
 [download release];
 }
 
 
// 다운로드가 끝나면 이 메소드가 호출된다.
// 오류가 발생했을 때 data는 nil이 들어온다.
- (void)urlDownload:(URLDownload *)aDownload data:(NSData *)data error:(NSError *)error
{
    if (data)
    {
        // 다운로드 완료
    }
    else
    {
        NSLog(@"download error: %@", error);
    }
}

*/