//
//  AddressFieldContentView.swift
//  DaApp
//
//  Created by Muhammed Demirak on 4/10/22.
//

import Foundation
import UIKit

class AddressFieldContentView: UIView, UIContentView {
    struct Configuration: UIContentConfiguration {
        var addr_text : String? = ""
        var onChange: (String)-> Void = { _ in } // onChange handler w/ default empty handler
        
        func makeContentView() -> UIView & UIContentView {
            return AddressFieldContentView(self)
        }
    }
    
    let addrField = UITextField()
    var configuration: UIContentConfiguration {
        didSet {
            configure(configuration: configuration)
        }
    }
    override var intrinsicContentSize: CGSize {
        CGSize(width: 50, height: 44)
    }

    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        addPinnedSubview(addrField, insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        addrField.addTarget(self, action: #selector(didChange(_:)), for: .editingChanged)
        addrField.clearButtonMode = .whileEditing
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? Configuration else { return }
        addrField.text = configuration.addr_text
    }
    
    @objc private func didChange(_ sender: UITextField) {
        guard let configuration = configuration as? TextFieldContentView.Configuration else { return }
        configuration.onChange(addrField.text ?? "")
    }
}

extension UICollectionViewListCell {
    func addressFieldConfiguration() -> AddressFieldContentView.Configuration {
        AddressFieldContentView.Configuration()
    }
}
