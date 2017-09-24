//
//  ReponsitoryNetworking.swift
//  RxAlamofileTest
//
//  Created by Nguyen on 9/23/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxAlamofire
import Alamofire
import ObjectMapper

enum CommonError: Error {
    case parstringError
    case networkError
}

struct RepositoryNetworking {
    static func fetchRepositories(for repositoryName: Observable<String>) -> Driver<Result<[Repository]>> {
        return repositoryName.subscribeOn(MainScheduler.instance)
            .do(onNext: {
                _ in
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            })
            .flatMapLatest {
                text in
                return requestJSON(.get, "https://api.github.com/users/\(text)/repos").debug()
            }
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map {(response, json) -> Result<[Repository]> in
                if response.statusCode == 200 {
                    guard let json = json as? [[String : Any]] else {
                        return .failure(CommonError.parstringError)
                    }
                    
                    if let repos = Mapper<Repository>().mapArray(JSONArray: json) {
                        return .success(repos)
                    } else {
                        return .failure(CommonError.parstringError)
                    }
                } else {
                    return .failure(CommonError.networkError)
                }
            }
            .observeOn(MainScheduler.instance)
            .do(onNext: {
                _ in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            })
            .asDriver(onErrorJustReturn: .failure(CommonError.parstringError))
    }
}
