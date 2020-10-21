import UIKit

class JobsViewController: UITableViewController {

    private var apiClient: APIClient!
    private var jobs: [Job] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiClient = APIClient()
        getJobs()
        
        tableView.register(JobCell.self, forCellReuseIdentifier: JobCell.cellId)
    }
    
    private func getJobs() {
        apiClient.getJobs { (jobs, error) in
            if error != nil {
                // handle error
            }
            if let jobs = jobs {
                self.jobs.append(contentsOf: jobs)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        jobs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: JobCell.cellId, for: indexPath) as! JobCell
        let job = jobs[indexPath.row]
        cell.configureCell(job: job)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

