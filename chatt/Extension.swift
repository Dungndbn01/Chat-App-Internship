//
//  Extension.swift
//  ChatApp
//
//  Created by Nguyen Dinh Dung on 2017/10/25.
//  Copyright © 2017年 Nguyen Dinh Dung. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func loadImageUsingCacheWithUrlString(urlString: String) {
        
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!,
                                   completionHandler: { (data, response, error) in
                                    if error != nil {
                                        print(error!)
                                        return
                                    }
                                    DispatchQueue.main.async {
                                        if let downloadedImage = UIImage(data: data!) {
                                            imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                                            self.image = downloadedImage                                        }
                                        
                                    }
        }).resume()
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround(bool: Bool) {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = bool
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UITextView {
    
    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
    
}

extension UITabBar {
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 50
        return sizeThatFits
    }
}

extension UINavigationBar {
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 44
        return sizeThatFits
    }
}

extension UIColor {
    
    convenience init(r:CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}

extension UIButton {
    open func setUpButton(radius: CGFloat, title: String, imageName: String, backgroundColor: UIColor, fontSize: CGFloat, titleColor: UIColor) -> UIButton{
        let button = UIButton()
        button.layer.cornerRadius = radius
        button.layer.masksToBounds = true
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.backgroundColor = backgroundColor
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSize)
        button.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}

extension UITextField {
    open func setUpTextField(placeHolderString: String) -> UITextField{
        let textField = UITextField()
        textField.placeholder = placeHolderString
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
}

extension UITextView {
    open func setUpTextView(text: String, textColor: UIColor, size: CGFloat) -> UITextView{
        let textView = UITextView()
        textView.text = text
        textView.textColor = textColor
        textView.font = UIFont.systemFont(ofSize: size)
        return textView
    }
}

extension UIView {
    open func setUpUIView(backgroundColor: UIColor, radius: CGFloat) -> UIView{
        let view = UIView()
        view.backgroundColor = backgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = radius
        view.layer.masksToBounds = true
        return view
    }
}

extension UIImageView {
    open func setUpImageView(imageName: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: imageName)
        imageView.layer.cornerRadius = 0
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }
}

extension UILabel {
    open func setUpLabel(labelText: String, textColor: UIColor, size: CGFloat) -> UILabel {
        let label = UILabel()
        label.text = labelText
        label.textColor = textColor
        label.font = UIFont.systemFont(ofSize: size)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}

extension UITabBarController {
    func removeTabbarItemsText() {
        tabBar.items?.forEach {
            $0.title = ""
            $0.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        }
    }
}








