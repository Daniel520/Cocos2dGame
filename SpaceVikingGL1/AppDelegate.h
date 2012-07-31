//
//  AppDelegate.h
//  SpaceVikingGL1
//
//  Created by Daniel yu on 12-7-31.
//  Copyright 广工 2012年. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
