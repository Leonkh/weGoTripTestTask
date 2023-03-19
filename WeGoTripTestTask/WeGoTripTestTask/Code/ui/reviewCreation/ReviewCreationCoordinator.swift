//
//  ReviewCreationCoordinator.swift
//  WeGoTripTestTask
//
//  Created by lr.habibullin on 17.03.2023.
//

import Foundation
import UIKit
import Swinject

protocol ReviewCreationCoordinator: AnyObject {
    
    var navigationController: UINavigationController? { get set }
    
    func start()
    
}

final class ReviewCreationCoordinatorImpl: NSObject {
    
    // MARK: - Constants
    
    private enum Constants {
        static let firstScreenUrl = URL(string: " https://webhook.site/c8f2041c-c57e-433f-853f-1ef739702903")
        static let secondScreenUrl = URL(string: " https://webhook.site/c8f2041c-c57e-433f-853f-1ef739702903")
    }
    
    
    // MARK: - Properties
    
    weak var navigationController: UINavigationController?
    private let reviewCreationTextReviewViewProvider: Provider<ReviewCreationTextReviewView>
    private let reviewCreationDataInteractor: ReviewCreationDataInteractor
    
    
    // MARK: - Init
    
    init(reviewCreationTextReviewViewProvider: Provider<ReviewCreationTextReviewView>,
         reviewCreationDataInteractor: ReviewCreationDataInteractor) {
        self.reviewCreationTextReviewViewProvider = reviewCreationTextReviewViewProvider
        self.reviewCreationDataInteractor = reviewCreationDataInteractor
    }
    
    
    // MARK: - Private methods
    
    private func pushFinalView(animated: Bool) {
        let reviewCreationTextReviewView = reviewCreationTextReviewViewProvider.instance
        reviewCreationTextReviewView.set(delegate: self)
        reviewCreationTextReviewView.loadViewIfNeeded()
        navigationController?.pushViewController(reviewCreationTextReviewView, animated: animated)
    }
    
    private func configureNavigationBarForFirstScreen() {
        navigationController?.navigationBar.backgroundColor = UIColor(red: 1.0,
                                                                      green: 1.0,
                                                                      blue: 1.0,
                                                                      alpha: .zero)
        if #available(iOS 13.0, *) {
            let apperance = UINavigationBarAppearance()
            apperance.configureWithTransparentBackground()
            UINavigationBar.appearance().standardAppearance = apperance
            UINavigationBar.appearance().compactAppearance = apperance
            UINavigationBar.appearance().scrollEdgeAppearance = apperance
        } else {
            // Fallback on earlier versions
        }
    }
    
    private func configureNavigationBarForSecondScreen() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(),
                                                               for: .default)
        navigationController?.navigationBar.backgroundColor = UIColor(red: 1.0,
                                                                      green: 1.0,
                                                                      blue: 1.0,
                                                                      alpha: 1)
        if #available(iOS 13.0, *) {
            let apperance = UINavigationBarAppearance()
            apperance.configureWithOpaqueBackground()
            UINavigationBar.appearance().standardAppearance = apperance
            UINavigationBar.appearance().compactAppearance = apperance
            UINavigationBar.appearance().scrollEdgeAppearance = apperance
        } else {
            // Fallback on earlier versions
        }
    }
    
}

extension ReviewCreationCoordinatorImpl: ReviewCreationCoordinator {
    
    // MARK: - ReviewCreationCoordinator
    
    func start() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(),
                                                               for: UIBarMetrics.default)
        configureNavigationBarForFirstScreen()
        navigationController?.delegate = self
    }
    
}

extension ReviewCreationCoordinatorImpl: UINavigationControllerDelegate {
    
    // MARK: - UINavigationControllerDelegate
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController == navigationController.viewControllers.first {
            configureNavigationBarForFirstScreen()
        } else {
            configureNavigationBarForSecondScreen()
        }
    }
    
}

extension ReviewCreationCoordinatorImpl: ReviewCreationRateViewDelegate {
    
    // MARK: - ReviewCreationRateViewDelegate
    
    func didTapNextButton() {
        if let url = Constants.firstScreenUrl {
            // TODO: handle error
            reviewCreationDataInteractor.sendData(to: url)
        }
        pushFinalView(animated: true)
    }
    
    func didTapNoAnswerButton() {
        pushFinalView(animated: true)
    }
    
}

extension ReviewCreationCoordinatorImpl: ReviewCreationTextReviewViewDelegate {
    
    // MARK: - ReviewCreationFinalViewDelegate
    
    func didTapSaveButton() {
        if let url = Constants.secondScreenUrl {
            reviewCreationDataInteractor.sendData(to: url, completion: { [weak self] result in
                guard let self = self else {
                    return
                }
                
                switch result {
                case .success(let isSuccess):
                    if isSuccess {
                        self.reviewCreationDataInteractor.deleteReview()
                    } else {
                        // TODO: handle bad request
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    // TODO: maybe needed special handle for error
                    self.reviewCreationDataInteractor.deleteReview()
                }
            })
        }
        
        navigationController?.dismiss(animated: true)
    }
    
    func didTapSkipButton() {
        reviewCreationDataInteractor.deleteReview()
        navigationController?.dismiss(animated: true)
    }
    
}
