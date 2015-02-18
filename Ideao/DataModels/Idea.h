//
//  Idea.h
//  Ideao
//
//  Created by Adam Fallon on 18/02/2015.
//  Copyright (c) 2015 com.adamf.ideao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Idea : NSManagedObject

@property (nonatomic, retain) NSString * ideaName;
@property (nonatomic, retain) NSString * ideaDescription;
@property (nonatomic, retain) NSString * ideaImage;
@property (nonatomic, retain) NSData * ideaTags;

@end
