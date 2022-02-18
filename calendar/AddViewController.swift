//
//  AddViewController.swift
//  calendar
//
//  Created by 김지연 on 2021/05/26.
//

import UIKit

class AddViewController: UIViewController, UITextViewDelegate{

    
    @IBOutlet weak var titleTextfield: UITextField!
    
    @IBOutlet weak var memoTextview: UITextView!
    @IBOutlet weak var startPickerview: UIDatePicker!
    @IBOutlet weak var finishPickerview: UIDatePicker!
    var date: String!
    var schedule: Schedule?
    
}
extension AddViewController{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        schedule = schedule ?? Schedule(title: "", date: "", start: "", finish: "", memo: "")
        titleTextfield.text = schedule!.title
        
        let formatter = DateFormatter() // DateFormatter 클래스 상수 선언
        formatter.dateFormat = "HH:mm"
        if !schedule!.start.isEmpty{
            startPickerview.date = formatter.date(from: schedule!.start)!
            finishPickerview.date = formatter.date(from: schedule!.finish)!
        }
        
        memoTextview.delegate = self
        self.memoTextview.layer.borderWidth = 1
        self.memoTextview.layer.borderColor = UIColor.darkGray.cgColor
        self.memoTextview.layer.cornerRadius = 10
        
        navigationItem.title = date
        
        //memoTextView placeholder
        memoTextview.text = schedule!.memo
        if schedule!.memo == "내용입력"{
            memoTextview.textColor = UIColor.lightGray
        }
        if schedule!.memo == ""{
            memoTextview.text = "내용입력"
            memoTextview.textColor = UIColor.lightGray
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        
        
        
       
        
    }
    
}



extension AddViewController{
    @objc func dismissKeyboard(sender: UITapGestureRecognizer){
        view.endEditing(true)
    }
}

extension AddViewController{
    @IBAction func saveButton(_ sender: Any) {
       
        let formatter = DateFormatter() // DateFormatter 클래스 상수 선언
        formatter.dateFormat = "HH:mm"
        schedule!.title = titleTextfield.text!
        schedule!.date = date
        schedule!.start = formatter.string(from: startPickerview.date)
        schedule!.finish = formatter.string(from: finishPickerview.date)
        schedule!.memo = memoTextview.text
        
        alert()
        
    }
    

    

}

extension AddViewController{
    func alert(){
        let alert = UIAlertController(title: "SAVE", message: "일정이 저장되었습니다.", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: false, completion: nil)
    }
}

extension AddViewController{
    func textViewSetupView(){
        if memoTextview.text == "내용입력" {
            memoTextview.text = ""
            memoTextview.textColor = UIColor.black

        } else if memoTextview.text == ""{
            memoTextview.text = "내용입력"
            memoTextview.textColor = UIColor.lightGray
        }
    }
}

extension AddViewController{
    func textViewDidBeginEditing(_ textView: UITextView) {
        textViewSetupView()
    }

    //편집 종료
    func textViewDidEndEditing(_ textView: UITextView) {
        if memoTextview.text == ""{
            textViewSetupView()
        }
    }

    //텍스트 입력될때
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            memoTextview.resignFirstResponder()
        }
        return true
    }



}


