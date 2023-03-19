//
//  ReviewCreationRatePresenter.swift
//  WeGoTripTestTask
//
//  Created by lr.habibullin on 17.03.2023.
//

import Foundation
import UIKit
import Alamofire

protocol ReviewCreationRatePresenter {
    
    var viewModels: [Any] { get }
    
    func set(delegate: ReviewCreationRateViewDelegate?)
    func viewDidLoad()
    func didSetRating(rating: Rating, from cellUuid: UUID)
    func didTapButton(from cellUuid: UUID)
    
}

final class ReviewCreationRatePresenterImpl {
    
    // MARK: - Constants
    
    private enum Constants {
        static let tourRateCellUuid = UUID()
        static let guideRateCellUuid = UUID()
        static let infoPresentationRateCellUuid = UUID()
        static let navigationRateCellUuid = UUID()
        static let nextButtonCellUuid = UUID()
        static let noAnswerButtonCellUuid = UUID()
        static let authorImageCellInsets = UIEdgeInsets.init(horizontal: 12,
                                                             vertical: 6)
        static let labelCellInsets = UIEdgeInsets.init(horizontal: 12,
                                                       vertical: 6)
        static let rateCellInsets = UIEdgeInsets.init(horizontal: 12,
                                                      vertical: 6)
        static let buttonCellInsets = UIEdgeInsets.init(horizontal: 12,
                                                      vertical: 6)
        static let labelCellFont = UIFont.boldSystemFont(ofSize: 20)
    }
    
    // MARK: - Properties
    
    var viewModels = [Any]()
    weak var view: ReviewCreationRateView?
    private weak var delegate: ReviewCreationRateViewDelegate?
    private let reviewCreationDataInteractor: ReviewCreationDataInteractor
    private let dispatchGroup = DispatchGroup()
    private var review: Review?
    private var avatarUrl: String?
    
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
        
        viewModels.append(LabelCell.Model(text: "Офигенно, вы дошли до конца!\nРасскажите как вам?",
                                          font: Constants.labelCellFont,
                                          contentInsets: Constants.labelCellInsets))
        
        if let review = review {
            viewModels.append(RateParametrCell.Model(uuid: Constants.tourRateCellUuid,
                                                     titleText: "Как вам тур в целом?",
                                                     rating: review.tourRating,
                                                     contentInsets: Constants.rateCellInsets))
            viewModels.append(RateParametrCell.Model(uuid: Constants.guideRateCellUuid,
                                                     titleText: "Понравился гид?",
                                                     rating: review.guideRating,
                                                     contentInsets: Constants.rateCellInsets))
            viewModels.append(RateParametrCell.Model(uuid: Constants.infoPresentationRateCellUuid,
                                                     titleText: "Как вам подача информации?",
                                                     rating: review.infoPresentationRating,
                                                     contentInsets: Constants.rateCellInsets))
            viewModels.append(RateParametrCell.Model(uuid: Constants.navigationRateCellUuid,
                                                     titleText: "Удобная навигация между шагами?",
                                                     rating: review.navigationRating,
                                                     contentInsets: Constants.rateCellInsets))
        }
        
        viewModels.append(ButtonCell.Model(uuid: Constants.nextButtonCellUuid,
                                           text: "Далее",
                                           style: .primary,
                                           contentInsets: Constants.buttonCellInsets))
        viewModels.append(ButtonCell.Model(uuid: Constants.noAnswerButtonCellUuid,
                                           text: "Не хочу отвечать",
                                           style: .secondary,
                                           contentInsets: Constants.buttonCellInsets))
        
        view?.configure()
    }
    
}

extension ReviewCreationRatePresenterImpl: ReviewCreationRatePresenter {
    
    // MARK: - ReviewCreationRatePresenter
    
    func set(delegate: ReviewCreationRateViewDelegate?) {
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
    
    func didSetRating(rating: Rating, from cellUuid: UUID) {
        do {
            try reviewCreationDataInteractor.updateReview { [weak self] in
                guard let self = self else {
                    return
                }
                
                switch cellUuid {
                case Constants.tourRateCellUuid:
                    self.review?.tourRating = rating
                case Constants.guideRateCellUuid:
                    self.review?.guideRating = rating
                case Constants.infoPresentationRateCellUuid:
                    self.review?.infoPresentationRating = rating
                case Constants.navigationRateCellUuid:
                    self.review?.navigationRating = rating
                default:
                    assertionFailure()
                    break
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func didTapButton(from cellUuid: UUID) {
        switch cellUuid {
        case Constants.nextButtonCellUuid:
            delegate?.didTapNextButton()
        case Constants.noAnswerButtonCellUuid:
            delegate?.didTapNoAnswerButton()
        default:
            assertionFailure()
            break
        }
    }
    
}

