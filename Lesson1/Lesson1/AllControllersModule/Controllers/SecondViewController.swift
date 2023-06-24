import UIKit

class SecondViewController: UIViewController {
    private let firstNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17)
        label.text = "First"
        label.snp.contentHuggingVerticalPriority = 251
        label.snp.contentHuggingHorizontalPriority = 251
        
        return label
    }()
    
    private let secondNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17)
        label.text = "Middle"
        label.snp.contentHuggingVerticalPriority = 251
        label.snp.contentHuggingHorizontalPriority = 251
        
        return label
    }()
    
    private let thirdNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17)
        label.text = "Last"
        label.snp.contentHuggingVerticalPriority = 251
        label.snp.contentHuggingHorizontalPriority = 251
        
        return label
    }()
    
    private let firstNameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter First Name"
        textField.snp.contentHuggingHorizontalPriority = 48
        textField.snp.contentCompressionResistanceHorizontalPriority = 749
        
        return textField
    }()
    
    private let secondNameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter Middle Name"
        textField.snp.contentHuggingHorizontalPriority = 48
        textField.snp.contentCompressionResistanceHorizontalPriority = 749
        
        return textField
    }()
    
    private let thirdNameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter Last Name"
        textField.snp.contentHuggingHorizontalPriority = 48
        textField.snp.contentCompressionResistanceHorizontalPriority = 749
        
        return textField
    }()
    
    private lazy var firstNameStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [firstNameLabel, firstNameTextField]
        )
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.alignment = .firstBaseline
        
        return stackView
    }()
    
    private lazy var secondNameStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [secondNameLabel, secondNameTextField]
        )
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.alignment = .firstBaseline
        
        return stackView
    }()
    
    private lazy var thirdNameStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [thirdNameLabel, thirdNameTextField]
        )
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.alignment = .firstBaseline
        
        return stackView
    }()
    
    private lazy var nameRowsStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [firstNameStackView, secondNameStackView, thirdNameStackView]
        )
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.alignment = .fill
        
        return stackView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person.circle"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.snp.contentCompressionResistanceVerticalPriority = 48
        imageView.snp.contentCompressionResistanceHorizontalPriority = 48
      
        return imageView
    }()
    
    private lazy var upperStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [imageView, nameRowsStackView]
        )
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.alignment = .fill
        
        return stackView
    }()
    
    private let button1: UIButton = {
        let button = UIButton(configuration: .tinted())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Edit", for: .normal)
        
        return button
    }()
    
    private let button2: UIButton = {
        let button = UIButton(configuration: .tinted())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Edit", for: .normal)
        
        return button
    }()
    
    private let button3: UIButton = {
        let button = UIButton(configuration: .tinted())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Edit", for: .normal)
        
        return button
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [button1, button2, button3]
        )
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.alignment = .firstBaseline
        
        return stackView
    }()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .lightGray
        textView.font = .systemFont(ofSize: 17)
        textView.text = "Note:"
        textView.snp.contentHuggingVerticalPriority = 249
        
        return textView
    }()
    
    private lazy var rootStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [upperStackView, textView, buttonStackView]
        )
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.alignment = .fill
        
        return stackView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .white
        
        let guide = view.safeAreaLayoutGuide
        view.addSubview(rootStackView)
        rootStackView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leadingMargin)
            make.trailing.equalTo(view.snp.trailingMargin)
            make.top.equalTo(guide.snp.top).inset(20)
            make.bottom.equalTo(guide.snp.bottom).inset(20)
        }
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(imageView.snp.height)
        }
        
        firstNameTextField.snp.makeConstraints { make in
            make.width.equalTo(secondNameTextField.snp.width)
        }
        
        thirdNameTextField.snp.makeConstraints { make in
            make.width.equalTo(firstNameTextField.snp.width)
        }
    }
}
