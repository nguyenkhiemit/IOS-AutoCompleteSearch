//
//  RepositoryViewModel.swift
//  RxAlamofileTest
//
//  Created by Nguyen on 9/23/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

protocol RepositoryViewModelType: Transitionable {
    
    var repositorySubject: PublishSubject<Repository>{get}
    
    func fetchRepositories(for observableText: Observable<String>) -> Driver<Result<[Repository]>>
}

class RepositoryViewModel: RepositoryViewModelType {
    
    fileprivate let disposeBag = DisposeBag()
    var repositorySubject = PublishSubject<Repository>()
    weak var navigationCoordinator: CoordinatorType?
    
    init() {
        repositorySubject
            .asObservable()
        .subscribe(onNext: {[unowned self] in
            self.navigationCoordinator?.performTransition(transition: .showRepository($0))
        })
        .addDisposableTo(disposeBag)
    }
    
    func fetchRepositories(for observaleText: Observable<String>) -> Driver<Result<[Repository]>> {
        return RepositoryNetworking.fetchRepositories(for: observaleText)
    }
    
}
