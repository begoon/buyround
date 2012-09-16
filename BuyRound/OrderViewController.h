#import <UIKit/UIKit.h>

@class InventoryViewController;
@class Inventory;

@interface OrderViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) IBOutlet UITableView* orderTableView;

@property (nonatomic, assign) InventoryViewController* inventoryViewController;

- (id)initWithInventory:(Inventory *)anInventory;
- (void)refresh;

@end
