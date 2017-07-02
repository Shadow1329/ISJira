#import "GPSService.h"

@implementation GPSService

int const OUT_DISTANCE = 1000;          // In meters (1km)
int const UPDATE_INTERVAL = 1800;       // In seconds (30m)


    
// Instance
+(GPSService*)sharedInstance
{
    static GPSService *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[GPSService alloc] init];
    });
    return sharedInstance;
}


// Constructor
-(id)init
{
    if (self = [super init])
    {
        _mWorkLocation = [[CLLocation alloc] initWithLatitude:53.383708 longitude:83.741448];
        _mStarted = false;
        _mUpdatingLocation = false;
        _mLocationManager = [[CLLocationManager alloc] init];
        _mLocationManager.delegate = self;
        _mLocationManager.pausesLocationUpdatesAutomatically = NO;
        _mLocationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        _mLocationManager.distanceFilter = 99999;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
        {
            _mLocationManager.allowsBackgroundLocationUpdates = true;
        }
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
            [_mLocationManager requestAlwaysAuthorization];
        }
        [_mLocationManager startUpdatingLocation];
        [_mLocationManager startMonitoringSignificantLocationChanges];
    }
    return self;
}




// Set delegate
-(void)setDelegate:(id<GPSServiceDelegate>)delegate
{
    _mDelegate = delegate;
}




// Start GPS service
-(void)start
{
    if (!_mStarted)
    {
        NSLog(@"GPS service started");
        
        _mStarted = true;
        
        // Get new location
        [self updateLocation];
    }
}




// Stop GPS service
-(void)stop
{
    if (_mStarted)
    {
        NSLog(@"GPS service stopped");
        
        _mStarted = false;
        
        // Stop update location
        _mUpdatingLocation = false;
        [_mLocationManager stopUpdatingLocation];
    }
}




// Get new location
-(void)updateLocation
{
    _mUpdatingLocation = true;
    _mLocationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    _mLocationManager.distanceFilter = kCLDistanceFilterNone;
}




// Handle fences
-(void)handleLocation:(CLLocation*)location
{
    NSLog(@"Handling location...");
    
    float distance = [location distanceFromLocation:_mWorkLocation];
    
    
    // If current location far from OUT_ZONE_RADIUS update init location and fences
    if (distance > OUT_DISTANCE)
        [_mDelegate outsideLocation:OUT_DISTANCE];
    else
        [_mDelegate insideLocation:OUT_DISTANCE];
    
    
    // After interval get new location
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, UPDATE_INTERVAL * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self updateLocation];
    });
}




// Update location callback
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (_mUpdatingLocation)
    {
        // Stop location updating
        _mUpdatingLocation = false;
        _mLocationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        _mLocationManager.distanceFilter = 99999;
        
        
        // Get last location
        CLLocation *location = [locations lastObject];
        NSLog(@"------- New location: %f, %f, %f, %f -------",
             location.coordinate.latitude,
             location.coordinate.longitude,
             location.speed,
             location.horizontalAccuracy);
        
            
        // Handle fances
        [NSThread detachNewThreadSelector:@selector(handleLocation:) toTarget:self withObject:location];
    }
}

@end
