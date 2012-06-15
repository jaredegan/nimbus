//
//  NITableViewDelegate.h
//  TunedIn
//
//  Created by Jared Egan on 12/25/11.
//  Copyright 2011 ThickFuzz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NITableViewModel;

/**
 * The "NITableViewDelegateDelegate" will typically be a view controller that's
 * interested in more control or messages.
 * It is also a silly name.
 */
@protocol NITableViewDelegateDelegate <NSObject>

@optional
- (void)tableView:(UITableView *)tableView didSelectObject:(id)object
      atIndexPath:(NSIndexPath *)indexPath;

@end

@interface NITableViewDelegate : NSObject <UITableViewDelegate> {
    NITableViewModel *_dataSource;
    id<NITableViewDelegateDelegate> __weak _delegate; 
}

@property (nonatomic, strong) NITableViewModel *dataSource;

@property (nonatomic, weak) id<NITableViewDelegateDelegate> delegate;

- (id)initWithDataSource:(NITableViewModel *)dataSource;
- (id)initWithDataSource:(NITableViewModel *)dataSource
                delegate:(id<NITableViewDelegateDelegate>)delegate;

@end
