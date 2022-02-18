//
//  ViewController.swift
//  calendar
//
//  Created by 김지연 on 2021/05/23.
//

import UIKit
import FSCalendar

class ViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate {

    @IBOutlet weak var calendar: FSCalendar!
    
    var dateStr: String!
    var dateList : DateList?
    var scheduleList: ScheduleList!
    var eventDate : [Date] = []
    var schedule : Schedule!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var scheduleTableview: UITableView!
    
}
extension ViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        calendar.dataSource = self
        customCalendar()
       
        let nowDate = Date() // 현재의 Date (ex: 2020-08-13 09:14:48 +0000)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy-MM-dd" // 2020-08-13 16:30
        
        
        
        
        dateStr = dateFormatter.string(from: nowDate)
        dateLabel.text = dateStr
        if let sceneDelegate = (UIApplication.shared.connectedScenes.first as? UIWindowScene)!.delegate as? SceneDelegate{
            dateList = sceneDelegate.dateList
        }
        
        
        if let text: String = dateStr {
            scheduleList = dateList?.find(date: text)
        }
        scheduleTableview.dataSource = self
        scheduleTableview.delegate = self
    }
    
   
    

}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheduleList.count()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTableCell")!
        
        let schedule = scheduleList.schedules[indexPath.row]
        
        
        cell.textLabel!.text = schedule.title
        cell.detailTextLabel?.text = "\(schedule.start)" + " ~ " + "\(schedule.finish)"
        cell.backgroundColor = .white
        return cell
    }
    
    
}


extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)!.backgroundColor = .white
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)!.backgroundColor = .white
    }
}

extension ViewController{
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
                self.calendar.reloadData()
            }
            alertController.addAction(cancelAction)
            alertController.addAction(deleteAction)
         
            
            present(alertController, animated: true)
            
        }
    }
}
extension ViewController{
        override func viewDidAppear(_ animated: Bool) {
            
            if let text: String = dateStr {
                scheduleList = dateList?.find(date: text)
            }
            //수정 시
            if let indexPath = scheduleTableview.indexPathForSelectedRow{
                
                guard let scheduleClone = schedule else {return}
                if scheduleClone.isEqual(schedule: scheduleList.schedules[indexPath.row]) == false{
                    scheduleList.modifySchedule(schedule: scheduleClone, index: indexPath.row)
                    scheduleTableview.reloadRows(at: [indexPath], with: .automatic )
                }
                scheduleTableview.reloadRows(at: [indexPath], with: .automatic )
                scheduleTableview.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                scheduleTableview.cellForRow(at: indexPath)?.backgroundColor = .white
                
            }
            //새로운 일정 등록
            else if let scheduleClone = schedule{
                //타이틀 입력 안되면 생성x
                if scheduleClone.title.isEmpty{
                    return
                }
                
                scheduleList.addSchedule(schedule: scheduleClone)
                let indexPath = IndexPath(row: scheduleList.count()-1, section: 0)
                scheduleTableview.insertRows(at: [indexPath], with: .automatic)
                
                if scheduleList.count() == 1{
                    if !dateList!.isExit(date: dateStr){
                        dateList?.addList(scheduleList: scheduleList)
                    }

                }
            }
            //이벤트 표시 위해서
            if dateList?.event.count != 0 {
                print("--")
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yy-MM-dd"
                eventDate.append(dateFormatter.date(from: dateList!.event[dateList!.event.count-1])!)
                calendar.reloadData()
                customCalendar()
            }
            
            
    
        }
}

extension ViewController{
        func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
            if self.eventDate.contains(date){
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "YY-MM-dd"
                let d = dateFormatter.string(from: date)
                if dateList?.find(date: d).count() == 0{
                    return 0
                }
                
                return 1
            }
            return 0
        }
    
}

extension ViewController{
    func customCalendar(){
        calendar.appearance.selectionColor = UIColor(red: 204/255, green: 153/255, blue: 235/255, alpha: 1)
        calendar.appearance.todayColor = UIColor(red: 000/255, green: 153/255, blue: 255/255, alpha: 1)
        // 스와이프 스크롤 작동 여부 ( 활성화하면 좌측 우측 상단에 다음달 살짝 보임, 비활성화하면 사라짐 )
        calendar.scrollEnabled = true
        // 스와이프 스크롤 방향 ( 버티칼로 스와이프 설정하면 좌측 우측 상단 다음달 표시 없어짐, 호리젠탈은 보임 )
        calendar.scrollDirection = .vertical
        calendar.appearance.headerTitleColor  = UIColor(red:000/255, green: 000/255, blue: 000/255, alpha: 1)
        calendar.appearance.headerTitleColor = .black
        
        
        calendar.calendarWeekdayView.weekdayLabels[0].textColor = .red
        calendar.calendarWeekdayView.weekdayLabels[1].textColor = .black
        calendar.calendarWeekdayView.weekdayLabels[2].textColor = .black
        calendar.calendarWeekdayView.weekdayLabels[3].textColor = .black
        calendar.calendarWeekdayView.weekdayLabels[4].textColor = .black
        calendar.calendarWeekdayView.weekdayLabels[5].textColor = .black
        calendar.calendarWeekdayView.weekdayLabels[6].textColor = .blue
        
        

    }
}

extension ViewController {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY-MM-dd"
        dateStr = dateFormatter.string(from: date)
        dateLabel.text = dateStr
        
        calendar.appearance.eventDefaultColor = UIColor.red
        calendar.appearance.eventSelectionColor = UIColor.red
        
        //스케줄이 등록되어 있는지 확인 후 테이블 뷰 reload
        if let text: String = dateStr {
            scheduleList = dateList?.find(date: text)
            scheduleTableview.reloadData()
        }
    }

}


extension ViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let addVC = segue.destination as! AddViewController
        if segue.identifier == "addSc"{
            schedule = Schedule(title: "", date: "", start: "", finish: "", memo: "")
            addVC.schedule = schedule
            addVC.date = dateStr
        }
        if segue.identifier == "editSc"{
            if let row = scheduleTableview.indexPathForSelectedRow?.row{
                schedule =  scheduleList.schedules[row].clone()
                addVC.schedule = schedule
                addVC.date = dateStr
            }
        }
    }
}
