//
//  WelcomeViewController.swift
//  aPollo
//
//  Created by Vanessa Nader on 3/28/18.
//  Copyright © 2018 Vanessa Nader. All rights reserved.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var myClassesList : [Class] = []
    {
        didSet{
            table.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuButton.target = self.revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        var ref = UserDefaults.standard.string(forKey: "email")!.components(separatedBy: "@")
        
        Database.database().reference().child("Users").child("Students").child(ref[0]).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.hasChild("Classes"){ //add lists
                
                
                let snapshotV = snapshot.value as? NSDictionary
                let snapshotValue = snapshotV!["Classes"] as? NSDictionary
                
                for element in snapshotValue! {
                    print("snap", element)
                    print("snapshot count: \(snapshotValue!.count)")
                    
                    Database.database().reference().child("Classes").child("\(element.key as! String)").observeSingleEvent(of: .value, with: {
                        (snapshot) in
                        let snapshotV = snapshot.value as? NSDictionary
                        print(snapshot.value)
                        
                            let courseName = snapshotV!["CourseName"] as! String
                            let courseNumber = snapshotV!["CourseNumber"] as! String
                            let evaluationId = snapshotV!["EvaluationId"] as! String
                            let evaluationStopped = snapshotV!["EvaluationIsStopped"] as! BooleanLiteralType
                            let evaluationNumber = snapshotV!["EvaluationNumber"] as! Int
                            let id = snapshotV!["Id"] as! String
                            let location = snapshotV!["Location"] as! String
                            let professorEmail = snapshotV!["ProfessorEmail"] as! String
                            let sectionNumber = snapshotV!["SectionNumber"] as! String
                            
                        let newclass = Class(id : id, courseName: courseName, courseNumber: courseNumber, location: location, sectionNumber: sectionNumber, professorEmail: professorEmail, evaluationNumber : evaluationNumber, evaluationIsStopped: evaluationStopped, evaluationId: evaluationId, studentsEnrolled: [], classPolls: [], questionsAsked: [])
                        Messaging.messaging().subscribe(toTopic: newclass.id)
                        self.myClassesList.append(newclass)
                           
                        print("Count",self.myClassesList.count)
                    })
                }
                
                
            }
        // Do any additional setup after loading the view.
    })
    }

    @IBOutlet weak var table: UITableView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myClassesList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        
        var numOfSections: Int = 0
        if myClassesList.count != 0
        {
            tableView.separatorStyle = .singleLine
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        else
        {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No classes to display"
            noDataLabel.textColor     = UIColor(red:0.01, green:0.47, blue:0.98, alpha:1.0)
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ClassesTableViewCell = table.dequeueReusableCell(withIdentifier: "myClass", for : indexPath) as! ClassesTableViewCell
        cell.classTitle.text = myClassesList[indexPath.row].courseNumber + " - " + myClassesList[indexPath.row].courseName

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath){
            cell.selectionStyle = UITableViewCellSelectionStyle.none
        }
        
    }
    
    var tempClass = Class(id : "", courseName: "", courseNumber: "", location: "", sectionNumber: "", professorEmail: "", evaluationNumber : 0, evaluationIsStopped: false, evaluationId: "", studentsEnrolled: [], classPolls: [], questionsAsked: [])
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {

            if (myClassesList.count != 0){
                tempClass = myClassesList[indexPath.row]
               
                performSegue(withIdentifier: "toClass", sender: self)
            }
            
        
        return indexPath
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if (segue.identifier == "toClass") {
            let guest = segue.destination as! ClassDetailsViewController
            guest.tempClass = tempClass
            
            
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        table.tableFooterView = UIView(frame: CGRect.zero)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    overrid prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
