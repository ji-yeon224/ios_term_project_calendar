//
//  ScheduleList.swift
//  calendar
//
//  Created by 김지연 on 2021/05/29.
//

import Foundation

class ScheduleList: NSObject{
    var schedules = [Schedule]()
    var date: String
    
    init(date: String){
        self.date = date
        super.init()
    }
    
    func count() -> Int{
        return schedules.count
    }
    
    func addSchedule(schedule:Schedule){
        schedules.append(schedule)
    }
    func modifySchedule(schedule: Schedule, index: Int){
        schedules[index] = schedule
    }
    func removeSchedule(index: Int){
        schedules.remove(at: index)
    }
    
}
