//
//  ViewController.m
//  CoreDataSample
//
//  Created by Sergey Zalozniy on 01/02/16.
//  Copyright © 2016 GeekHub. All rights reserved.
//

#import "CoreDataManager.h"

#import "ProductsTableViewController.h"
#import "CDBasket.h"

#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *items;

@end

@implementation ViewController

-(void) viewDidLoad {
    [super viewDidLoad];
    [self refreshData];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewBasket:)];
}


-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

#pragma mark - Action methods

-(void) addNewBasket:(id)sender {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"New Basket" message:@"Enter name" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [controller addAction:action];
    [controller addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Basket name";
    }];
    action = [UIAlertAction actionWithTitle:@"Create" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = controller.textFields[0];
        [self createBasketWithName:textField.text];
    }];
    
    [controller addAction:action];
    [self presentViewController:controller animated:YES completion:NULL];
}


#pragma mark - Private methods

-(void) refreshData {
    self.items = [self fetchBaskets];
    [self.tableView reloadData];
}

-(NSArray *) fetchBaskets {
    NSManagedObjectContext *context = [CoreDataManager sharedInstance].managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:[[CDBasket class] description]];
    return [context executeFetchRequest:request error:nil];
}

-(void) createBasketWithName:(NSString *)name {
    NSManagedObjectContext *context = [CoreDataManager sharedInstance].managedObjectContext;
    CDBasket *basket = [NSEntityDescription insertNewObjectForEntityForName:[[CDBasket class] description]
                                              inManagedObjectContext:context];
    basket.name = name;
    [[CoreDataManager sharedInstance] saveContext];
    [self refreshData];
}

#pragma mark - Delegated methods

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductsTableViewController *controller = [ProductsTableViewController instanceControllerWithBasket:self.items[indexPath.row]];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - UITableViewDataSource Delegated methods

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.items count];
}


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    CDBasket *basket = self.items[indexPath.row];
    cell.textLabel.text = basket.name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

@end
