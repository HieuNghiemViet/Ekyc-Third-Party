import Flutter
import UIKit
import ICSdkEKYC

@main
@objc class AppDelegate: FlutterAppDelegate {
    var methodChannel: FlutterResult?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        UIDevice.current.isProximityMonitoringEnabled = false
        
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        //        let controller = FlutterViewController()
        //        let nav = UINavigationController.init(rootViewController: controller)
        //        nav.isNavigationBarHidden = true
        //        self.window.rootViewController = nav
        let channel = FlutterMethodChannel(name: "flutter.sdk.ekyc/integrate",
                                           binaryMessenger: controller.binaryMessenger)
        
        channel.setMethodCallHandler {
            (call: FlutterMethodCall, result: @escaping FlutterResult) in
            // Note: this method is invoked on the UI thread.
            // Handle battery messages.
            self.methodChannel = result
            // print(self.convertToDictionary(text: info))
            // input key - get from flutter
            ICEKYCSavedData.shared().tokenId = ""
//            ICEKYCSavedData.shared().tokenKey = ""
//            ICEKYCSavedData.shared().authorization = ""
        
            DispatchQueue.main.async {
                if call.method == "startEkycFull" {
                    self.startEkycFull(controller)
                }
            }
            
            print("channel.setMethodCallHandler")
        }
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    /// Luồng đầy đủ: Ocr + Face
    /// - Parameter controller: root viewcontroller
    func startEkycFull(_ controller: UIViewController) {
        print("HieuV")
        let camera = ICEkycCameraRouter.createModule() as! ICEkycCameraViewController
        
        camera.cameraDelegate = self
        
        /// Giá trị này xác định kiểu giấy tờ để sử dụng:
        /// - IDENTITY_CARD: Chứng minh thư nhân dân, Căn cước công dân
        /// - IDCardChipBased: Căn cước công dân gắn Chip
        /// - Passport: Hộ chiếu
        /// - DriverLicense: Bằng lái xe
        /// - MilitaryIdCard: Chứng minh thư quân đội
        camera.documentType = IdentityCard
        
        /// Luồng đầy đủ
        /// Bước 1 - chụp ảnh giấy tờ
        /// Bước 2 - chụp ảnh chân dung xa gần
        camera.flowType = full
        
        /// xác định xác thực khuôn mặt bằng oval xa gần
        camera.versionSdk = ProOval
        
        /// Bật/Tắt chức năng So sánh ảnh trong thẻ và ảnh chân dung
        camera.isEnableCompare = true
        
        /// Bật/Tắt chức năng kiểm tra che mặt
        camera.isCheckMaskedFace = true
        
        /// Bật/Tắt chức năng kiểm tra ảnh giấy tờ chụp trực tiếp (liveness card)
        camera.isCheckLivenessCard = true
        
        /// Lựa chọn chế độ kiểm tra ảnh giấy tờ ngay từ SDK
        /// - None: Không thực hiện kiểm tra ảnh khi chụp ảnh giấy tờ
        /// - Basic: Kiểm tra sau khi chụp ảnh
        /// - MediumFlip: Kiểm tra ảnh hợp lệ trước khi chụp (lật giấy tờ thành công → hiển thị nút chụp)
        /// - Advance: Kiểm tra ảnh hợp lệ trước khi chụp (hiển thị nút chụp)
        camera.validateDocumentType = Basic
        
        /// Giá trị này xác định việc có xác thực số ID với mã tỉnh thành, quận huyện, xã phường tương ứng hay không.
        camera.isValidatePostcode = true
        
        /// Lựa chọn chức năng kiểm tra ảnh chân dung chụp trực tiếp (liveness face)
        /// - NoneCheckFace: Không thực hiện kiểm tra ảnh chân dung chụp trực tiếp hay không
        /// - iBETA: Kiểm tra ảnh chân dung chụp trực tiếp hay không iBeta (phiên bản hiện tại)
        /// - Standard: Kiểm tra ảnh chân dung chụp trực tiếp hay không Standard (phiên bản mới)
        camera.checkLivenessFace = IBeta
        
        /// Giá trị này dùng để đảm bảo mỗi yêu cầu (request) từ phía khách hàng sẽ không bị thay đổi.
        camera.challengeCode = "INNOVATIONCENTER"
        
        /// Ngôn ngữ sử dụng trong SDK
        /// - vi: Tiếng Việt
        /// - en: Tiếng Anh
        camera.languageSdk = "vi"
        
        /// Bật/Tắt Hiển thị màn hình hướng dẫn
        camera.isShowTutorial = true
        
        /// Bật chức năng hiển thị nút bấm "Bỏ qua hướng dẫn" tại các màn hình hướng dẫn bằng video
        camera.isEnableGotIt = true
        
        /// Sử dụng máy ảnh mặt trước
        /// - PositionFront: Camera trước
        /// - PositionBack: Camera sau
        camera.cameraPositionForPortrait = PositionFront
        
        camera.modalTransitionStyle = .coverVertical
        camera.modalPresentationStyle = .fullScreen
        controller.present(camera, animated: true)
    }
}

extension AppDelegate: ICEkycCameraDelegate {
    func icEkycGetResult() {
        UIDevice.current.isProximityMonitoringEnabled = false /// tắt cảm biến làm tối màn hình
        let dataInfoResult = ICEKYCSavedData.shared().ocrResult
        let dataLivenessCardFrontResult = ICEKYCSavedData.shared().livenessCardFrontResult
        let dataLivenessCardRearResult = ICEKYCSavedData.shared().livenessCardBackResult
        let dataCompareResult = ICEKYCSavedData.shared().compareFaceResult
        let dataLivenessFaceResult = ICEKYCSavedData.shared().livenessFaceResult
        let dataMaskedFaceResult = ICEKYCSavedData.shared().maskedFaceResult
        
        let dict = [
            "INFO_RESULT": dataInfoResult,
            "LIVENESS_CARD_FRONT_RESULT": dataLivenessCardFrontResult,
            "LIVENESS_CARD_REAR_RESULT": dataLivenessCardRearResult,
            "COMPARE_RESULT": dataCompareResult,
            "LIVENESS_FACE_RESULT": dataLivenessFaceResult,
            "MASKED_FACE_RESULT": dataMaskedFaceResult,
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            let jsonString = String(data: jsonData, encoding: String.Encoding.ascii)
            self.methodChannel!(jsonString)
            
        } catch {
            print(error.localizedDescription)
            self.methodChannel!(FlutterMethodNotImplemented)
        }
    }
    
    func icEkycCameraClosed(with type: ScreenType) {
        UIDevice.current.isProximityMonitoringEnabled = false
        self.methodChannel!(FlutterMethodNotImplemented)
    }
}
