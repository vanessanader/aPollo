//
//  StudentQuestionsViewController.swift
//  aPollo
//
//  Created by Vanessa Nader on 4/17/18.
//  Copyright © 2018 Vanessa Nader. All rights reserved.
//

import UIKit
import CCMPopup

class StudentQuestionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tempClass = Class(id : "", courseName: "", courseNumber: "", location: "", sectionNumber: "", professorEmail: "", evaluationNumber : 0, evaluationIsStopped: false, evaluationId: "", studentsEnrolled: [], classPolls: [], questionsAsked: [])

    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        table.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : StudentQTableViewCell = table.dequeueReusableCell(withIdentifier: "StudentQuestionCell", for : indexPath) as! StudentQTableViewCell
        
        if indexPath.row == 0 {
            cell.topic.text = "Ask a Question"
        }
        else {
            cell.topic.text = "Answered Student Questions"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        if (indexPath.row == 0){
            performSegue(withIdentifier: "toQuestion", sender: self)
        }
        else {
            performSegue(withIdentifier: "toAnswered", sender: self)
        }
        
        return indexPath
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "toQuestion") {
            var popupSegue: CCMPopupSegue? = (segue as? CCMPopupSegue)
            popupSegue?.destinationBounds = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(300), height: CGFloat(200))
            
            popupSegue?.dismissableByTouchingBackground = true
            
            let popController = popupSegue?.destination as! StudentQuestionViewController
            
            
            popController.tempClass = tempClass
            
            
        }
        
        if (segue.identifier == "toAnswered"){
            let guest = segue.destination as! AnsweredQuestionsViewController
            guest.tempClass = tempClass
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 69.0
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
