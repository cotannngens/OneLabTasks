import UIKit

class FifthViewController: UIViewController {
    private let button1: UIButton = {
        let button = UIButton(configuration: .tinted())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Button 1", for: .normal)
        return button
    }()
    
    private let button2: UIButton = {
        let button = UIButton(configuration: .tinted())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Button 2", for: .normal)
        return button
    }()
    
    private let button3: UIButton = {
        let button = UIButton(configuration: .tinted())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Button 3", for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .white
        
        let guide = view.safeAreaLayoutGuide
        view.addSubview(button1)
        button1.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leadingMargin)
            make.bottom.equalTo(guide.snp.bottom).inset(20)
        }
        
        view.addSubview(button2)
        button2.snp.makeConstraints { make in
            make.leading.equalTo(button1.snp.trailing).offset(10)
            make.bottom.equalTo(guide.snp.bottom).inset(20)
            make.width.equalTo(button1.snp.width)
        }
        
        view.addSubview(button3)
        button3.snp.makeConstraints { make in
            make.leading.equalTo(button2.snp.trailing).offset(10)
            make.trailing.equalTo(view.snp.trailingMargin)
            make.bottom.equalTo(guide.snp.bottom).inset(20)
            make.width.equalTo(button1.snp.width)
        }
    }
}
