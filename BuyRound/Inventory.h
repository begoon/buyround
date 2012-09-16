#import <Foundation/Foundation.h>

@class DrinkItem;

@interface Inventory : NSObject

- (id)init;

- (int)countOfItems;
- (int)countOfNonEmptyItems;

- (DrinkItem *)itemAtIndex:(int)index;
- (DrinkItem *)nonEmptyItemAtIndex:(int)index;

- (void)createItemWithName:(NSString *)name;
- (void)removeItemAtIndex:(int)index;

- (void)incrementCountForItemAtIndex:(int)index;
- (void)decrementCountForNonEmptyItemAtIndex:(int)index;
- (void)zeroCountForNonEmptyItemAtIndex:(int)index;

- (int)itemPosition:(NSString *)name;

- (int)sumOfCounters;

- (void)save;

- (NSArray*)alphabet;

@end
