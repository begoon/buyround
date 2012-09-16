#import <Foundation/Foundation.h>

@interface DrinkItem : NSObject

@property (nonatomic) int count;
@property (copy, nonatomic) NSString* name;

- (id)initWithName:(NSString *)aName andCount:(int)aCount;

@end
