//
//  textViewController.m
//  VeterinaryDrugs
//
//  Created by 邱 德政 on 16/5/25.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "textViewController.h"
#import "AppDelegate.h"

@interface textViewController ()
@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)UIProgressView *progressIndicator;

@property (nonatomic,strong)NSURLSession *urlSession;         //  普通会话
//@property (nonatomic,strong)NSURLSession *backgroundSession;  //  后台会话
@property (nonatomic,strong)NSURLSessionDownloadTask *sessionDownloadTask;  //  下载Task
@property (nonatomic,strong)NSURLSessionDownloadTask *resumableTask;        //  恢复下载Task
@property (nonatomic,strong)NSURLSessionDownloadTask *backgroundTask;       //  后台下载Task
@property (nonatomic,strong)NSData *partialData;   //  下载的局部数据
@end

@implementation textViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, 320, 300)];
    [self.view addSubview:_imageView];
    
    self.progressIndicator = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    _progressIndicator.frame = CGRectMake(50, 500, 220, 50);
    [self.view addSubview:_progressIndicator];
    
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cancleButton.frame = CGRectMake(120, 400, 40, 40);
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancleButton addTarget:self action:@selector(didClickCancleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancleButton];
    
    UIButton *downloadButton = [UIButton buttonWithType:UIButtonTypeSystem];
    downloadButton.frame = CGRectMake(20, 400, 40, 40);
    [downloadButton setTitle:@"下载" forState:UIControlStateNormal];
    [downloadButton addTarget:self action:@selector(didClickDownloadButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:downloadButton];
    
    UIButton *uploadButton = [UIButton buttonWithType:UIButtonTypeSystem];
    uploadButton.frame = CGRectMake(70, 400, 40, 40);
    [uploadButton setTitle:@"上传" forState:UIControlStateNormal];
    [uploadButton addTarget:self action:@selector(didClickUploadButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:uploadButton];
    
    UIButton *resumableButton = [UIButton buttonWithType:UIButtonTypeSystem];
    resumableButton.frame = CGRectMake(180, 400, 40, 40);
    [resumableButton setTitle:@"恢复" forState:UIControlStateNormal];
    [resumableButton addTarget:self action:@selector(didClickResuableButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resumableButton];
    
    UIButton *backgroundLoadButton = [UIButton buttonWithType:UIButtonTypeSystem];
    backgroundLoadButton.frame = CGRectMake(220, 400, 80, 40);
    [backgroundLoadButton setTitle:@"后台下载" forState:UIControlStateNormal];
    [backgroundLoadButton addTarget:self action:@selector(didClickBackgroundButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backgroundLoadButton];
    
    
#pragma mark - 如果我们需要利用NSURLSession进行数据传输我们需要：
    /**
     *  创建一个NSURLSessionConfiguration，用于创建NSSession时设置工作模式(3种)
     *  (1)一般模式（default）：工作模式类似于原来的NSURLConnection，可以使用缓存的Cache，Cookie，鉴权。
     *  (2)及时模式（ephemeral）：不使用缓存的Cache，Cookie，鉴权。
     *  (3)后台模式（background）：在后台完成上传下载，创建Configuration对象的时候需要给一个NSString的ID用于追踪完成工作的Session是哪一个
     */
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    /**
     *  @网络设置：参考NSURLConnection中的设置项
     *  两种创建方法(目前不太懂什么区别)
     *  (1)就是根据刚才创建的Configuration创建一个Session，系统默认创建一个新的OperationQueue处理Session的消息
     *  (2)可以设定回调的delegate（注意这个回调delegate会被强引用），并且可以设定delegate在哪个OperationQueue回调，如果我们将其
     *     设置为[NSOperationQueue mainQueue]就能在主线程进行回调非常的方便
     */
    //NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    self.urlSession = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURL *url = [NSURL URLWithString:@"http://www.bizhiwa.com/uploads/allimg/2012-01/22021207-1-311536.jpg"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    /**
     *  NSURLSessionUploadTask：上传用的Task，传完以后不会再下载返回结果；
     *  NSURLSessionDownloadTask：下载用的Task；
     *  NSURLSessionDataTask：可以上传内容，上传完成后再进行下载。
     */
    self.sessionDownloadTask = [self.urlSession downloadTaskWithRequest:request];
    
    //  同NSURLConnection一样,有代理方法也就有block方法
    //    [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    //    }];
    
}

#pragma mark 点击下载
- (void)didClickDownloadButtonAction:(UIButton *)button{
    
    // 因为任务默认是挂起状态，需要恢复任务（执行任务）
    [_sessionDownloadTask resume];
    
}

#pragma mark 点击上传
- (void)didClickUploadButtonAction:(UIButton *)button{
    
    //判断imageView是否有内容
    if (_imageView.image == nil) {
        
        NSLog(@"image view is empty");
        return;
        
    }
    
    // 0. 上传之前在界面上添加指示符
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    // 设置位置???
    CGSize size = _imageView.bounds.size;
    indicator.center = CGPointMake(size.width / 2.0, size.height / 2.0);
    [self.imageView addSubview:indicator];
    [indicator startAnimating];
    
    // 1. URL
    NSURL *url = [NSURL URLWithString:@"http://www.bizhiwa.com/uploads/allimg/2012-01/22021207-1-311536.jpg"];
    
    // 2. Request -> PUT,request的默认操作是GET
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0f];
    request.HTTPMethod = @"PUT";
    
    // *** 设置网络请求的身份验证! ***
    
    // 1> 授权字符串
    
    NSString *authStr = @"admin:123456";
    
    // 2> BASE64的编码,避免数据在网络上以明文传输
    // iOS中,仅对NSData类型的数据提供了BASE64的编码支持
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *encodeStr = [authData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", encodeStr];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    // 3. Session
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    // 4. UploadTask
    NSData *imageData = UIImageJPEGRepresentation(_imageView.image, 0.75);
    //  应用block的请求方式
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:imageData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        // 上传完成后,data参数转换成string就是服务器返回的内容
        
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"OK -> %@", str);
        
        [NSThread sleepForTimeInterval:5.0f];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [indicator stopAnimating];
            [indicator removeFromSuperview];
            
        });
        
    }];
    
    // 因为任务默认是挂起状态，需要恢复任务（执行任务）
    [uploadTask resume];
}

#pragma mark 点击取消
//  NSURLConnection一旦发送是没法取消的。但是，我们可以很容易的取消掉一个NSURLSessionTask任务
- (void)didClickCancleButtonAction:(UIButton *)button{
    
    /**
     *  当取消后，会回调这个URLSession:task:didCompleteWithError:代理方法，通知你去及时更新UI。当取消一个任务后，也
     *  十分可能会再一次回调这个代理方法URLSession:downloadTask:didWriteData:BytesWritten:totalBytesExpectedToWrite:
     *  当然，didComplete 方法肯定是最后一个回调的。
     */
    //    if (_sessionDownloadTask) {
    //
    //        //  取消下载请求
    //        [_sessionDownloadTask cancel];
    //        _sessionDownloadTask = nil;
    //    }
    
    if (!self.sessionDownloadTask) {
        
        //  停止下载任务,把待恢复的数据保存到一个变量中，方便后面恢复下载使用
        [self.sessionDownloadTask cancelByProducingResumeData:^(NSData *resumeData) {
            
            self.partialData = resumeData;
            self.sessionDownloadTask = nil;
            
        }];
    }
}

#pragma mark  恢复下载(断点续传)
- (void)didClickResuableButtonAction:(UIButton *)button{
    
    if (self.partialData) {
        
        self.sessionDownloadTask = [self.urlSession downloadTaskWithResumeData:self.partialData];
        self.partialData = nil;
        
    }else{
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://pic4.duowan.com/wow/1002/130782267821/130782458426.jpg"]];
        self.resumableTask = [self.urlSession downloadTaskWithRequest:request];
        
    }
    
    [self.sessionDownloadTask resume];
    
}

#pragma mark 后台下载模式
- (void)didClickBackgroundButtonAction:(UIButton *)button{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://dldir1.qq.com/qqfile/QQforMac/QQ_V3.1.2.dmg"]];
    self.backgroundTask = [[self backgroundSession] downloadTaskWithRequest:request];
    
    [self.backgroundTask resume];
}

#pragma mark - NSURLSessionDownloadTaskDelegate
//  下载完成
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    
    /**
     *******->appDelegete里面的方法
     typedef void(^MyBlock)();
     @property (copy, nonatomic) MyBlock backgroundURLSessionCompletionHandler;
     //  后台请求结束时调用的方法
     - (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler{
     
     self.backgroundURLSessionCompletionHandler = completionHandler;
     }
     
     */
    //  如果是后台NSURLSession,后台请求结束后会调用这个方法,通知你应该更新UI了
    if (session == [self backgroundSession]) {
        
//        self.backgroundTask = nil;
//        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//        if (appDelegate.backgroundURLSessionCompletionHandler) {
//            
//            void(^handler)() = appDelegate.backgroundURLSessionCompletionHandler;
//            appDelegate.backgroundURLSessionCompletionHandler = nil;
//            handler();
//        }
        
    }
    
    //  这里的缓存处理做的不好,大家按自己的方法处理就行,还有图片的存储以它本身的URL路径为准,这样是不会有重复的
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *cachesURLPath = [[fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
    //  根据URL获取到下载的文件名,拼接成沙盒的存储路径(location是下载的临时文件目录,在tmp文件夹里面)
    NSURL *destinationPath = [cachesURLPath URLByAppendingPathComponent:[location lastPathComponent]];
    
    NSError *error = nil;
    BOOL success = [fileManager moveItemAtURL:location toURL:destinationPath error:&error];
    [fileManager removeItemAtURL:location error:NULL];
    
    //  location是下载的临时文件目录,将文件从临时文件夹复制到沙盒
    //    BOOL success = [fileManager copyItemAtURL:location toURL:destinationPath error:&error];
    if (success) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIImage *image = [UIImage imageWithContentsOfFile:[destinationPath path]];
            self.imageView.image = image;
            //  UIImageView会自动裁剪图片适应它的frame,下面这个属性就是展示原图
            self.imageView.contentMode = UIViewContentModeScaleAspectFill;
            
        });
    }
    
}

//  不管任务是否成功，在完成后都会回调这个代理方法
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    
    //  如果error是nil，则证明下载是成功的，否则就要通过它来查询失败的原因。如果下载了一部分，这个error会包含一个NSData对象，如果后面要恢复任务可以用到
    if (error == nil) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.progressIndicator.hidden = YES;
        });
    }
    
}

//  传输进度
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    
    double currentValue = totalBytesWritten / (double)totalBytesExpectedToWrite;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%f",currentValue);
        self.progressIndicator.hidden = NO;
        self.progressIndicator.progress = currentValue;
    });
}

//  未知
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes{
    
}

#pragma mark - NSURLSession另一个重要的特性：即使当应用不在前台时，你也可以继续传输任务。当然，我们的会话模式也要为后台模式
- (NSURLSession *)backgroundSession{
    
    //  通过给的后台token，我们只能创建一个后台会话，所以这里使用dispatch once block
    static NSURLSession *backgroundSession = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
//        NSURLSessionConfiguration *config = [NSURLSessionConfiguration backgroundSessionConfiguration:@"com.shinobicontrols.BackgroundDownload.BackgroundSession"];
//        backgroundSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
        
        
    });
    
    return backgroundSession;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
