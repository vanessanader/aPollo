//
//  ClassDetailsViewController.swift
//  aPollo
//
//  Created by Vanessa Nader on 4/10/18.
//  Copyright © 2018 Vanessa Nader. All rights reserved.
//

import UIKit
import CCMPopup

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
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var navBarTitle: UINavigationItem!
    
    var tempClass = Class(id : "", courseName: "", courseNumber: "", location: "", sectionNumber: "", professorEmail: "", evaluationNumber : 0, evaluationIsStopped: false, evaluationId: "", studentsEnrolled: [], classPolls: [], questionsAsked: [])
    
   
    @IBOutlet weak var askQuestionView: UIView!
    @IBOutlet weak var weeklyReviewView: UIView!
    @IBOutlet weak var attendanceView: UIView!
    @IBOutlet weak var pollsView: UIView!
    @IBOutlet weak var navBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Class" , tempClass)
        // Do any additional setup after loading the view.
        navBarTitle.title = tempClass.courseNumber + " - Section " + tempClass.sectionNumber
        
        menuButton.target = self.revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        

        pollsView.layer.roundCorners(radius: 10)
        pollsView.layer.addShadow()
        askQuestionView.layer.roundCorners(radius: 10)
        askQuestionView.layer.addShadow()
        weeklyReviewView.layer.roundCorners(radius: 10)
        weeklyReviewView.layer.addShadow()
        attendanceView.layer.roundCorners(radius: 10)
        attendanceView.layer.addShadow()
        
    }
    
    @IBAction func questionButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "toQuestion", sender: self)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "toQuestion") {
            var popupSegue: CCMPopupSegue? = (segue as? CCMPopupSegue)
            popupSegue?.destinationBounds = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(300), height: CGFloat(200))
            
            popupSegue?.dismissableByTouchingBackground = true
            
            let popController = popupSegue?.destination as! StudentQuestionViewController
            
         
            popController.tempClass = tempClass
            
            
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
