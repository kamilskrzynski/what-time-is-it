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
    let dateFormatter = DateFormatter()
    @State var localization = "Warsaw, Poland"
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
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
                        .foregroundColor(Color("timerColor"))
                    HStack {
                        Text("Actual time in")
                            .font(.title2)
                            .fontWeight(.thin)
                            .foregroundColor(Color("timerColor"))
                        VStack(spacing: 2) {
                            Text(localization)
                                .lineLimit(0)
                                .frame(width: 150)
                                .font(.title2)
                                .fontWeight(.thin)
                                .foregroundColor(Color("timerColor"))
                            Rectangle()
                                .frame(width: 150, height: 0.5)
                        }
                        Text("is:")
                            .font(.title2)
                            .fontWeight(.thin)
                            .foregroundColor(Color("timerColor"))
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
            Spacer()
            Text(timeNow)
                .font(.system(size: 95, weight: .black))
                .foregroundColor(Color("timerColor"))
                .onReceive(timer) { _ in
                    self.timeNow = dateFormatter.string(from: Date())
                }
                .onAppear {
                    dateFormatter.dateFormat = "HH:mm:ss"
                }
            Spacer()
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
