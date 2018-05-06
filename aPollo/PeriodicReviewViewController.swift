//
//  PeriodicReviewViewController.swift
//  aPollo
//
//  Created by Vanessa Nader on 4/23/18.
//  Copyright © 2018 Vanessa Nader. All rights reserved.
//

import UIKit
import Firebase
import Cosmos

class PeriodicReviewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

   
    private var ratingStorage : [Double] = []
    var evaluationNumber = 0
    var evaluationId = ""
    
    @IBOutlet weak var table: UITableView!
    
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
    

    var indexPathArray : [IndexPath] = []
    
    var myEvaluationQuestions : [EvaluationQuestion] = []
    {
        didSet{
            table.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Database.database().reference().child("PeriodicEvaluations").child(evaluationId).child("Questions").observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            let snapshotValue = snapshot.value as? NSDictionary
            
            for element in snapshotValue! {
                print("snap", element)
                
            Database.database().reference().child("PeriodicQuestions").child("\(element.value as! String)").child(String(self.evaluationNumber)).observeSingleEvent(of: .value, with: {
                    (snapshot) in
                    print("snap", snapshot)
                if snapshot.exists() {
                    var answers = [""]
                    let snapshotV = snapshot.value as? NSDictionary
                    let questionText = snapshotV!["QuestionText"] as! String
                    let isMCQ = snapshotV!["IsMCQ"] as! BooleanLiteralType
                    let isRating = snapshotV!["IsRating"] as! BooleanLiteralType
                    if (isMCQ){
                        let dict = snapshotV!["PossibleAnswers"] as! NSDictionary
                        answers = Array(dict.allValues) as! [String]
                        answers = answers.sorted { $0 < $1 }
                    }
                    let id = snapshotV!["Id"] as! String
                    var newquest = EvaluationQuestion(evaluationNumber: self.evaluationNumber, courseEvaluationId: self.evaluationId, questionText: questionText, answersByStudents: [], possibleAnswers: answers, isMCQ: isMCQ, isRating: isRating, id: id)
                    self.myEvaluationQuestions.append(newquest)
                }
                    
                    
                    
                })
            }
            
        })
        
        
        
        // Do any additional setup after loading the view.
    }
 
    override var prefersStatusBarHidden: Bool {
        return true
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myEvaluationQuestions.count
    }
    
    override func viewWillAppear(_ animated: Bool) {
        table.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
     
        if let cell = tableView.cellForRow(at: indexPath){
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        
        var numOfSections: Int = 0
        if myEvaluationQuestions.count != 0
        {
            tableView.separatorStyle = .singleLine
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        else
        {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "Click on the classes section in the menu to be able to access the reivew"
            noDataLabel.textColor     = UIColor(red:0.01, green:0.47, blue:0.98, alpha:1.0)
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
            noDataLabel.numberOfLines = 2
        }
        return numOfSections
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if myEvaluationQuestions[indexPath.row].isRating{
        let cell : RatingTableViewCell = table.dequeueReusableCell(withIdentifier: "RatingCell", for : indexPath) as! RatingTableViewCell
            
        cell.stars.settings.fillMode = .half
            
        cell.questionText.text = myEvaluationQuestions[indexPath.row].questionText

        cell.submit.tag = indexPath.row
        cell.submit.addTarget(self, action: #selector(ratingButtonPressed), for: UIControlEvents.touchUpInside)

        indexPathArray.append(indexPath)
        
        return cell
        }
        if myEvaluationQuestions[indexPath.row].isMCQ{
            let cell : MCQEvaluationTableViewCell = table.dequeueReusableCell(withIdentifier: "MCQCell", for : indexPath) as! MCQEvaluationTableViewCell
            if myEvaluationQuestions[indexPath.row].possibleAnswers.count >= 2
            {
                cell.answer1.setTitle(myEvaluationQuestions[indexPath.row].possibleAnswers[0], for: .normal)
                cell.answer2.setTitle(myEvaluationQuestions[indexPath.row].possibleAnswers[1], for: .normal)
                cell.answer1.tag = indexPath.row
                cell.answer2.tag = indexPath.row
                
                cell.answer1.addTarget(self, action: #selector(answer1Pressed), for: UIControlEvents.touchUpInside)
                cell.answer2.addTarget(self, action: #selector(answer2Pressed), for: UIControlEvents.touchUpInside)
            }
            if myEvaluationQuestions[indexPath.row].possibleAnswers.count >= 3
            {
                cell.answer3.tag = indexPath.row
                cell.answer3.setTitle(myEvaluationQuestions[indexPath.row].possibleAnswers[2], for: .normal)
                cell.answer3.addTarget(self, action: #selector(answer3Pressed), for: UIControlEvents.touchUpInside)
            }
            if myEvaluationQuestions[indexPath.row].possibleAnswers.count == 4 {
                cell.answer4.tag = indexPath.row
                cell.answer4.setTitle(myEvaluationQuestions[indexPath.row].possibleAnswers[3], for: .normal)
                cell.answer4.addTarget(self, action: #selector(answer4Pressed), for: UIControlEvents.touchUpInside)
            }
            cell.questionText.text = myEvaluationQuestions[indexPath.row].questionText
            indexPathArray.append(indexPath)
            return cell
            
        }
        let cell : OpenEndedEvaluationTableViewCell = table.dequeueReusableCell(withIdentifier: "OpenEndedCell", for : indexPath) as! OpenEndedEvaluationTableViewCell
        cell.submit.tag = indexPath.row
        cell.submit.addTarget(self, action: #selector(doneButtonPressed), for: UIControlEvents.touchUpInside)
        cell.questionText.text =  myEvaluationQuestions[indexPath.row].questionText
        indexPathArray.append(indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if myEvaluationQuestions[indexPath.row].isRating {
            return 251
        }
        if myEvaluationQuestions[indexPath.row].isMCQ{
            if myEvaluationQuestions[indexPath.row].possibleAnswers.count == 2
            {
                return 262
            }
            if myEvaluationQuestions[indexPath.row].possibleAnswers.count == 3
            {
                return 322
            }
            
            return 398
            
        }
        return 226
    }
    

    
    @IBAction func answer1Pressed(_ sender: UIButton){
        var ref = UserDefaults.standard.string(forKey: "email")!.components(separatedBy: "@")
    Database.database().reference().child("PeriodicQuestions").child(myEvaluationQuestions[sender.tag].id).child(String(self.evaluationNumber)).child("AnswersByStudents").child(ref[0]).setValue(myEvaluationQuestions[sender.tag].possibleAnswers[0])
        let cell: MCQEvaluationTableViewCell = table.cellForRow(at: indexPathArray[sender.tag+1]) as! MCQEvaluationTableViewCell
        cell.answer1.backgroundColor = UIColor(red:0.01, green:0.47, blue:0.98, alpha:1.0)
        cell.answer2.backgroundColor = UIColor.gray
        cell.answer3.backgroundColor = UIColor.gray
        cell.answer4.backgroundColor = UIColor.gray
        
    }
    
    @IBAction func answer2Pressed(_ sender: UIButton){
        var ref = UserDefaults.standard.string(forKey: "email")!.components(separatedBy: "@")
    Database.database().reference().child("PeriodicQuestions").child(myEvaluationQuestions[sender.tag].id).child(String(self.evaluationNumber)).child("AnswersByStudents").child(ref[0]).setValue(myEvaluationQuestions[sender.tag].possibleAnswers[1])
        let cell: MCQEvaluationTableViewCell = table.cellForRow(at: indexPathArray[sender.tag+1]) as! MCQEvaluationTableViewCell
        cell.answer2.backgroundColor = UIColor(red:0.01, green:0.47, blue:0.98, alpha:1.0)
        cell.answer1.backgroundColor = UIColor.gray
        cell.answer3.backgroundColor = UIColor.gray
        cell.answer4.backgroundColor = UIColor.gray
        
    }
    
    @IBAction func answer3Pressed(_ sender: UIButton){
        var ref = UserDefaults.standard.string(forKey: "email")!.components(separatedBy: "@")
    Database.database().reference().child("PeriodicQuestions").child(myEvaluationQuestions[sender.tag].id).child(String(self.evaluationNumber)).child("AnswersByStudents").child(ref[0]).setValue(myEvaluationQuestions[sender.tag].possibleAnswers[2])
        let cell: MCQEvaluationTableViewCell = table.cellForRow(at: indexPathArray[sender.tag+1]) as! MCQEvaluationTableViewCell
        cell.answer3.backgroundColor = UIColor(red:0.01, green:0.47, blue:0.98, alpha:1.0)
        cell.answer2.backgroundColor = UIColor.gray
        cell.answer1.backgroundColor = UIColor.gray
        cell.answer4.backgroundColor = UIColor.gray
        
    }
    
    @IBAction func answer4Pressed(_ sender: UIButton){
        var ref = UserDefaults.standard.string(forKey: "email")!.components(separatedBy: "@")
    Database.database().reference().child("PeriodicQuestions").child(myEvaluationQuestions[sender.tag].id).child(String(self.evaluationNumber)).child("AnswersByStudents").child(ref[0]).setValue(myEvaluationQuestions[sender.tag].possibleAnswers[3])
        let cell: MCQEvaluationTableViewCell = table.cellForRow(at: indexPathArray[sender.tag+1]) as! MCQEvaluationTableViewCell
        cell.answer4.backgroundColor = UIColor(red:0.01, green:0.47, blue:0.98, alpha:1.0)
        cell.answer2.backgroundColor = UIColor.gray
        cell.answer3.backgroundColor = UIColor.gray
        cell.answer1.backgroundColor = UIColor.gray
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton){
        var ref = UserDefaults.standard.string(forKey: "email")!.components(separatedBy: "@")
        
        
        let cell: OpenEndedEvaluationTableViewCell = table.cellForRow(at: indexPathArray[sender.tag+1]) as! OpenEndedEvaluationTableViewCell
        if cell.answerText.text != "" {
            Database.database().reference().child("PeriodicQuestions").child(myEvaluationQuestions[sender.tag].id).child(String(self.evaluationNumber)).child("AnswersByStudents").child(ref[0]).setValue(cell.answerText.text!)
        }
        
    }
    
    @IBAction func ratingButtonPressed(_ sender: UIButton){
        var ref = UserDefaults.standard.string(forKey: "email")!.components(separatedBy: "@")
        
        
        let cell: RatingTableViewCell = table.cellForRow(at: indexPathArray[sender.tag+1]) as! RatingTableViewCell
    Database.database().reference().child("PeriodicQuestions").child(myEvaluationQuestions[sender.tag].id).child(String(self.evaluationNumber)).child("AnswersByStudents").child(ref[0]).setValue(String(cell.stars.rating))
        
       
    
        
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


