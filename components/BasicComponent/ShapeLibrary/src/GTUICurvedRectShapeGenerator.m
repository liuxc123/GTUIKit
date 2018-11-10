//
//  GTUICurvedRectShapeGenerator.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/7.
//

#import "GTUICurvedRectShapeGenerator.h"

#import "GTUICurvedCornerTreatment.h"

static NSString *const GTUICurvedRectShapeGeneratorCornerSizeKey =
@"GTUICurvedRectShapeGeneratorCornerSizeKey";

@implementation GTUICurvedRectShapeGenerator {
    GTUIRectangleShapeGenerator *_rectGenerator;
    GTUICurvedCornerTreatment *_widthHeightCorner;
    GTUICurvedCornerTreatment *_heightWidthCorner;
}

- (instancetype)init {
    return [self initWithCornerSize:CGSizeMake(0, 0)];
}

- (instancetype)initWithCornerSize:(CGSize)cornerSize {
    if (self = [super init]) {
        [self commonInit];

        self.cornerSize = cornerSize;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        [self commonInit];

        self.cornerSize = [aDecoder decodeCGSizeForKey:GTUICurvedRectShapeGeneratorCornerSizeKey];
    }
    return self;
}

- (void)commonInit {
    _rectGenerator = [[GTUIRectangleShapeGenerator alloc] init];

    _widthHeightCorner = [[GTUICurvedCornerTreatment alloc] init];
    _heightWidthCorner = [[GTUICurvedCornerTreatment alloc] init];

    _rectGenerator.topLeftCorner = _widthHeightCorner;
    _rectGenerator.topRightCorner = _heightWidthCorner;
    _rectGenerator.bottomRightCorner = _widthHeightCorner;
    _rectGenerator.bottomLeftCorner = _heightWidthCorner;
}

- (void)setCornerSize:(CGSize)cornerSize {
    _cornerSize = cornerSize;

    _widthHeightCorner.size = _cornerSize;
    _heightWidthCorner.size = CGSizeMake(cornerSize.height, cornerSize.width);
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeCGSize:_cornerSize forKey:GTUICurvedRectShapeGeneratorCornerSizeKey];
}

- (id)copyWithZone:(nullable NSZone *)__unused zone {
    GTUICurvedRectShapeGenerator *copy = [[[self class] alloc] init];
    copy.cornerSize = self.cornerSize;
    return copy;
}

- (CGPathRef)pathForSize:(CGSize)size {
    return [_rectGenerator pathForSize:size];
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end

