//
//  ReviewCreationFinalPresenter.swift
//  WeGoTripTestTask
//
//  Created by lr.habibullin on 19.03.2023.
//


import UIKit
import Alamofire

protocol ReviewCreationTextReviewPresenter {
    
    var viewModels: [Any] { get }
    
    func set(delegate: ReviewCreationTextReviewViewDelegate?)
    func viewDidLoad()
    func didTapButton(from cellUuid: UUID)
    func didChangeText(text: String?, uuid: UUID)
    
}

final class ReviewCreationTextReviewPresenterImpl {
    
    // MARK: - Constants
    
    private enum Constants {
        static let saveButtonCellUuid = UUID()
        static let skipButtonCellUuid = UUID()
        static let reviewTextFieldCellUuid = UUID()
        static let wishesTextFieldCellUuid = UUID()
        static let authorImageCellInsets = UIEdgeInsets.init(horizontal: 12,
                                                             vertical: 6)
        static let labelCellInsets = UIEdgeInsets.init(horizontal: 12,
                                                       vertical: 6)
        static let textFieldCellInsets = UIEdgeInsets.init(horizontal: 12,
                                                      vertical: 6)
        static let buttonCellInsets = UIEdgeInsets.init(horizontal: 12,
                                                      vertical: 6)
        static let labelCellFont = UIFont.boldSystemFont(ofSize: 20)
    }
    
    // MARK: - Properties
    
    var viewModels = [Any]()
    weak var view: ReviewCreationTextReviewView?
    private weak var delegate: ReviewCreationTextReviewViewDelegate?
    private let reviewCreationDataInteractor: ReviewCreationDataInteractor
    private var review: Review?
    private var avatarUrl: String?
    private let dispatchGroup = DispatchGroup()
    private var debounceTimer: Timer?
    
    
    // MARK: - Init
    
    init(reviewCreationDataInteractor: ReviewCreationDataInteractor) {
        self.reviewCreationDataInteractor = reviewCreationDataInteractor
    }
    
    // MARK: - Private methods
    
    private func configureView() {
        viewModels.removeAll()
        
        if let avatarUrl = avatarUrl {
            viewModels.append(AuthorImageCell.Model(imageUrl: avatarUrl,
                                                    contentInsets: Constants.authorImageCellInsets))
        }
        
        if let review = review {
            viewModels.append(LabelCell.Model(text: "Что особенно понравилось в этом туре?",
                                              font: Constants.labelCellFont,
                                              contentInsets: Constants.labelCellInsets))
            
            viewModels.append(TextFieldCell.Model(uuid: Constants.reviewTextFieldCellUuid,
                                                  text: review.reviewText ?? "",
                                                  placeholder: "Напишите здесь, чем вам запомнился тур, посоветуете ли его друзьям и как удалось ли повеселиться",
                                                  contentInsets: Constants.textFieldCellInsets))
            
            viewModels.append(LabelCell.Model(text: "Как мы могли бы улучшить подачу информации?",
                                              font: Constants.labelCellFont,
                                              contentInsets: Constants.labelCellInsets))
            
            viewModels.append(TextFieldCell.Model(uuid: Constants.wishesTextFieldCellUuid,
                                                  text: review.wishesText ?? "",
                                                  placeholder: "Напишите здесь, чем вам запомнился тур, посоветуете ли его друзьям и как удалось ли повеселиться",
                                                  contentInsets: Constants.textFieldCellInsets))
        }
        
        viewModels.append(ButtonCell.Model(uuid: Constants.saveButtonCellUuid,
                                           text: "Сохранить отзыв",
                                           style: .primary,
                                           contentInsets: Constants.buttonCellInsets))
        viewModels.append(ButtonCell.Model(uuid: Constants.skipButtonCellUuid,
                                           text: "Пропустить",
                                           style: .secondary,
                                           contentInsets: Constants.buttonCellInsets))
        
        view?.configure()
    }
    
}

extension ReviewCreationTextReviewPresenterImpl: ReviewCreationTextReviewPresenter {
    
    // MARK: - ReviewCreationRatePresenter
    
    func set(delegate: ReviewCreationTextReviewViewDelegate?) {
        self.delegate = delegate
    }
    
    func viewDidLoad() {
        // TODO: loading state
        
        dispatchGroup.enter()
        AF.request("https://app.wegotrip.com/api/v2/products/3728/").responseDecodable(of: ImageDataResponse.self) { [weak self] result in
            guard let self = self else {
                return
            }
            
            self.avatarUrl = result.value?.data.author.avatar
            self.dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        reviewCreationDataInteractor.createReviewIfNeeded { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let review):
                self.review = review
            case .failure(let error):
                // TODO: empty state
                print(error.localizedDescription)
            }
            self.dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.configureView()
        }
    }
    
    func didTapButton(from cellUuid: UUID) {
        switch cellUuid {
        case Constants.saveButtonCellUuid:
            delegate?.didTapSaveButton()
        case Constants.skipButtonCellUuid:
            delegate?.didTapSkipButton()
        default:
            assertionFailure()
            break
        }
    }
    
    func didChangeText(text: String?, uuid: UUID) {
        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5,
                                             repeats: false,
                                             block: { [weak self] _ in
            guard let self = self else {
                return
            }
            do {
                try self.reviewCreationDataInteractor.updateReview { [weak self] in
                    guard let self = self else {
                        return
                    }
                    
                    switch uuid {
                    case Constants.reviewTextFieldCellUuid:
                        self.review?.reviewText = text
                    case Constants.wishesTextFieldCellUuid:
                        self.review?.wishesText = text
                    default:
                        assertionFailure()
                        break
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        })
    }
    
}

