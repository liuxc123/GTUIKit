//
//  GTUICornerTreatment+CornerTypeInitalizer.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/7.
//

#import "GTShapes.h"

#import "GTUICurvedCornerTreatment.h"
#import "GTUICutCornerTreatment.h"
#import "GTUIRoundedCornerTreatment.h"

@interface GTUICornerTreatment (CornerTypeInitalizer)

/**
 Initialize and return an GTUICornerTreatment as an GTUIRoundedCornerTreatment.

 @param value The radius to set the rounded corner to.
 @return an GTUIRoundedCornerTreatment.
 */
+ (GTUIRoundedCornerTreatment *)cornerWithRadius:(CGFloat)value;

/**
 Initialize and return an GTUICornerTreatment as an GTUIRoundedCornerTreatment.

 @param value The radius to set the rounded corner to.
 @param valueType The value type in which the value is set as. It can be sent either as an
 absolute value, or a percentage value (0.0 - 1.0) of the height of the surface.
 @return an GTUIRoundedCornerTreatment.
 */
+ (GTUIRoundedCornerTreatment *)cornerWithRadius:(CGFloat)value
                                      valueType:(GTUICornerTreatmentValueType)valueType;

/**
 Initialize and return an GTUICornerTreatment as an GTUICutCornerTreatment.

 @param value The cut to set the cut corner to.
 @return an GTUICutCornerTreatment.
 */
+ (GTUICutCornerTreatment *)cornerWithCut:(CGFloat)value;

/**
 Initialize and return an GTUICornerTreatment as an GTUIRoundedCornerTreatment.

 @param value The cut to set the cut corner to.
 @param valueType The value type in which the value is set as. It can be sent either as an
 absolute value, or a percentage value (0.0 - 1.0) of the height of the surface.
 @return an GTUICutCornerTreatment.
 */
+ (GTUICutCornerTreatment *)cornerWithCut:(CGFloat)value
                               valueType:(GTUICornerTreatmentValueType)valueType;

/**
 Initialize and return an GTUICornerTreatment as an GTUICurvedCornerTreatment.

 @param value The size to set the curved corner to.
 @return an GTUICurvedCornerTreatment.
 */
+ (GTUICurvedCornerTreatment *)cornerWithCurve:(CGSize)value;

/**
 Initialize and return an GTUICornerTreatment as an GTUICurvedCornerTreatment.

 @param value The curve to set the curved corner to.
 @param valueType The value type in which the value is set as. It can be sent either as an
 absolute value, or a percentage value (0.0 - 1.0) of the height of the surface.
 @return an GTUICurvedCornerTreatment.
 */
+ (GTUICurvedCornerTreatment *)cornerWithCurve:(CGSize)value
                                    valueType:(GTUICornerTreatmentValueType)valueType;

@end
