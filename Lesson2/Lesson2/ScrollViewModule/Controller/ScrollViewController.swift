import UIKit
import SnapKit


class ScrollViewController: UIViewController, ViewControllerTitleProtocol{
    let titleText = "Scroll View"
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .systemGroupedBackground
        scrollView.decelerationRate = .fast
        scrollView.showsVerticalScrollIndicator = true
        
        return scrollView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: createButtons(count: 50))
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 1
        
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        generateCorners(
            element: stackView.arrangedSubviews.first!,
            corners: [.topLeft, .topRight]
        )
        
        generateCorners(
            element: stackView.arrangedSubviews.last!,
            corners: [.bottomLeft, .bottomRight]
        )
    }
    
    private func createButtons(count: Int) -> [UIButton] {
        var buttons = [UIButton]()
        for counter in 1...count {
            let button = UIButton(type: .system)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle("Button №\(counter)", for: .normal)
            button.backgroundColor = .white
            buttons.append(button)
        }
        return buttons
    }

    private func generateCorners(element: UIView, corners: UIRectCorner) {
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(
            roundedRect: element.bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: 25, height: 25)
        ).cgPath
        element.layer.mask = maskLayer
        element.layer.masksToBounds = true
    }
    
    private func setupUI() {
        title = titleText
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .systemGroupedBackground
        
        let guide = view.safeAreaLayoutGuide
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalTo(guide)
        }
        
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().inset(25)
        }
        
        stackView.arrangedSubviews.forEach { button in
            button.snp.makeConstraints { make in
                make.height.equalTo(50)
            }
        }
    }
}
