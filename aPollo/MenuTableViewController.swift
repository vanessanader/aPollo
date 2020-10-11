//
//  MenuTableViewController.swift
//  
//
//  Created by Vanessa Nader on 3/28/18.
//

import UIKit

extension UIImageView {
    func setRounded() {
        let radius = self.frame.width/2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}
class MenuTableViewController: UITableViewController {

    override var prefersStatusBarHidden: Bool {
        return true
    }
    @IBOutlet weak var userDp: UIImageView!
    @IBOutlet weak var userInitials: UILabel!
    @IBOutlet weak var useremail: UILabel!
    @IBOutlet weak var username: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        username.text = UserDefaults.standard.string(forKey: "name")
        useremail.text = UserDefaults.standard.string(forKey: "email")
        userDp.setRounded()
        var initials = ""
        var cha = ""
        for ch in UserDefaults.standard.string(forKey: "name")! {
            if ch >= "A" && ch <= "Z"{
                cha = String(ch)
                initials += cha
            }
            userInitials.text = initials
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
         self.tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath){
            cell.selectionStyle = UITableViewCellSelectionStyle.none
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if (segue.identifier == "signingOut") {
            let guest = segue.destination as! ViewController
             UserDefaults.standard.set(false, forKey: "LoggedIn")
            guest.comingFromApp = true
        }
    }
}
