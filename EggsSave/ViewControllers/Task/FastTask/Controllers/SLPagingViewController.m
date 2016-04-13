//
//  SLPagingViewController.m
//  SLPagingView
//
//  Created by Stefan Lage on 20/11/14.
//  Copyright (c) 2014 Stefan Lage. All rights reserved.
//

#import "SLPagingViewController.h"
#import "TasksManager.h"
#import "Task.h"
#import "FastTaskView.h"
#import "ShareTaskView.h"
#import "FTDetailViewController.h"
#import "UIWindow+YzdHUD.h"
#import "CommonDefine.h"

#define SCREEN_SIZE [[UIScreen mainScreen] bounds].size

@interface SLPagingViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic) NSInteger indexSelected;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property(strong, nonatomic)NSArray* fastTasks;

@property (strong, nonatomic) id loginedObserver;
@property (strong, nonatomic) id loginFailedObserver;

@property (strong, nonatomic)FastTaskView* ftView;
@property (strong, nonatomic)ShareTaskView* stView;
- (IBAction)segmentAction:(id)sender;

@end

@implementation SLPagingViewController

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self initCrucialObjects:[UIColor whiteColor]];
    }
    return self;
}

-(void)initializationWithViews:(NSArray*)views
{
    int i = 0;
    // is there any controllers ?
    if(views && views.count > 0){
        NSMutableArray *controllerKeys = [NSMutableArray new];
        for(i=0; i < views.count; i++){
            if([[views objectAtIndex:i] isKindOfClass:UIView.class]){
                UIView *ctr = [views objectAtIndex:i];
                // Set the tag
                ctr.tag = i;
                [controllerKeys addObject:@(i)];
            }
            else if([[views objectAtIndex:i] isKindOfClass:UIViewController.class]){
                UIViewController *ctr = [views objectAtIndex:i];
                // Set the tag
                ctr.view.tag = i;
                [controllerKeys addObject:@(i)];
            }
        }
        // Number of keys equals number of controllers ?
        if(controllerKeys.count == views.count)
            _viewControllers = [[NSMutableDictionary alloc] initWithObjects:views
                                                                    forKeys:controllerKeys];
        else{
            // Something went wrong -> inform the client
            NSException *exc = [[NSException alloc] initWithName:@"View Controllers error"
                                                          reason:@"Some objects in viewControllers are not kind of UIViewController!"
                                                        userInfo:nil];
            @throw exc;
        }
    }
}

#pragma mark - LifeCycle

- (void)loadView {
    [super loadView];
   
    self.ftView = [[FastTaskView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    self.stView = [[ShareTaskView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    
    __weak __typeof(self)weakSelf = self;
    
    _ftView.ftdCellSelected = ^(NSInteger index)
    {
        FTDetailViewController *ftdvc = [[FTDetailViewController alloc]initWithStyle:UITableViewStyleGrouped];
        [ftdvc setTask:[[TasksManager getInstance] getTasks][index]];
        
        UIBarButtonItem *temporaryBarButtonItem=[[UIBarButtonItem alloc] init];
        
        temporaryBarButtonItem.title=@"返回";
        
        weakSelf.navigationItem.backBarButtonItem = temporaryBarButtonItem;
        
//        ftdvc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:ftdvc animated:YES];
    };
    
    [self initializationWithViews:@[_ftView, _stView]];
    
    [self setupPagingProcess];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:NAVIBARTITLECOLOR};
    
    self.navigationController.navigationBar.tintColor = NAVIBARTINTCOLOR;
    
    self.fastTasks = [[TasksManager getInstance]getTasks] ;
    
    [self setCurrentIndex:self.indexSelected
                 animated:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    DLog(@"SLPagingViewController viewWillAppear:");
    //注册一个监听者，监听数据获取完毕
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    self.loginedObserver = [center addObserverForName:NSUserDidLoginedNotification object:nil
                                                queue:mainQueue usingBlock:^(NSNotification *note) {
                                                    
                                                    NSDictionary* dict = note.userInfo;
                                                    
                                                    [[TasksManager getInstance] parseLoginData:dict];
                                                    
                                                    NSDictionary* response = dict[@"response"];
                                                    int result = [response[@"result"] intValue];
                                                    
                                                    if (result == 1) {
                                                        //登录成功
                                                        DLog(@"登录成功");
                                                    }else
                                                    {
                                                        //登录失败
                                                        DLog(@"登录失败");
                                                    }
                                                    
                                                    [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
                                                    
                                                    [_ftView refreshData];
                                                }];
    
    self.loginFailedObserver = [center addObserverForName:NSUserLoginFailedNotification object:nil
                                                     queue:mainQueue usingBlock:^(NSNotification *note) {
                                                         
                                                         DLog(@"The user sign up failed");
                                                         
                                                         [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
                                                         //登录失败
                                                         
                                                         [_ftView refreshData];
                                                     }];
}

- (void)viewDidDisappear:(BOOL)animated
{
    DLog(@"SLPagingViewController viewDidDisappear:");
    [[NSNotificationCenter defaultCenter] removeObserver:self.loginedObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self.loginFailedObserver];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - public methods

-(void)setCurrentIndex:(NSInteger)index animated:(BOOL)animated{
    // Be sure we got an existing index
    // save current index
    self.indexSelected = index;
    // Get the right position and update it
    CGFloat xOffset    = (index * ((int)SCREEN_SIZE.width));
    [self.scrollView setContentOffset:CGPointMake(xOffset, self.scrollView.contentOffset.y) animated:animated];
}

#pragma mark - Internal methods

-(void) initCrucialObjects:(UIColor *)background{
    _viewControllers                   = [NSMutableDictionary new];
}

-(void)setupPagingProcess{
    // Make our ScrollView
    CGRect frame                                   = CGRectMake(0, 0, SCREEN_SIZE.width, self.view.frame.size.height);
    self.scrollView                                = [[UIScrollView alloc] initWithFrame:frame];
    self.scrollView.backgroundColor                = [UIColor colorWithRed:238.f/255 green:238.f/255 blue:238.f/255 alpha:238.f/255];
    self.scrollView.pagingEnabled                  = NO;
    self.scrollView.scrollEnabled                  = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator   = NO;
    self.scrollView.delegate                       = self;
    self.scrollView.bounces                        = NO;
    [self.scrollView setContentInset:UIEdgeInsetsMake(0, 0, -80, 0)];
    [self.view addSubview:self.scrollView];
    
    // Adds all views
    [self addControllers];
}

// Add all views
-(void)addControllers{
    if(self.viewControllers
       && self.viewControllers.count > 0){
        float width                 = SCREEN_SIZE.width * self.viewControllers.count;
        float height                = CGRectGetHeight(self.view.frame) - 64.0f - 48.0;
        self.scrollView.contentSize = (CGSize){width, height};
        __block int i               = 0;
        [self.viewControllers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            UIView *v = [self.viewControllers objectForKey:key];
            v.frame   = (CGRect){SCREEN_SIZE.width * i, 0, SCREEN_SIZE.width, CGRectGetHeight(self.view.frame) - 64.0f - 48.0};
            [self.scrollView addSubview:v];
            i++;
        }];
    }
}

-(CGSize) getLabelSize:(UILabel *)lbl{
    return [[lbl text] sizeWithAttributes:@{NSFontAttributeName:[lbl font]}];;
}

#pragma mark - SLPagingViewDidChanged delegate

-(void)sendNewIndex:(UIScrollView *)scrollView{
    
    CGFloat xOffset              = scrollView.contentOffset.x;
    int currentIndex             = ((int) roundf(xOffset)) / (int)(SCREEN_SIZE.width)  ;
    
    DLog(@"currentIndex = %d", currentIndex);
    
    self.segmentControl.selectedSegmentIndex = currentIndex;
}

#pragma mark - ScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self sendNewIndex:scrollView];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self sendNewIndex:scrollView];
}

//scroll to the segmentcontrol indicated
- (IBAction)segmentAction:(id)sender {
    
    UISegmentedControl* segmentControl = (UISegmentedControl*)sender;
    
    int index = (int)segmentControl.selectedSegmentIndex;
    
    CGRect temp = (CGRect){SCREEN_SIZE.width * index, 0, SCREEN_SIZE.width, CGRectGetHeight(self.view.frame) - 64.0f - 48.0};
    
    [self.scrollView scrollRectToVisible:temp animated:YES];
    
}

@end

