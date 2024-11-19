//
//  EkycView.swift
//  Runner
//
//  Created by Hieu Nghiem Viet on 18/11/24.
//

import Foundation

import Flutter
import UIKit

class EkycView: NSObject, FlutterPlatformView {
    private var _view: UIView

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        _view = UIView()
        super.init()
        // iOS views can be created here
        createNativeView(view: _view)
    }

    func view() -> UIView {
        return _view
    }

    func createNativeView(view _view: UIView) {
        let nativeLabel = UILabel()
        nativeLabel.text = "Hieu Nghiem Viet Native iOS"
        nativeLabel.textColor = UIColor.red
        nativeLabel.textAlignment = .center
        nativeLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 48.0)
        _view.addSubview(nativeLabel)
    }
}
