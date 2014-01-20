//
//  LHEmailCheck.m
//  EmailCheck/Suggest
//
//  Created by Louis Harwood on 03/01/2014.
//  Copyright (c) 2014 LouisHarwood. All rights reserved.
//  www.louisharwood.com

#import "LHEmailCheck.h"

@interface LHEmailCheck ()
@property (nonatomic, strong) NSMutableArray *defaultDomains;
@property (nonatomic, strong) NSMutableArray *defaultTLDs;
@end

@implementation LHEmailCheck

- (NSString *)suggestEmail:(NSString *)originalEmail {
    self.defaultDomains = [[NSMutableArray alloc] initWithArray:@[@"yahoo.com", @"google.com", @"hotmail.com", @"gmail.com", @"me.com", @"aol.com", @"mac.com", @"live.com", @"comcast.net", @"googlemail.com", @"msn.com", @"hotmail.co.uk", @"yahoo.co.uk", @"facebook.com", @"verizon.net", @"sbcglobal.net", @"att.net", @"gmx.com", @"mail.com", @"outlook.com", @"icloud.com"]];
    
    self.defaultTLDs = [[NSMutableArray alloc] initWithArray:@[@"co.uk", @"co.jp", @"com", @"net", @"org", @"info", @"edu", @"gov", @"mil", @"ca"]];
    
    NSString *componentToTest = [[originalEmail componentsSeparatedByString:@"@"] lastObject];
    NSString *firstPartEmail =  [[originalEmail componentsSeparatedByString:@"@"] firstObject];
    NSString *domainToTest =    [[componentToTest componentsSeparatedByString:@"."] firstObject];
    NSString *TLDToTest =       [[componentToTest componentsSeparatedByString:@"."] lastObject];
    
    NSString *matchedDomain = [self matchedString:componentToTest inArray:self.defaultDomains];
    
    
    if (matchedDomain == nil) {
        NSString *matchedTLD = [self matchedString:TLDToTest inArray:self.defaultTLDs];
        if (matchedTLD == nil) {
            return nil;
        } else {
            NSString *suggestedEmail = [NSString stringWithFormat:@"%@@%@.%@", firstPartEmail, domainToTest, matchedTLD];
            if ([suggestedEmail isEqualToString:originalEmail])
                return nil;
            else
                return suggestedEmail;
        }
    } else {
        NSString *suggestedEmail = [NSString stringWithFormat:@"%@@%@", firstPartEmail, matchedDomain];
        if([suggestedEmail isEqualToString:originalEmail])
            return nil;
        else
            return suggestedEmail;
    }
}

- (NSString *)matchedString:(NSString *)testString inArray:(NSArray *)testArray {
    NSInteger bestDistance = 999999999;
    int indexOfMatch = -1;
    
    for (int i=0; i<[testArray count]; i++) {
        NSString *possibleDomain = [testArray objectAtIndex:i];
        NSInteger distance = [self levensteinDistanceMethod:possibleDomain forString:testString];
        if ((distance < bestDistance) && distance <= 0) {
            indexOfMatch = i;
            bestDistance = distance;
        }
    }
    
    if (indexOfMatch < 0) {
        return nil;
    } else {
        return [testArray objectAtIndex:indexOfMatch];
    }
}

- (NSInteger)levensteinDistanceMethod:(NSString *)string1 forString:(NSString *)string2 {
    // calculate the lev distance, and return it as an NSInteger *.
    // source https://gist.github.com/iloveitaly/1515464
    NSInteger gain = 1;
    NSInteger cost = 10;
    
    NSString * stringA = [NSString stringWithString: string1];
	stringA =            [[stringA stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
	NSString *stringB =  [[string2 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
	
	NSInteger k, i, j, change, *d, distance;
	
	NSUInteger n = [stringA length];
	NSUInteger m = [stringB length];
	
	if( n++ != 0 && m++ != 0 ) {
		d = malloc( sizeof(NSInteger) * m * n );
	
		for( k = 0; k < n; k++)
			d[k] = k;
		
		for( k = 0; k < m; k++)
			d[ k * n ] = k;
	
		for( i = 1; i < n; i++ ) {
			for( j = 1; j < m; j++ ) {
	
				if([stringA characterAtIndex: i-1] == [stringB characterAtIndex: j-1]) {
					change = -gain;
				} else {
					change = cost;
				}
	
				d[ j * n + i ] = MIN(d [ (j - 1) * n + i ] + 1, MIN(d[ j * n + i - 1 ] +  1, d[ (j - 1) * n + i -1 ] + change));
			}
		}
		
		distance = d[ n * m - 1 ];
		free( d );

		return distance;
	}
	
	return 0;
}

@end
