//
//  ImagePicker.swift
//  FamilyEducationLab
//
//  Created by yousef on 27/05/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import Foundation
import YPImagePicker

class ImagePicker {
    
    static let shared = ImagePicker()
    
    let picker: YPImagePicker = {
        var config = YPImagePickerConfiguration()
        
        config.isScrollToChangeModesEnabled = true
        config.onlySquareImagesFromCamera = true
        config.usesFrontCamera = false
        config.showsPhotoFilters = false
        config.shouldSaveNewPicturesToAlbum = true
        config.albumName = "DefaultYPImagePickerAlbumName"
        config.startOnScreen = YPPickerScreen.photo
        config.screens = [.library, .photo]
        config.showsCrop = .none
        config.targetImageSize = YPImageSize.original
        config.overlayView = UIView()
        config.hidesStatusBar = true
        config.hidesBottomBar = false
        config.preferredStatusBarStyle = UIStatusBarStyle.default
        
        config.library.options = nil
        config.library.onlySquare = false
        config.library.minWidthForItem = nil
        config.library.mediaType = YPlibraryMediaType.photo
        config.library.maxNumberOfItems = 1
        config.library.minNumberOfItems = 1
        config.library.numberOfItemsInRow = 4
        config.library.spacingBetweenItems = 1.0
        config.library.skipSelectionsGallery = false
        
        config.video.fileType = .mov
        config.video.recordingTimeLimit = 60.0
        config.video.libraryTimeLimit = 60.0
        config.video.minimumTimeLimit = 3.0
        config.video.trimmerMaxDuration = 60.0
        config.video.trimmerMinDuration = 3.0
        
        return YPImagePicker(configuration: config)
    }()
    
    func presentAskPermissionAlert() {
        AppDelegate.shared.rootNavigationViewController.showAlertPopUp(title: "الوصول الى الكاميرا ومعرض الصور", message: "يرجى السماح بالوصول الى الكاميرا ومعرض الصور حتى تتمكن من إضافة صورة للدرس", buttonTitle1: "الإعدادت", buttonTitle2: "إلغاء", action1: {
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
               UIApplication.shared.openURL(settingsURL)
             }
        }) {
            
        }
    }
    
}
