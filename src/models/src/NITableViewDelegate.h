//
//  NITableViewDelegate.h
//  TunedIn
//
//  Created by Jared Egan on 12/25/11.
//  Copyright 2011 ThickFuzz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NITableViewModel;

@interface NITableViewDelegate : NSObject <UITableViewDelegate> {
    NITableViewModel *_dataSource;
}

@property (nonatomic, retain) NITableViewModel *dataSource;

// Designated initializer.
- (id)initWithDataSource:(NITableViewModel *)dataSource;

@end
