#import "Inventory.h"

#import "DrinkItem.h"

@implementation Inventory

NSMutableArray *items;

- (id)init
{
    [self load];
    if (items == nil)
        items = [[NSMutableArray alloc] init];
    if ([items count] < 1) {
        NSString* drinks[] = {
            @"Magners", @"Bulmers", @"Corona", @"Stella",
            @"Carling", @"London Pride", @"IPO", @"Bombardier",
            @"Doom Bar", @"Strongbow",
            @"Coke", @"Orange juice",
            0
        };
        for (NSString** p = &drinks[0]; *p; ++p) {
            [self createItemWithName:*p];
        }
    } else {
        NSLog(@"Loaded %d items", [items count]);
        for (DrinkItem* item in items) {
            NSLog(@"%@, %d", item.name, item.count);
        }
    }

    return self;
}

- (void)dealloc
{
    for (DrinkItem* item in items)
        [item release];
    [items removeAllObjects];
    [items release];
    [super dealloc];
}

NSString* const InventoryStorage = @"Drinks";

NSString *pathInDocumentDirectory(NSString *fileName) {
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:fileName];
}

- (void)saveBinary
{
    NSString* filename = pathInDocumentDirectory(InventoryStorage);
    NSLog(@"Saving to %@", filename);
    
    if ([NSKeyedArchiver archiveRootObject:items toFile:filename] == FALSE) {
        NSLog(@"Unable to archive inventory to file %@", filename);
        return;
    }
}

- (void)save
{
    NSString* filename = pathInDocumentDirectory(InventoryStorage);
    NSLog(@"Saving to %@", filename);

    NSMutableData *data = [NSMutableData new];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver setOutputFormat:NSPropertyListXMLFormat_v1_0];
    
    // This cannot be used because it doesn't write the "root" item (a bug).
    // [archiver encodeRootObject:items];
    
    [archiver encodeObject:items forKey:@"root"];
    [archiver finishEncoding];
    
    [data writeToFile:filename atomically:YES];
    
    [archiver release];
    [data release];
}

- (void)load
{
    NSString* filename = pathInDocumentDirectory(InventoryStorage);
    NSLog(@"Loading from %@", filename);
    
    items = [[NSKeyedUnarchiver unarchiveObjectWithFile:filename] mutableCopy];
    if (items == nil) {
        NSLog(@"Unable to read inventory from file %@", filename);
        return;
    }
    
    NSLog(@"Loaded %@ items", items);
    for (DrinkItem* item in items) {
        NSLog(@"%@, %d", item.name, item.count);
    }
    [self sortItems];
}

- (int)countOfItems
{
    return items.count;
}

- (int)countOfNonEmptyItems
{
    int count = 0;
    for (DrinkItem* item in items) {
        if (item.count > 0) {
            count += 1;
        }
    }
    return count;
}

- (DrinkItem *)itemAtIndex:(int)index
{
    return [items objectAtIndex:index];
}

- (DrinkItem *)nonEmptyItemAtIndex:(int)index
{
    int i = -1;
    for (DrinkItem* item in items) {
        if (item.count > 0) {
            i += 1;
            if (i == index)
                return item;
        }
    }
    return nil;
}

- (void)sortItems
{
    for (int i = 1; i < items.count; ++i) {
        DrinkItem* v = [items objectAtIndex:i];
        int j = i - 1;
        while (j >= 0 && [[[items objectAtIndex:j] name] compare:v.name] == NSOrderedDescending) {
            [items replaceObjectAtIndex:j+1 withObject:[items objectAtIndex:j]];
            j -= 1;
        }
        [items replaceObjectAtIndex:j+1 withObject:v];
    }
}

- (void)createItemWithName:(NSString *)name
{
    for (DrinkItem* item in items) {
        if ([[item name] isEqualToString:name]) {
            item.count += 1;
            return;
        }
    }
    [items addObject:[[[DrinkItem alloc] initWithName:name andCount:0] autorelease]];
    [self sortItems];
}

- (void)removeItemAtIndex:(int)index
{
    [items removeObjectAtIndex:index];
    [self sortItems];
}

- (void)incrementCountForItemAtIndex:(int)index
{
    DrinkItem* item = [items objectAtIndex:index];
    item.count += 1;
}

- (void)decrementCountForNonEmptyItemAtIndex:(int)index
{
    DrinkItem* item = [self nonEmptyItemAtIndex:index];
    if (item.count > 0)
        item.count -= 1;
}
    
- (void)zeroCountForNonEmptyItemAtIndex:(int)index 
{
    DrinkItem* item = [self nonEmptyItemAtIndex:index];
    item.count = 0;
}

- (int)sumOfCounters
{
    int count = 0;
    for (DrinkItem* item in items) {
        count += item.count;
    }
    return count;
}

- (NSArray*)alphabet
{
    NSMutableArray* letters = [[[NSMutableArray alloc] init] autorelease];
    for (DrinkItem* item in items) {
        NSString* name = item.name;
        unichar ch = [name characterAtIndex:0];
        NSString* charString = [[NSString stringWithCharacters:&ch length:1] uppercaseString];
        bool found = NO;
        for (NSString* added in letters) {
            if ([added isEqualToString:charString]) {
                found = YES;
                break;
            }
        }
        if (!found)
            [letters addObject:charString];
    }
    return letters;
}

- (int)itemPosition:(NSString *)name {
    for (int i = 0; i < items.count; ++i) {
        if ([[[items objectAtIndex:i] name] isEqualToString:name])
            return i;
    }
    return -1;
}

@end
