#import "Converter.h"

// Do not change
NSString *KeyPhoneNumber = @"phoneNumber";
NSString *KeyCountry = @"country";

@implementation PNConverter
- (NSDictionary*)converToPhoneNumberNextString:(NSString*)string; {
    
    NSMutableString *mtString = [[NSMutableString alloc]initWithString:string];
    
     NSDictionary *codeCountry = @{@"+7": @"RU",
                                  @"+380": @"UA",
                                  @"+373": @"MD",
                                  @"+374": @"AM",
                                  @"+375": @"BY",
                                  @"+992": @"TJ",
                                  @"+993": @"TM",
                                  @"+994": @"AZ",
                                  @"+996": @"KG",
                                  @"+998": @"UZ"};
    
    if([mtString characterAtIndex:0] != '+'){
        [mtString insertString:@"+" atIndex:0];
    }
    
    NSString *keyPhoneNumber = [NSMutableString new];
    NSString *keyCountry = [NSString new];
    NSDictionary *result = @{KeyPhoneNumber: @"", KeyCountry: @""};
    NSArray *codeArray = [codeCountry allKeys];
    for(NSString *code in codeArray){
        if(mtString.length >= code.length){
             NSString *phoneNumberCode = [mtString substringWithRange:NSMakeRange(0, code.length)];
            if([phoneNumberCode isEqualToString:code]){
                keyCountry = [codeCountry objectForKey:code];
                [mtString deleteCharactersInRange:NSMakeRange(0, code.length)];
                if (mtString.length > 0) {
                    if ([mtString characterAtIndex:0] == '7') {
                        keyCountry = @"KZ";
                    }
                    keyPhoneNumber = [self convertType:mtString forCode:code andCountry: keyCountry];
                } else {
                    keyPhoneNumber = code;
                }
            }
        }
       
    }
    if (keyCountry.length<1) {
        keyCountry = @"";
        if (mtString.length > 12) {
            keyPhoneNumber = [mtString substringWithRange: NSMakeRange(0, 13)];
        } else {
            keyPhoneNumber = mtString;
        }
    }
    result = @{KeyPhoneNumber: keyPhoneNumber, KeyCountry: keyCountry};
    return result;
}

- (NSString *)convertType:(NSMutableString *)remainString forCode: (NSString *)code andCountry: (NSString *)country {
    
    NSMutableString *result = [code mutableCopy];
    [result appendString:@" "];
    NSString *format = @"";
    
    if ([country isEqualToString: @"RU"] || [country isEqualToString: @"KZ"]) {
        format = @"(xxx) xxx-xx-xx";
    } else if ([country isEqualToString: @"MD"] || [country isEqualToString: @"AM"] || [country isEqualToString: @"TM"]) {
        format = @"(xx) xxx-xxx";
    } else {
        format = @"(xx) xxx-xx-xx";
    }
    
    for (int i = 0; i < format.length; i++) {
        if (remainString.length != 0 && [format characterAtIndex:i] != 'x') {
            [result appendString: [format substringWithRange: NSMakeRange(i, 1)]];
        } else if (remainString.length != 0 && [format characterAtIndex:i] == 'x') {
            [result appendString: [remainString substringWithRange: NSMakeRange(0, 1)]];
            [remainString deleteCharactersInRange: NSMakeRange(0, 1)];
        }
    }
    return result;
}

@end
