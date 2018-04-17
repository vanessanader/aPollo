//
//  NewPollViewController.swift
//  aPollo
//
//  Created by Vanessa Nader on 4/16/18.
//  Copyright © 2018 Vanessa Nader. All rights reserved.
//

import UIKit
import Firebase

class NewPollViewController: UIViewController {

    var pollId = ""
    
    var counter = 0
    
    var myPollQuestions : [PollQuestion] = []
    {
        didSet{
            update()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        answer1.isHidden = true
        answer2.isHidden = true
        answer3.isHidden = true
        answer4.isHidden = true
        openEndedAnswer.isHidden = true
        
        Database.database().reference().child("Polls").child(pollId).child("PollQuestions").observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            let snapshotValue = snapshot.value as? NSDictionary
            
            for element in snapshotValue! {
                print("snap", element)
                Database.database().reference().child("PollQuestions").child("\(element.key as! String)").observeSingleEvent(of: .value, with: {
                    (snapshot) in
                    var answers = [""]
                     let snapshotV = snapshot.value as? NSDictionary
                    let questionText = snapshotV!["QuestionText"] as! String
                    let isMCQ = snapshotV!["IsMCQ"] as! BooleanLiteralType
                    if (isMCQ){
                        let dict = snapshotV!["PossibleAnswers"] as! NSDictionary
                    answers = Array(dict.allValues) as! [String]
                        
                        var newquest = PollQuestion(id: "", questionText: questionText, possibleAnswers: answers, answersByStudents: [], isMCQ: isMCQ, correctAnswer: "")
                        self.myPollQuestions.append(newquest)
                    }
                    
                    
                })
            }
            
        })
        
        

        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var answer1: UIButton!
    @IBOutlet weak var answer2: UIButton!
    @IBOutlet weak var answer3: UIButton!
    @IBOutlet weak var answer4: UIButton!
    @IBOutlet weak var openEndedAnswer: UITextField!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func answer1Pressed(_ sender: Any) { //save to database the answer
        
    }
    
    @IBAction func answer2Pressed(_ sender: Any) {
    }
    
    @IBAction func answer3Pressed(_ sender: Any) {
    }
    
    @IBAction func answer4Pressed(_ sender: Any) {
    }
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    func update(){ //connect it to next
        answer1.isHidden = true
        answer2.isHidden = true
        answer3.isHidden = true
        answer4.isHidden = true
        openEndedAnswer.isHidden = true
    }
    @IBAction func nextPressed(_ sender: Any) {
    }
    
    @IBOutlet weak var nextButton: UIBarButtonItem!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
