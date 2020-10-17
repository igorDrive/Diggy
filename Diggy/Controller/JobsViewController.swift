import UIKit

class JobsViewController: UIViewController {

    private var apiClient: APIClient!
    private var jobs: [Job] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiClient = APIClient()
        getJobs()
    }
    
    private func getJobs() {
        apiClient.getJobs { (jobs, error) in
            if error != nil {
                // handle error
            }
            if let jobs = jobs {
                self.jobs.append(contentsOf: jobs)
            }
        }
    }


}

