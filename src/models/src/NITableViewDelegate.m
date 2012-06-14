//
//  NITableViewDelegate.m
//  TunedIn
//
//  Created by Jared Egan on 12/25/11.
//  Copyright 2011 ThickFuzz. All rights reserved.
//

#import "NimbusCore.h"
#import "NITableViewDelegate.h"
#import "NITableViewModel.h"
#import "NICellFactory.h"
#import "objc/runtime.h"

@implementation NITableViewDelegate

@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;

#pragma mark -
#pragma mark Init & Factory
///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDataSource:(NITableViewModel *)dataSource {
	if ((self = [super init])) {
        self.dataSource = dataSource;
	}
	
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDataSource:(NITableViewModel *)dataSource
                delegate:(id<NITableViewDelegateDelegate>)delegate {
	if ((self = [super init])) {
        self.dataSource = dataSource;
        self.delegate = delegate;
	}
	
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
	self.dataSource = nil;
    self.delegate = nil;
	[super dealloc];
}

#pragma mark -
#pragma mark UITableViewDelegate
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NIDINFO(@"_delegate: %@", _delegate);

    if ([_delegate conformsToProtocol:@protocol(NITableViewDelegateDelegate)] &&
        [_delegate respondsToSelector:@selector(tableView:didSelectObject:atIndexPath:)]) {
        id object = [self.dataSource objectAtIndexPath:indexPath];

        if (object != nil) {
            [_delegate tableView:tableView didSelectObject:object atIndexPath:indexPath];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = [self.dataSource objectAtIndexPath:indexPath];
    
    if ([object conformsToProtocol:@protocol(NICellObject)]) {
        Class cls = [(id<NICellObject>)object cellClass];
        if ([cls conformsToProtocol:@protocol(NICell)]) {
            Method method = class_getClassMethod(cls, @selector(tableView:rowHeightForObject:));
            if (method != NULL) {
                return [cls tableView:tableView rowHeightForObject:object];
            }
        }
    }
    
    // Default option
    return tableView.rowHeight;
}

#pragma mark - UIScrollViewDelegate
/**
 * Since this class frequently takes away the oppotunity of view controllers to be table view
 * delegates, it can forward the messages to the NITableViewDelegateDelegate.
 */
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] &&
        [self.delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [(id<UIScrollViewDelegate>)self.delegate scrollViewDidScroll:scrollView];
    }
        
}

@end
