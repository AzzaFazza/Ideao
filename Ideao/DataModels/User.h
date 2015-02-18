//
//  User.h
//  Ideao
//
//  Created by Adam Fallon on 18/02/2015.
//  Copyright (c) 2015 com.adamf.ideao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * authToken;
@property (nonatomic, retain) NSString * authTokenSecret;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSString * userID;

@end
