//
//  ButtonCell.swift
//  WeGoTripTestTask
//
//  Created by lr.habibullin on 18.03.2023.
//

import Foundation
import UIKit

protocol ButtonCellDelegate: AnyObject {
    
    func didTapButton(from cellUuid: UUID)
    
}

final class ButtonCell: UITableViewCell {
    
    // MARK: - Constants
    
    private enum Constants {
        static let buttonHeight: CGFloat = 60
        static let buttonPrimaryBackgroundColor: UIColor = UIColor(red: 84 / 255,
                                                                   green: 72 / 255,
                                                                   blue: 239 / 255,
                                                                   alpha: 1)
        static let buttonPrimaryForegroundColor: UIColor = .white
        static let buttonSecondaryBackgroundColor: UIColor = .white
        static let buttonSecondaryForegroundColor: UIColor = .lightGray
    }
    
    // MARK: - Model
    
    struct Model: Hashable {
        
        enum Style: Hashable {
            case primary
            case secondary
        }
        
        let uuid: UUID
        let text: String
        let style: Style
        let contentInsets: UIEdgeInsets
        
        init(uuid: UUID,
             text: String,
             style: Style,
             contentInsets: UIEdgeInsets) {
            self.uuid = uuid
            self.text = text
            self.style = style
            self.contentInsets = contentInsets
        }
    }
    
    
    // MARK: - Properties
    
    static var reuseId: String {
        String(describing: self)
    }
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.cornerRadius = Constants.buttonHeight / 3
        button.clipsToBounds = true
        return button
    }()
    private lazy var padView = UIView()
    private weak var delegate: ButtonCellDelegate?
    private var viewModel: Model?
    
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Internal methods
    
    func setup(model: Model, delegate: ButtonCellDelegate?) {
        viewModel = model
        self.delegate = delegate
        
        button.setTitle(model.text, for: .normal)
        applyStyle(model.style)
        
        padView.snp.updateConstraints { update in
            update.top.equalToSuperview().offset(model.contentInsets.top)
            update.leading.equalToSuperview().offset(model.contentInsets.left)
            update.trailing.equalToSuperview().offset(-model.contentInsets.right)
            update.bottom.equalToSuperview().offset(-model.contentInsets.bottom)
        }
    }
    
    
    // MARK: - Private methods
    
    private func setupLayout() {
        padView.addSubview(button)
        contentView.addSubview(padView)
        
        padView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        button.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
            make.height.equalTo(Constants.buttonHeight)
        }
    }
    
    private func applyStyle(_ style: Model.Style) {
        switch style {
        case .primary:
            button.setTitleColor(Constants.buttonPrimaryForegroundColor, for: .normal)
            button.setBackgroundImage(UIImage.from(color: Constants.buttonPrimaryBackgroundColor), for: .normal)
            
        case .secondary:
            button.setTitleColor(Constants.buttonSecondaryForegroundColor, for: .normal)
            button.setBackgroundImage(UIImage.from(color: Constants.buttonSecondaryBackgroundColor),
                                      for: .normal)
        }
    }
    
    @objc private func didTapButton() {
        guard let viewModel = viewModel else {
            return
        }
        
        delegate?.didTapButton(from: viewModel.uuid)
    }
    
}
