//
//  HomeViewController.swift
//  LoginTest
//
//  Created by Rabialco Argana on 08/05/23.
//

import UIKit
import SnapKit

class HomeViewController : UIViewController {
    
    private var userList: [User] = []
    private var userIndex: UserIndex?
    
    private lazy var mainStackView : UIStackView = {
        let mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.spacing = 12
        return mainStackView
    }()
    
    private lazy var whiteView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.isHidden = false
        return view
    }()
    
    private lazy var titlePage : UILabel = {
        let label = UILabel()
        label.text = "USER LIST"
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 90
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: "UserTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var button : UIButton = {
        let button = UIButton()
        button.setTitle("LOGOUT", for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(logoutButtonPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getAllUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        validateAuth()
    }
    
    func validateAuth() {
        if !UserDefaults.standard.bool(forKey: "isLoggedIn") {
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false)
            print("PRESENT LOGIN VIEW CONTROLLER")
        }
        else{
            self.whiteView.isHidden = true
        }
    }
    
    func setupUI() {
        view.backgroundColor = .white
        view.addSubview(mainStackView)
        
        mainStackView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        mainStackView.addSubview(titlePage)
        mainStackView.addSubview(tableView)
        mainStackView.addSubview(button)
        mainStackView.addSubview(whiteView)
        
        titlePage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titlePage.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalToSuperview().inset(90)
        }
        
        button.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        whiteView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func getAllUsers() {
        apiManager.request(.getUsers) { result in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data // Data, your JSON response is probably in here!
                let _ = moyaResponse.statusCode // Int - 200, 401, 500, etc

                do {
                    let userIndexDecoded = try JSONDecoder().decode(UserIndex.self, from: data)
                    self.userIndex = userIndexDecoded
                    guard let userListDecoded = userIndexDecoded.data else{
                        return
                    }
                    self.userList = userListDecoded
                    self.tableView.reloadData()
                }
                catch {
                    print("==================================")
                    print("Error JSONSerialization : \(error.localizedDescription)")
                    print("==================================\n")
                }
            case let .failure(error):
                // TODO: handle the error == best. comment. ever.
                print("==================================")
                print("Error Get All Users : \(error.localizedDescription)")
                print("==================================\n")
            }
        }
    }
    
    @objc func logoutButtonPressed(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Logout?", message: "Are you sure?", preferredStyle: .alert)
        actionSheet.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            let defaults = UserDefaults.standard
            defaults.set(false, forKey: "isLoggedIn")
            print("USER DEFAULT SET TO FALSE")
            strongSelf.validateAuth()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true)
    }
}

// MARK: - TableView Delegates
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Cell setup
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell") as! UserTableViewCell
        
        cell.setData(user: userList[indexPath.row])
        
        return cell
    }
}
