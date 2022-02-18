//
//  DateList.swift
//  calendar
//
//  Created by 김지연 on 2021/05/29.
//

import Foundation

class DateList: NSObject{
    var scheduleLists = [ScheduleList]()
    var event:[String]
    override init(){
        event = []
        super.init()
        
    }
    func count() -> Int{
        return scheduleLists.count
    }
    func addList(scheduleList: ScheduleList){
        
        scheduleLists.append(scheduleList)
        event.append(scheduleList.date)
    }
    
    func find(date: String) -> ScheduleList{
        var sc = ScheduleList(date: date)
        if scheduleLists.count == 0{
            return sc
        }
        for i in 0...scheduleLists.count-1{
            if scheduleLists[i].date == date {
                sc = scheduleLists[i]
                break
            }
            
        }
        return sc
    }
    
    func isExit(date:String) -> Bool{
        if scheduleLists.count == 0{
            return false
        }
        for i in 0...scheduleLists.count-1{
            if scheduleLists[i].date == date {
                return true
            }
            
        }
        return false
    }
}
