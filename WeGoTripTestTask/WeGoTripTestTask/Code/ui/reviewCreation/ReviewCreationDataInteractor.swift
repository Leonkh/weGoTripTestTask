//
//  ReviewCreationInteractor.swift
//  WeGoTripTestTask
//
//  Created by lr.habibullin on 18.03.2023.
//

import Foundation
import RealmSwift
import Alamofire

protocol ReviewCreationDataInteractor: AnyObject {
    
    func createReviewIfNeeded(completion: @escaping ClosureResult<Review>)
    func updateReview(block: @escaping () -> ()) throws
    func deleteReview()
    // TODO: sendData to Network service
    func sendData(to url: URL, completion: @escaping ClosureResult<Bool>)
    
}

extension ReviewCreationDataInteractor {
    
    func sendData(to url: URL) {
        sendData(to: url, completion: { _ in })
    }
    
}

final class ReviewCreationDataInteractorImpl {
    
    // MARK: - Properties
    
    private lazy var realm = try? Realm()
    
}

extension ReviewCreationDataInteractorImpl: ReviewCreationDataInteractor {
    
    // MARK: - ReviewCreationInteractor
    
    func sendData(to url: URL, completion: @escaping ClosureResult<Bool>) {
        createReviewIfNeeded { result in
            switch result {
            case .success(let review):
                AF.request(url, method: .post, parameters: review, encoder: .json) { response in
                    completion(.success(true))
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    func createReviewIfNeeded(completion: @escaping ClosureResult<Review>) {
        guard let realm = self.realm else {
            return
        }
        
        
        let reviews = realm.objects(Review.self)
        if let review = reviews.first {
            completion(.success(review))
            
        } else {
            let review = Review()
            realm.writeAsync({
                realm.add(review)
            }, onComplete: { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(review))
                }
            })
        }
    }
    
    func updateReview(block: @escaping () -> ()) throws {
        guard let realm = realm else {
            return
        }
        
        try realm.write() {
            block()
        }
    }
    
    func deleteReview() {
        guard let realm = self.realm else {
            return
        }
        
        realm.writeAsync {
            realm.deleteAll()
        }
    }
    
}
