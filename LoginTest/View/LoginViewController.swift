//
//  LoginViewController.swift
//  LoginTest
//
//  Created by Rabialco Argana on 08/05/23.
//

import UIKit
import SnapKit
import Moya

class LoginViewController: UIViewController {
    
    private lazy var mainStackView : UIStackView = {
        let mainStackView = UIStackView()
        mainStackView.axis = .vertical
        return mainStackView
    }()
    
    private lazy var loadingView: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView()
        loadingView.color = UIColor.red
        loadingView.isHidden = true
        return loadingView
    }()
    
    private lazy var whiteView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.isHidden = true
        return view
    }()
    
    private lazy var loginTextLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.text = "LOGIN"
        return label
    }()
    
    private lazy var emailTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.autocapitalizationType = .none
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return textField
    }()
    
    private lazy var passwordTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.autocapitalizationType = .none
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var loginButton : UIButton = {
        let button = UIButton()
        button.setTitle("LOGIN", for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        view.addSubview(mainStackView)
        view.addSubview(whiteView)
        view.addSubview(loadingView)
        
        // MARK: - Main Stack View
        // mainStackView
        mainStackView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        // MARK: - White View
        // whiteView
        whiteView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        // MARK: - Loading View
        // loadingView
        loadingView.snp.makeConstraints { make in
            make.height.width.equalTo(20)
            make.centerX.centerY.equalToSuperview()
        }
        
        mainStackView.addSubview(loginTextLabel)
        
        mainStackView.addSubview(emailTextField)
        
        mainStackView.addSubview(passwordTextField)

        mainStackView.addSubview(loginButton)
        
        loginTextLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(200)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(loginTextLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.width.equalTo(100)
        }

    }
    
    @objc func loginButtonPressed(_ sender: Any) {
        if(emailTextField.text?.isEmpty ?? false || passwordTextField.text?.isEmpty ?? false){
            self.showAlert("Error", message: "Please fill all the details")
        } else {
            loadingView.isHidden = false
            whiteView.isHidden = false
            let email : String = emailTextField.text ?? ""
            let password : String = passwordTextField.text ?? ""
            requestLoginAPI(emailInput: email, passwordInput: password)
        }
    }
    
    fileprivate func showAlert(_ title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func goToHomeView(alert: UIAlertAction!) {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "isLoggedIn")
        self.navigationController?.dismiss(animated: false)
    }

    func requestLoginAPI(emailInput: String, passwordInput: String) {
        let parameters: [String: Any] = [
            "email" : emailInput,
            "password" : passwordInput
        ]
        
        apiManager.request(.login(parameters)) { result in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data // Data, your JSON response is probably in here!
                let statusCode = moyaResponse.statusCode // Int - 200, 401, 500, etc

                if statusCode == 200 {
                    guard let decodedData = try? JSONDecoder().decode(LoginResponse.self, from: data), let token = decodedData.token else {
                        self.showAlert("Error Login", message: "Login Response Wrong")
                        return
                    }
                    let alert = UIAlertController(title: "Successfully Logged In", message: "Token : \(token)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK",style: .destructive,handler: self.goToHomeView))
                    DispatchQueue.main.async { self.present(alert, animated: true) }
                }
                else {
                    guard let errorData = try? JSONDecoder().decode(LoginResponseError.self, from: data) else {
                        self.showAlert("Error Login", message: "Login Response Error Wrong")
                        return
                    }
                    
                    self.showAlert("Error Login", message: "Response Error : \(String(describing: errorData.error))")
                }
            case let .failure(error):
                // TODO: handle the error == best. comment. ever.
                print("==================================")
                self.showAlert("Error Login", message: "Please fill in the correct credential")
                print("Error Login : \(error.localizedDescription)")
                print("==================================\n")
            }
            self.loadingView.isHidden = true
            self.whiteView.isHidden = true
        }
    }
}

