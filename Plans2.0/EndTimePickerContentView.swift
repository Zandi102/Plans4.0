//
//  EndTimePickerContentView.swift
//  DaApp
//
//  Created by Muhammed Demirak on 4/10/22.
//

import Foundation
import UIKit

class EndTimePickerContentView : UIView, UIContentView {
    
    struct Configuration: UIContentConfiguration {
        var end_time_val = Date()
        var onChange: (Date)->Void = { _ in } // onChange handler w/ default empty handler

        func makeContentView() -> UIView & UIContentView {
            return EndTimePickerContentView(self)
        }
    }
    
    let timePicker = UIDatePicker()
    var configuration: UIContentConfiguration {
        didSet {
            configure(configuration: configuration)
        }
    }

    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        addPinnedSubview(timePicker)
        timePicker.addTarget(self, action: #selector(didPick(_:)), for: .valueChanged)
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .inline
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? Configuration else { return }
        timePicker.date = configuration.end_time_val
    }
    
    @objc private func didPick(_ sender: UIDatePicker) {
        guard let configuration = configuration as? StartTimePickerContentView.Configuration else { return }
        configuration.onChange(sender.date)
    }
}

extension UICollectionViewListCell {
    func endTimePickerConfiguration() -> EndTimePickerContentView.Configuration {
        EndTimePickerContentView.Configuration()
    }
}
