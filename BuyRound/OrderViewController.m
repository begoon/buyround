#import "OrderViewController.h"
#import "DrinkItem.h"
#import "Inventory.h"

@interface OrderViewController ()

@end

@implementation OrderViewController

@synthesize orderTableView;
@synthesize inventoryViewController;

Inventory* inventory;
UIAlertView *confirmOrderCleanupAlertView;

- (id)initWithInventory:(Inventory *)anInventory 
{
    [self initWithNibName:@"OrderViewController" bundle:nil];
    if (self) {
        [anInventory retain];
        inventory = anInventory;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Order", @"Second");
        self.tabBarItem.image = [UIImage imageNamed:@"shopping-cart-icon"];
    }

    confirmOrderCleanupAlertView = 
        [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Are you sure to clean the order?", @"") 
                                   message:nil delegate:self 
                         cancelButtonTitle:@"No" 
                         otherButtonTitles:NSLocalizedString(@"Yes", @""), nil];
    [confirmOrderCleanupAlertView setAlertViewStyle:UIAlertViewStyleDefault];

    [self refresh];
    return self;
}

- (void)dealloc
{
    [confirmOrderCleanupAlertView release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self refresh];
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

- (IBAction)cleanTheOrder:(id)sender
{
    [confirmOrderCleanupAlertView show];
}

- (void)reallyCleanTheOrder
{
    while ([inventory countOfNonEmptyItems] > 0)
        [inventory zeroCountForNonEmptyItemAtIndex:0];
    [self refresh];
    [inventoryViewController refresh];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    if (buttonIndex == 1) {
        [self reallyCleanTheOrder];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [inventory countOfNonEmptyItems];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"itemCell"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"itemCell"] autorelease];
    }
    DrinkItem* item = [inventory nonEmptyItemAtIndex:[indexPath row]];
    [cell.textLabel setText:item.name];
    NSString* counter = item.count > 0 ? [NSString stringWithFormat:@"%d", item.count] : @"";
    [cell.detailTextLabel setText:counter];
    return cell;
}

- (void)refresh
{
    int count = [inventory sumOfCounters];
    self.tabBarItem.badgeValue = count > 0 ? [NSString stringWithFormat:@"%d", count] : nil;
    [orderTableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [inventory decrementCountForNonEmptyItemAtIndex:indexPath.row];
    [self refresh];
    [inventoryViewController refresh];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView beginUpdates];    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [inventory zeroCountForNonEmptyItemAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:YES];      
    }       
    [tableView endUpdates];
    [self refresh];
    [inventoryViewController refresh];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [inventory alphabet];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title 
               atIndex:(NSInteger)index {
    return 0;
}

@end
