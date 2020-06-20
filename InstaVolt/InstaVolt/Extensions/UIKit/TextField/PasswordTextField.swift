//
//  VDTextField.swift
//  VedantaComms
//
//  Created by Anshul on 01/11/19.
//  Copyright © 2019 MAC240. All rights reserved.
//

import UIKit
import Foundation
import SkyFloatingLabelTextField

protocol PasswordTextFieldDelegate: class {
    func isValidPassword(_ password: String) -> Bool
}

public class PasswordTextField: SkyFloatingLabelTextField {
    
    weak var passwordDelegate: PasswordTextFieldDelegate?
    var preferredFont: UIFont? {
        didSet {
            self.font = nil
            if self.isSecureTextEntry {
                self.font = self.preferredFont
            }
        }
    }
    
    override public var isSecureTextEntry: Bool {
        didSet {
            if !self.isSecureTextEntry {
                self.font = nil
                self.font = self.preferredFont
            }
            
            // Hack to prevent text from getting cleared when switching secure entry
            // https://stackoverflow.com/a/49771445/1417922
            if self.isFirstResponder {
                _ = self.becomeFirstResponder()
            }
        }
    }
    fileprivate var passwordToggleVisibilityView: PasswordToggleVisibilityView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    override public func becomeFirstResponder() -> Bool {
        // Hack to prevent text from getting cleared when switching secure entry
        // https://stackoverflow.com/a/49771445/1417922
        let success = super.becomeFirstResponder()
        if self.isSecureTextEntry, let text = self.text {
            self.text?.removeAll()
            self.insertText(text)
        }
        return success
    }
}

// MARK: UITextFieldDelegate needed calls
// Implement UITextFieldDelegate when you use this, and forward these calls to this class!
extension PasswordTextField {
    func textFieldDidEndEditing(_ textField: UITextField) {
        passwordToggleVisibilityView.eyeState = PasswordToggleVisibilityView.EyeState.closed
        self.isSecureTextEntry = !isSelected
    }
}

// MARK: PasswordToggleVisibilityDelegate
extension PasswordTextField: PasswordToggleVisibilityDelegate {
    func viewWasToggled(_ passwordToggleVisibilityView: PasswordToggleVisibilityView, isSelected selected: Bool) {
        
        // hack to fix a bug with padding when switching between secureTextEntry state
        let hackString = self.text
        self.text = " "
        self.text = hackString
        
        // hack to save our correct font.  The order here is VERY finicky
        self.isSecureTextEntry = !selected
    }
}

// MARK: Control events
extension PasswordTextField {
    @objc func passwordTextChanged(_ sender: AnyObject) {
        if let password = self.text {
            passwordToggleVisibilityView.checkmarkVisible = passwordDelegate?.isValidPassword(password) ?? false
        } else {
            passwordToggleVisibilityView.checkmarkVisible = false
        }
    }
}

// MARK: Private helpers
extension PasswordTextField {
    fileprivate func setupViews() {
        let toggleFrame = CGRect(x: 0, y: 0, width: 66, height: frame.height)
        passwordToggleVisibilityView = PasswordToggleVisibilityView(frame: toggleFrame)
        passwordToggleVisibilityView.delegate = self
        passwordToggleVisibilityView.checkmarkVisible = false
        passwordToggleVisibilityView.tintColor = .black
        self.keyboardType = .asciiCapable
        self.rightView = passwordToggleVisibilityView
        self.font = self.preferredFont
        self.addTarget(self, action: #selector(PasswordTextField.passwordTextChanged(_:)), for: .editingChanged)
        
        // if we don't do this, the eye flies in on textfield focus!
        self.rightView?.frame = self.rightViewRect(forBounds: self.bounds)
        
        self.rightViewMode = .whileEditing
        // left view hack to add padding
//        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 3))
//        self.leftViewMode = .always
    }
}


// MARK: UITextFieldDelegate needed calls
// Implement UITextFieldDelegate when you use this, and forward these calls to this class!
protocol PasswordToggleVisibilityDelegate: class {
    func viewWasToggled(_ passwordToggleVisibilityView: PasswordToggleVisibilityView, isSelected selected: Bool)
}

class PasswordToggleVisibilityView: UIView {
    fileprivate let eyeOpenedImage: UIImage
    fileprivate let eyeClosedImage: UIImage
    fileprivate let checkmarkImage: UIImage
    fileprivate let eyeButton: UIButton
    fileprivate let checkmarkImageView: UIImageView
    weak var delegate: PasswordToggleVisibilityDelegate?
    
    enum EyeState {
        case open
        case closed
    }
    
    var eyeState: EyeState {
        set {
            eyeButton.isSelected = newValue == .open
        }
        get {
            return eyeButton.isSelected ? .open : .closed
        }
    }
    
    var checkmarkVisible: Bool {
        set {
            let isHidden = !newValue
            guard checkmarkImageView.isHidden != isHidden else {
                return
            }
            checkmarkImageView.isHidden = isHidden
        }
        get {
            return !checkmarkImageView.isHidden
        }
    }
    
    override var tintColor: UIColor! {
        didSet {
            eyeButton.tintColor = tintColor
            checkmarkImageView.tintColor = tintColor
        }
    }
    
    override init(frame: CGRect) {
        if #available(iOS 13.0, *) {
            self.eyeOpenedImage = R.image.eye()!.withRenderingMode(.alwaysTemplate).withTintColor(.black)
        } else {
            self.eyeOpenedImage = R.image.eyeSelected()!
        }
        if #available(iOS 13.0, *) {
            self.eyeClosedImage = R.image.eye()!.withRenderingMode(.alwaysTemplate).withTintColor(.black)
        } else {
            self.eyeClosedImage = R.image.eyeSelected()!
        }
        if #available(iOS 13.0, *) {
            self.checkmarkImage = R.image.eye()!.withRenderingMode(.alwaysTemplate).withTintColor(.black)
        } else {
            self.checkmarkImage = R.image.eye()!
        }
        self.eyeButton = UIButton(type: .custom)
        self.checkmarkImageView = UIImageView(image: self.checkmarkImage)
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Don't use init with coder.")
    }
    
    fileprivate func setupViews() {
        let padding: CGFloat = 10
        let buttonWidth = (frame.width / 2) - padding
        let buttonFrame = CGRect(x: buttonWidth + padding, y: 0, width: buttonWidth, height: frame.height)
        eyeButton.frame = buttonFrame
        eyeButton.backgroundColor = UIColor.clear
        eyeButton.adjustsImageWhenHighlighted = false
        eyeButton.setImage(self.eyeClosedImage, for: UIControl.State())
        eyeButton.setImage(self.eyeOpenedImage.withRenderingMode(.alwaysTemplate), for: .selected)
        eyeButton.addTarget(self, action: #selector(PasswordToggleVisibilityView.eyeButtonPressed(_:)), for: .touchUpInside)
        eyeButton.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        eyeButton.tintColor = self.tintColor
        self.addSubview(eyeButton)
        
        let checkmarkImageWidth = (frame.width / 2) - padding
        let checkmarkFrame = CGRect(x: padding, y: 0, width: checkmarkImageWidth, height: frame.height)
        checkmarkImageView.frame = checkmarkFrame
        checkmarkImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        checkmarkImageView.contentMode = .center
        checkmarkImageView.backgroundColor = UIColor.clear
        checkmarkImageView.tintColor = self.tintColor
        self.addSubview(checkmarkImageView)
        
        self.checkmarkImageView.isHidden = true
    }
    
    
    @objc func eyeButtonPressed(_ sender: AnyObject) {
        eyeButton.isSelected = !eyeButton.isSelected
        delegate?.viewWasToggled(self, isSelected: eyeButton.isSelected)
    }
}

public class CornerImageView: UIImageView{
    var radius: CGFloat = 0
    
    override public var image: UIImage?{
        didSet{
            self.roundCornersForAspectFit(radius: 15)
        }
    }
}

//
public class RatioBasedImageView : UIImageView {
    /// constraint to maintain same aspect ratio as the image
    private var aspectRatioConstraint:NSLayoutConstraint? = nil

    // This makes it use the correct size in Interface Builder
    public override func prepareForInterfaceBuilder() {
        invalidateIntrinsicContentSize()
    }

    @IBInspectable
    var maxAspectRatio: CGFloat = 999 {
        didSet {
            updateAspectRatioConstraint()
        }
    }

    @IBInspectable
    var minAspectRatio: CGFloat = 0 {
        didSet {
            updateAspectRatioConstraint()
        }
    }


    required public init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.setup()
    }

    public override init(frame:CGRect) {
        super.init(frame:frame)
        self.setup()
    }

    public override init(image: UIImage!) {
        super.init(image:image)
        self.setup()
    }

    public override init(image: UIImage!, highlightedImage: UIImage?) {
        super.init(image:image,highlightedImage:highlightedImage)
        self.setup()
    }

    override public var image: UIImage? {
        didSet { self.updateAspectRatioConstraint() }
    }

    private func setup() {
        self.updateAspectRatioConstraint()
    }

    /// Removes any pre-existing aspect ratio constraint, and adds a new one based on the current image
    private func updateAspectRatioConstraint() {
        // remove any existing aspect ratio constraint
        if let constraint = self.aspectRatioConstraint {
            self.removeConstraint(constraint)
        }
        self.aspectRatioConstraint = nil

        if let imageSize = image?.size, imageSize.height != 0 {
            var aspectRatio = imageSize.width / imageSize.height
            aspectRatio = max(minAspectRatio, aspectRatio)
            aspectRatio = min(maxAspectRatio, aspectRatio)

            let constraint = NSLayoutConstraint(item: self, attribute: .width,
                                       relatedBy: .equal,
                                       toItem: self, attribute: .height,
                                       multiplier: aspectRatio, constant: 0)
            constraint.priority = .required
            self.addConstraint(constraint)
            self.aspectRatioConstraint = constraint
        }
    }
}
