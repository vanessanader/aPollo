//
//  AnsweredQuestionsViewController.swift
//  aPollo
//
//  Created by Vanessa Nader on 4/17/18.
//  Copyright © 2018 Vanessa Nader. All rights reserved.
//

import UIKit
import Firebase

class AnsweredQuestionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var studentsQuestions : [StudentQuestion] = []
    {
        didSet{
            table.reloadData()
        }
    }
    
    @IBAction func back(_ sender: Any) {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        Database.database().reference().child("Classes").child(tempClass.id).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.hasChild("StudentQuestions"){ //add lists
                
                
                let snapshotV = snapshot.value as? NSDictionary
                let snapshotValue = snapshotV!["StudentQuestions"] as? NSDictionary
                
                for element in snapshotValue! {
                    print("snap", element.value)
                    var q = element.value as? NSDictionary
                    let question = q!["QuestionText"] as! String
                    var answer = ""
                    if (q!["AnswerText"] as! String != ""){
                        answer = q!["AnswerText"] as! String
                        var newquestion = StudentQuestion(id: "", courseNumber: "", questionText: question, answerText: answer)
                        self.studentsQuestions.append(newquestion)
                    }
                 
                    
                    
                }
            }
        
        })
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentsQuestions.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        
        var numOfSections: Int = 0
        if studentsQuestions.count != 0
        {
            tableView.separatorStyle = .singleLine
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        else
        {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No questions answered yet"
            noDataLabel.textColor     = UIColor(red:0.01, green:0.47, blue:0.98, alpha:1.0)
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : AnsweredQuestionsTableViewCell = table.dequeueReusableCell(withIdentifier: "Q&A", for : indexPath) as! AnsweredQuestionsTableViewCell
        
        cell.questionText.text = studentsQuestions[indexPath.row].questionText
        cell.answerText.text = studentsQuestions[indexPath.row].answerText
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    var tempClass = Class(id : "", courseName: "", courseNumber: "", location: "", sectionNumber: "", professorEmail: "", evaluationNumber : 0, evaluationIsStopped: false, evaluationId: "", studentsEnrolled: [], classPolls: [], questionsAsked: [])
    
    
    override func viewWillAppear(_ animated: Bool) {
        table.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 236.0
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
