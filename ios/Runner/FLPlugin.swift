//
//  FLPlugin.swift
//  Runner
//
//  Created by Hieu Nghiem Viet on 18/11/24.
//

import Foundation

class FLPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let factory = FLEkycViewFactory(messenger: registrar.messenger())
        registrar.register(factory, withId: "ekyc-view")
    }
}
