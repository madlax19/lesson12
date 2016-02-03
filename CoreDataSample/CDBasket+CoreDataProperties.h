//
//  CDBasket+CoreDataProperties.h
//  CoreDataSample
//
//  Created by Sergey Zalozniy on 01/02/16.
//  Copyright © 2016 GeekHub. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDBasket.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDBasket (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSDate *sheduleDate;
@property (nullable, nonatomic, retain) NSSet<CDProduct *> *products;

@end

@interface CDBasket (CoreDataGeneratedAccessors)

- (void)addProductsObject:(CDProduct *)value;
- (void)removeProductsObject:(CDProduct *)value;
- (void)addProducts:(NSSet<CDProduct *> *)values;
- (void)removeProducts:(NSSet<CDProduct *> *)values;

@end

NS_ASSUME_NONNULL_END
