//
//  dbConnector.m
//  dbConnectSample
//
//  Created by Kazutoshi Uetsuhara on 12/01/20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "dbConnector.h"

@implementation dbConnector


//DBへ接続する
-(id) dbConnect{
    BOOL success;
    NSError *error;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"sample.db"];
    NSLog(@"%@",writableDBPath);
    success = [fm fileExistsAtPath:writableDBPath];
    if(!success){
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"sample.db"];
        success = [fm copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
        if(!success){
            NSLog(@"%@",[error localizedDescription]);
        }
    }
    
    FMDatabase* db = [FMDatabase databaseWithPath:writableDBPath];
    return db;
}


- (NSMutableArray *)dbSelector{
    FMDatabase* db = [self dbConnect];
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        
        // SELECT
        
        NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
        
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM customer"];
        while ([rs next]) {
            
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"address",[rs stringForColumn:@"address"],@"name",[rs stringForColumn:@"name"], nil];
            
            [array addObject:dic];
            [dic release];
            
        }
        [rs close];
        [db close];
        
        return array;
        
    }else{
        NSLog(@"Could not open db.");
        return nil;
    }
    
}

- (BOOL)dbInsertor{
    FMDatabase* db = [self dbConnect];
    if ([db open]) {
        [db setShouldCacheStatements:YES];
        
        //insert
        [db beginTransaction];
        int i = 0;
        while (i++ < 20) {
            [db executeUpdate:@"INSERT INTO customer(name,address) values (?,?)" , [NSString stringWithFormat:@"にほんご%d", i],[NSString stringWithFormat:@"住所%d", i]];
            if ([db hadError]) {
                NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
            }
        }
        [db commit];
        [db close];
        
        return YES;
        
    }else{
        NSLog(@"Could not open db.");
        return NO;
    }
}





@end
