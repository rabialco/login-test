//
//  UserTableViewCell.swift
//  LoginTest
//
//  Created by Rabialco Argana on 08/05/23.
//

import Foundation
import SnapKit
import SDWebImage

class UserTableViewCell : UITableViewCell {
    
    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
//        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 23, weight: .semibold)
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .gray
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        self.backgroundColor = .white
        self.selectionStyle = .none
        self.accessoryType = .none
        
        // MARK: - IMAGE VIEW
        self.addSubview(avatarImageView)
        
        // pokemonImageView
        avatarImageView.snp.makeConstraints { make in
            make.height.width.equalTo(60)
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalTo(self)
        }
        
        // MARK: - STACK VIEW
        self.addSubview(mainStackView)
        
        // mainStackView
        mainStackView.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(10)
            make.centerY.equalTo(self)
        }
        
        mainStackView.addSubview(nameLabel)
        
        // nameLabel
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(5)
        }
        
        mainStackView.addSubview(emailLabel)
        
        // emailLabel
        emailLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(5)
        }
    }
    
    func setData(user: User) {
        guard let firstName = user.firstName, let lastName = user.lastName, let email = user.email, let avatar = user.avatar else {
            print("User Data Nil when setData")
            return
        }
        self.nameLabel.text = "\(firstName) \(lastName)"
        self.emailLabel.text = "\(email)"
        self.avatarImageView.sd_setImage(with: URL(string: avatar))
    }
}
