//
//  ViewController.m
//  UIWebviewWithCookie
//
//  Created by hudong on 16/7/9.
//  Copyright © 2016年 ZPengs. All rights reserved.
//


#import "ViewController.h"
//#import "SBJson.h"
//#import "JSONKit.h"



//#define YourURL @"http://www.baidu.com"
#define YourURL @"https://bugreport.apple.com"
#define Connection @"keep-alive"
#define Accept @"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8; application/json, text/javascript, */*; q=0.01"
#define clientInfo @"%7B%22U%22%3A%22Mozilla%2F5.0+%28Macintosh%3B+Intel+Mac+OS+X+10_11_3%29+AppleWebKit%2F537.36+%28KHTML%2C+like+Gecko%29+Chrome%2F52.0.2743.116+Safari%2F537.36%22%2C%22L%22%3A%22en-US%22%2C%22Z%22%3A%22GMT%2B08%3A00%22%2C%22V%22%3A%221.1%22%2C%22F%22%3A%22NGa44j1e3NlY5BSo9z4ofjb75PaK4Vpjt3Q9cUVlOrXTAxw63UYOKES5jfzmkflHfmNzl998tp7ppfAaZ6m1CdC5MQjGejuTDRNziCvTDfWl_LwpHWIO_0vLG9mhORoVidPZW2AUMnGWVQdgMVQdgGgeVjrkRGjftckcKyAd65hz7YOK2w5ADwIlUjVsYwQ9dvcpxUyL4T9KTI6y8GGEDd5ihORoVyFGh8cmvSuCKzIlnY6xljQlpRDBeraeJ9QBcEPm8LKfAaZ4ySy.aPjftckvIhIDLTK43xbJlpMpwoNSUC56MnGWpwoNHHACVZXnN95Mfp2qB3dKBSQVD_DJhCizgzH_y3EjNpmd.1wcDhveKQ6TtLB.Tf5.EKVdIX_DJF0ixAzcUeAvqCSFQ_H.4tFaiK7.MJZNqhyA_r_LwwKdBvpZfWfUXtStKjE4PIDzp9hyr1BNlrAp5BNlan0Os5Apw..w1%22%7D"
#define Accept_Encoding @"gzip, deflate, sdch, br"
#define Accept_Language @"en-US,en;q=0.8,zh-CN;q=0.6,zh;q=0.4"
#define UpgradeInsecureRequests @"1"
#define UserAgent @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36"
#define Mode1 1;
#define Mode2 2;
#define Mode3 3;
#define Mode4 4;
#define Mode5 5;

@interface ViewController ()<UIWebViewDelegate>
@property (nonatomic,strong)UIWebView *webView;
@end
@implementation ViewController
NSMutableData* totalData;
NSString* content;
NSInteger Mode;
NSString* filePath;
id writeHandle;
int totaLength;
int currentLength;
float progress;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView.scrollView.frame =self.webView.frame;
    _webView.backgroundColor = [UIColor grayColor];
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 180, self.view.bounds.size.width, self.view.bounds.size.height-100)];
    _webView.delegate = self;
    
    //sandBox
    NSString* cache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"cache: %@", cache);
    filePath = [cache stringByAppendingPathComponent:@"Mclaren_mlb_skip_p2_info_20170730D.xlsx"];
    
    
    UIButton* but = [[UIButton alloc] initWithFrame:CGRectMake(50, 50, 50, 50)];
    
    [self.view addSubview:but];
    [but addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
    
    NSMutableURLRequest *req;

    
    
    //判断是否沙盒中是否有这个值
    if ([[[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys]containsObject:@"cookie"]) {
        
        NSLog(@"xx");
        //获取cookies：程序起来之后，uiwebview加载url之前获取保存好的cookies，并设置cookies，
        NSArray *cookies =[[NSUserDefaults standardUserDefaults]  objectForKey:@"cookie"];
        NSLog(@"cookies: %@", cookies);
        NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
        [cookieProperties setObject:[cookies objectAtIndex:0] forKey:NSHTTPCookieName];
        [cookieProperties setObject:[cookies objectAtIndex:1] forKey:NSHTTPCookieValue];
        [cookieProperties setObject:[cookies objectAtIndex:3] forKey:NSHTTPCookieDomain];
        [cookieProperties setObject:[cookies objectAtIndex:4] forKey:NSHTTPCookiePath];
        NSHTTPCookie *cookieuser = [NSHTTPCookie cookieWithProperties:cookieProperties];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage]  setCookie:cookieuser];
        
        NSString* authUrl = @"https://idmsa.apple.com/IDMSWebAuth/authenticate";
        
        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",authUrl]] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
        
        NSString* appIdKey = @"77e2a60d4bdfa6b7311c854a56505800be3c24e3a27a670098ff61b69fc5214b";
        NSString* appleId = @"bill_chen2";
        NSString* accountPassword = @"Panic_008";

        
        NSString* post = [NSString stringWithFormat:@"appIdKey=%@&accNameLocked=false&language=US-EN&rv=3&Env=PROD&appleId=%@&accountPassword=%@&clientInfo=%@", appIdKey,appleId,accountPassword,clientInfo];
        
        NSData* postData = [post dataUsingEncoding:NSUTF8StringEncoding];
        [req setHTTPMethod:@"POST"];
        [req setValue:Accept_Language forHTTPHeaderField:@"Accept-Language"];
        [req setValue:Connection forHTTPHeaderField:@"Connection"];
        [req setValue:Accept_Encoding forHTTPHeaderField:@"Accept-Encoding"];
        [req setValue:Accept forHTTPHeaderField:@"Accept"];
        [req setValue:UpgradeInsecureRequests forHTTPHeaderField:@"Upgrade-Insecure-Requests"];
        [req setValue:UserAgent forHTTPHeaderField:@"User-Agent"];
        
        [req setHTTPBody:postData];
        NSURLConnection* conn = [NSURLConnection connectionWithRequest:req delegate:self];
        NSLog(@"conn1: %@", conn);
        
    }else{
        
        NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",YourURL]] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
        NSURLConnection* conn = [NSURLConnection connectionWithRequest:req delegate:self];
        
        NSLog(@"conn: %@", conn);
    }
    
    totalData = [[NSMutableData alloc] init];
    
    
    _webView.scalesPageToFit = YES;
    [ self.webView loadRequest:req];
    [self.view addSubview:self.webView];
    

    
}



-(void)connection:(NSURLConnection*)connection didReceiveResponse:( NSURLResponse *)response{
    NSLog(@"--didReceiveResponse--");
    NSLog(@"响应的数据类型：%@" , response.MIMEType);
    // 获取响应数据的长度，如果不能检测到长度，返回NSURLResponseUnknownLength（-1）
    NSLog(@"响应的数据长度为：%lld"
          , response.expectedContentLength);
//    NSLog(@"响应的数据所使用的字符集：%@" , response.textEncodingName);
    NSLog(@"响应的文件名：%@" , response.suggestedFilename);
    
    
    if (Mode == 4) {
        NSFileManager* fm = [NSFileManager defaultManager];
        [fm createFileAtPath:filePath contents:nil attributes:nil];
        
        writeHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
        
        totaLength = (int)response.expectedContentLength;
    }
}


-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    NSError* error = nil;
    id string = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSLog(@"string: %@", string);
    
    [totalData appendData:data];
    NSLog(@"data1: %@", data);
    NSLog(@"data: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    if (Mode == 4) {
        [writeHandle seekToEndOfFile];
        [writeHandle writeData:data];
        currentLength += data.length;
        progress = (double)currentLength/totaLength;
        NSLog(@"progress: %f", progress);
    }
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"--finishLoading--它才是最后的请求结果");
    content = [[NSString alloc] initWithData:totalData encoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    
    if (Mode == 1) {
        
        
        id string = [NSJSONSerialization JSONObjectWithData:totalData options:NSJSONReadingAllowFragments error:&error];
        NSLog(@"string1: %@", string);
        
    }else if (Mode == 2){
        
        id string = [NSJSONSerialization JSONObjectWithData:totalData options:NSJSONReadingAllowFragments error:&error];
        NSLog(@"string2: %@", string);
        
    }else if (Mode == 3){
        
        id string = [NSJSONSerialization JSONObjectWithData:totalData options:NSJSONReadingAllowFragments error:&error];
        NSLog(@"string3: %@", string);
    
    }else if (Mode == 4){
        
        id string = [NSJSONSerialization JSONObjectWithData:totalData options:NSJSONReadingAllowFragments error:&error];
        NSLog(@"string4: %@", string);
        
        currentLength = 0;
        totaLength = 0;
        
        // 关闭文件
        [writeHandle closeFile];
        writeHandle = nil;
        
    }
    
    // 清空所有数据。
    [totalData setLength:0];
    NSLog(@"totalDta: %@", totalData);
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{

}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
// 将获取的cookie储存在沙盒中（ 通过 [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie: cookies]来保存cookies，但是我发现，即使这样设置之后再app退出之后，该cookies还是丢失了（其实是cookies过期的问题)
    NSArray *nCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    NSLog(@"nCookies: %@", nCookies);
    

    NSHTTPCookie *cookie;
    for (id c in nCookies)
    {
        if ([c isKindOfClass:[NSHTTPCookie class]])
        {
            cookie=(NSHTTPCookie *)c;
            NSLog(@"cookie: %@", cookie);
            if ([cookie.name isEqualToString:@"JSESSIONID"]) {
                
                NSLog(@"hh");
                NSNumber *sessionOnly = [NSNumber numberWithBool:cookie.sessionOnly];
                NSNumber *isSecure = [NSNumber numberWithBool:cookie.isSecure];
                NSArray *cookies = [NSArray arrayWithObjects:cookie.name, cookie.value, sessionOnly, cookie.domain, cookie.path, isSecure, nil];
                [[NSUserDefaults standardUserDefaults] setObject:cookies forKey:@"cookie"];
                break;
            }
        }
    }
}


-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"--------------%@",error);
}

-(void)cookie{
    
    NSArray *cookies =[[NSUserDefaults standardUserDefaults]  objectForKey:@"cookie"];
    NSLog(@"cookies: %@", cookies);
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    [cookieProperties setObject:[cookies objectAtIndex:0] forKey:NSHTTPCookieName];
    [cookieProperties setObject:[cookies objectAtIndex:1] forKey:NSHTTPCookieValue];
    [cookieProperties setObject:[cookies objectAtIndex:3] forKey:NSHTTPCookieDomain];
    [cookieProperties setObject:[cookies objectAtIndex:4] forKey:NSHTTPCookiePath];
    NSHTTPCookie *cookieuser = [NSHTTPCookie cookieWithProperties:cookieProperties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage]  setCookie:cookieuser];
}


- (IBAction)test:(id)sender {
    
    Mode = Mode1;
    
    [self cookie];

    NSString*url = @"https://bugreport.apple.com/problems/28666630/description";
    
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",url]] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
    NSURLConnection* conn = [NSURLConnection connectionWithRequest:req delegate:self];

    //conn为上一次请求的response
    NSLog(@"conn: %@", conn);
    NSLog(@"content2: %@", content);
    
}



- (IBAction)test2:(id)sender {
    
    Mode = Mode2;
    
    [self cookie];
    
    NSString*url = @"https://bugreport.apple.com/problems/28666630/diagnosis";
    
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",url]] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
    NSURLConnection* conn = [NSURLConnection connectionWithRequest:req delegate:self];
    
    NSLog(@"conn: %@", conn);

}

- (IBAction)test3:(id)sender {
    
    Mode = Mode3;
    
    [self cookie];
    
    NSString*url = @"https://bugreport.apple.com/problems/28666630/attachments";
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",url]] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
    NSURLConnection* conn = [NSURLConnection connectionWithRequest:req delegate:self];
    
    NSLog(@"conn: %@", conn);
    NSLog(@"content4: %@", content);
    
}

- (IBAction)test4:(id)sender {
    
    Mode = Mode4;
    
    [self cookie];
    
    NSString*url = @"https://bugreport.apple.com/problems/28666630/attachments/Mclaren_mlb_skip_p2_info_20170730D.xlsx";
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",url]] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
    NSURLConnection* conn = [NSURLConnection connectionWithRequest:req delegate:self];
    
    NSLog(@"conn: %@", conn);
    NSLog(@"content5: %@", content);
    
}

- (IBAction)test5:(id)sender {
    Mode = Mode5;
    
    [self cookie];
    
    NSString* raw_url = @"https://bugreport.apple.com/problems/28666630/attachments/exp.txt";
//    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",url]] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
//    NSURLConnection* conn = [NSURLConnection connectionWithRequest:req delegate:self];
//
//    NSLog(@"conn: %@", conn);
//    NSLog(@"content5: %@", content);
    
    //1、确定URL
    NSURL *url = [NSURL URLWithString:raw_url];
    
    //2、确定请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    /******************************************************************/
    //                          设置请求头
    [request setValue:@"multipart/form-data; boundary=----WebKitFormBoundaryUFNaH6losNxu4xDq" forHTTPHeaderField:@"Content-Type"];
    
    /******************************************************************/
    //                          设置请求体
    // 设置请求体
    // 给请求体加入固定格式数据  这里也是使用的也是可变的，因为多嘛
    NSMutableData *data = [NSMutableData data];
    /******************************************************************/
    //                       开始标记/Users/DemonZhu/Desktop/exp.txt
    [data appendData:[@"------WebKitFormBoundaryUFNaH6losNxu4xDq" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"Content-Disposition: form-data; name=\"file\"; filename=\"/Users/DemonZhu/Desktop/exp.txt\"" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"Content-Type: text/plain" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    /******************************************************************/
    //                      上传文件参数
    //图片数据  并且转换为Data
    UIImage *image = [UIImage imageNamed:@"Liiii"];
    NSData *imagedata = UIImagePNGRepresentation(image);
    
    NSString* tem = @"/Users/DemonZhu/Desktop/exp.txt";
    
    NSString* string = [NSString stringWithContentsOfFile:tem encoding:NSUTF8StringEncoding error:NULL];
    
    NSData* txtData = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    
    [data appendData:txtData];
    [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    /******************************************************************/
    //                       非文件参数
    [data appendData:[@"------WebKitFormBoundaryUFNaH6losNxu4xDq" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"Content-Disposition: form-data; name=\"username\"" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"LitterL" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    /******************************************************************/
    //                      添加结束标记
    [data appendData:[@"------WebKitFormBoundaryUFNaH6losNxu4xDq--" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    /******************************************************************/
    
    //请求方式
    request.HTTPMethod = @"POST";
    //请求体
    request.HTTPBody = data;
    
    //3、发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    }];
}

@end

