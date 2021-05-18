//
//  LoginPresenter.swift
//  TestMovieApp
//
//  Created by Максим Вечирко on 18.05.2021.
//

protocol LoginPresenterInput {
    var output: LoginPresenterOutput? {get set}
    var buttonIsEnable: Bool {get set}
    func auth(_ method: AuthMethod, with email: String, and password: String)
    func validateFields(_ email: String, password: String)
}

protocol LoginPresenterOutput: class {
    func validateFields()
    func errorMessage(message: String)
}

final class LoginPresenter: LoginPresenterInput {
    weak var output: LoginPresenterOutput?
    
    var buttonIsEnable: Bool = false {
        didSet {
            output?.validateFields()
        }
    }
    
    private var authService: AuthService
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    func validateFields(_ email: String, password: String) {
        buttonIsEnable = email.count >= 3 && password.count >= 6
    }
    
    func auth(_ method: AuthMethod, with email: String, and password: String) {
        authService.auth(method, with: email, and: password) { [weak self] (result) in
            switch result {
            case .success:
                self?.output?.errorMessage(message: "")
            case .failure(let error):
                self?.output?.errorMessage(message: error.localizedDescription)
            }
        }
    }
}
