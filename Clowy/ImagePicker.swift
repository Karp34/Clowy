//
//  ImagePicker.swift
//  CoreDataImage
//
//  Created by Егор Карпухин on 30.06.2022.
//

import SwiftUI
import Combine

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var show: Bool
    @Binding var image: Data
    
    func makeCoordinator() -> ImagePicker.Coordinator {
        return ImagePicker.Coordinator(child1: self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    class Coordinator : NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var child : ImagePicker
        
        init (child1: ImagePicker) {
            child = child1
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            self.child.show.toggle()
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let image = info[.originalImage] as! UIImage
            let data = image.jpegData(compressionQuality: 0.45)
            
            self.child.image = data!
            self.child.show.toggle()
        }
    }
}
