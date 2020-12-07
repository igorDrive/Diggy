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
    
    var currentOrder = MovieFilter.byOpeningDay {
        didSet {
            if oldValue != currentOrder {
                fetchMovies()
            }
        }
    }
    
    private var articles: [Article] = []
    private var books: [Book] = []
    private var movies: [Movie] = []
    
    private var filteredArticles: [Article] = []
    private var filteredBooks: [Book] = []

    private var isFiltering = false
    
    var tableView: UITableView!
    var activityIndicator: UIActivityIndicatorView!
    var segmentedControl: UISegmentedControl!
    var textField: UITextField!
        
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
        tableView.topAnchor.constraint(equalTo: textField.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func initSegmentedControl() {
        segmentedControl = UISegmentedControl(items: ["News", "Books", "Movies"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        
        view.addSubview(segmentedControl)
        segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        segmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        segmentedControl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
    }
    
    func initTextField() {
        textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Title search"
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.clearButtonMode = .always
//        textField.autocorrectionType = UITextAutocorrectionType.no
//        textField.keyboardType = UIKeyboardType.default
//        textField.returnKeyType = UIReturnKeyType.done
//        textField.clearButtonMode = UITextField.ViewMode.whileEditing
//        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textField.delegate = self
        
        view.addSubview(textField)
        textField.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8).isActive = true
        textField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        textField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSegmentedControl()
        initTextField()
        initTableView()
        initActivityIndicator()
        
        tableView.register(ArticleCell.self, forCellReuseIdentifier: ArticleCell.cellId)
        tableView.register(BookCell.self, forCellReuseIdentifier: BookCell.cellId)
        tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.cellId)
        tableView.separatorStyle = .singleLine
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.backgroundColor = .white
        
        fetchData()
    }
    
    @objc func fetchData() {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            getArticles()
            
            let newsFilterButton = UIBarButtonItem(title: "News Filter", style: .plain, target: self, action: #selector(articlesFilter))
            self.navigationItem.rightBarButtonItem = newsFilterButton
            navigationItem.title = "News"
            
        case 1:
            fetchBooks()
            
            let booksFilterButton = UIBarButtonItem(title: "Books Filter", style: .plain, target: self, action: #selector(booksFilter))
            self.navigationItem.rightBarButtonItem = booksFilterButton
            navigationItem.title = "Books"
            
        default:
            fetchMovies()
            
            let moviesFilterButton = UIBarButtonItem(title: "Movies Order", style: .plain, target: self, action: #selector(moviesOrder))
            self.navigationItem.rightBarButtonItem = moviesFilterButton
            navigationItem.title = "Movie Reviews"
            
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
    
    @objc func moviesOrder() {
        let filterAlert = UIAlertController(title: "Choose movie order", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        
        let titleButton = UIAlertAction(title: "By title", style: .default) { (action: UIAlertAction) in
            self.currentOrder = .byTitle
        }
        
        let openingDateButton = UIAlertAction(title: "By opening date", style: .default) { (action: UIAlertAction) in
            self.currentOrder = .byOpeningDay
        }
        
        let publicationDateButton = UIAlertAction(title: "By publication date", style: .default) { (action: UIAlertAction) in
            self.currentOrder = .byDate
        }
        
        filterAlert.addAction(titleButton)
        filterAlert.addAction(openingDateButton)
        filterAlert.addAction(publicationDateButton)
        
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
    
    private func fetchMovies() {
        showLoadingIndicator()
        MovieAPI.shared.fetchMovies(filter: currentOrder) { (movies) in
            self.hideLoadingIndicator()
            if let movies = movies {
                self.movies = movies
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
            let article = isFiltering ? filteredArticles[indexPath.row] : articles[indexPath.row]
            cell.configureCell(article: article)
            return cell
        } else if segmentedControl.selectedSegmentIndex == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: BookCell.cellId, for: indexPath) as! BookCell
            let book = isFiltering ? filteredBooks[indexPath.row] : books[indexPath.row]
            cell.configureCell(book: book)
            return cell
        } else if segmentedControl.selectedSegmentIndex == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.cellId, for: indexPath) as! MovieCell
            let movie = movies[indexPath.row]
            cell.configureCell(movie: movie)
            return cell
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            return isFiltering ? filteredArticles.count : articles.count
        } else if segmentedControl.selectedSegmentIndex == 1 {
            return isFiltering ? filteredBooks.count : books.count
        } else if segmentedControl.selectedSegmentIndex == 2 {
            return movies.count
        }
        return 0
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
        let controller = BookDetailsViewController()
        controller.book = book
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func presentMovieController(movie: Movie) {
        let controller = MovieDetailsViewController()
        controller.movie = movie
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            let article = articles[indexPath.row]
            presentArticleController(article: article)
        } else if segmentedControl.selectedSegmentIndex == 1 {
            let book = books[indexPath.row]
            presentBookController(book: book)
        } else if segmentedControl.selectedSegmentIndex == 2 {
            let movie = movies[indexPath.row]
            presentMovieController(movie: movie)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func searchMoviesFromAPI(movieName: String) {
        showLoadingIndicator()
        MovieAPI.shared.fetchMovies(search: movieName) { (movies) in
            self.hideLoadingIndicator()
            if let movies = movies {
                self.movies = movies
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func searchNewsQueriesLocally(query: String) {
        filteredArticles = articles.filter({ (article) in
            article.title.range(of: query, options: .caseInsensitive) != nil
        })
        tableView.reloadData()
    }
    
    func searchBooksQueriesLocally(query: String) {
        filteredBooks = books.filter({ (book) in
            book.title.range(of: query, options: .caseInsensitive) != nil
        })
        tableView.reloadData()
    }
}

extension MainViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text?.trimmingCharacters(in: .whitespaces), text .count > 0 {
            isFiltering = true
        } else {
            isFiltering = false
        }
        if isFiltering == false {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        if let searchQuery = textField.text {
            if segmentedControl.selectedSegmentIndex == 0 {
                searchNewsQueriesLocally(query: searchQuery)
            } else if segmentedControl.selectedSegmentIndex == 1 {
                searchBooksQueriesLocally(query: searchQuery)
            } else if segmentedControl.selectedSegmentIndex == 2 {
                searchMoviesFromAPI(movieName: searchQuery)
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
