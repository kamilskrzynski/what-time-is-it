//
//  ContentView.swift
//  What time is it
//
//  Created by Kamil Skrzyński on 02/01/2023.
//

import SwiftUI

struct ContentView: View {
    
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var timeNow = ""
    @State var dateNow = ""
    let timeFormatter = DateFormatter()
    let dateFormatter = DateFormatter()
    @State var localization = "Warsaw, Poland"
    let cities = ["Los Angeles", "New York", "London", "Paris", "Kiev", "Pekin", "Tokyo"]
    
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
                    Text("This is your actual time!")
                        .font(.title.bold())
                        .foregroundColor(Color("appGrey"))
                    HStack {
                        Text("Actual time in")
                            .font(.title2)
                            .fontWeight(.thin)
                            .foregroundColor(Color("appGrey"))
                        Text(localization)
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
            Text(timeNow)
                .font(.system(size: 95, weight: .black))
                .foregroundColor(Color("appGrey"))
                .onReceive(timer) { _ in
                    self.timeNow = timeFormatter.string(from: Date())
                }
            
            HStack {
                Spacer()
                Text(dateNow)
                    .foregroundColor(Color("appGrey"))
                    .font(.title2)
                    .fontWeight(.light)
                    .onReceive(timer) { _ in
                        self.dateNow = dateFormatter.string(from: Date())
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
                        Text("Actual in Central European Time (CET), UTC +1")
                            .font(.subheadline)
                            .fontWeight(.bold)
                    }
                    .foregroundColor(.white)
                    
                    HStack {
                        Rectangle()
                            .frame(width: 6, height: 6)
                        Text("Paris has the same time as Warsaw")
                            .font(.subheadline)
                            .fontWeight(.bold)
                    }
                    .foregroundColor(.white)
                    
                        Text("IANA time zone identifier for Warsaw is Europe/Warsaw")
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
        .onAppear {
            timeFormatter.dateFormat = "HH:mm:ss"
            dateFormatter.dateFormat = "EEEE, MMMM d YYYY"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
