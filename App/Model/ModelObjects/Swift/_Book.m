



@interface _Book()

@end

/** \ingroup DataModel */

@implementation _Book

+ (NSSet *)dictionaryRepresentationKeys
{
    NSMutableSet *set = [NSMutableSet setWithSet:[super dictionaryRepresentationKeys]];
    
    
      [set addObject:kModelPropertyBookAuthor];
    
      [set addObject:kModelPropertyBookBlurb];
    
      [set addObject:kModelPropertyBookPrice];
    
      [set addObject:kModelPropertyBookTitle];
    
    
    
    return [NSSet setWithSet:set];
}

- (id)init
{
    if((self = [super init]))
    {
        
        
        
        
        
    }
    
    return self;
}

- (id) initWithCoder: (NSCoder*) aDecoder
{
    if ([[super class] instancesRespondToSelector: @selector(initWithCoder:)]) {
        self = [super initWithCoder: aDecoder];
    } else {
        self = [super init];
    }
    if (self) {
        
        self.author = [aDecoder decodeObjectOfClass:[NSString class] forKey:kModelPropertyBookAuthor];
        
        self.blurb = [aDecoder decodeObjectOfClass:[NSString class] forKey:kModelPropertyBookBlurb];
        
        self.price = [aDecoder decodeObjectOfClass:[NSString class] forKey:kModelPropertyBookPrice];
        
        self.title = [aDecoder decodeObjectOfClass:[NSString class] forKey:kModelPropertyBookTitle];
        
        
    }
    return self;
}

- (void) encodeWithCoder: (NSCoder*) aCoder
{
    [super encodeWithCoder: aCoder];
    
    [aCoder encodeObject: self.author forKey: kModelPropertyBookAuthor];
    
    [aCoder encodeObject: self.blurb forKey: kModelPropertyBookBlurb];
    
    [aCoder encodeObject: self.price forKey: kModelPropertyBookPrice];
    
    [aCoder encodeObject: self.title forKey: kModelPropertyBookTitle];
    
}

#pragma mark Dictionary representation

- (id)initWithDictionaryRepresentation:(NSDictionary *)dictionary
{
    if((self = [super initWithDictionaryRepresentation:dictionary]))
    {
        
        self.author = [dictionary objectForKey:kModelPropertyBookAuthor];
        
        self.blurb = [dictionary objectForKey:kModelPropertyBookBlurb];
        
        self.price = [dictionary objectForKey:kModelPropertyBookPrice];
        
        self.title = [dictionary objectForKey:kModelPropertyBookTitle];
        
        
    }
    
    return self;
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentation]];
    
    [dict setObjectIfNotNil:self.author forKey:kModelPropertyBookAuthor];
    
    [dict setObjectIfNotNil:self.blurb forKey:kModelPropertyBookBlurb];
    
    [dict setObjectIfNotNil:self.price forKey:kModelPropertyBookPrice];
    
    [dict setObjectIfNotNil:self.title forKey:kModelPropertyBookTitle];
    
    
    return dict;
}

#pragma mark Direct access









//scalar setter and getter support


















#pragma mark Synthesizes


@synthesize author;

@synthesize blurb;

@synthesize price;

@synthesize title;



+ (BOOL)supportsSecureCoding
{
    return YES;
}

@end
