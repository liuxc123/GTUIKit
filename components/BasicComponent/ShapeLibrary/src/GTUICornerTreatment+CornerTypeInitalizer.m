//
//  GTUICornerTreatment+CornerTypeInitalizer.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/7.
//

#import "GTUICornerTreatment+CornerTypeInitalizer.h"

@implementation GTUICornerTreatment (CornerTypeInitalizer)


+ (GTUIRoundedCornerTreatment *)cornerWithRadius:(CGFloat)value {
    return [[GTUIRoundedCornerTreatment alloc] initWithRadius:value];
}

+ (GTUIRoundedCornerTreatment *)cornerWithRadius:(CGFloat)value
                                      valueType:(GTUICornerTreatmentValueType)valueType {
    GTUIRoundedCornerTreatment *roundedCornerTreatment =
    [GTUIRoundedCornerTreatment cornerWithRadius:value];
    roundedCornerTreatment.valueType = valueType;
    return roundedCornerTreatment;
}

+ (GTUICutCornerTreatment *)cornerWithCut:(CGFloat)value {
    return [[GTUICutCornerTreatment alloc] initWithCut:value];
}

+ (GTUICutCornerTreatment *)cornerWithCut:(CGFloat)value
                               valueType:(GTUICornerTreatmentValueType)valueType {
    GTUICutCornerTreatment *cutCornerTreatment = [GTUICutCornerTreatment cornerWithCut:value];
    cutCornerTreatment.valueType = valueType;
    return cutCornerTreatment;
}

+ (GTUICurvedCornerTreatment *)cornerWithCurve:(CGSize)value {
    return [[GTUICurvedCornerTreatment alloc] initWithSize:value];
}

+ (GTUICurvedCornerTreatment *)cornerWithCurve:(CGSize)value
                                    valueType:(GTUICornerTreatmentValueType)valueType {
    GTUICurvedCornerTreatment *curvedCornerTreatment =
    [GTUICurvedCornerTreatment cornerWithCurve:value];
    curvedCornerTreatment.valueType = valueType;
    return curvedCornerTreatment;
}


@end
