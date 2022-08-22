//
//  SwiftUIView.swift
//  Clowy2
//
//  Created by Егор Карпухин on 14.04.2022.
//

import SwiftUI

struct GreetingView: View {
    var color: String
    var username = UserDefaults.standard.string(forKey: "username")
    
    @State var identifier = "en"
    
    func convertDateFormate(date : Date) -> String{
        // Day
        let calendar = Calendar.current
        let anchorComponents = calendar.dateComponents([.day, .month, .year], from: date)

        // Formate
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "MMM"
        dateFormate.locale = Locale(identifier: identifier)
        let newDate = dateFormate.string(from: date)

        var day  = "\(anchorComponents.day!)"
        switch (day) {
        case "1" , "21" , "31":
            day.append("st")
        case "2" , "22":
            day.append("nd")
        case "3" ,"23":
            day.append("rd")
        default:
            day.append("th")
        }
        return newDate + " " + day
            
    }
    
    var body: some View {
        HStack {
            AvatarIcon(color: color)
            VStack(alignment: .leading, spacing: 4) {
                let myCurrentDate = convertDateFormate(date: Date())
                Text(myCurrentDate)
                    .font(.custom("Montserrat-Regular", size: 12))
                    .foregroundColor(Color(hex: "#646C75"))
                Text("Hello, " + (username ?? "Username"))
                    .font(.custom("Montserrat-SemiBold", size: 20))
                    .foregroundColor(Color(hex: "#23232D"))
            }
            .padding(.leading)
            Spacer()
        }
    }
}

struct GreetingView_Previews: PreviewProvider {
    static var previews: some View {
        GreetingView(color: "")
    }
}
