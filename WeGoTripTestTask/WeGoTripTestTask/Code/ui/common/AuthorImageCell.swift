//
//  AuthorImage.swift
//  WeGoTripTestTask
//
//  Created by lr.habibullin on 18.03.2023.
//

import Foundation
import UIKit
import Nuke

final class AuthorImageCell: UITableViewCell {
    
    // MARK: - Model
    
    struct Model: Hashable {
        let imageUrl: String
        let contentInsets: UIEdgeInsets
    }
    
    
    // MARK: - Constants
    
    private enum Constants {
        static let authorImageViewSize = CGSize(width: 100, height: 100)
    }
    
    
    // MARK: - Properties
    
    static var reuseId: String {
        String(describing: self)
    }
    
    private lazy var authorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Constants.authorImageViewSize.height / 2
        imageView.clipsToBounds = true
        return imageView
    }()
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
        if let url = URL(string: model.imageUrl) {
            Nuke.loadImage(with: url, into: authorImageView)
        } else {
            // TODO: empty view
        }
        
        
        padView.snp.updateConstraints { update in
            update.top.equalToSuperview().offset(model.contentInsets.top)
            update.leading.equalToSuperview().offset(model.contentInsets.left)
            update.trailing.equalToSuperview().offset(-model.contentInsets.right)
            update.bottom.equalToSuperview().offset(-model.contentInsets.bottom)
        }
    }
    
    
    // MARK: - Private methods
    
    func setupLayout() {
        padView.addSubview(authorImageView)
        contentView.addSubview(padView)
        
        padView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        authorImageView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.size.equalTo(Constants.authorImageViewSize)
        }
    }
    
}
