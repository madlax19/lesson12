//
//  ProductsTableViewController.h
//  CoreDataSample
//
//  Created by Sergey Zalozniy on 01/02/16.
//  Copyright © 2016 GeekHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CDBasket;

@interface ProductsTableViewController : UITableViewController

+(instancetype) instanceControllerWithBasket:(CDBasket *)basket;

@end
