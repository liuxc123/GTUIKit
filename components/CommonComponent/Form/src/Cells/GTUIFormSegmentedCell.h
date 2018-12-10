//
//  GTUIFormSegmentedCell.h
//  GTForm
//
//  Created by liuxc on 2018/10/23.
//

#import "GTUIFormBaseCell.h"

@interface GTUIFormSegmentedCell : GTUIFormBaseCell

@property (nonatomic, readonly) UILabel * textLabel;
@property (nonatomic, readonly) UISegmentedControl *segmentedControl;

@end
