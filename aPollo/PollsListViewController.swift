//
//  PollsListViewController.swift
//  aPollo
//
//  Created by Vanessa Nader on 4/16/18.
//  Copyright © 2018 Vanessa Nader. All rights reserved.
//

import UIKit
import Firebase

class PollsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var table: UITableView!
    
     var tempClass = Class(id : "", courseName: "", courseNumber: "", location: "", sectionNumber: "", professorEmail: "", evaluationNumber : 0, evaluationIsStopped: false, evaluationId: "", studentsEnrolled: [], classPolls: [], questionsAsked: [])
    
    var myPollsList : [Poll] = []
    {
        didSet{
            table.reloadData()
        }
    }
    
    var isPresent = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Database.database().reference().child("Classes").child(tempClass.id).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.hasChild("Polls"){ //add lists
                
                
                let snapshotV = snapshot.value as? NSDictionary
                let snapshotValue = snapshotV!["Polls"] as? NSDictionary
                
                for element in snapshotValue! {
                    print("snap", element)
                    print("snapshot count: \(snapshotValue!.count)")
                    
                    
                    Database.database().reference().child("Polls").child("\(element.value as! String)").observeSingleEvent(of: .value, with: {
                        (snapshot) in
                        let snapshotV = snapshot.value as? NSDictionary
                        print(snapshot.value)
                        
                        let pollTitle = snapshotV!["PollTitle"] as! String
                        let pollDate = snapshotV!["PollDate"] as! Int
                        let isAvailable = snapshotV!["IsAvailable"] as! BooleanLiteralType
                        let isActive = snapshotV!["IsActive"] as! BooleanLiteralType
                        let isAnswered = snapshotV!["IsAnswered"] as! BooleanLiteralType
                        let id = snapshotV!["Id"] as! String
                      
                        if (isAvailable){
                            let newpoll = Poll(id: id,pollTitle: pollTitle, pollQuestions: [], classId: self.tempClass.id, isAvailable: isAvailable, isActive: isActive, isAnswered: isAnswered, pollDate: pollDate)
                        self.myPollsList.append(newpoll)
                        }
                        
                        print("Count",self.myPollsList.count)
                    })
                }
                
                
            }
            // Do any additional setup after loading the view.
        })
        
        var ref = UserDefaults.standard.string(forKey: "email")!.components(separatedBy: "@")
        
        Database.database().reference().child("Users").child("Students").child(ref[0]).child("Classes").child(tempClass.id).child("IsPresent").observeSingleEvent(of: .value, with: { (snapshot) in
            
            self.isPresent = snapshot.value! as! BooleanLiteralType
        })

        // Do any additional setup after loading the view.
    }

    @IBAction func backPressed(_ sender: Any) {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPollsList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : PollsListTableViewCell = table.dequeueReusableCell(withIdentifier: "myPoll", for : indexPath) as! PollsListTableViewCell
        cell.pollTitle.text = myPollsList[indexPath.row].pollTitle
        var dateformat = String(myPollsList[indexPath.row].pollDate)
        var index = dateformat.index(dateformat.startIndex, offsetBy: 4)
        let year = dateformat.prefix(upTo: index)
        index = dateformat.index(dateformat.endIndex, offsetBy: -2)
        let day = dateformat[index...]
        let start = dateformat.index(dateformat.startIndex, offsetBy: 4)
        let end = dateformat.index(dateformat.endIndex, offsetBy: -2)
        let range = start..<end
        let month = dateformat[range]
        
        cell.pollDate.text = day + "/" + month + "/" + year
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath){
            cell.selectionStyle = UITableViewCellSelectionStyle.none
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        table.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    var pollId = ""
    var pollTitle = ""
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        if (myPollsList.count != 0){
            pollId = myPollsList[indexPath.row].id
            pollTitle = myPollsList[indexPath.row].pollTitle
            if (myPollsList[indexPath.row].isActive && isPresent){
            performSegue(withIdentifier: "toSelectedActivePoll", sender: self)
            }
            else if (!myPollsList[indexPath.row].isActive && myPollsList[indexPath.row].isAnswered){
                performSegue(withIdentifier: "toSelectedOldPoll", sender: self)
            }
             else {
                let alert  = UIAlertController(title: "No access", message: "You don't have access to this poll", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        
        
        return indexPath
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "toSelectedActivePoll") {
            let guest = segue.destination as! NewPollViewController
            guest.pollId = pollId
            guest.pollTitle = pollTitle
        }
        if (segue.identifier == "toSelectedOldPoll") {
            let guest = segue.destination as! OldPollViewController
            guest.pollId = pollId
            guest.pollTitle = pollTitle
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
