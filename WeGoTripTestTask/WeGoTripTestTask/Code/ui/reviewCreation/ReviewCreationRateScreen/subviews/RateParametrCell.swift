//
//  RateParametrCell.swift
//  WeGoTripTestTask
//
//  Created by lr.habibullin on 17.03.2023.
//

import Foundation
import UIKit

protocol RateParametrCellDelegate: AnyObject {
    
    func didSetRating(rating: Rating, from cellUuid: UUID)
    
}

final class RateParametrCell: UITableViewCell {
    
    // MARK: - Model
    
    struct Model: Hashable {
        let uuid: UUID
        let titleText: String
        let rating: Rating
        let contentInsets: UIEdgeInsets
    }
    
    // MARK: - Constants
    
    private enum Constants {
        static let titleLabelNumberOfLines: Int = .zero
    }
    
    
    // MARK: - Properties
    
    static var reuseId: String {
        String(describing: self)
    }
    
    private lazy var padView = UIView()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = Constants.titleLabelNumberOfLines
        return label
    }()
    private lazy var ratingSlider: StepSliderView = {
        let slider = StepSliderView()
        slider.minimumValue = 1
        slider.maximumValue = Rating.allCases.count
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        return slider
    }()
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.baselineAdjustment = .alignCenters
        label.textAlignment = .center
        return label
    }()
    private weak var delegate: RateParametrCellDelegate?
    private var viewModel: Model?
    
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Internal methods
    
    func setup(model: Model, delegate: RateParametrCellDelegate?) {
        self.delegate = delegate
        self.viewModel = model
        titleLabel.text = model.titleText
        ratingSlider.value = model.rating.rawValue
        setupRatingLabel(with: model.rating)
        
        padView.snp.updateConstraints { update in
            update.top.equalToSuperview().offset(model.contentInsets.top)
            update.leading.equalToSuperview().offset(model.contentInsets.left)
            update.trailing.equalToSuperview().offset(-model.contentInsets.right)
            update.bottom.equalToSuperview().offset(-model.contentInsets.bottom)
        }
    }
    
    // MARK: - Private methods
    
    private func setupRatingLabel(with rating: Rating) {
        let text: String
        switch rating {
        case .veryBad:
            text = "😡"
        case .bad:
            text = "😒"
        case .neutral:
            text = "😐"
        case .good:
            text = "🙂"
        case .veryGood:
            text = "🥳"
        }
        ratingLabel.text = text
    }
    
    private func setupLayout() {
        [titleLabel, ratingSlider, ratingLabel].forEach {
            padView.addSubview($0)
        }
        
        contentView.addSubview(padView)
        
        padView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.trailing.lessThanOrEqualTo(ratingLabel.snp.leading).offset(-12)
        }
        
        ratingSlider.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
    }
    
    @objc func sliderValueChanged() {
        guard let rating = Rating(rawValue: Int(ratingSlider.value)) else {
            assertionFailure()
            return
        }
        guard let uuid = viewModel?.uuid else {
            return
        }
        
        setupRatingLabel(with: rating)
        delegate?.didSetRating(rating: rating, from: uuid)
    }
    
}
