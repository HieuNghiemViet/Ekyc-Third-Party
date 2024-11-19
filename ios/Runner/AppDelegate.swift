import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        weak var registrar = self.registrar(forPlugin: "plugin-name")
        FLPlugin.register(with: registrar!)
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)

        return self.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
