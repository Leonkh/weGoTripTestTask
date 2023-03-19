//
//  LabelCell.swift
//  WeGoTripTestTask
//
//  Created by lr.habibullin on 18.03.2023.
//

import Foundation
import UIKit

final class LabelCell: UITableViewCell {
    
    // MARK: - Model
    
    struct Model: Hashable {
        let text: String
        let font: UIFont
        let numberOfLines: Int
        let contentInsets: UIEdgeInsets
        
        init(text: String,
             font: UIFont,
             numberOfLines: Int = .zero,
             contentInsets: UIEdgeInsets) {
            self.text = text
            self.font = font
            self.numberOfLines = numberOfLines
            self.contentInsets = contentInsets
        }
    }
    
    // MARK: - Properties
    
    static var reuseId: String {
        String(describing: self)
    }
    
    private lazy var titleLabel = UILabel()
    private lazy var padView = UIView()
    
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Internal methods
    
    func setup(model: Model) {
        titleLabel.text = model.text
        titleLabel.font = model.font
        titleLabel.numberOfLines = model.numberOfLines
        
        padView.snp.updateConstraints { update in
            update.top.equalToSuperview().offset(model.contentInsets.top)
            update.leading.equalToSuperview().offset(model.contentInsets.left)
            update.trailing.equalToSuperview().offset(-model.contentInsets.right)
            update.bottom.equalToSuperview().offset(-model.contentInsets.bottom)
        }
    }
    
    
    // MARK: - Private methods
    
    func setupLayout() {
        padView.addSubview(titleLabel)
        contentView.addSubview(padView)
        
        padView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }
    }
    
}
