//
//  NSString+GTBidi.h
//  Pods-GTFInternationalization_Example
//
//  Created by liuxc on 2018/8/20.
//

#import <Foundation/Foundation.h>

@interface NSString (GTBidi)

/**
 Uses CFStringTokenizerCopyBestStringLanguage to determine string's language direction.
 If the language direction is unknown or vertical returns left-to-right.

 As CFStringTokenizerCopyBestStringLanguage is Apple's API, its result may change if
 Apple improves or modifies the implementation.

 @return the direction of the string
 */
- (NSLocaleLanguageDirection)gtf_calculatedLanguageDirection;

/**
 Initializes a copy of the string tagged with the given language direction. This
 formatting adds the appropriate Unicode embedding characters at the beginning and end of the
 string.

 Only NSLocaleLanguageDirectionLeftToRight and NSLocaleLanguageDirectionRightToLeft
 language directions are supported. Other values of NSLocalLanguageDirection will
 return a copy of self.

 Returns a string wrapped with Unicode bidi formatting characters by inserting these characters
 around the string:
 RLE+|string|+PDF for RTL text, or LRE+|string|+PDF for LTR text.

 @returns the new string.
 */
- (nonnull NSString *)gtf_stringWithBidiEmbedding:(NSLocaleLanguageDirection)languageDirection;

/**
 Returns a copy of the string explicitly tagged with a language direction.

 Uses gtf_calculatedLanguageDirection to determine string's language direction then invokes
 gtf_stringWithBidiEmbedding:.

 @return the new string.
 */
- (nonnull NSString *)gtf_stringWithBidiEmbedding;

/**
 This method will wrap the string in embedding (LRE/RLE and PDF) characters, based on the string
 direction and additionally wrapping the string in marks (LRM and RLM) if the string's direction
 is different from the context direction.

 |direction| can be NSLocaleLanguageDirectionLeftToRight, NSLocaleLanguageDirectionRightToLeft, or
 NSLocaleLanguageDirectionUnknown. If NSLocaleLanguageDirectionUnknown, the direction of the string
 will be calculated with gtf_calculatedLanguageDirection.

 |contextDirection| must be specified and cannot be unknown. Only
 NSLocaleLanguageDirectionLeftToRight and NSLocaleLanguageDirectionRightToLeft language directions
 are supported.

 @returns the new string.
 */
- (nonnull NSString *)gtf_stringWithStereoReset:(NSLocaleLanguageDirection)direction
                                        context:(NSLocaleLanguageDirection)contextDirection;

/**
 Returns a new string in which all occurrences of Unicode bidirectional format markers are removed.

 @returns the new string.
 */
- (nonnull NSString *)gtf_stringWithBidiMarkersStripped;

@end
