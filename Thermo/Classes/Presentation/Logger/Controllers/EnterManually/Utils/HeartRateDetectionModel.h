//
//  HeartRateDetectionModel.h
//  Thermo
//
//  Created by Andrey Chernyshev on 23.01.2021.
//

#import <UIKit/UIKit.h>

@protocol HeartRateDetectionModelDelegate

- (void)heartRateUpdate:(int)bpm atTime:(int)seconds;

@end

@interface HeartRateDetectionModel : NSObject

@property (nonatomic, weak) id<HeartRateDetectionModelDelegate> delegate;

- (void)startDetection;
- (void)stopDetection;

@end
