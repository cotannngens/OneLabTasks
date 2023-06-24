import UIKit

class ThirdViewController: UIViewController {
    private let blueView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        
        return view
    }()
    
    private let redView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .white
        
        let guide = view.safeAreaLayoutGuide
        view.addSubview(blueView)
        blueView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leadingMargin)
            make.top.bottom.equalTo(guide).inset(20)
            make.width.greaterThanOrEqualTo(150)
        }
        
        view.addSubview(redView)
        redView.snp.makeConstraints { make in
            make.trailing.equalTo(view.snp.trailingMargin)
            make.leading.equalTo(blueView.snp.trailing).offset(10)
            make.top.bottom.equalTo(guide).inset(20)
            make.width.equalTo(blueView.snp.width).multipliedBy(2).priority(750)
        }
    }
}
