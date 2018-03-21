import UIKit
import MSAL
import Firebase

class ViewController: UIViewController, UITextFieldDelegate, URLSessionDelegate {
    
    let kClientID = "cfc975d2-df79-44e6-b9a9-e73f54f9d4f7"
    let kAuthority = "https://login.microsoftonline.com/common/v2.0"
    
    let kGraphURI = "https://graph.microsoft.com/v1.0/me/"
    let kScopes: [String] = ["https://graph.microsoft.com/user.read"]
    
    var accessToken = String()
    var applicationContext = MSALPublicClientApplication.init()
    
    
    
    // This button will invoke the call to the Microsoft Graph API. It uses the
    // built in Swift libraries to create a connection.
    
    @IBAction func callGraphButton(_ sender: UIButton) {
    
        
        do {
            
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
            
            // This is the catch all error.
            
            print("Unable to acquire token. Got error: \(error)")
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Messaging.messaging().subscribe(toTopic: "-L-D_pp26VNrfCiRCvPa")
        Messaging.messaging().subscribe(toTopic: "try")
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
        
        if self.accessToken.isEmpty {
           
        }
    }
    func getContentWithToken() {
        do {
            
            // Removes all tokens from the cache for this application for the provided user
            // first parameter:   The user to remove from the cache
            
            try self.applicationContext.remove(self.applicationContext.users().first)
            
            
        } catch let error {
            print("Received error signing user out: \(error)")
        }
        
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
                    let alert = UIAlertController(title: "Incomplete form", message: "Please sign in using a valid AUB email", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    
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
                        let alert = UIAlertController(title: "Error", message: "You do not have access to this application. Login through our website if you are a professor.", preferredStyle: .alert)
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

                    }
                    else{
                let realResult = result as! NSDictionary
                let name = realResult["displayName"] as! String
                    if name.contains("(Student)"){

                        var email = realResult["mail"] as! String
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
                                }
                            }
                                if (!found) {
                                    let firstName = realResult["givenName"] as! String
                                    let lastName = realResult["surname"] as! String
                                    
                                    var fullName = firstName + " "+lastName
                                    print("new user")
                                    let newstudent = Student(name: fullName, email: email, classes: [], questionsAsked: [])
                                    
                                    print( "new user: \(newstudent)")
                                    
                                    let userref = Database.database().reference().child("Users").child("Students").child(ref[0])
                                    
                                    userref.setValue(newstudent.toAnyObject())
                                    UserDefaults.standard.set(fullName, forKey: "name")
                                    UserDefaults.standard.set(email, forKey: "email")
                                    UserDefaults.standard.set(ref[0], forKey: "id")
                                    UserDefaults.standard.set(true, forKey: "LoggedIn")
                                    
                                }
                                
                                
                            })
                            
                    
                        
                    }
                    
                }
                }
            }
                
            
            }.resume()
    }
   


}
