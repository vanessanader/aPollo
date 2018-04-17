//
//  OldPollViewController.swift
//  aPollo
//
//  Created by Vanessa Nader on 4/16/18.
//  Copyright © 2018 Vanessa Nader. All rights reserved.
//

import UIKit
import Firebase

class OldPollViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var scoreText: UILabel!
    var pollTitle = ""
    var pollId = ""
    var myPollQuestions : [PollQuestion] = []
    {
        didSet{
            scoreText.text = String(score) + "/" + String(myPollQuestions.count)
            table.reloadData()
        }
    }
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    var score = 0
    
    var correctOrNot : [BooleanLiteralType] = []
    
    var myAnswers : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(pollTitle)
        var ref = UserDefaults.standard.string(forKey: "email")!.components(separatedBy: "@")
        navigationBar.title = pollTitle
        Database.database().reference().child("Polls").child(pollId).child("PollQuestions").observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            let snapshotValue = snapshot.value as? NSDictionary
            
            for element in snapshotValue! {
                print("snap", element)
                Database.database().reference().child("PollQuestions").child("\(element.key as! String)").observeSingleEvent(of: .value, with: {
                    (snapshot) in
                    var answers = [""]
                    let snapshotV = snapshot.value as? NSDictionary
                    let questionText = snapshotV!["QuestionText"] as! String
                    let correctAnswer = snapshotV!["CorrectAnswer"] as! String
                    let answerDict = snapshotV!["AnswersByStudents"] as? NSDictionary
             
                    let myAnswer = answerDict![ref[0]] as! String
                    if (myAnswer.lowercased() == correctAnswer.lowercased())
                    {
                        self.correctOrNot.append(true)
                        self.score += 1
                    }
                    else {
                        self.correctOrNot.append(false)
                    }
                    
                    self.myAnswers.append(myAnswer)
                    var newquest = PollQuestion(id: element.key as! String, questionText: questionText, possibleAnswers: [], answersByStudents: [], isMCQ: false, correctAnswer: correctAnswer)
                    self.myPollQuestions.append(newquest)
                    print("count", self.myPollQuestions.count)
                    
                    
                })
            }
            
        })
        
        
        
        // Do any additional setup after loading the view.
    }

    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPollQuestions.count
    }
    
    override func viewWillAppear(_ animated: Bool) {
        table.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : OldPollTableViewCell = table.dequeueReusableCell(withIdentifier: "pollQuestion", for : indexPath) as! OldPollTableViewCell
        
       
        let q = myPollQuestions[indexPath.row].questionText
        cell.correctAnswerText.text = myPollQuestions[indexPath.row].correctAnswer
       
        let range               = (q as NSString).range(of: q)
        let attributedString    = NSMutableAttributedString(string: q)
        
        
//        attributedString.addAttribute(NSAttributedStringKey.underlineStyle, value: NSNumber(value: 1), range: range)
//        attributedString.addAttribute(NSAttributedStringKey.underlineColor, value: UIColor.black, range: range)

        attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 18.0, weight:.semibold), range: range)
        //textView.attributedText = attributedString
        
        cell.questionText.attributedText = attributedString
        cell.yourAnswerText.text = myAnswers[indexPath.row]
        if correctOrNot[indexPath.row]{
            cell.yourAnswerText.textColor = UIColor.green
        }
        else {
            cell.yourAnswerText.textColor = UIColor.red
        }
        
        return cell
    }
    
    @IBOutlet weak var table: UITableView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 212
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
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
