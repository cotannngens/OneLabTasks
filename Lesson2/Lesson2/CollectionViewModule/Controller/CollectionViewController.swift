import UIKit
import SnapKit


class CollectionViewController: UIViewController, ViewControllerTitleProtocol{
    let titleText = "Collection View"
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Comming soon... :)"
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .center
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    private func setupUI() {
        title = titleText
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .systemBackground
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(50)
            make.centerY.equalToSuperview()
        }
    }
}
