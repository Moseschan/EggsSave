//
//  EggsHomeViewController.m
//  EggsSave
//
//  Created by 郭洪军 on 12/17/15.
//  Copyright © 2015 Adwan. All rights reserved.
//

#import "EggsHomeViewController.h"
#import "CommonDefine.h"
#import "HomeCell.h"
#import "MJRefresh.h"
#import "LoginManager.h"
#import "UIWindow+YzdHUD.h"

@interface EggsHomeViewController ()

@property (weak, nonatomic) HomeCell *homeCell;
@property (strong, nonatomic) id loginedObserver;

@end

NSString* const NSUserDidLoginedNotification = @"NSUserDidLoginedNotification" ;
NSString* const NSUserSignUpNotification = @"NSUserSignUpNotification";
NSString* const NSUserSignUpFailedNotification = @"NSUserSignUpFailedNotification";
NSString* const NSUserLoginFailedNotification = @"NSUserLoginFailedNotification";
NSString* const NSUserGetTaskSucceedNotification = @"NSUserGetTaskSucceedNotification";  //接任务成功
NSString* const NSUserDoTaskFailedNotification = @"NSUserDoTaskFailedNotification";  //审核任务失败

@implementation EggsHomeViewController

- (void)viewWillAppear:(BOOL)animated
{
    //注册一个监听者，监听数据获取完毕
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    self.loginedObserver = [center addObserverForName:NSUserDidLoginedNotification object:nil
                                                queue:mainQueue usingBlock:^(NSNotification *note) {
                                                    
                                                    NSLog(@"The user's did logined");
                                                    
                                                    [self.homeCollection.header endRefreshing];
                                                    
                                                    [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
                                                    
                                                }];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self.loginedObserver];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupRefresh];
}

- (void)setupRefresh
{
    // 下拉刷新
    self.homeCollection.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //进行登录操作
        
        [self.view.window showHUDWithText:@"加载中" Type:ShowLoading Enabled:YES];
        
        LoginManager* manager = [LoginManager getInstance];
        [manager login];
        
    }];
    
    [self.homeCollection.header beginRefreshing];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = nil;
    
    self.homeCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reusedID" forIndexPath:indexPath];
    cell = self.homeCell;
    
    if (self.homeCell.adImageView.gestureRecognizers.count == 0) {
        UITapGestureRecognizer * gestureAd = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAd)];
        [self.homeCell.adImageView addGestureRecognizer:gestureAd];
    }
    
    return cell;
}

- (void)tapAd
{
    NSLog(@"taped ad!!!");
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionReusableView* reusableView = nil;
//    
//    reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"reusedViewID" forIndexPath:indexPath];
//    
//    return reusableView;
//}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(SCREEN_WIDTH, 557 + (SCREEN_WIDTH * 130.0) / 320.0f - 130.0f) ;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    return UIEdgeInsetsZero;
//}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
//{
//    if (0 == section) {
//        return CGSizeMake(320, 80);
//    }
//    return CGSizeZero;
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if (0 == indexPath.section) {
//        if (0 == indexPath.row) {
//            CLLocation * curLoc = [BussinessDataProvider lastGoodLocation];
//            if (curLoc) {
//                [self gotoDetail:self.bestGuessDest fromLoc:curLoc];
//            } else {
//                [self showToast:@"当前gps不可用" onDismiss:nil];
//            }
//        }
//    }
}


- (IBAction)goTask:(id)sender {
    //跳转到任务界面
    [self.tabBarController setSelectedIndex:2];
}
@end
