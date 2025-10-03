//
//  LoginView.swift
//  MovieFlix
//
//  Created by Emre Simsek on 3.10.2025.
//
import Combine
import UIKit

protocol LoginViewProtocol: AnyObject {
    func configureView()
    func configureSubViews()
    func addSubViews()
    func configureConstraints()
    func startActivityIndicator()
    func stopActivityIndicator()
    func showErrorMessage(_ message: String)
}

final class LoginView: UIViewController {
    private let viewModel: LoginViewModel
    private var bindings = Set<AnyCancellable>()
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let loginButton = UIButton(type: .system)
    private let errorLabel = UILabel()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private lazy var stack = UIStackView(arrangedSubviews: [errorLabel, loginButton])

    init(viewModel: LoginViewModel = LoginViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        viewModel.viewDidLoad()
    }
}

extension LoginView: LoginViewProtocol {
    func configureView() {
        view.backgroundColor = .green
    }

    func configureSubViews() {
        // Configure EmailTextField
        emailTextField.placeholder = LocaleKeys.Login.emailPlaceholder
        emailTextField.backgroundColor = .secondarySystemBackground
        emailTextField.borderStyle = .roundedRect
        emailTextField.textPublisher
            .assign(to: \.emailValue, on: viewModel)
            .store(in: &bindings)

        // Configure PasswordTextField
        passwordTextField.placeholder = LocaleKeys.Login.passwordPlaceholder
        passwordTextField.backgroundColor = .secondarySystemBackground
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.textPublisher
            .assign(to: \.passwordValue, on: viewModel)
            .store(in: &bindings)

        // Configure ErrorLabel
        errorLabel.textColor = .red
        errorLabel.text = "viewModel.errorMessage"
        errorLabel.font = .preferredFont(forTextStyle: .callout)
        errorLabel.isHidden = true

        // Error Label Bindings
        viewModel.$errorMessage
            .map { ($0?.isEmpty ?? true) }
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .sink { [weak self] hidden in
                guard let self = self else { return }
                UIView.animate(withDuration: 0.2) {
                    self.errorLabel.isHidden = hidden
                    self.view.layoutIfNeeded()
                }
            }
            .store(in: &bindings)

        viewModel.$errorMessage
            .map { $0 ?? "" }
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .assign(to: \.text, on: errorLabel)
            .store(in: &bindings)

        // Configure LoginButton
        var configuration = UIButton.Configuration.filled()
        configuration.title = LocaleKeys.Login.loginButton
        configuration.background.cornerRadius = 8
        configuration.buttonSize = .large
        loginButton.configuration = configuration
        loginButton.addAction(UIAction { _ in
            self.viewModel.onClickLoginButton()
        }, for: .touchUpInside)

        // Configure StackView
        stack.axis = .vertical
        stack.spacing = 10
    }

    func startActivityIndicator() {
        view.isUserInteractionEnabled = false
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }

    func stopActivityIndicator() {
        view.isUserInteractionEnabled = true
        activityIndicator.stopAnimating()
    }

    func showErrorMessage(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }

    func addSubViews() {
        for item in [emailTextField, passwordTextField, activityIndicator, stack] {
            view.addSubview(item)
            item.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    func configureConstraints() {
        NSLayoutConstraint.activate([
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30.0),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40.0),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40.0),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),

            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10.0),
            passwordTextField.centerXAnchor.constraint(equalTo: emailTextField.centerXAnchor),
            passwordTextField.widthAnchor.constraint(equalTo: emailTextField.widthAnchor, multiplier: 1.0),
            passwordTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor),

            stack.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10.0),
            stack.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),

//            errorLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10),
//            errorLabel.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
//            errorLabel.centerXAnchor.constraint(equalTo: passwordTextField.centerXAnchor),

//            loginButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 10.0),
//            loginButton.centerXAnchor.constraint(equalTo: emailTextField.centerXAnchor),
//            loginButton.widthAnchor.constraint(equalToConstant: 220.0),
//            loginButton.heightAnchor.constraint(equalToConstant: 40.0),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.heightAnchor.constraint(equalToConstant: 50),
            activityIndicator.widthAnchor.constraint(equalToConstant: 50.0)

        ])
    }
}

#Preview {
    LoginView()
}
