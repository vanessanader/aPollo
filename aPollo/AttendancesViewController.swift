//
//  AttendancesViewController.swift
//  aPollo
//
//  Created by Vanessa Nader on 4/10/18.
//  Copyright © 2018 Vanessa Nader. All rights reserved.
//

import UIKit
import Firebase

class AttendancesViewController: UIViewController {

    @IBOutlet weak var attendanceCount: UILabel!
    var tempClass = Class(id : "", courseName: "", courseNumber: "", location: "", sectionNumber: "", professorEmail: "", evaluationNumber : 0, evaluationIsStopped: false, evaluationId: "", studentsEnrolled: [], classPolls: [], questionsAsked: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var ref = UserDefaults.standard.string(forKey: "email")!.components(separatedBy: "@")
        Database.database().reference().child("Users").child("Students").child(ref[0]).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.hasChild("Classes"){ //add lists
                
                
                let snapshotV = snapshot.value as? NSDictionary
                let snapshotValue = snapshotV!["Classes"] as? NSDictionary
                let snapshotClass = snapshotValue![self.tempClass.id] as? NSDictionary
                print(snapshotClass!)
                self.attendanceCount.text = String(snapshotClass!["AbsenceCount"] as! Int)
                
               
            }
        })
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
