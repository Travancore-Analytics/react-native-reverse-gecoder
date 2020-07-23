#import "ReverseGecoder.h"
#import <MapKit/MapKit.h>

@implementation ReverseGecoder

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(reverseGeocodeLocation : (double)latitude longitude:(double) longitude language:(NSLocale *)language resolve:(RCTPromiseResolveBlock) resolve
                  reject:(RCTPromiseRejectBlock) reject){
    
    CLLocationDegrees lat = latitude;
    CLLocationDegrees log = longitude;
    CLGeocoder *ceo       = [[CLGeocoder alloc]init];
    CLLocation *loc       = [[CLLocation alloc]initWithLatitude:lat longitude:log];

    if (@available(iOS 11.0, *)) {
        [ceo reverseGeocodeLocation: loc preferredLocale:(NSLocale *)language completionHandler:
         ^(NSArray *placemarks, NSError *error) {
            if (error == nil){
                CLPlacemark *placemark = [placemarks objectAtIndex:0];
                resolve([self getAddressForPlacemark:placemark]);
            }else{
                NSString* errorCode = [NSString stringWithFormat:@"%li", (long)error.code];
                reject(errorCode,error.localizedDescription,error);
            }
        }];
    } else {
        [ceo reverseGeocodeLocation: loc completionHandler:
         ^(NSArray *placemarks, NSError *error) {
            if (error == nil){
                CLPlacemark *placemark = [placemarks objectAtIndex:0];
                resolve([self getAddressForPlacemark:placemark]);
            }else{
                NSString* errorCode = [NSString stringWithFormat:@"%li", (long)error.code];
                reject(errorCode,error.localizedDescription,error);
            }
        }];
    }
}

- (NSMutableDictionary*) getAddressForPlacemark:(CLPlacemark*) placemark {

    NSMutableDictionary *address = [[NSMutableDictionary alloc] init];
    CLLocation *location         = placemark.location;
    if (location != nil) {
        [address setValue: @(location.coordinate.latitude) forKey:@"Latitude"];
        [address setValue: @(location.coordinate.longitude) forKey:@"Longitude"];
    }
    [address setValue:placemark.subThoroughfare forKey:@"StreetNumber"];
    [address setValue:placemark.administrativeArea forKey:@"State"];
    [address setValue:placemark.locality forKey:@"City"];
    [address setValue:placemark.country forKey:@"Country"];
    [address setValue:placemark.postalCode forKey:@"PostalCode"];
    [address setValue:placemark.thoroughfare forKey:@"Street"];
    return address;
}

@end
