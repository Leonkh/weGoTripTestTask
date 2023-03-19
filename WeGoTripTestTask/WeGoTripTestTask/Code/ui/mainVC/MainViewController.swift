//
//  MainViewController.swift
//  WeGoTripTestTask
//
//  Created by lr.habibullin on 17.03.2023.
//

import UIKit
import SnapKit

protocol MainView: UIViewController {
    
}

final class MainViewController: UIViewController {
    
    // MARK: - Constants
     
    private enum Constants {
        static let backgroundColor: UIColor = .white
        static let createReviewButtonTextColor: UIColor = .black
        static let createReviewButtonBackgroundColor: UIColor = .lightGray
        static let createReviewButtonHeight: CGFloat = 40
    }
    
    // MARK: - Properties
    
    private lazy var createReviewButton: UIButton = {
        let button = UIButton()
        button.setTitle("Write a review",
                        for: .normal)
        button.setTitleColor(Constants.createReviewButtonTextColor,
                             for: .normal)
        button.addTarget(self, action: #selector(didTapCreateReviewButton),
                         for: .touchUpInside)
        button.setBackgroundImage(UIImage.from(color: Constants.createReviewButtonBackgroundColor),
                                  for: .normal)
        return button
    }()
    private let presenter: MainPresenter
    
    
    // MARK: - Init
    
    init(presenter: MainPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Constants.backgroundColor
        setupLayout()
        presenter.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        createReviewButton.roundCorners(.allCorners,
                                        radius: Constants.createReviewButtonHeight / 2)
    }
    
    // MARK: - Private methods
    
    private func setupLayout() {
        view.addSubview(createReviewButton)
        
        createReviewButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
            make.height.equalTo(Constants.createReviewButtonHeight)
        }
    }
    
    @objc private func didTapCreateReviewButton() {
        presenter.didTapCreateReviewButton()
    }


}

extension MainViewController: MainView {
    
    // MARK: - MainView
    
}

