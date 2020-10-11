//
//  AttendanceQuestionViewController.swift
//  aPollo
//
//  Created by Vanessa Nader on 4/11/18.
//  Copyright © 2018 Vanessa Nader. All rights reserved.
//

import UIKit
import Firebase

class AttendanceQuestionViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var answerTextField: UITextField!
    
    var tempClass = Class(id : "", courseName: "", courseNumber: "", location: "", sectionNumber: "", professorEmail: "", evaluationNumber : 0, evaluationIsStopped: false, evaluationId: "", studentsEnrolled: [], classPolls: [], questionsAsked: [])
    
    var answerText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        answerTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        answerTextField.resignFirstResponder()
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func checkAttendancePressed(_ sender: Any) {
        if (answerTextField.text == ""){
            let alert  = UIAlertController(title: "Empty answer", message: "Please answer the question provided to confirm your attendance", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            
            
            if (answerTextField.text!.lowercased() == answerText.lowercased()){
                let ref2 = UserDefaults.standard.string(forKey: "email")!.components(separatedBy: "@")
                Database.database().reference().child("Users").child("Students").child(ref2[0]).child("Classes").child(self.tempClass.id).child("IsPresent").setValue(true)
            let alert  = UIAlertController(title: "Marked Present", message: "Your attendance to today's class was confirmed", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {
                action in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            }
            else {
                let alert  = UIAlertController(title: "Attendance Error", message: "Your answer didn't match the one set by the professor, you weren't marked present", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }
}
