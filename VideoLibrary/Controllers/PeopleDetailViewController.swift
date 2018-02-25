
import UIKit

class PeopleDetailViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var deathdayLabel: UILabel!
    @IBOutlet weak var placeOfBirthLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var biographyLabel: UILabel!
    
    
    
    let utils = Utils()
    let repository = MovieDatabaseRepository()
    var id: Int?
    var movie: [Movie]?
    var tvShow: [TVShow]?
    var photo: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDetails(id: id!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    
    
    //Obtención de datos por id
    
    func getDetails(id: Int) {
        
        let indicator = utils.showLoadingIndicator(title: "Loading...", view: view)
        
        repository.getPersonDetail(id: id) { (responseObject, error) in            
            if let response = responseObject {
                print(response)
                let name = response["name"].string ?? nil
                let photo = response["profile_path"].string ?? nil
                var biography = response["biography"].string ?? nil
                if biography == "" {
                    biography = "The biography is not available in the requested language"
                }
                let birthday = response["birthday"].string ?? "-"
                let deathday = response["deathday"].string ?? "-"
                let placeOfBirth = response["place_of_birth"].string ?? "-"
                let popularity = response["popularity"].int ?? nil
                let person = ActorDetails(id: id, name: name!, photoURL: photo, biography: biography, birthday: birthday, deathday: deathday, placeOfBirth: placeOfBirth, popularity: popularity, movie: self.movie, tvShow: self.tvShow)
                if let imageURL = person.photoURL {
                    self.repository.getPosterImage(poster: imageURL, view: self.image)
                } else {
                    self.image.image = UIImage(named: "No Image")
                }
                self.nameLabel.text = person.name
                self.birthdayLabel.text = person.birthday
                self.deathdayLabel.text = person.deathday
                self.popularityLabel.text = "\(person.popularity!)"
                self.biographyLabel.text = person.biography
                self.biographyLabel.sizeToFit()
                self.placeOfBirthLabel.text = person.placeOfBirth
                
                self.utils.stopLoadingIndicator(indicator: indicator)
                return
            }
            
            
            if (error?.code)! < 0 {
                self.utils.showAlertConnectionLost(view: self)
            }
            else {
                self.utils.showAlertError(code: (error?.code)!, message: (error?.domain)!, view: self)
            }
            
        }
        
    }
    
    //TODO Obtener películas y series
    
    //TODO asignar al storyboard

}
