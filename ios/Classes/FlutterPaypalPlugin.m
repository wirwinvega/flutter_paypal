#import "FlutterPaypalPlugin.h"
#if __has_include(<flutter_paypal/flutter_paypal-Swift.h>)
#import <flutter_paypal/flutter_paypal-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_paypal-Swift.h"
#endif

@implementation FlutterPaypalPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterPaypalPlugin registerWithRegistrar:registrar];
}
@end
