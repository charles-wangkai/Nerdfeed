//
//  WebViewController.h
//  Nerdfeed
//
//  Created by WangKai on 9/29/15.
//  Copyright © 2015 Big Nerd Ranch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UISplitViewControllerDelegate>

@property (nonatomic) NSURL *URL;

@end
