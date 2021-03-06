
import UIKit

class PeopleDetailViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var deathdayLabel: UILabel!
    @IBOutlet weak var placeOfBirthLabel: UILabel!
    @IBOutlet weak var biographyLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionHeigthConstraint: NSLayoutConstraint!
    
    let utils = Utils()
    let repository = MovieDatabaseRepository()
    var id: Int!
    var photo: String?
    var credits: [Any] = []

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        getDetails(id: id)
        getMovies(id: id)
        getTVShows(id: id)
        
        collectionFormat(heightScreen: view.bounds.height)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.collectionFormat(heightScreen: view.bounds.height)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
    
    
//Obtención de datos del actor por id
extension PeopleDetailViewController {
    func getDetails(id: Int) {
        
        let indicator = utils.showLoadingIndicator(title: NSLocalizedString("loading", comment: "Texto que indica la carga de un recurso"), view: view)
        
        repository.getPersonDetail(id: id) {[weak self] (responseObject, error) in
            if let response = responseObject {
                
                let person = response
                
                if let imageURL = person.photoURL {                    
                    self?.image.sd_setImage(with: URL(string: "\(self!.repository.posterUrl)/\(imageURL)"), completed: nil)
                } else {
                    self?.image.image = UIImage(named: "No Image")
                }
                
                self?.image.layer.cornerRadius = 10
                self?.nameLabel.text = person.name
                self?.birthdayLabel.text = person.birthday
                self?.deathdayLabel.text = person.deathday
                self?.biographyLabel.text = person.biography
                self?.biographyLabel.sizeToFit()
                self?.placeOfBirthLabel.text = person.placeOfBirth
                
                self?.utils.stopLoadingIndicator(indicator: indicator)
                return
            }
            
            
            if (error?.code)! < 0 {
                self?.utils.showAlertConnectionLost(view: self!)
            }
            else {
                self?.utils.showAlertError(code: (error?.code)!, message: (error?.domain)!, view: self!)
            }
            
        }
    }

}

//Obtención de películas y series del actor indicado
extension PeopleDetailViewController {
    
    func getMovies(id: Int) {
        repository.getMovieCredits(id: id) {[weak self] (responseObject, error) in
            if let response = responseObject {
                
                for movie in response {
                    
                    self?.credits.append(movie)
                }
                
                self?.collectionView.reloadData()
                return
            }
            
            if (error?.code)! < 0 {
                self?.utils.showAlertConnectionLost(view: self!)
            }
            else {
                self?.utils.showAlertError(code: (error?.code)!, message: (error?.domain)!, view: self!)
            }
        }
    }
    
    func getTVShows(id: Int) {
        repository.getTVShowCredits(id: id) {[weak self] (responseObject, error) in
            if let response = responseObject {
               
                for show in response {
                    
                    self?.credits.append(show)
                }
                
                self?.collectionView.reloadData()
                return
            }
            if (error?.code)! < 0 {
                self?.utils.showAlertConnectionLost(view: self!)
            }
            else {
                self?.utils.showAlertError(code: (error?.code)!, message: (error?.domain)!, view: self!)
            }
        }
    }
    
    
    
}

//Collection View
extension PeopleDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return credits.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let movieIdentifier = "MovieCreditsCell"
        let tvShowIdentifier = "TVShowCreditsCell"
        var customCell: UICollectionViewCell?
        
        if let item = credits[indexPath.row] as? OMMovie {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: movieIdentifier, for: indexPath) as! MovieCreditsViewCell
            if let posterUrl = item.posterUrl {
                cell.moviePoster.sd_setImage(with: URL(string: "\(repository.posterUrl)/\(posterUrl)"), completed: nil)
            } else {
                cell.moviePoster.image = UIImage(named: "No Image narrow")
            }
            cell.moviePoster.layer.cornerRadius = 10
            customCell = utils.customCardMoviesAndTVShows(cell: cell)
        } else if let item = credits[indexPath.row] as? OMTVShow {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tvShowIdentifier, for: indexPath) as! TVShowCreditsViewCell
            if let posterUrl = item.posterUrl {
                cell.tvShowPoster.sd_setImage(with: URL(string: "\(repository.posterUrl)/\(posterUrl)"), completed: nil)
            } else {
                cell.tvShowPoster.image = UIImage(named: "No Image narrow")
            }
            cell.tvShowPoster.layer.cornerRadius = 10
            customCell = utils.customCardMoviesAndTVShows(cell: cell)
        }
        
        return customCell!
    }
    
}

//Detalles de la película o serie seleccionada
extension PeopleDetailViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let cell = sender as? MovieCreditsViewCell
        {
            let indexPath = collectionView.indexPath(for: cell)
            let detailViewController = segue.destination as! MovieDetailViewController
            let item = credits[(indexPath?.row)!] as! OMMovie
            detailViewController.id = item.id
        }
        else if let cell = sender as? TVShowCreditsViewCell
        {
            let indexPath = collectionView.indexPath(for: cell)
            let detailViewController = segue.destination as! TVShowDetailViewController
            let item = credits[(indexPath?.row)!] as! OMTVShow
            detailViewController.id = item.id
        }
    }
}

//Formato del collection view
extension PeopleDetailViewController {
    
    func collectionFormat(heightScreen: CGFloat) {
        //En vertical la altura será un tercio de la pantalla y en horizontal la mitad
        let size: CGFloat = view.bounds.width > view.bounds.height ? 1/2 : 1/3
        collectionHeigthConstraint.constant = heightScreen * size
        let padding: CGFloat = 10
        let itemHeight = collectionHeigthConstraint.constant - padding * 2
        let itemWidth = itemHeight * (3/4)
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(padding, padding, padding, padding)
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
    }
    
}

