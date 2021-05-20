//
//  ViewController.swift
//  TestMovieApp
//
//  Created by Максим Вечирко on 18.05.2021.
//

import UIKit
import SnapKit

class LoginController: UIViewController {
    
    // MARK: -  Lazy Properties
    
    private lazy var backgroundContainerView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "movie")
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.8
        blurEffectView.frame = imageView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.addSubview(blurEffectView)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var emailField: BrandTextField = {
        let field = BrandTextField()
        field.placeholder = "Email"
        field.addTarget(self, action: #selector(emailTextChanged(sender:)), for: .editingChanged)
        return field
    }()
    
    private lazy var passwordField: BrandTextField = {
        let field = BrandTextField()
        field.placeholder = "Password"
        field.isSecureTextEntry = true
        field.addTarget(self, action: #selector(passwordTextChanged(sender:)), for: .editingChanged)
        return field
    }()
    
    private lazy var loginButton: BrandButton = {
        let button = BrandButton()
        button.setTitle("Sign In", for: .normal)
        button.addTarget(self, action: #selector(signInAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var registerButton: BrandButton = {
        let button = BrandButton()
        button.setTitle("Sign Up", for: .normal)
        button.addTarget(self, action: #selector(signUpAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var warningTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: -  Properties
    
    var presenter: LoginPresenterInput

    // MARK: -  Life Cycle
    
    init(presenter: LoginPresenterInput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundContainerView)
        backgroundContainerView.addSubviews(
            emailField,
            passwordField,
            loginButton,
            registerButton,
            warningTextLabel
        )
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundContainerView.snp.makeConstraints {
            $0.size.equalToSuperview()
        }
        emailField.snp.makeConstraints {
            $0.center.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(10)
            $0.right.equalToSuperview().inset(10)
            $0.height.equalTo(40)
        }
        passwordField.snp.makeConstraints {
            $0.top.equalTo(emailField.snp.bottom).offset(10)
            $0.left.equalToSuperview().inset(10)
            $0.right.equalToSuperview().inset(10)
            $0.height.equalTo(40)
        }
        loginButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(10)
            $0.top.equalTo(passwordField.snp.bottom).offset(10)
            $0.height.equalTo(40)
            $0.width.equalTo(100)
        }
        registerButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(10)
            $0.top.equalTo(loginButton.snp.bottom).offset(10)
            $0.size.equalTo(loginButton.snp.size)
        }
        warningTextLabel.snp.makeConstraints {
            $0.top.equalTo(passwordField.snp.bottom).offset(10)
            $0.left.equalToSuperview().inset(10)
            $0.right.equalTo(loginButton.snp.left).offset(-10)
        }
    }
    
    // MARK: -  Private functions
    
    private func performToTabBarController() {
        let tabBar = TabBarController()
        tabBar.modalPresentationStyle = .fullScreen
        tabBar.modalTransitionStyle = .crossDissolve
        present(tabBar, animated: true, completion: nil)
    }
    
    // MARK: -  Actions
    
    @objc func emailTextChanged(sender: UITextField) {
        presenter.validateFields(emailField.text ?? "", password: passwordField.text ?? "")
    }
    
    @objc func passwordTextChanged(sender: UITextField) {
        presenter.validateFields(emailField.text ?? "", password: passwordField.text ?? "")
    }
    
    @objc func signInAction() {
        presenter.auth(.signIn, with: emailField.text ?? "", and: passwordField.text ?? "")
    }
    
    @objc func signUpAction() {
        presenter.auth(.signUp, with: emailField.text ?? "", and: passwordField.text ?? "")
    }
}

extension LoginController: LoginPresenterOutput {
    
    func performToTabBar() {
        DispatchQueue.main.async {
            self.performToTabBarController()
        }
    }
    
    func validateFields() {
        loginButton.isEnabled = presenter.buttonIsEnable
        registerButton.isEnabled = presenter.buttonIsEnable
    }
    func errorMessage(message: String) {
        DispatchQueue.main.async {
            self.warningTextLabel.text = message
        }
    }
}
