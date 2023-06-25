import UIKit
import Contacts

class AllControllersViewController: UIViewController {
    private let viewControllers: [ViewControllerTitleProtocol] = [
        ScrollViewController(), TableViewController(),
        CollectionViewController()
    ]
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        
        return tableView
    }()
    
    override func loadView() {
        view = tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Lesson 2"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        ContactsManager.shared.requestAccess { granted in
            if !granted {
                self.showSettingsAlert()
            }
        }
        
    }
    
    private func showSettingsAlert() {
        let alertController = UIAlertController(
            title: "Warning",
            message: "This app requires access to contacts. Go to settings to give access.",
            preferredStyle: .alert
        )
        
        if let settings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(settings) {
            alertController.addAction(UIAlertAction(title: "Open settings", style: .default) { action in
                UIApplication.shared.open(settings)
            })
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        self.navigationController?.present(alertController, animated: true)
    }
    
}

extension AllControllersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewControllers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = "\(viewControllers[indexPath.row].titleText)"
        
        return cell
    }
}

extension AllControllersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Controllers"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(viewControllers[indexPath.row] as! UIViewController, animated: true)
    }
}
