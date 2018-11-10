//
//  GTUIRectangleShapeGenerator.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/7.
//

#import "GTUIRectangleShapeGenerator.h"

#import "GTUICornerTreatment.h"
#import "GTUIEdgeTreatment.h"
#import "GTUIPathGenerator.h"
#import "GTMath.h"

static NSString *const GTUIRectangleShapeGeneratorTopLeftCornerKey =
@"GTUIRectangleShapeGeneratorTopLeftCornerKey";
static NSString *const GTUIRectangleShapeGeneratorTopRightCornerKey =
@"GTUIRectangleShapeGeneratorTopRightCornerKey";
static NSString *const GTUIRectangleShapeGeneratorBottomRightCornerKey =
@"GTUIRectangleShapeGeneratorBottomRightCornerKey";
static NSString *const GTUIRectangleShapeGeneratorBottomLeftCornerKey =
@"GTUIRectangleShapeGeneratorBottomLeftCornerKey";

static NSString *const GTUIRectangleShapeGeneratorTopLeftCornerOffsetKey =
@"GTUIRectangleShapeGeneratorTopLeftCornerOffsetKey";
static NSString *const GTUIRectangleShapeGeneratorTopRightCornerOffsetKey =
@"GTUIRectangleShapeGeneratorTopRightCornerOffsetKey";
static NSString *const GTUIRectangleShapeGeneratorBottomRightCornerOffsetKey =
@"GTUIRectangleShapeGeneratorBottomRightCornerOffsetKey";
static NSString *const GTUIRectangleShapeGeneratorBottomLeftCornerOffsetKey =
@"GTUIRectangleShapeGeneratorBottomLeftCornerOffsetKey";

static NSString *const GTUIRectangleShapeGeneratorTopEdgeKey =
@"GTUIRectangleShapeGeneratorTopEdgeKey";
static NSString *const GTUIRectangleShapeGeneratorRightEdgeKey =
@"GTUIRectangleShapeGeneratorRightEdgeKey";
static NSString *const GTUIRectangleShapeGeneratorBottomEdgeKey =
@"GTUIRectangleShapeGeneratorBottomEdgeKey";
static NSString *const GTUIRectangleShapeGeneratorLeftEdgeKey =
@"GTUIRectangleShapeGeneratorLeftEdgeKey";

static inline CGFloat CGPointDistanceToPoint(CGPoint a, CGPoint b) {
    return GTUIHypot(a.x - b.x, a.y - b.y);
}

// Edges in clockwise order
typedef enum : NSUInteger {
    GTUIShapeEdgeTop = 0,
    GTUIShapeEdgeRight,
    GTUIShapeEdgeBottom,
    GTUIShapeEdgeLeft,
} GTUIShapeEdgePosition;

// Corners in clockwise order
typedef enum : NSUInteger {
    GTUIShapeCornerTopLeft = 0,
    GTUIShapeCornerTopRight,
    GTUIShapeCornerBottomRight,
    GTUIShapeCornerBottomLeft,
} GTUIShapeCornerPosition;

@implementation GTUIRectangleShapeGenerator

- (instancetype)init {
    if (self = [super init]) {
        [self setEdges:[[GTUIEdgeTreatment alloc] init]];
        [self setCorners:[[GTUICornerTreatment alloc] init]];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.topLeftCorner =
        [aDecoder decodeObjectOfClass:[GTUICornerTreatment class]
                               forKey:GTUIRectangleShapeGeneratorTopLeftCornerKey];
        self.topRightCorner =
        [aDecoder decodeObjectOfClass:[GTUICornerTreatment class]
                               forKey:GTUIRectangleShapeGeneratorTopRightCornerKey];
        self.bottomRightCorner =
        [aDecoder decodeObjectOfClass:[GTUICornerTreatment class]
                               forKey:GTUIRectangleShapeGeneratorBottomRightCornerKey];
        self.bottomLeftCorner =
        [aDecoder decodeObjectOfClass:[GTUICornerTreatment class]
                               forKey:GTUIRectangleShapeGeneratorBottomLeftCornerKey];

        self.topLeftCornerOffset =
        [aDecoder decodeCGPointForKey:GTUIRectangleShapeGeneratorTopLeftCornerOffsetKey];
        self.topRightCornerOffset =
        [aDecoder decodeCGPointForKey:GTUIRectangleShapeGeneratorTopRightCornerOffsetKey];
        self.bottomRightCornerOffset =
        [aDecoder decodeCGPointForKey:GTUIRectangleShapeGeneratorBottomRightCornerOffsetKey];
        self.bottomLeftCornerOffset =
        [aDecoder decodeCGPointForKey:GTUIRectangleShapeGeneratorBottomLeftCornerOffsetKey];

        self.topEdge = [aDecoder decodeObjectOfClass:[GTUIEdgeTreatment class]
                                              forKey:GTUIRectangleShapeGeneratorTopEdgeKey];
        self.rightEdge = [aDecoder decodeObjectOfClass:[GTUIEdgeTreatment class]
                                                forKey:GTUIRectangleShapeGeneratorRightEdgeKey];
        self.bottomEdge = [aDecoder decodeObjectOfClass:[GTUIEdgeTreatment class]
                                                 forKey:GTUIRectangleShapeGeneratorBottomEdgeKey];
        self.leftEdge = [aDecoder decodeObjectOfClass:[GTUIEdgeTreatment class]
                                               forKey:GTUIRectangleShapeGeneratorLeftEdgeKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.topLeftCorner
                  forKey:GTUIRectangleShapeGeneratorTopLeftCornerKey];
    [aCoder encodeObject:self.topRightCorner
                  forKey:GTUIRectangleShapeGeneratorTopRightCornerKey];
    [aCoder encodeObject:self.bottomRightCorner
                  forKey:GTUIRectangleShapeGeneratorBottomRightCornerKey];
    [aCoder encodeObject:self.bottomLeftCorner
                  forKey:GTUIRectangleShapeGeneratorBottomLeftCornerKey];

    [aCoder encodeCGPoint:self.topLeftCornerOffset
                   forKey:GTUIRectangleShapeGeneratorTopLeftCornerOffsetKey];
    [aCoder encodeCGPoint:self.topRightCornerOffset
                   forKey:GTUIRectangleShapeGeneratorTopRightCornerOffsetKey];
    [aCoder encodeCGPoint:self.bottomRightCornerOffset
                   forKey:GTUIRectangleShapeGeneratorBottomRightCornerOffsetKey];
    [aCoder encodeCGPoint:self.bottomLeftCornerOffset
                   forKey:GTUIRectangleShapeGeneratorBottomLeftCornerOffsetKey];

    [aCoder encodeObject:self.topEdge forKey:GTUIRectangleShapeGeneratorTopEdgeKey];
    [aCoder encodeObject:self.rightEdge forKey:GTUIRectangleShapeGeneratorRightEdgeKey];
    [aCoder encodeObject:self.bottomEdge forKey:GTUIRectangleShapeGeneratorBottomEdgeKey];
    [aCoder encodeObject:self.leftEdge forKey:GTUIRectangleShapeGeneratorLeftEdgeKey];
}

- (id)copyWithZone:(NSZone *)zone {
    GTUIRectangleShapeGenerator *copy = [[[self class] alloc] init];

    copy.topLeftCorner = [copy.topLeftCorner copyWithZone:zone];
    copy.topRightCorner = [copy.topRightCorner copyWithZone:zone];
    copy.bottomRightCorner = [copy.bottomRightCorner copyWithZone:zone];
    copy.bottomLeftCorner = [copy.bottomLeftCorner copyWithZone:zone];

    copy.topLeftCornerOffset = copy.topLeftCornerOffset;
    copy.topRightCornerOffset = copy.topRightCornerOffset;
    copy.bottomRightCornerOffset = copy.bottomRightCornerOffset;
    copy.bottomLeftCornerOffset = copy.bottomLeftCornerOffset;

    copy.topEdge = [copy.topEdge copyWithZone:zone];
    copy.rightEdge = [copy.rightEdge copyWithZone:zone];
    copy.bottomEdge = [copy.bottomEdge copyWithZone:zone];
    copy.leftEdge = [copy.leftEdge copyWithZone:zone];

    return copy;
}

- (void)setCorners:(GTUICornerTreatment *)cornerShape {
    self.topLeftCorner = [cornerShape copy];
    self.topRightCorner = [cornerShape copy];
    self.bottomRightCorner = [cornerShape copy];
    self.bottomLeftCorner = [cornerShape copy];
}

- (void)setEdges:(GTUIEdgeTreatment *)edgeShape {
    self.topEdge = [edgeShape copy];
    self.rightEdge = [edgeShape copy];
    self.bottomEdge = [edgeShape copy];
    self.leftEdge = [edgeShape copy];
}

- (GTUICornerTreatment *)cornerTreatmentForPosition:(GTUIShapeCornerPosition)position {
    switch (position) {
        case GTUIShapeCornerTopLeft:
            return self.topLeftCorner;
        case GTUIShapeCornerTopRight:
            return self.topRightCorner;
        case GTUIShapeCornerBottomLeft:
            return self.bottomLeftCorner;
        case GTUIShapeCornerBottomRight:
            return self.bottomRightCorner;
    }
}

- (CGPoint)cornerOffsetForPosition:(GTUIShapeCornerPosition)position {
    switch (position) {
        case GTUIShapeCornerTopLeft:
            return self.topLeftCornerOffset;
        case GTUIShapeCornerTopRight:
            return self.topRightCornerOffset;
        case GTUIShapeCornerBottomLeft:
            return self.bottomLeftCornerOffset;
        case GTUIShapeCornerBottomRight:
            return self.bottomRightCornerOffset;
    }
}

- (GTUIEdgeTreatment *)edgeTreatmentForPosition:(GTUIShapeEdgePosition)position {
    switch (position) {
        case GTUIShapeEdgeTop:
            return self.topEdge;
        case GTUIShapeEdgeLeft:
            return self.leftEdge;
        case GTUIShapeEdgeRight:
            return self.rightEdge;
        case GTUIShapeEdgeBottom:
            return self.bottomEdge;
    }
}

- (CGPathRef)pathForSize:(CGSize)size {
    CGMutablePathRef path = CGPathCreateMutable();
    GTUIPathGenerator *cornerPaths[4];
    CGAffineTransform cornerTransforms[4];
    CGAffineTransform edgeTransforms[4];
    CGFloat edgeAngles[4];
    CGFloat edgeLengths[4];

    // Start by getting the path of each corner and calculating edge angles.
    for (NSInteger i = 0; i < 4; i++) {
        GTUICornerTreatment *cornerShape = [self cornerTreatmentForPosition:i];
        CGFloat cornerAngle = [self angleOfCorner:i forViewSize:size];
        if (cornerShape.valueType == GTUICornerTreatmentValueTypeAbsolute) {
            cornerPaths[i] = [cornerShape pathGeneratorForCornerWithAngle:cornerAngle];
        } else if (cornerShape.valueType == GTUICornerTreatmentValueTypePercentage) {
            cornerPaths[i] = [cornerShape pathGeneratorForCornerWithAngle:cornerAngle forViewSize:size];
        }
        edgeAngles[i] = [self angleOfEdge:i forViewSize:size];
    }

    // Create transformation matrices for each corner and edge
    for (NSInteger i = 0; i < 4; i++) {
        CGPoint cornerCoords = [self cornerCoordsForPosition:i forViewSize:size];
        CGAffineTransform cornerTransform = CGAffineTransformMakeTranslation(cornerCoords.x,
                                                                             cornerCoords.y);
        CGFloat prevEdgeAngle = edgeAngles[(i + 4 - 1) % 4];
        // We add 90 degrees (M_PI_2) here because the corner starts rotated from the edge.
        cornerTransform = CGAffineTransformRotate(cornerTransform, prevEdgeAngle + (CGFloat)M_PI_2);
        cornerTransforms[i] = cornerTransform;

        CGPoint edgeStartPoint = CGPointApplyAffineTransform(cornerPaths[i].endPoint,
                                                             cornerTransforms[i]);
        CGAffineTransform edgeTransform = CGAffineTransformMakeTranslation(edgeStartPoint.x,
                                                                           edgeStartPoint.y);
        CGFloat edgeAngle = edgeAngles[i];
        edgeTransform = CGAffineTransformRotate(edgeTransform, edgeAngle);
        edgeTransforms[i] = edgeTransform;
    }

    // Calculate the length of each edge using the transformed corner paths.
    for (NSInteger i = 0; i < 4; i++) {
        NSInteger next = (i + 1) % 4;
        CGPoint edgeStartPoint = CGPointApplyAffineTransform(cornerPaths[i].endPoint,
                                                             cornerTransforms[i]);
        CGPoint edgeEndPoint = CGPointApplyAffineTransform(cornerPaths[next].startPoint,
                                                           cornerTransforms[next]);
        edgeLengths[i] = CGPointDistanceToPoint(edgeStartPoint, edgeEndPoint);
    }

    // Draw the first corner manually because we have to MoveToPoint to start the path.
    CGPathMoveToPoint(path,
                      &cornerTransforms[0],
                      cornerPaths[0].startPoint.x,
                      cornerPaths[0].startPoint.y);
    [cornerPaths[0] appendToCGPath:path transform:&cornerTransforms[0]];

    // Draw the remaining three corners joined by edges.
    for (NSInteger i = 1; i < 4; i++) {
        // draw the edge from the previous point to the current point
        GTUIEdgeTreatment *edge = [self edgeTreatmentForPosition:(i - 1)];
        GTUIPathGenerator *edgePath = [edge pathGeneratorForEdgeWithLength:edgeLengths[i - 1]];
        [edgePath appendToCGPath:path transform:&edgeTransforms[i - 1]];

        GTUIPathGenerator *cornerPath = cornerPaths[i];
        [cornerPath appendToCGPath:path transform:&cornerTransforms[i]];
    }

    // Draw final edge back to first point.
    GTUIEdgeTreatment *edge = [self edgeTreatmentForPosition:3];
    GTUIPathGenerator *edgePath = [edge pathGeneratorForEdgeWithLength:edgeLengths[3]];
    [edgePath appendToCGPath:path transform:&edgeTransforms[3]];

    CGPathCloseSubpath(path);

    return path;
}

- (CGFloat)angleOfCorner:(GTUIShapeCornerPosition)cornerPosition forViewSize:(CGSize)size {
    CGPoint prevCornerCoord = [self cornerCoordsForPosition:(cornerPosition - 1 + 4) % 4
                                                forViewSize:size];
    CGPoint nextCornerCoord = [self cornerCoordsForPosition:(cornerPosition + 1) % 4
                                                forViewSize:size];
    CGPoint cornerCoord = [self cornerCoordsForPosition:cornerPosition forViewSize:size];
    CGPoint prevVector = CGPointMake(prevCornerCoord.x - cornerCoord.x,
                                     prevCornerCoord.y - cornerCoord.y);
    CGPoint nextVector = CGPointMake(nextCornerCoord.x - cornerCoord.x,
                                     nextCornerCoord.y - cornerCoord.y);
    CGFloat prevAngle = GTUIAtan2(prevVector.y, prevVector.x);
    CGFloat nextAngle = GTUIAtan2(nextVector.y, nextVector.x);
    CGFloat angle = prevAngle - nextAngle;
    if (angle < 0) angle += 2 * M_PI;
    return angle;
}

- (CGFloat)angleOfEdge:(GTUIShapeEdgePosition)edgePosition forViewSize:(CGSize)size {
    GTUIShapeCornerPosition startCornerPosition = (GTUIShapeCornerPosition)edgePosition;
    GTUIShapeCornerPosition endCornerPosition = (startCornerPosition + 1) % 4;
    CGPoint startCornerCoord = [self cornerCoordsForPosition:startCornerPosition forViewSize:size];
    CGPoint endCornerCoord = [self cornerCoordsForPosition:endCornerPosition forViewSize:size];

    CGPoint edgeVector = CGPointMake(endCornerCoord.x - startCornerCoord.x,
                                     endCornerCoord.y - startCornerCoord.y);
    return GTUIAtan2(edgeVector.y, edgeVector.x);
}

- (CGPoint)cornerCoordsForPosition:(GTUIShapeCornerPosition)cornerPosition
                       forViewSize:(CGSize)viewSize {
    CGPoint offset = [self cornerOffsetForPosition:cornerPosition];
    CGPoint translation;
    switch (cornerPosition) {
        case GTUIShapeCornerTopLeft:
            translation = CGPointMake(0, 0);
            break;
        case GTUIShapeCornerTopRight:
            translation = CGPointMake(viewSize.width, 0);
            break;
        case GTUIShapeCornerBottomLeft:
            translation = CGPointMake(0, viewSize.height);
            break;
        case GTUIShapeCornerBottomRight:
            translation = CGPointMake(viewSize.width, viewSize.height);
            break;
    }

    return CGPointMake(offset.x + translation.x,
                       offset.y + translation.y);
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end
