#import <UIKit/UIKit.h>

@class OrderViewController;
@class Inventory;

@interface InventoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, assign) IBOutlet UITableView* drinksTableView;

@property (nonatomic, assign) OrderViewController* orderViewController;

- (id)initWithInventory:(Inventory *)anInventory;
- (void)refresh;

@end
