//
//  StudentQuestionViewController.swift
//  aPollo
//
//  Created by Vanessa Nader on 4/10/18.
//  Copyright © 2018 Vanessa Nader. All rights reserved.
//

import UIKit
import Firebase

class StudentQuestionViewController: UIViewController, UITextFieldDelegate {

    var tempClass = Class(id : "", courseName: "", courseNumber: "", location: "", sectionNumber: "", professorEmail: "", evaluationNumber : 0, evaluationIsStopped: false, evaluationId: "", studentsEnrolled: [], classPolls: [], questionsAsked: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionTyped.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var questionTyped: UITextField!
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        questionTyped.resignFirstResponder()
        return true
    }
    @IBAction func submitPressed(_ sender: Any) {
        if (questionTyped.text == ""){
            let alert  = UIAlertController(title: "Empty question", message: "Please input a question to send", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let ref = Database.database().reference().child("Classes").child(tempClass.id).child("StudentQuestions").childByAutoId()
            let newQuestion = StudentQuestion(id: ref.key, courseNumber: tempClass.id, questionText: questionTyped.text!, answerText: "")
            ref.setValue(newQuestion.toAnyObject())
            let alert  = UIAlertController(title: "Success", message: "Your question was sent", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {
            action in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
