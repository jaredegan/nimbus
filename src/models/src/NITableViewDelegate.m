//
//  NITableViewDelegate.m
//  TunedIn
//
//  Created by Jared Egan on 12/25/11.
//  Copyright 2011 ThickFuzz. All rights reserved.
//

#import "NITableViewDelegate.h"
#import "NITableViewModel.h"
#import "NICellFactory.h"
#import "objc/runtime.h"

@implementation NITableViewDelegate

@synthesize dataSource = _dataSource;

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
- (void)dealloc {
	self.dataSource = nil;
	[super dealloc];
}

#pragma mark -
#pragma mark UITableViewDelegate
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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

@end
