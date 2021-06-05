//
//  DateExtension.swift
//  MatchGameTask
//
//  Created by Sajeev Raj on 05/06/2021.
//

import UIKit

extension Date {

   func getTimeDiff(to: Date = Date()) -> (hour: Int, minute: Int, second: Int) {
       let difference = Calendar.current.dateComponents([.hour, .minute, .second], from: self, to: to)
       return ( getAbsoluteTime(difference.hour), getAbsoluteTime(difference.minute), getAbsoluteTime(difference.second))
   }

   func getAbsoluteTime(_ time: Int?) -> Int {
       guard let time = time else { return 0 }
       return time < 0 ? 0 : time
   }
}
