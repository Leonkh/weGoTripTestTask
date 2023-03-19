//
//  ReviewCreationTextReviewView.swift
//  WeGoTripTestTask
//
//  Created by lr.habibullin on 19.03.2023.
//

import Foundation
import UIKit

protocol ReviewCreationTextReviewViewDelegate: AnyObject {
    
    func didTapSaveButton()
    
    func didTapSkipButton()
    
}

protocol ReviewCreationTextReviewView: UIViewController {
    
    func set(delegate: ReviewCreationTextReviewViewDelegate?)
    func configure()
    
}

final class ReviewCreationTextReviewViewController: UIViewController {
    
    // MARK: - Properties
    
    private let presenter: ReviewCreationTextReviewPresenter
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()
    
    
    // MARK: - Init
    
    init(presenter: ReviewCreationTextReviewPresenter) {
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
        tableView.register(LabelCell.self, forCellReuseIdentifier: LabelCell.reuseId)
        tableView.register(AuthorImageCell.self, forCellReuseIdentifier: AuthorImageCell.reuseId)
        tableView.register(ButtonCell.self, forCellReuseIdentifier: ButtonCell.reuseId)
        tableView.register(TextFieldCell.self, forCellReuseIdentifier: TextFieldCell.reuseId)
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

extension ReviewCreationTextReviewViewController: ReviewCreationTextReviewView {
    
    // MARK: - ReviewCreationRateView
    
    func set(delegate: ReviewCreationTextReviewViewDelegate?) {
        presenter.set(delegate: delegate)
    }
    
    func configure() {
        tableView.reloadData()
    }
    
}

extension ReviewCreationTextReviewViewController: UITableViewDelegate {
    
}

extension ReviewCreationTextReviewViewController: UITableViewDataSource {
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.viewModels.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: cell factory
        guard let model = presenter.viewModels[safe: indexPath.row] else {
            return UITableViewCell()
        }
        switch model {
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
        case let textFieldCelllModel as TextFieldCell.Model:
            if let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.reuseId) as? TextFieldCell {
                cell.setup(model: textFieldCelllModel, delegate: self)
                return cell
            } else {
                return UITableViewCell()
            }
        default:
            return UITableViewCell()
        }
    }
    
}

extension ReviewCreationTextReviewViewController: ButtonCellDelegate {
    
    // MARK: - ButtonCellDelegate
    
    func didTapButton(from cellUuid: UUID) {
        presenter.didTapButton(from: cellUuid)
    }
    
}

extension ReviewCreationTextReviewViewController: TextFieldCellDelegate {
    
    // MARK: - TextFieldCellDelegate
    
    func didChangeText(text: String?, uuid: UUID) {
        presenter.didChangeText(text: text, uuid: uuid)
    }
    
    func didChangeHeight(uuid: UUID) {
        guard let index = presenter.viewModels.firstIndex(where: { ($0 as? TextFieldCell.Model)?.uuid == uuid }) else {
            return
        }
        guard tableView.cellForRow(at: IndexPath(row: index, section: .zero)) != nil else {
             return
        }
        
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
    
    
}

