//
//  TextFieldCell.swift
//  WeGoTripTestTask
//
//  Created by lr.habibullin on 19.03.2023.
//

import Foundation
import UIKit

protocol TextFieldCellDelegate: AnyObject {
    
    func didChangeText(text: String?, uuid: UUID)
    func didChangeHeight(uuid: UUID)
    
}

final class TextFieldCell: UITableViewCell {
    
    // MARK: - Constants
    
    private enum Constants {
        static let placeholderTextColor = UIColor.lightGray
        static let mainTextColor = UIColor.black
    }
    
    // MARK: - Model
    
    struct Model: Hashable {
        let uuid: UUID
        let text: String
        let placeholder: String?
        let contentInsets: UIEdgeInsets
        
        init(uuid: UUID,
             text: String,
             placeholder: String?,
             contentInsets: UIEdgeInsets) {
            self.uuid = uuid
            self.text = text
            self.placeholder = placeholder
            self.contentInsets = contentInsets
        }
    }
    
    
    // MARK: - Properties
    
    static var reuseId: String {
        String(describing: self)
    }
    
    private lazy var textView: UITextView = {
        let field = UITextView()
        field.delegate = self
        field.font = UIFont.systemFont(ofSize: 18)
        return field
    }()
    private lazy var padView = UIView()
    private weak var delegate: TextFieldCellDelegate?
    private var viewModel: Model?
    private var contentSizeObserver: NSKeyValueObservation?
    
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
        contentSizeObserver = textView.observe(\.contentSize, options: [.new]) {  [weak self] _, contentSize in
            guard let self = self else {
                return
            }
            guard let newContentSize = contentSize.newValue else {
                return
            }
            
            self.textView.snp.updateConstraints { update in
                update.height.equalTo(newContentSize)
            }
            
            if let uuid = self.viewModel?.uuid {
                self.delegate?.didChangeHeight(uuid: uuid)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Internal methods
    
    func setup(model: Model, delegate: TextFieldCellDelegate) {
        viewModel = model
        self.delegate = delegate
        if model.text.isEmpty {
            textView.text = model.placeholder
            textView.textColor = Constants.placeholderTextColor
        } else {
            textView.text = model.text
            textView.textColor = Constants.mainTextColor
        }
        
        textView.setNeedsLayout()
        textView.layoutIfNeeded()
        textView.snp.updateConstraints { update in
            update.height.equalTo(textView.contentSize.height)
        }
        
        
        padView.snp.updateConstraints { update in
            update.top.equalToSuperview().offset(model.contentInsets.top)
            update.leading.equalToSuperview().offset(model.contentInsets.left)
            update.trailing.equalToSuperview().offset(-model.contentInsets.right)
            update.bottom.equalToSuperview().offset(-model.contentInsets.bottom)
        }
        
    }
    
    
    // MARK: - Private methods
    
    private func setupLayout() {
        padView.addSubview(textView)
        contentView.addSubview(padView)
        
        padView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        textView.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
            make.height.equalTo(CGFloat.zero)
        }
    }
    
    @objc private func textFieldDidChange() {
        guard let model = viewModel else {
            return
        }
        guard textView.text != viewModel?.placeholder else {
            return
        }
        
        delegate?.didChangeText(text: textView.text,
                                uuid: model.uuid)
    }
    
}

extension TextFieldCell: UITextViewDelegate {
    
    // MARK: - UITextViewDelegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == Constants.placeholderTextColor {
            textView.text = ""
            textView.textColor = Constants.mainTextColor
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textFieldDidChange()
        let textWithoutSpacers = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if textWithoutSpacers.isEmpty {
            textView.text = viewModel?.placeholder
            textView.textColor = Constants.placeholderTextColor
        } else {
            textView.textColor = Constants.mainTextColor
        }
    }
    
    
}
