//
//  Schedule.swift
//  calendar
//
//  Created by 김지연 on 2021/05/26.
//

import Foundation

class Schedule: NSObject{
    var title: String
    var date: String
    var start: String
    var finish: String
    var memo: String
    
    init(title: String, date: String, start: String, finish: String, memo: String)
    {
        self.title = title
        self.date = date
        self.start = start
        self.finish = finish
        self.memo = memo
        super.init()
    }
}

extension Schedule{
    func clone() -> Schedule{
        let sche = Schedule(title: "", date: "", start: "", finish: "", memo: "")
        sche.title = title
        sche.date = date
        sche.start = start
        sche.finish = finish
        sche.memo = memo
        return sche
    }
}

extension Schedule{
    func isEqual(schedule: Schedule) -> Bool{
        if schedule.title != title {return false}
        else if schedule.date != date {return false}
        else if schedule.start != start {return false}
        else if schedule.finish != finish {return false}
        else if schedule.memo != memo {return false}
        
        return true
        
    }
}
