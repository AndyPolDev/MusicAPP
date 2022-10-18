import UIKit

class UserInfoViewController: UIViewController {
    
    private let firstNameLabel: UILabel = {
        let label = UILabel()
        label.text = "First Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let secondNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Second Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ageLabel: UILabel = {
        let label = UILabel()
        label.text = "Age"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let phoneLabel: UILabel = {
        let label = UILabel()
        label.text = "Phone"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Password"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setConstraints()
        setModel()
    }
    
    private func setupViews() {
        title = "Active User"
        view.backgroundColor = .white
        
        stackView = UIStackView(arrangedSubviews: [firstNameLabel,
                                                   secondNameLabel,
                                                   ageLabel,
                                                   phoneLabel,
                                                   emailLabel,
                                                   passwordLabel],
                                axis: .vertical,
                                spacing: 10,
                                distribution: .fillProportionally)
        
        view.addSubview(stackView)
    }
    
    private func setModel() {
        guard let activeUser = DataBase.shared.activeUser else { return }
        firstNameLabel.text = activeUser.firstName
        secondNameLabel.text = activeUser.secondName
        phoneLabel.text = activeUser.phone
        emailLabel.text = activeUser.email
        passwordLabel.text = activeUser.password
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        ageLabel.text = formatter.string(from: activeUser.age)
    }
}

//MARK: - SetConstraints

extension UserInfoViewController {
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
