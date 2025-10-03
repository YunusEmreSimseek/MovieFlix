//
//  LoginViewModel.swift
//  MovieFlix
//
//  Created by Emre Simsek on 3.10.2025.
//
import Combine
import UIKit

protocol LoginViewModelProtocol {
    var view: LoginViewProtocol? { get set }
    func viewDidLoad()
    func onClickLoginButton()
    func startLoading()
    func stopLoading()
    func checkValidateLogin() -> Bool
}

final class LoginViewModel {
    weak var view: LoginViewProtocol?
    @Published var emailValue: String = ""
    @Published var passwordValue: String = ""
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
}

extension LoginViewModel: LoginViewModelProtocol {
    func viewDidLoad() {
        view?.configureView()
        view?.configureSubViews()
        view?.addSubViews()
        view?.configureConstraints()
    }

    func onClickLoginButton() {
        startLoading()
        let result = checkValidateLogin()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.stopLoading()
            if !result {
                print("Login Failed")
                self.errorMessage = "Login Failed"
                return
            }
            print("Login Success")
            self.errorMessage = nil
            NavigationManager.shared.push(HomeViewController())
        }
    }

    func startLoading() {
        isLoading = true
        view?.startActivityIndicator()
    }

    func stopLoading() {
        isLoading = false
        view?.stopActivityIndicator()
    }

    func checkValidateLogin() -> Bool {
        guard emailValue == "emre@test.com", passwordValue == "Emre123."
        else { return false }
        return true
    }
}
