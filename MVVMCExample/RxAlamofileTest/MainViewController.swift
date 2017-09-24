//
//  MainViewController.swift
//  RxAlamofileTest
//
//  Created by Nguyen on 9/23/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class MainViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate let disposeBag = DisposeBag()
    fileprivate let viewModel: RepositoryViewModelType
    
    init(viewModel: RepositoryViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var searchBarText: Observable<String> {
        return searchBar
                .rx
                .text
                .map { $0! }
                .filter { $0.characters.count > 0 }
                .throttle(1, scheduler: MainScheduler.instance)
                .distinctUntilChanged()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension MainViewController {
    fileprivate func setup() {
        tableView.register(UINib(nibName: String(describing: RepositoryCell.self), bundle: nil), forCellReuseIdentifier: String(describing: RepositoryCell.self))
        viewModel.fetchRepositories(for: searchBarText)
            .map { result -> [Repository] in
                switch result {
                case .success(let repositories):
                    return repositories
                case .failure(let error):
                    print(error.localizedDescription)
                    return []
                }
            }
            .drive(tableView.rx.items(cellIdentifier: String(describing: RepositoryCell.self), cellType: RepositoryCell.self)) {
                row, repository, cell in
                cell.titleLabel.text = repository.name
            }
            .addDisposableTo(disposeBag)
        
            tableView.rx.modelSelected(Repository.self)
                    .bind(to: viewModel.repositorySubject)
                    .addDisposableTo(disposeBag)

    }

}
