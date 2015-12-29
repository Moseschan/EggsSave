//
//  SLPagingViewController.h
//  SLPagingView
//
//  Created by Stefan Lage on 20/11/14.
//  Copyright (c) 2014 Stefan Lage. All rights reserved.
//

#import <UIKit/UIKit.h>


/*
 *  Block delegates
 */

typedef void(^SLPagingViewDidChanged)(NSInteger currentPage);


@interface SLPagingViewController : UIViewController


/*
 *  Delegate: Inform when the page changed
 *  
 *  @param currentPage
 */
@property (nonatomic, copy) SLPagingViewDidChanged didChangedPage;
/*
 *  Contains all views displayed
 */
@property (nonatomic, strong) NSMutableDictionary *viewControllers;



-(void)initializationWithViews:(NSArray*)views;

/*
 *  Set the current index page and scroll to its position
 *
 *  @param index of the wanted page
 *  @param animated animate the moving
 */
-(void)setCurrentIndex:(NSInteger)index animated:(BOOL)animated;


@end


