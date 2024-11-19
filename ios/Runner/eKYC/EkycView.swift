//
//  EkycView.swift
//  Runner
//
//  Created by Hieu Nghiem Viet on 18/11/24.
//

import Foundation

import Flutter
import ICSdkEKYC
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
        let button = UIButton(frame: CGRectMake(60, 360, 240, 40))
        button.setTitle("eKYC", for: .normal)
        button.setTitleColor(.yellow, for: .normal)
        button.addTarget(self, action: #selector(self.actionFullEkyc), for: .touchUpInside)
        _view.addSubview(button)
    }
    
    
    // MARK: - eKYC
        
        
        // Phương thức thực hiện eKYC luồng đầy đủ bao gồm: Chụp ảnh giấy tờ và chụp ảnh chân dung
        // Bước 1 - chụp ảnh giấy tờ
        // Bước 2 - chụp ảnh chân dung xa gần
        // Bước 3 - hiển thị kết quả
        @objc private func actionFullEkyc() {
            let objCamera = ICEkycCameraRouter.createModule() as! ICEkycCameraViewController
            objCamera.cameraDelegate = self

            // Giá trị này xác định phiên bản khi sử dụng Máy ảnh tại bước chụp ảnh chân dung luồng full. Mặc định là Normal ✓
            // - Normal: chụp ảnh chân dung 1 hướng
            // - ProOval: chụp ảnh chân dung xa gần
            objCamera.versionSdk = ProOval
            
            // Giá trị xác định luồng thực hiện eKYC
            // - full: thực hiện eKYC đầy đủ các bước: chụp mặt trước, chụp mặt sau và chụp ảnh chân dung
            // - ocrFront: thực hiện OCR giấy tờ một bước: chụp mặt trước
            // - ocrBack: thực hiện OCR giấy tờ một bước: chụp mặt trước
            // - ocr: thực hiện OCR giấy tờ đầy đủ các bước: chụp mặt trước, chụp mặt sau
            // - face: thực hiện so sánh khuôn mặt với mã ảnh chân dung được truyền từ bên ngoài
            objCamera.flowType = full
            
            // Giá trị này xác định kiểu giấy tờ để sử dụng:
            // - IdentityCard: Chứng minh thư nhân dân, Căn cước công dân
            // - IDCardChipBased: Căn cước công dân gắn Chip
            // - Passport: Hộ chiếu
            // - DriverLicense: Bằng lái xe
            // - MilitaryIdCard: Chứng minh thư quân đội
            objCamera.documentType = IdentityCard
            
            // Giá trị này dùng để đảm bảo mỗi yêu cầu (request) từ phía khách hàng sẽ không bị thay đổi.
            objCamera.challengeCode = "INNOVATIONCENTER"
            
            // Bật/Tắt Hiển thị màn hình hướng dẫn
            objCamera.isShowTutorial = true
            
            // Bật/Tắt chức năng So sánh ảnh trong thẻ và ảnh chân dung
            objCamera.isEnableCompare = true
            
            // Bật/Tắt chức năng kiểm tra che mặt
            objCamera.isCheckMaskedFace = true
            
            // Lựa chọn chức năng kiểm tra ảnh chân dung chụp trực tiếp (liveness face)
            // - NoneCheckFace: Không thực hiện kiểm tra ảnh chân dung chụp trực tiếp hay không
            // - IBeta: Kiểm tra ảnh chân dung chụp trực tiếp hay không iBeta (phiên bản hiện tại)
            // - Standard: Kiểm tra ảnh chân dung chụp trực tiếp hay không Standard (phiên bản mới)
            objCamera.checkLivenessFace = IBeta
            
            // Bật/Tắt chức năng kiểm tra ảnh giấy tờ chụp trực tiếp (liveness card)
            objCamera.isCheckLivenessCard = true
            
            // Lựa chọn chế độ kiểm tra ảnh giấy tờ ngay từ SDK
            // - None: Không thực hiện kiểm tra ảnh khi chụp ảnh giấy tờ
            // - Basic: Kiểm tra sau khi chụp ảnh
            // - MediumFlip: Kiểm tra ảnh hợp lệ trước khi chụp (lật giấy tờ thành công → hiển thị nút chụp)
            // - Advance: Kiểm tra ảnh hợp lệ trước khi chụp (hiển thị nút chụp)
            objCamera.validateDocumentType = Basic
            
            // Bật chức năng hiển thị nút bấm "Bỏ qua hướng dẫn" tại các màn hình hướng dẫn bằng video
            objCamera.isEnableGotIt = true
            
            // Ngôn ngữ sử dụng trong SDK
            objCamera.languageSdk = "icekyc_vi"
            
            // Bật/Tắt Hiển thị ảnh thương hiệu
            objCamera.isShowLogo = true
            
            objCamera.modalPresentationStyle = .fullScreen
            objCamera.modalTransitionStyle = .coverVertical
            self.present(objCamera, animated: true, completion: nil)
        }
        
}

extension EkycView: ICEkycCameraDelegate {
    
    // Phương thức trả về kết quả sau khi thực hiện eKYC
    func icEkycGetResult() {
        
        // Thông tin bóc tách OCR
        let ocrResult = ICEKYCSavedData.shared().ocrResult
        // Kết quả kiểm tra giấy tờ chụp trực tiếp (Liveness Card) mặt trước
        let livenessCardFrontResult = ICEKYCSavedData.shared().livenessCardFrontResult
        // Kết quả kiểm tra giấy tờ chụp trực tiếp (Liveness Card) mặt sau
        let livenessCardBackResult = ICEKYCSavedData.shared().livenessCardBackResult
        
        // Dữ liệu thực hiện SO SÁNH khuôn mặt (lấy từ mặt trước ảnh giấy tờ hoặc ảnh thẻ)
        let compareFaceResult = ICEKYCSavedData.shared().compareFaceResult
        
        // Dữ liệu kiểm tra ảnh CHÂN DUNG chụp trực tiếp hay không
        let livenessFaceResult = ICEKYCSavedData.shared().livenessFaceResult
        
        // Dữ liệu XÁC THỰC ảnh CHÂN DUNG và SỐ GIẤY TỜ
        let verifyFaceResult = ICEKYCSavedData.shared().verifyFaceResult
        
        // Dữ liệu kiểm tra ảnh CHÂN DUNG có bị che mặt hay không
        let maskedFaceResult = ICEKYCSavedData.shared().maskedFaceResult
        
        
        // Ảnh [chụp giấy tờ mặt trước] đã cắt được trả ra để ứng dụng hiển thị
        let imageFrontCroped = ICEKYCSavedData.shared().imageFrontCropped
        
        // Mã ảnh giấy tờ mặt trước sau khi tải lên máy chủ
        let hashImageFront = ICEKYCSavedData.shared().hashImageFront
        
        // Đường dẫn Ảnh đầy đủ khi chụp giấy tờ mặt trước
        let pathImageFront = ICEKYCSavedData.shared().pathImageFrontFull
        print("pathImageFront = \(pathImageFront.path)")
        
        // Đường dẫn Ảnh [chụp giấy tờ mặt trước] đã cắt được trả ra để ứng dụng hiển thị
        let pathImageCropedFront = ICEKYCSavedData.shared().pathImageFrontFull
        print("pathImageCropedFront = \(pathImageCropedFront.path)")
        
        
        // Ảnh [chụp giấy tờ mặt sau] đã cắt được trả ra để ứng dụng hiển thị
        let imageBackCroped = ICEKYCSavedData.shared().imageBackCropped
        
        // Mã ảnh giấy tờ mặt sau sau khi tải lên máy chủ
        let hashImageBack = ICEKYCSavedData.shared().hashImageBack
        
        // Đường dẫn Ảnh đầy đủ khi chụp giấy tờ mặt sau
        let pathImageBack = ICEKYCSavedData.shared().pathImageBackFull
        print("pathImageBack = \(pathImageBack.path)")
        
        // Đường dẫn Ảnh [chụp giấy tờ mặt sau] đã cắt được trả ra để ứng dụng hiển thị
        let pathImageCropedBack = ICEKYCSavedData.shared().pathImageBackFull
        print("pathImageCropedBack = \(pathImageCropedBack.path)")
        
        
        // Ảnh chân dung chụp xa đã cắt được trả ra để ứng dụng hiển thị
        let imageFaceFarCroped = ICEKYCSavedData.shared().imageFaceCropped
        // Mã ảnh chân dung chụp xa sau khi tải lên máy chủ
        let hashImageFaceFar = ICEKYCSavedData.shared().hashImageFaceFar
        
        // Ảnh chân dung chụp gần đã cắt được trả ra để ứng dụng hiển thị
//        let imageFaceNearCroped = ICEKYCSavedData.shared().imageCropedFaceNear
        // Mã ảnh chân dung chụp gần sau khi tải lên máy chủ
        let hashImageFaceNear = ICEKYCSavedData.shared().hashImageFaceNear
        
        // Dữ liệu để xác định cách giao dịch (yêu cầu) cùng nằm trong cùng một phiên
        let clientSessionResult = ICEKYCSavedData.shared().clientSessionResult
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let viewShowResult = storyboard.instantiateViewController(withIdentifier: "ResultEkyc") as! ResultEkycViewController
            
            // Thông tin Giấy tờ
            viewShowResult.ocrResult = ocrResult
            viewShowResult.livenessCardFrontResult = livenessCardFrontResult
            viewShowResult.livenessCardBackResult = livenessCardBackResult
            
            // Thông tin khuôn mặt
            viewShowResult.compareFaceResult = compareFaceResult
            viewShowResult.livenessFaceResult = livenessFaceResult
            viewShowResult.verifyFaceResult = verifyFaceResult
            viewShowResult.maskedFaceResult = maskedFaceResult
            
            // Ảnh giấy tờ Mặt trước
            viewShowResult.imageFrontCroped = imageFrontCroped
            viewShowResult.hashImageFront = hashImageFront
            
            // Ảnh giấy tờ Mặt sau
            viewShowResult.imageBackCroped = imageBackCroped
            viewShowResult.hashImageBack = hashImageBack
            
            // Ảnh chân dung xa
            viewShowResult.imageFaceFarCroped = imageFaceFarCroped
            viewShowResult.hashImageFaceFar = hashImageFaceFar
            
            // Ảnh chân dung gần
//            viewShowResult.imageFaceNearCroped = imageFaceNearCroped
            viewShowResult.hashImageFaceNear = hashImageFaceNear
            
            viewShowResult.clientSession = clientSessionResult
            
            let navigationController = UINavigationController(rootViewController: viewShowResult)
            navigationController.modalPresentationStyle = .fullScreen
            navigationController.modalTransitionStyle = .coverVertical
            self.present(navigationController, animated: true, completion: nil)
        }
    }
    
}
