//
//  HomeViewModel.swift
//  MovieFlix
//
//  Created by Emre Simsek on 3.10.2025.
//

protocol HomeViewModelProtocol: BaseViewModelProtocol {}

final class HomeViewModel: BaseViewModel {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension HomeViewModel: HomeViewModelProtocol {}
