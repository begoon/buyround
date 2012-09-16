#import <Foundation/Foundation.h>
#import "InventoryViewController.h"
#import "OrderViewController.h"
#import "Inventory.h"
#import "DrinkItem.h"

@implementation InventoryViewController

UIAlertView *newDrinkAlertView;

@synthesize drinksTableView;
@synthesize orderViewController;

Inventory* inventory;

- (id)initWithInventory:(Inventory *)anInventory 
{
    self = [self initWithNibName:@"InventoryViewController" bundle:nil];
    if (self) {
        [anInventory retain];
        inventory = anInventory;
    }
    return self;
}

- (void)dealloc
{
    [newDrinkAlertView release];
    [inventory release];
    [super dealloc];
}

- (void)setInventory:(Inventory *)anInventory
{
    inventory = anInventory;
}

- (IBAction)addItem:(id)sender
{
    [[newDrinkAlertView textFieldAtIndex:0] setText:@""];
    [newDrinkAlertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    NSString* text = [[alertView textFieldAtIndex:0] text];
    if ([text length] < 1 || buttonIndex == 0) { 
        return;
    }
    if (buttonIndex == 1) {
        [self newDrinkTextFieldEntered:text];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [newDrinkAlertView dismissWithClickedButtonIndex:0 animated:YES];
    [self newDrinkTextFieldEntered:[textField text]];
    return YES;
}

- (void)refresh
{
    [drinksTableView reloadData];
}

- (void)newDrinkTextFieldEntered:(NSString*)drinkName
{
    if ([drinkName length] < 1) return;
    NSLog(@"New drink: %@", drinkName);
    [inventory createItemWithName:drinkName];
    [self refresh];
    [orderViewController refresh];
    int const newItemIndex = [inventory itemPosition:drinkName];
    [drinksTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:newItemIndex - 1 inSection:0]
                           atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Inventory", @"Inventory");
        self.tabBarItem.image = [UIImage imageNamed:@"beer-icon"];
        
        newDrinkAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Enter new drink", @"") 
                                                       message:nil delegate:self 
                                             cancelButtonTitle:@"Cancel" 
                                             otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
        [newDrinkAlertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [[newDrinkAlertView textFieldAtIndex:0] setAutocapitalizationType:UITextAutocapitalizationTypeWords];
        [[newDrinkAlertView textFieldAtIndex:0] setAutocorrectionType:UITextAutocorrectionTypeYes];
        [[newDrinkAlertView textFieldAtIndex:0] setDelegate:self];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [inventory countOfItems];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"itemCell"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"itemCell"] autorelease];
    }
    DrinkItem* item = [inventory itemAtIndex:indexPath.row];
    [item retain];
    [cell.textLabel setText:item.name];
    NSString* count = item.count > 0 ? [NSString stringWithFormat:@"%d", item.count] : @"";
    [cell.detailTextLabel setText:count];
    [item release];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [inventory incrementCountForItemAtIndex:indexPath.row];
    [self refresh];
    [orderViewController refresh];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Item to delete from inventory: %d, [%@]", indexPath.row, [[inventory itemAtIndex:indexPath.row] name]);
    [tableView beginUpdates];    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [inventory removeItemAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:YES];      
    }       
    [tableView endUpdates];
    [self refresh];
    [orderViewController refresh];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [inventory alphabet];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title 
               atIndex:(NSInteger)index {
    return 0;
}
@end
