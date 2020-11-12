import UIKit

class MainViewController: UIViewController {
    
    var currentPeriod = Period.thirtyDays {
        didSet {
            if oldValue != currentPeriod {
                getArticles()
            }
        }
    }
    
    var currentGenre = BookGenre.hardCover {
        didSet {
            if oldValue != currentGenre {
                fetchBooks()
            }
        }
    }
    
    private var articles: [Article] = []
    private var books: [Book] = []
    
    var tableView: UITableView!
    var activityIndicator: UIActivityIndicatorView!
    var segmentedControl: UISegmentedControl!
    
//    let newsFilterButton = UIBarButtonItem(title: "News Filter", style: .plain, target: self, action: #selector(articlesFilter))
//    let booksFilterButton = UIBarButtonItem(title: "Books Filter", style: .plain, target: self, action: #selector(booksFilter))
    
    func initActivityIndicator() {
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.color = .black
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func initTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func initSegmentedControl() {
        segmentedControl = UISegmentedControl(items: ["News", "Books"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
        
        view.addSubview(segmentedControl)
        segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        segmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        segmentedControl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSegmentedControl()
        initTableView()
        initActivityIndicator()

        getArticles()
        fetchBooks()
        
        tableView.register(ArticleCell.self, forCellReuseIdentifier: ArticleCell.cellId)
        tableView.register(BookCell.self, forCellReuseIdentifier: BookCell.cellId)
        tableView.separatorStyle = .singleLine
        
        let newsFilterButton = UIBarButtonItem(title: "News Filter", style: .plain, target: self, action: #selector(articlesFilter))
        self.navigationItem.rightBarButtonItem = newsFilterButton
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.backgroundColor = .white
        
    }
    
    @objc func handleSegmentChange() {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            getArticles()
            
            let newsFilterButton = UIBarButtonItem(title: "News Filter", style: .plain, target: self, action: #selector(articlesFilter))
            self.navigationItem.rightBarButtonItem = newsFilterButton
            navigationItem.title = "News"
        default:
            fetchBooks()
            
            let booksFilterButton = UIBarButtonItem(title: "Books Filter", style: .plain, target: self, action: #selector(booksFilter))
            self.navigationItem.rightBarButtonItem = booksFilterButton
            navigationItem.title = "Books"
        }
        tableView.reloadData()
    }
    
    @objc func articlesFilter() {
        let filterAlert = UIAlertController(title: "Choose period", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        
        let oneActionButton = UIAlertAction(title: "1 day", style: .default) { (action: UIAlertAction) in
            self.currentPeriod = .oneDay
        }
        
        let sevenActionButton = UIAlertAction(title: "7 days", style: .default) { (action: UIAlertAction) in
            self.currentPeriod = .sevenDays
        }
        
        let thirtyActionButton = UIAlertAction(title: "30 days", style: .default) { (action: UIAlertAction) in
            self.currentPeriod = .thirtyDays
        }
        
        filterAlert.addAction(oneActionButton)
        filterAlert.addAction(sevenActionButton)
        filterAlert.addAction(thirtyActionButton)
        
        present(filterAlert, animated: true) {
            filterAlert.view.superview?.subviews[0].addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissAlert)))
        }
    }
    
    @objc func booksFilter() {
        let filterAlert = UIAlertController(title: "Choose type", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        
        let hardcoverButton = UIAlertAction(title: "Hardcover Fiction", style: .default) { (action: UIAlertAction) in
            self.currentGenre = .hardCover
        }
        
        let papercoverButton = UIAlertAction(title: "Paperback Nonfiction", style: .default) { (action: UIAlertAction) in
            self.currentGenre = .paperCover
        }
        
        let ebookButton = UIAlertAction(title: "E-book Fiction", style: .default) { (action: UIAlertAction) in
            self.currentGenre = .ebook
        }
        
        filterAlert.addAction(hardcoverButton)
        filterAlert.addAction(papercoverButton)
        filterAlert.addAction(ebookButton)
        
        present(filterAlert, animated: true) {
            filterAlert.view.superview?.subviews[0].addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissAlert)))
        }
    }
    
    
    @objc func dismissAlert() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showLoadingIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            self.tableView.isHidden = true
        }

    }
    
    func hideLoadingIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            self.tableView.isHidden = false
        }
    }
    
    private func getArticles() {
        showLoadingIndicator()
        NewsAPI.shared.fetchNews(period: currentPeriod) { (articles) in
            self.hideLoadingIndicator()
            if let articles = articles {
                self.articles = articles
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    private func fetchBooks() {
        showLoadingIndicator()
        BookAPI.shared.fetchBooks(genre: currentGenre) { (books) in
            self.hideLoadingIndicator()
            if let books = books {
                self.books = books
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if segmentedControl.selectedSegmentIndex == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ArticleCell.cellId, for: indexPath) as! ArticleCell
            let article = articles[indexPath.row]
            cell.configureCell(article: article)
            return cell
        } else if segmentedControl.selectedSegmentIndex == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: BookCell.cellId, for: indexPath) as! BookCell
            let book = books[indexPath.row]
            cell.configureCell(book: book)
            return cell
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            return articles.count
        } else if segmentedControl.selectedSegmentIndex == 1 {
        }
        return books.count
    }
       
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    private func presentArticleController(article: Article) {
        let controller = ArticleDetailsCiewController()
        controller.article = article
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func presentBookController(book: Book) {
        let controller = BookDetailsCiewController()
        controller.book = book
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = articles[indexPath.row]
        let book = books[indexPath.row]
        
        if segmentedControl.selectedSegmentIndex == 0 {
        presentArticleController(article: article)
        } else {
            presentBookController(book: book)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
