import UIKit
import MSAL
import Firebase

class ViewController: UIViewController, UITextFieldDelegate, URLSessionDelegate {
    
    let kClientID = "yourClientID"
    let kAuthority = "https://login.microsoftonline.com/common/v2.0"
    
    let kGraphURI = "https://graph.microsoft.com/v1.0/me/"
    let kScopes: [String] = ["https://graph.microsoft.com/user.read"]
    
    var comingFromApp = false
    var accessToken = String()
    var applicationContext = MSALPublicClientApplication.init()
    
    @IBOutlet weak var logInButton: UIButton!
    var success = false
    
    // This button will invoke the call to the Microsoft Graph API. It uses the
    // built in Swift libraries to create a connection.
    
    @IBAction func callGraphButton(_ sender: UIButton) {
        do {
            
             self.logInButton.isUserInteractionEnabled = false
            // We check to see if we have a current logged in user. If we don't, then we need to sign someone in.
            // We throw an interactionRequired so that we trigger the interactive signin.
            
            if  try self.applicationContext.users().isEmpty {
                throw NSError.init(domain: "MSALErrorDomain", code: MSALErrorCode.interactionRequired.rawValue, userInfo: nil)
            } else {
                
                // Acquire a token for an existing user silently
                
                try self.applicationContext.acquireTokenSilent(forScopes: self.kScopes, user: applicationContext.users().first) { (result, error) in
                    
                    if error == nil {
                        self.accessToken = (result?.accessToken)!
                        print("Refreshing token silently")
                        print("Refreshed Access token is \(self.accessToken)")
                        
                        self.getContentWithToken()
                        
                    } else {
                        print("Could not acquire token silently: \(error ?? "No error information" as! Error)")
                    }
                }
            }
        }  catch let error as NSError {
            
            // interactionRequired means we need to ask the user to sign-in. This usually happens
            // when the user's Refresh Token is expired or if the user has changed their password
            // among other possible reasons.
            
            if error.code == MSALErrorCode.interactionRequired.rawValue {
                
                self.applicationContext.acquireToken(forScopes: self.kScopes) { (result, error) in
                    if error == nil {
                        self.accessToken = (result?.accessToken)!
                        print("Access token is \(self.accessToken)")
               
                        self.getContentWithToken()
                        
                    } else  {
                        print("Could not acquire token: \(error ?? "No error information" as! Error)")
                    }
                }
            }
            
        } catch {
            print("Unable to acquire token. Got error: \(error)")
            
        }
    }
    
    override func viewDidLoad() {
       logInButton.isUserInteractionEnabled = true
        super.viewDidLoad()
        if comingFromApp {
            do {
                
                // Removes all tokens from the cache for this application for the provided user
                // first parameter:   The user to remove from the cache
                
                try self.applicationContext.remove(self.applicationContext.users().first)
                UserDefaults.standard.set(false, forKey: "LoggedIn")
                comingFromApp = false
                
            } catch let error {
                print("Received error signing user out: \(error)")
            }
        }
        
        Messaging.messaging().subscribe(toTopic: "yourTopic")
        do {
            // Initialize a MSALPublicClientApplication with a given clientID and authority
            self.applicationContext = try MSALPublicClientApplication.init(clientId: kClientID, authority: kAuthority)
        } catch {
            print("Unable to create Application Context. Error: \(error)")
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override func viewDidAppear(_ animated: Bool) {
         DispatchQueue.main.async {
        if UserDefaults.standard.bool(forKey: "LoggedIn") == true{
            
            self.success = true
            self.performSegue(withIdentifier: "toWelcome", sender: self)
        }
        }
    }
    override func
        shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if let ident = identifier {
            if ident == "toWelcome" {
                if !success {
                    return false
                }
            }
        }
        return true
    }
    func getContentWithToken() {
        do {
            
            // Removes all tokens from the cache for this application for the provided user
            // first parameter:   The user to remove from the cache
            
            try self.applicationContext.remove(self.applicationContext.users().first)
            
            
        } catch let error {
            print("Received error signing user out: \(error)")
        }
        logInButton.isUserInteractionEnabled = false
        let sessionConfig = URLSessionConfiguration.default
        
        // Specify the Graph API endpoint
        let url = URL(string: kGraphURI)
        var request = URLRequest(url: url!)
        
        // Set the Authorization header for the request. We use Bearer tokens, so we specify Bearer + the token we got from the result
        request.setValue("Bearer \(self.accessToken)", forHTTPHeaderField: "Authorization")
        let urlSession = URLSession(configuration: sessionConfig, delegate: self, delegateQueue: OperationQueue.main)
        
        urlSession.dataTask(with: request) { data, response, error in
            let result = try? JSONSerialization.jsonObject(with: data!, options: [])
            if result != nil {
                
                print(result.debugDescription)
                if (!result.debugDescription.contains("mail.aub.edu") && !result.debugDescription.contains("aub.edu.lb")){
                    let alert = UIAlertController(title: "Access Denied", message: "Please sign in using a valid AUB email", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                    self.logInButton.isUserInteractionEnabled = true
                    
                    
                    do {
                        
                        // Removes all tokens from the cache for this application for the provided user
                        // first parameter:   The user to remove from the cache
                        
                        try self.applicationContext.remove(self.applicationContext.users().first)
                        
                        
                    } catch let error {
                        print("Received error signing user out: \(error)")
                    }
                }
                
                else {
                    if (result.debugDescription.contains("aub.edu.lb")){
                        let alert = UIAlertController(title: "Access Denied", message: "You do not have access to this application. Login through our website if you are a professor.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {action in
                            do {
                            
                            // Removes all tokens from the cache for this application for the provided user
                            // first parameter:   The user to remove from the cache
                            
                            try self.applicationContext.remove(self.applicationContext.users().first)
                            
                            
                            } catch let error {
                            print("Received error signing user out: \(error)")
                            }
                            }))
                        self.present(alert, animated: true, completion: nil)
                        self.logInButton.isUserInteractionEnabled = true
                    }
                    else{
                let realResult = result as! NSDictionary
                let name = realResult["displayName"] as! String
                    if name.contains("(Student)"){
                        self.success = true
                        self.logInButton.isUserInteractionEnabled = false
                        let email = realResult["mail"] as! String
                        var ref = email.components(separatedBy: "@")
                        Database.database().reference().child("Users").observeSingleEvent(of: .value, with: { (snapshot) in
                            
                            var found = false
                            if snapshot.hasChild("Students"){
                                
                                let snapshotV = snapshot.value as? NSDictionary
                                let snapshotValue = snapshotV!["Students"] as! NSDictionary
                                if snapshotValue[ref[0]] != nil {
                                    found = true
                                    let userInfo = snapshotValue[ref[0]] as! NSDictionary
                                    
                                    UserDefaults.standard.set(userInfo["Name"], forKey: "name")
                                    UserDefaults.standard.set(userInfo["Email"] as! String, forKey: "email")
                                    UserDefaults.standard.set(ref[0], forKey: "id")
                                    UserDefaults.standard.set(true, forKey: "LoggedIn")
                                    print("old user")
                                    self.performSegue(withIdentifier: "toWelcome", sender: self)

                                }
                            }
                                if (!found) {
                                    let firstName = realResult["givenName"] as! String
                                    let lastName = realResult["surname"] as! String
                                    
                                    let fullName = firstName + " "+lastName
                                    print("new user")
                                    let newstudent = Student(name: fullName, email: email, classes: [], questionsAsked: [])
                                    
                                    print( "new user: \(newstudent)")
                                    
                                    let userref = Database.database().reference().child("Users").child("Students").child(ref[0])
                                    
                                    userref.setValue(newstudent.toAnyObject())
                                    UserDefaults.standard.set(fullName, forKey: "name")
                                    UserDefaults.standard.set(email, forKey: "email")
                                    UserDefaults.standard.set(ref[0], forKey: "id")
                                    UserDefaults.standard.set(true, forKey: "LoggedIn")
                                    self.performSegue(withIdentifier: "toWelcome", sender: self)
                                }
                            })
                    }
                }
                }
            }
            }.resume()
    }
}
