import UIKit
import SnapKit

class DetailViewController: UIViewController {
    var post: Post!
    
    private lazy var postUserIdLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20)
        label.text = "User id: \(post.userId)"
        
        return label
    }()
    
    private lazy var postTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20)
        label.text = "Title: \(post.title)"
        
        return label
    }()
    
    private lazy var postBodyTextView: UITextView = {
        let textView = UITextView()
        textView.contentMode = .scaleToFill
        textView.font = .systemFont(ofSize: 17)
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = post?.body
        textView.backgroundColor = .systemGroupedBackground
        textView.layer.cornerRadius = 10
        
        return textView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = . scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .systemGroupedBackground
        
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        getImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        postBodyTextView.becomeFirstResponder()
    }
    
    private func setupUI() {
        title = "Post №\(post.id)"
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .systemBackground
        
        let guide = view.safeAreaLayoutGuide
        view.addSubview(postUserIdLabel)
        postUserIdLabel.snp.makeConstraints { make in
            make.top.equalTo(guide).inset(10)
            make.leading.equalTo(view.snp.leadingMargin)
            make.trailing.equalTo(view.snp.trailingMargin)
        }
        
        view.addSubview(postTitleLabel)
        postTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(postUserIdLabel.snp.bottom).inset(-10)
            make.leading.equalTo(view.snp.leadingMargin)
            make.trailing.equalTo(view.snp.trailingMargin)
        }
        
        view.addSubview(postBodyTextView)
        postBodyTextView.snp.makeConstraints { make in
            make.top.equalTo(postTitleLabel.snp.bottom).inset(-10)
            make.leading.equalTo(view.snp.leadingMargin)
            make.trailing.equalTo(view.snp.trailingMargin)
        }
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(postBodyTextView.snp.bottom).inset(-10)
            make.leading.equalTo(view.snp.leadingMargin)
            make.trailing.equalTo(view.snp.trailingMargin)
            make.bottom.equalTo(guide).inset(20)
            make.height.equalTo(200)
        }
    }
    
    private func getImage() {
        let url = URL(string: "https://techcrunch.com/wp-content/uploads/2022/11/postnews.jpg")!
        NetworkService.shared.downloadImage(from: url) { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension DetailViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        post?.body = textView.text
        NetworkService.shared.updatePost(post: post) { result in
            switch result {
            case .success(let post):
                print("\(post) was successfully updated")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        navigationItem.rightBarButtonItem = nil
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Done",
            style: .done,
            target: self,
            action: #selector(doneButtonPressed)
        )
    }
    
    @objc private func doneButtonPressed() {
        postBodyTextView.endEditing(true)
    }
}
