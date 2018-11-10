//
//  GTUICheckBoxPath.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/6.
//

#import <UIKit/UIKit.h>
#import "GTUICheckBox.h"

/*
 Path object used by GTUICheckBox to generate paths.
 */
@interface GTUICheckBoxPath : NSObject

/*
 The paths are assumed to be created in squares.
 This is the size of width, or height, of the paths that will be created.
 */
@property (nonatomic) CGFloat size;

/*
 The width of the lines on the created paths.
 */
@property (nonatomic) CGFloat lineWidth;

/*
 The corner radius of the path when the boxType is BEMBoxTypeSquare.
 */
@property (nonatomic) CGFloat cornerRadius;

/**
 The type of box.
 Depending on the box type, paths may be created differently
 @see GTUICheckBoxStyle
 */
@property (nonatomic) GTUICheckBoxType boxType;

/**
 Returns a UIBezierPath object for the box of the checkbox

 @return The path of the box.
 */
- (UIBezierPath *)pathForBox;

/**
 Returns a UIBezierPath object for the box of the checkbox
 @return The path of the checkmark.
 */
- (UIBezierPath *)pathForCheckMark;


/**
 Returns a UIBezierPath object for an extra long checkmark which is in contact with the box.
 @return The path of the checkmark.
 */
- (UIBezierPath *)pathForLongCheckMark;


/**
 Returns a UIBezierPath object for the flat checkmark of the checkbox
 @return The path of the flat checkmark.
 */
- (UIBezierPath *)pathForFlatCheckMark;

@end
