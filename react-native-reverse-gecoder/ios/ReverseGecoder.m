#import "ReverseGecoder.h"
#import <MapKit/MapKit.h>

@implementation ReverseGecoder

RCT_EXPORT_MODULE()

- (NSMutableDictionary*) getPOIDetails:(CLPlacemark*) placemark {

    NSMutableDictionary *poiDetails = [[NSMutableDictionary alloc] init];
    [poiDetails setValue:placemark.country forKey:@"Country"];
    [poiDetails setValue:placemark.postalCode forKey:@"PostalCode"];
    [poiDetails setValue:placemark.thoroughfare forKey:@"Street"];
    [poiDetails setValue:placemark.subThoroughfare forKey:@"StreetNumber"];
    [poiDetails setValue:placemark.administrativeArea forKey:@"State"];
    [poiDetails setValue:placemark.locality forKey:@"City"];

    CLLocation *location = placemark.location;
    if (location != nil) {
        [poiDetails setValue: @(location.coordinate.latitude) forKey:@"Latitude"];
        [poiDetails setValue: @(location.coordinate.longitude) forKey:@"Longitude"];
    }
    return poiDetails;
}

RCT_EXPORT_METHOD(getAddressFromLocation : (double)latitude longitude:(double) longitude language:(NSLocale *)language resolve:(RCTPromiseResolveBlock) resolve
                  reject:(RCTPromiseRejectBlock) reject){
    CLLocationDegrees lat = latitude;
    CLLocationDegrees log = longitude;
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:lat longitude:log];

    if (@available(iOS 11.0, *)) {
        [ceo reverseGeocodeLocation: loc preferredLocale:(NSLocale *)language completionHandler:
         ^(NSArray *placemarks, NSError *error) {
            if (error == nil){
                CLPlacemark *placemark = [placemarks objectAtIndex:0];
                resolve([self getPOIDetails:placemark]);
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
                resolve([self getPOIDetails:placemark]);
            }else{
                NSString* errorCode = [NSString stringWithFormat:@"%li", (long)error.code];
                reject(errorCode,error.localizedDescription,error);
            }
        }];
    }
}

@end
