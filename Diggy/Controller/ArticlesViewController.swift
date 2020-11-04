import UIKit

class ArticlesViewController: UIViewController {
    
    var currentPeriod = Period.thirtyDays {
        didSet {
            if oldValue != currentPeriod {
                getArticles()
            }
        }
    }
    
    private var articles: [Article] = []
    
    var tableView: UITableView!
    var activityIndicator: UIActivityIndicatorView!
    
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
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        initActivityIndicator()

        getArticles()
        
        tableView.register(ArticleCell.self, forCellReuseIdentifier: ArticleCell.cellId)
        tableView.separatorStyle = .singleLine
        
        let button1 = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(jobsFilter))
        self.navigationItem.rightBarButtonItem = button1
        
        navigationItem.title = "News"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.backgroundColor = .white
    }
    
    @objc func jobsFilter() {
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
        NewsAPI.shared.fetchData(period: currentPeriod) { (articles) in
            self.hideLoadingIndicator()
            if let articles = articles {
                self.articles = articles
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension ArticlesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticleCell.cellId, for: indexPath) as! ArticleCell
        let article = articles[indexPath.row]
        cell.configureCell(article: article)
        return cell
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = articles[indexPath.row]
        presentArticleController(article: article)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
