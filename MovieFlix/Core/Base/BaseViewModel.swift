//
//  BaseViewModel.swift
//  MovieFlix
//
//  Created by Emre Simsek on 3.10.2025.
//

protocol BaseViewModelProtocol: AnyObject {
    var view: BaseViewControllerProtocol? { get set }
    func viewDidLoad()
}

class BaseViewModel: BaseViewModelProtocol {
    weak var view: BaseViewControllerProtocol?
    func viewDidLoad() {
        view?.configureVC()
        view?.configureSubViews()
        view?.addSubViews()
        view?.configureConstraints()
    }
}
