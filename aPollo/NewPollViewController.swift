//
//  NewPollViewController.swift
//  aPollo
//
//  Created by Vanessa Nader on 4/16/18.
//  Copyright © 2018 Vanessa Nader. All rights reserved.
//

import UIKit
import Firebase


class NewPollViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var pollId = ""
    
    var pollTitle = ""
    
    var counter = 0
    
    var indexPathArray : [IndexPath] = []
    
    var myPollQuestions : [PollQuestion] = []
    {
        didSet{
          table.reloadData()
          
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(pollTitle)
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
                    let isMCQ = snapshotV!["IsMCQ"] as! BooleanLiteralType
                    if (isMCQ){
                        let dict = snapshotV!["PossibleAnswers"] as! NSDictionary
                    answers = Array(dict.allValues) as! [String]
                        answers = answers.sorted { $0 < $1 }
                        
                       
                        
                    }
                    var newquest = PollQuestion(id: element.key as! String, questionText: questionText, possibleAnswers: answers, answersByStudents: [], isMCQ: isMCQ, correctAnswer: "")
                    self.myPollQuestions.append(newquest)
                    print("count", self.myPollQuestions.count)
                    
                    
                })
            }
            
        })
        
        

        // Do any additional setup after loading the view.
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
        return myPollQuestions.count
    }
    
    override func viewWillAppear(_ animated: Bool) {
        table.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath){
            cell.selectionStyle = UITableViewCellSelectionStyle.none
        }
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if myPollQuestions[indexPath.row].isMCQ{
            let cell : MCQTableViewCell = table.dequeueReusableCell(withIdentifier: "MCQCell", for : indexPath) as! MCQTableViewCell
            if myPollQuestions[indexPath.row].possibleAnswers.count >= 2
            {
                cell.answer1.setTitle(myPollQuestions[indexPath.row].possibleAnswers[0], for: .normal)
                cell.answer2.setTitle(myPollQuestions[indexPath.row].possibleAnswers[1], for: .normal)
                cell.answer1.tag = indexPath.row
                cell.answer2.tag = indexPath.row
                
                cell.answer1.addTarget(self, action: #selector(answer1Pressed), for: UIControlEvents.touchUpInside)
                cell.answer2.addTarget(self, action: #selector(answer2Pressed), for: UIControlEvents.touchUpInside)
            }
            if myPollQuestions[indexPath.row].possibleAnswers.count >= 3
            {
                cell.answer3.tag = indexPath.row
                cell.answer3.setTitle(myPollQuestions[indexPath.row].possibleAnswers[2], for: .normal)
                cell.answer3.addTarget(self, action: #selector(answer3Pressed), for: UIControlEvents.touchUpInside)
            }
             if myPollQuestions[indexPath.row].possibleAnswers.count == 4 {
                cell.answer4.tag = indexPath.row
                cell.answer4.setTitle(myPollQuestions[indexPath.row].possibleAnswers[3], for: .normal)
                cell.answer4.addTarget(self, action: #selector(answer4Pressed), for: UIControlEvents.touchUpInside)
            }
            cell.questionText.text = myPollQuestions[indexPath.row].questionText
            indexPathArray.append(indexPath)
            return cell
            
        }
        let cell : OpenEndedTableViewCell = table.dequeueReusableCell(withIdentifier: "OpenEndedCell", for : indexPath) as! OpenEndedTableViewCell
        cell.done.tag = indexPath.row
        cell.done.addTarget(self, action: #selector(doneButtonPressed), for: UIControlEvents.touchUpInside)
        cell.questionText.text =  myPollQuestions[indexPath.row].questionText
        indexPathArray.append(indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if myPollQuestions[indexPath.row].isMCQ{
             if myPollQuestions[indexPath.row].possibleAnswers.count == 2
            {
                return 310
            }
            if myPollQuestions[indexPath.row].possibleAnswers.count == 3
            {
                return 385
            }
            
            return 463
            
        }
        return 293
    }

    @IBOutlet weak var navigationBar: UINavigationItem!
    

    @IBAction func nextPressed(_ sender: Any) {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func answer1Pressed(_ sender: UIButton){
        var ref = UserDefaults.standard.string(forKey: "email")!.components(separatedBy: "@")
    Database.database().reference().child("PollQuestions").child(myPollQuestions[sender.tag].id).child("AnswersByStudents").child(ref[0]).setValue(myPollQuestions[sender.tag].possibleAnswers[0])
         let cell: MCQTableViewCell = table.cellForRow(at: indexPathArray[sender.tag+1]) as! MCQTableViewCell
        cell.answer1.backgroundColor = UIColor(red:0.01, green:0.47, blue:0.98, alpha:1.0)
        cell.answer2.backgroundColor = UIColor.gray
        cell.answer3.backgroundColor = UIColor.gray
        cell.answer4.backgroundColor = UIColor.gray
        
    }
    
    @IBAction func answer2Pressed(_ sender: UIButton){
        var ref = UserDefaults.standard.string(forKey: "email")!.components(separatedBy: "@")
        Database.database().reference().child("PollQuestions").child(myPollQuestions[sender.tag].id).child("AnswersByStudents").child(ref[0]).setValue(myPollQuestions[sender.tag].possibleAnswers[1])
        let cell: MCQTableViewCell = table.cellForRow(at: indexPathArray[sender.tag+1]) as! MCQTableViewCell
        cell.answer2.backgroundColor = UIColor(red:0.01, green:0.47, blue:0.98, alpha:1.0)
        cell.answer1.backgroundColor = UIColor.gray
        cell.answer3.backgroundColor = UIColor.gray
        cell.answer4.backgroundColor = UIColor.gray
        
    }
    
    @IBAction func answer3Pressed(_ sender: UIButton){
        var ref = UserDefaults.standard.string(forKey: "email")!.components(separatedBy: "@")
        Database.database().reference().child("PollQuestions").child(myPollQuestions[sender.tag].id).child("AnswersByStudents").child(ref[0]).setValue(myPollQuestions[sender.tag].possibleAnswers[2])
        let cell: MCQTableViewCell = table.cellForRow(at: indexPathArray[sender.tag+1]) as! MCQTableViewCell
        cell.answer3.backgroundColor = UIColor(red:0.01, green:0.47, blue:0.98, alpha:1.0)
        cell.answer2.backgroundColor = UIColor.gray
        cell.answer1.backgroundColor = UIColor.gray
        cell.answer4.backgroundColor = UIColor.gray
        
    }
    
    @IBAction func answer4Pressed(_ sender: UIButton){
        var ref = UserDefaults.standard.string(forKey: "email")!.components(separatedBy: "@")
        Database.database().reference().child("PollQuestions").child(myPollQuestions[sender.tag].id).child("AnswersByStudents").child(ref[0]).setValue(myPollQuestions[sender.tag].possibleAnswers[3])
        let cell: MCQTableViewCell = table.cellForRow(at: indexPathArray[sender.tag+1]) as! MCQTableViewCell
        cell.answer4.backgroundColor = UIColor(red:0.01, green:0.47, blue:0.98, alpha:1.0)
        cell.answer2.backgroundColor = UIColor.gray
        cell.answer3.backgroundColor = UIColor.gray
        cell.answer1.backgroundColor = UIColor.gray
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton){
        var ref = UserDefaults.standard.string(forKey: "email")!.components(separatedBy: "@")
       

        let cell: OpenEndedTableViewCell = table.cellForRow(at: indexPathArray[sender.tag+1]) as! OpenEndedTableViewCell
        if cell.answerText.text != "" {
            Database.database().reference().child("PollQuestions").child(myPollQuestions[sender.tag].id).child("AnswersByStudents").child(ref[0]).setValue(cell.answerText.text!)
                cell.done.flash()
        }
        
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
