//
//  ClassDetailsViewController.swift
//  aPollo
//
//  Created by Vanessa Nader on 4/10/18.
//  Copyright © 2018 Vanessa Nader. All rights reserved.
//

import UIKit
import CCMPopup
import Firebase

extension CALayer {
    func addShadow() {
        self.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius:self.cornerRadius).cgPath
        self.shadowColor = UIColor.black.cgColor
        self.shadowOpacity = 0.5
        self.shadowOffset = CGSize(width: 3.0,height: 3.0)
        self.shadowRadius = 1
        self.masksToBounds = false
    }

    func roundCorners(radius: CGFloat) {
        self.cornerRadius = radius
    }
}

class ClassDetailsViewController: UIViewController {
    
    @IBAction func backPressed(_ sender: Any) {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var navBarTitle: UINavigationItem!
    
    var tempClass = Class(id : "", courseName: "", courseNumber: "", location: "", sectionNumber: "", professorEmail: "", evaluationNumber : 0, evaluationIsStopped: false, evaluationId: "", studentsEnrolled: [], classPolls: [], questionsAsked: [])
    
   
    @IBOutlet weak var askQuestionView: UIView!
    @IBOutlet weak var weeklyReviewView: UIView!
    @IBOutlet weak var attendanceView: UIView!
    @IBOutlet weak var pollsView: UIView!
    @IBOutlet weak var navBar: UINavigationBar!
    
      var answerText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Class" , tempClass)
        // Do any additional setup after loading the view.
        navBarTitle.title = tempClass.courseNumber + " - Section " + tempClass.sectionNumber
     
        pollsView.layer.roundCorners(radius: 10)
        pollsView.layer.addShadow()
        askQuestionView.layer.roundCorners(radius: 10)
        askQuestionView.layer.addShadow()
        weeklyReviewView.layer.roundCorners(radius: 10)
        weeklyReviewView.layer.addShadow()
        attendanceView.layer.roundCorners(radius: 10)
        attendanceView.layer.addShadow()
        
        //check if attendance question is available
       var ref =  Database.database().reference().child("Classes").child(tempClass.id).child("AttendanceQuestion")
        ref.observe(.childAdded, with: { (snapshot) -> Void in
            print(snapshot)
             let snapshotV = snapshot.value as? NSDictionary
             print(snapshotV)
            let isAvailable = snapshotV!["IsAvailable"] as! BooleanLiteralType
            self.answerText = snapshotV!["AnswerText"] as! String
            let ref2 = UserDefaults.standard.string(forKey: "email")!.components(separatedBy: "@")
            Database.database().reference().child("Users").child("Students").child(ref2[0]).child("Classes").child(self.tempClass.id).child("IsPresent").observeSingleEvent(of: .value, with: { (snapshot) in
                    let isPresent = snapshot.value! as! BooleanLiteralType

                if (!isPresent && isAvailable){
                    self.performSegue(withIdentifier: "toAttendanceCheck", sender: self)
                }
            })

        })
        ref.observe(.childChanged, with: { (snapshot) -> Void in
            let snapshotV = snapshot.value as? NSDictionary
            print(snapshot)
            let isAvailable = snapshotV!["IsAvailable"] as! BooleanLiteralType
             self.answerText = snapshotV!["AnswerText"] as! String
            let ref2 = UserDefaults.standard.string(forKey: "email")!.components(separatedBy: "@")
            Database.database().reference().child("Users").child("Students").child(ref2[0]).child("Classes").child(self.tempClass.id).child("IsPresent").observeSingleEvent(of: .value, with: { (snapshot) in
                let isPresent = snapshot.value! as! BooleanLiteralType
                
                if (!isPresent && isAvailable){
                    self.performSegue(withIdentifier: "toAttendanceCheck", sender: self)
                }
            })
            
        })
      
        
    }
    
    @IBAction func questionButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "toStudentQuestions", sender: self)
    }

    @IBAction func attendancesButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "toAttendances", sender: self)
    }
    
    @IBAction func pollButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "toPolls", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if (segue.identifier == "toAttendances"){
            var popupSegue: CCMPopupSegue? = (segue as? CCMPopupSegue)
            popupSegue?.destinationBounds = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(300), height: CGFloat(200))
            
            popupSegue?.dismissableByTouchingBackground = true
            
            let popController = popupSegue?.destination as! AttendancesViewController
            
            
            popController.tempClass = tempClass
        }
        
        if (segue.identifier == "toAttendanceCheck"){
            var popupSegue: CCMPopupSegue? = (segue as? CCMPopupSegue)
            popupSegue?.destinationBounds = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(300), height: CGFloat(500))
            
            popupSegue?.dismissableByTouchingBackground = true
            
            let popController = popupSegue?.destination as! AttendanceQuestionViewController
            
            popController.answerText = answerText
            popController.tempClass = tempClass
        }
        
        if (segue.identifier == "toPolls"){
            let guest = segue.destination as! PollsListViewController
            guest.tempClass = tempClass
        }
        if (segue.identifier == "toStudentQuestions"){
            let guest = segue.destination as! StudentQuestionsViewController
            guest.tempClass = tempClass
        }
        
    
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
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
