#import "UrlLinkPlugin.h"
#if __has_include(<url_link/url_link-Swift.h>)
#import <url_link/url_link-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "url_link-Swift.h"
#endif

@implementation UrlLinkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftUrlLinkPlugin registerWithRegistrar:registrar];
}
@end
