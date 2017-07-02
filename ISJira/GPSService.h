#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


// GPS service delegate
@protocol GPSServiceDelegate <NSObject>
-(void)outsideLocation:(int)distance;
-(void)insideLocation:(int)distance;
@end




// GPS service
@interface GPSService : NSObject <CLLocationManagerDelegate>

+(GPSService*)sharedInstance;
    
extern int const OUT_DISTANCE;
extern int const UPDATE_INTERVAL;

@property CLLocation* mWorkLocation;
@property bool mStarted;
@property bool mUpdatingLocation;
@property (strong, nonatomic) CLLocationManager *mLocationManager;
@property (nonatomic, weak) id <GPSServiceDelegate> mDelegate;

-(id)init;
-(void)setDelegate:(id<GPSServiceDelegate>)delegate;
-(void)start;
-(void)stop;
-(void)updateLocation;
-(void)handleLocation:(CLLocation*)location;

@end
