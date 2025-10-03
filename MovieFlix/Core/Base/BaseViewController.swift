//
//  BaseViewController.swift
//  MovieFlix
//
//  Created by Emre Simsek on 3.10.2025.
//
import UIKit

protocol BaseViewControllerProtocol: AnyObject {
    func configureVC()
    func configureSubViews()
    func addSubViews()
    func configureConstraints()
}

class BaseViewController<VM: BaseViewModelProtocol>: UIViewController {
    let viewModel: VM

    init(viewModel: VM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

//    override func viewDidLoad() {
//        super.viewDidLoad()
//        viewModel.view = self
//        viewModel.viewDidLoad()
//    }
//
//    func configureVC() {}
//    func configureSubViews() {}
//
//    func addSubViews() {}
//
//    func configureConstraints() {}
}
