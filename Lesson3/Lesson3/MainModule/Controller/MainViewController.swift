import UIKit
import SnapKit

class MainViewController: UIViewController {
    private var posts = [Post]()
    
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
        navigationItem.title = "Lesson 3"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(newPostButtonPressed)
        )
        
        getData()
    }
    
    @objc private func newPostButtonPressed() {
        let alertController = UIAlertController(title: "Add post", message: nil, preferredStyle: .alert)
        let placeHoldersText = ["User Id", "Title"]
        placeHoldersText.forEach { placeHolderText in
            alertController.addTextField { textField in
                textField.placeholder = placeHolderText
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            guard let userId = alertController.textFields?[0].text,
                  let title = alertController.textFields?[1].text else {
                return
            }
            if Int(userId) != nil && Int(userId) != 0{
                let newPost = Post(
                    id: (self.posts.last?.id ?? 0) + 1,
                    userId: Int(userId)!,
                    title: title,
                    body: ""
                )
                self.posts.append(newPost)
                self.tableView.reloadData()
                #warning("В таблице данные обновляются, но так как сервер только имитирует put, delete и post запросы, то на сервере изменения не сохраняются, что приводит к сообщениями об ошибке при создании и сохранении текста нового поста, так как обращение идет по несуществующему id поста")
                NetworkService.shared.createPost(post: newPost) { result in
                    switch result {
                    case .success(let post):
                        print("\(post) was successfully created")
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                let viewController = DetailViewController()
                viewController.post = newPost
                print(newPost)
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        
        present(alertController, animated: true)
           
    }
    
    private func getData() {
        NetworkService.shared.getPosts(completion: { [weak self] result in
            switch result {
            case .success(let posts):
                self?.posts = posts
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = "\(posts[indexPath.row].title)"
        cell.detailTextLabel?.text = "User id: \(posts[indexPath.row].userId), post id: \(posts[indexPath.row].id)"

        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Posts"
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let viewController = DetailViewController()
        viewController.post = posts[indexPath.row]
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deletingPostId = posts[indexPath.row].id
            posts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        
            NetworkService.shared.deletePost(postId: deletingPostId) { result in
                switch result {
                case .success:
                    print("post with ID \(deletingPostId) was successfully deleted")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
