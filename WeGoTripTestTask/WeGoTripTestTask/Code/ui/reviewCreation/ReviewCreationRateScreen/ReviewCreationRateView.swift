//
//  ReviewCreationRateView.swift
//  WeGoTripTestTask
//
//  Created by lr.habibullin on 17.03.2023.
//

import Foundation
import UIKit

protocol ReviewCreationRateViewDelegate: AnyObject {
    
    func didTapNextButton()
    
    func didTapNoAnswerButton()
    
}

protocol ReviewCreationRateView: UIViewController {
    
    func set(delegate: ReviewCreationRateViewDelegate?)
    func configure()
}

final class ReviewCreationRateViewController: UIViewController {
    
    // MARK: - Properties
    
    private let presenter: ReviewCreationRatePresenter
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    
    // MARK: - Init
    
    init(presenter: ReviewCreationRatePresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupLayout()
        registerCells()
        presenter.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.roundCorners([.topLeft, .topRight], radius: 6)
    }
    
    
    // MARK: - Private methods
    
    private func registerCells() {
        tableView.register(RateParametrCell.self, forCellReuseIdentifier: RateParametrCell.reuseId)
        tableView.register(LabelCell.self, forCellReuseIdentifier: LabelCell.reuseId)
        tableView.register(AuthorImageCell.self, forCellReuseIdentifier: AuthorImageCell.reuseId)
        tableView.register(ButtonCell.self, forCellReuseIdentifier: ButtonCell.reuseId)
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(view.safeAreaInsets.bottom)
        }
    }
    
}

extension ReviewCreationRateViewController: ReviewCreationRateView {
    
    // MARK: - ReviewCreationRateView
    
    func set(delegate: ReviewCreationRateViewDelegate?) {
        presenter.set(delegate: delegate)
    }
    
    func configure() {
        tableView.reloadData()
    }
    
}

extension ReviewCreationRateViewController: UITableViewDelegate { }

extension ReviewCreationRateViewController: UITableViewDataSource {
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.viewModels.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: cell factory
        guard let model = presenter.viewModels[safe: indexPath.row] else {
            return UITableViewCell()
        }
        switch model {
        case let rateParametrCellModel as RateParametrCell.Model:
            if let cell = tableView.dequeueReusableCell(withIdentifier: RateParametrCell.reuseId) as? RateParametrCell {
                cell.setup(model: rateParametrCellModel, delegate: self)
                return cell
            } else {
                return UITableViewCell()
            }
        case let labelCellCellModel as LabelCell.Model:
            if let cell = tableView.dequeueReusableCell(withIdentifier: LabelCell.reuseId) as? LabelCell {
                cell.setup(model: labelCellCellModel)
                return cell
            } else {
                return UITableViewCell()
            }
        case let authorImageCelllModel as AuthorImageCell.Model:
            if let cell = tableView.dequeueReusableCell(withIdentifier: AuthorImageCell.reuseId) as? AuthorImageCell {
                cell.setup(model: authorImageCelllModel)
                return cell
            } else {
                return UITableViewCell()
            }
        case let buttonCellModel as ButtonCell.Model:
            if let cell = tableView.dequeueReusableCell(withIdentifier: ButtonCell.reuseId) as? ButtonCell {
                cell.setup(model: buttonCellModel, delegate: self)
                return cell
            } else {
                return UITableViewCell()
            }
        default:
            return UITableViewCell()
        }
    }
    
}

extension ReviewCreationRateViewController: RateParametrCellDelegate {
    
    // MARK: - RateParametrCellDelegate
    
    func didSetRating(rating: Rating, from cellUuid: UUID) {
        presenter.didSetRating(rating: rating, from: cellUuid)
    }
    
}

extension ReviewCreationRateViewController: ButtonCellDelegate {
    
    // MARK: - ButtonCellDelegate
    
    func didTapButton(from cellUuid: UUID) {
        presenter.didTapButton(from: cellUuid)
    }
    
}
