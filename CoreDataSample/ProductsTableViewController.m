//
//  ProductsTableViewController.m
//  CoreDataSample
//
//  Created by Sergey Zalozniy on 01/02/16.
//  Copyright © 2016 GeekHub. All rights reserved.
//

#import "CoreDataManager.h"

#import "CDBasket.h"
#import "CDProduct.h"

#import "ProductsTableViewController.h"

@interface ProductsTableViewController () <UITableViewDelegate>

@property (strong, nonatomic) NSArray *items;
@property (nonatomic, strong) CDBasket *basket;

@end

@implementation ProductsTableViewController

#pragma mark - Instance initialization

+(instancetype) instanceControllerWithBasket:(CDBasket *)basket {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ProductsTableViewController *controller = [sb instantiateViewControllerWithIdentifier:@"ProductsTableViewControllerIdentifier"];
    controller.basket = basket;
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchProducts];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewProduct:)];
    [self refreshData];
}

#pragma mark - Private methods

-(void) refreshData {
    self.items = [self fetchProducts];
    [self.tableView reloadData];
}


-(void) addNewProduct:(id)sender {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"New Basket" message:@"Enter name" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [controller addAction:action];
    [controller addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Basket name";
    }];
    action = [UIAlertAction actionWithTitle:@"Create" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = controller.textFields[0];
        [self createProductWithName:textField.text];
    }];
    
    [controller addAction:action];
    [self presentViewController:controller animated:YES completion:NULL];
}


-(void) createProductWithName:(NSString *)name {
    NSManagedObjectContext *context = [CoreDataManager sharedInstance].managedObjectContext;
    CDProduct *product = [NSEntityDescription insertNewObjectForEntityForName:[[CDProduct class] description]
                                                     inManagedObjectContext:context];
    product.name = name;
    [self.basket addProductsObject:product];
    [[CoreDataManager sharedInstance] saveContext];
    [self refreshData];
}


-(NSArray *) fetchProducts {
    NSManagedObjectContext *context = [CoreDataManager sharedInstance].managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:[[CDProduct class] description]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"basket = %@", self.basket.objectID];
    request.predicate = predicate;
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = @[sortDescriptor];
    return [context executeFetchRequest:request error:nil];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CDProduct *product = self.items[indexPath.row];
    if ([product.complete boolValue]) {
        product.complete = @NO;
    } else {
        product.complete = @YES;
    }
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.items count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    CDProduct *product = self.items[indexPath.row];
    cell.textLabel.text = product.name;
    if ([product.complete boolValue]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        CDProduct *product = self.items[indexPath.row];
        [[CoreDataManager sharedInstance].managedObjectContext deleteObject:product];
        NSMutableArray *items = [self.items mutableCopy];
        [items removeObject:product];
        self.items = [items copy];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
