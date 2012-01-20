//
//  dbConnector.h
//  dbConnectSample
//
//  Created by Kazutoshi Uetsuhara on 12/01/20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

@interface dbConnector : NSObject

- (NSArray *)dbSelector;
- (BOOL)dbInsertor;

@end
