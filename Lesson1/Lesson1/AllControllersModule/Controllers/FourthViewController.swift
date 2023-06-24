import UIKit

class FourthViewController: UIViewController {
    private let yellowView: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        
        return view
    }()
    
    private let greenView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .white
        
        let guide = view.safeAreaLayoutGuide
        view.addSubview(yellowView)
        yellowView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leadingMargin)
            make.top.bottom.equalTo(guide).inset(20)
        }
        
        view.addSubview(greenView)
        greenView.snp.makeConstraints { make in
            make.trailing.equalTo(view.snp.trailingMargin)
            make.leading.equalTo(yellowView.snp.trailing).offset(10)
            make.top.bottom.equalTo(guide).inset(20)
            make.width.equalTo(yellowView.snp.width)
        }
    }
}
