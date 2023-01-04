//
//  MainView.swift
//  What time is it
//
//  Created by Kamil Skrzyński on 02/01/2023.
//

import SwiftUI

struct MainView: View {
    
    let localizationsArray = TimeZone.knownTimeZoneIdentifiers
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var timer2 = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    @State var timeNow = ""
    @State var dateNow = ""
    @State var time: Date = Date()
    @State var date: Date = Date()
    let timeFormatter = DateFormatter()
    let dateFormatter = DateFormatter()
    @State var localization = TimeZone.current.identifier
    @State var localizationName = ""
    let cities = ["Los Angeles", "New York", "London", "Paris", "Kiev", "Pekin", "Tokyo"]
    
    @StateObject private var viewModel = MainViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Spacer()
                        Image(systemName: "magnifyingglass")
                            .font(.title3)
                            .foregroundColor(.black.opacity(0.5))
                    }
                    Text("WHAT TIME IS IT")
                        .foregroundColor(.white)
                        .bold()
                        .frame(height: 40)
                        .padding(.horizontal, 6)
                        .background(
                            Rectangle()
                                .foregroundColor(Color("appRed"))
                        )
                    Spacer()
                        .frame(height: 40)
                    if localization == TimeZone.current.identifier {
                        Text("This is your actual time!")
                            .font(.title.bold())
                            .foregroundColor(Color("appGrey"))
                    }
                    HStack {
                        Text("Actual time in")
                            .font(.title2)
                            .fontWeight(.thin)
                            .foregroundColor(Color("appGrey"))
                        Text(localizationName)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color("appGrey"))
                        Text("is:")
                            .font(.title2)
                            .fontWeight(.thin)
                            .foregroundColor(Color("appGrey"))
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
            Spacer()
                .frame(height: 20)
            Text(timeFormatter.string(from: time))
                .font(.system(size: 95, weight: .black))
                .foregroundColor(Color("appGrey"))
                .onReceive(timer) { _ in
                    self.time = viewModel.getTime(for: localization, timeStyle: .time)
                    print(localization)
                    print(timeFormatter.string(from: time))
                }
            
            HStack {
                Spacer()
                Text(dateFormatter.string(from: date))
                    .foregroundColor(Color("appGrey"))
                    .font(.title2)
                    .fontWeight(.light)
                    .onReceive(timer) { _ in
                        dateFormatter.locale = Locale(identifier: "en_us")
                        self.date = viewModel.getTime(for: localization, timeStyle: .date)
                    }
            }
            .padding(.horizontal)
            
            HStack {
                Spacer()
                ForEach(cities, id: \.self) { city in
                    VStack(alignment: .trailing) {
                        Text(city)
                            .foregroundColor(Color("appGrey"))
                            .font(.footnote)
                            .fontWeight(.bold)
                        Text("02:41")
                            .foregroundColor(Color("appGrey"))
                            .font(.caption)
                            .fontWeight(.thin)
                    }
                }
            }
            .padding(.horizontal)
            Spacer()
            HStack {
                VStack(alignment: .leading) {
                    Text("Time zone")
                        .padding(.top)
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .foregroundColor(Color("appRed"))
                    HStack {
                        Rectangle()
                            .frame(width: 6, height: 6)
                        Text(viewModel.getAbbrevation(from: localization))
                            .font(.subheadline)
                            .fontWeight(.bold)
                    }
                    .foregroundColor(.white)
                    
//                    if localization != TimeZone.current.identifier {
//                        HStack {
//                            Rectangle()
//                                .frame(width: 6, height: 6)
//                            Text("\(localizationName) has the same time as Warsaw")
//                                .font(.subheadline)
//                                .fontWeight(.bold)
//                        }
//                        .foregroundColor(.white)
//                    }
                    
                    Text("IANA time zone identifier for \(localizationName) is \(localization)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color("appLightGrey"))
                    
                    Spacer()
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
                Spacer()
            }
            .background(Color("appGrey").ignoresSafeArea())
        }
        
        .background(Color.white)
        .onReceive(timer2) { _ in
            localization = localizationsArray.randomElement() ?? ""
            let localizationArray = localization.components(separatedBy: "/")
            localizationName = localizationArray.last!.replacingOccurrences(of: "_", with: " ")
        }
        .onAppear {
            localization = localizationsArray.randomElement() ?? ""
            print(localization)
            let localizationArray = localization.components(separatedBy: "/")
            localizationName = localizationArray.last!.replacingOccurrences(of: "_", with: " ")
            timeFormatter.dateFormat = "HH:mm:ss"
            dateFormatter.dateFormat = "EEEE, MMMM d YYYY"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
