import UIKit
import Contacts
import Foundation

class TableViewController: UIViewController, ViewControllerTitleProtocol {
    var titleText = "Contacts"
    private var contacts = [CNContact]()
    private var filteredContacts = [CNContact]()
    private var contactInitials = [String]()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableHeaderView = searchController.searchBar
        
        return tableView
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.delegate = self
        
        return searchController
    }()
    
    override func loadView() {
        view = tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        fetchData()
    }
    
    private func setupUI() {
        title = titleText
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonTapped)
        )
        definesPresentationContext = true
    }
    
    private func fetchData() {
        ContactsManager.shared.fetchContacts { [weak self] contacts in
            self?.contacts = contacts
            self?.contactInitials = contacts.compactMap({ $0.familyName.first?.uppercased() }).sorted().removeDuplicates()
            self?.tableView.reloadData()
        }
    }
    
    @objc private func addButtonTapped() {
        let alertController = UIAlertController(title: "Add Contact", message: nil, preferredStyle: .alert)
        let placeHoldersText = ["First Name", "Last Name", "Phone Number"]
        placeHoldersText.forEach { placeHolderText in
            alertController.addTextField { textField in
                textField.placeholder = placeHolderText
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            guard let firstName = alertController.textFields?[0].text,
                  let lastName = alertController.textFields?[1].text,
                  let phoneNumber = alertController.textFields?[2].text else {
                return
            }
            if !(phoneNumber == "" || (firstName == "" && lastName == "")) {
                ContactsManager.shared.addContact(givenName: firstName, familyName: lastName, phoneNumber: phoneNumber)
                self.fetchData()
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

extension TableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredContacts.filter({ $0.familyName.first?.uppercased() == contactInitials[section] }).count
        } else {
            return contacts.filter({ $0.familyName.first?.uppercased() == contactInitials[section] }).count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return contactInitials.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return contactInitials[section]
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return contactInitials
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return contactInitials.firstIndex(of: title)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let contactsForInitial = isFiltering ? filteredContacts : contacts
        let contact = contactsForInitial.filter({ $0.familyName.first?.uppercased() == contactInitials[indexPath.section] })[indexPath.row]
        cell.textLabel?.text = "\(contact.givenName) \(contact.familyName)"
        cell.detailTextLabel?.text = contact.phoneNumbers.first?.value.stringValue
        
        return cell
    }
}

extension TableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension TableViewController: UISearchResultsUpdating {
    private var isFiltering: Bool {
        return searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        filterContacts(with: searchText)
    }
    
    private func filterContacts(with searchText: String) {
        let filteredContacts = contacts.filter { contact in
            return contact.givenName.localizedCaseInsensitiveContains(searchText) ||
            contact.familyName.localizedCaseInsensitiveContains(searchText)
        }
        
        self.filteredContacts = filteredContacts
        contactInitials = filteredContacts.compactMap({ $0.familyName.first?.uppercased() }).sorted().removeDuplicates()
        tableView.reloadData()
    }
}

extension TableViewController: UISearchControllerDelegate {
    func didDismissSearchController(_ searchController: UISearchController) {
        fetchData()
        tableView.reloadData()
    }
}
