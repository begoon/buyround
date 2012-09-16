#import "DrinkItem.h"

@implementation DrinkItem

@synthesize count, name;

- (id)initWithName:(NSString *)aName andCount:(int)aCount
{
    [self setName:aName];
    [self setCount:aCount];
    return self;
}

- (void)dealloc
{
    [name release];
    [super dealloc];
}

-(void) encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeInt:count forKey:@"DrinkItemCount"];
    [encoder encodeObject:name forKey:@"DrinkItemName"];
}

-(id) initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        count = [decoder decodeIntForKey:@"DrinkItemCount"];
        name = [[decoder decodeObjectForKey:@"DrinkItemName"] copy];
    }
    return self;
}

@end
