//
//  ListViewController.swift
//  calendar
//
//  Created by 김지연 on 2021/05/25.
//

import UIKit

class ListViewController: UIViewController{
    
    
    var date: String!
    var schedule: Schedule?
    var scheduleList : ScheduleList!
    var dateList : DateList!
    @IBOutlet weak var scheduleTable: UITableView!
    
}
extension ListViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = date
        
        if let sceneDelegate = (UIApplication.shared.connectedScenes.first as? UIWindowScene)!.delegate as? SceneDelegate{
            dateList = sceneDelegate.dateList

        }
        
        scheduleList = scheduleList ?? ScheduleList(date: date)
        scheduleTable.dataSource = self
        scheduleTable.delegate = self
    }
    
}


extension ListViewController{
    override func viewDidAppear(_ animated: Bool) {
        
        //수정 시
        if let indexPath = scheduleTable.indexPathForSelectedRow{
            
            guard let scheduleClone = schedule else {return}
            if scheduleClone.isEqual(schedule: scheduleList.schedules[indexPath.row]) == false{
                scheduleList.modifySchedule(schedule: scheduleClone, index: indexPath.row)
                scheduleTable.reloadRows(at: [indexPath], with: .automatic )
            }
            scheduleTable.reloadRows(at: [indexPath], with: .automatic )
            scheduleTable.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            scheduleTable.cellForRow(at: indexPath)?.backgroundColor = .white
            
        }
        //새로운 일정 등록
        else if let scheduleClone = schedule{
            //타이틀 입력 안되면 생성x
            if scheduleClone.title.isEmpty{
                return
            }
            
            scheduleList.addSchedule(schedule: scheduleClone)
            let indexPath = IndexPath(row: scheduleList.count()-1, section: 0)
            scheduleTable.insertRows(at: [indexPath], with: .automatic)
            
            //이벤트 등록 여부 위해
            if scheduleList.count() == 1{
                if !dateList.isExit(date: date){
                    dateList.addList(scheduleList: scheduleList)
                }

            }
        }
    }
}

extension ListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheduleList.count()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell")!
        
        let schedule = scheduleList.schedules[indexPath.row]
        
        
        cell.textLabel!.text = schedule.title
        cell.detailTextLabel?.text = "\(schedule.start)" + " ~ " + "\(schedule.finish)"
        cell.backgroundColor = .white
        return cell
    }
    
    
}


extension ListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)!.backgroundColor = .white
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)!.backgroundColor = .white
    }
}


extension ListViewController{
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            
            let schedule = scheduleList.schedules[indexPath.row]
            let title = "Delete \(schedule.title)"
            let message = "삭제하시겠습니까?"
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            let deleteAction = UIAlertAction(title: "Sure", style: .destructive){
                (action) in
                self.scheduleList.removeSchedule(index: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            alertController.addAction(cancelAction)
            alertController.addAction(deleteAction)
         
            present(alertController, animated: true)
            
        }
    }
}




extension ListViewController{
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let addVC = segue.destination as! AddViewController
        if segue.identifier == "AddSc"{
            schedule = Schedule(title: "", date: "", start: "", finish: "", memo: "")
            addVC.schedule = schedule
            addVC.date = date
        }
        if segue.identifier == "EditSc"{
            if let row = scheduleTable.indexPathForSelectedRow?.row{
                schedule =  scheduleList.schedules[row].clone()
                addVC.schedule = schedule
                addVC.date = date
            }
        }
        
    }
    

}
