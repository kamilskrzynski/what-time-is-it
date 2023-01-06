//
//  MainView.swift
//  What time is it
//
//  Created by Kamil Skrzyński on 02/01/2023.
//

import SwiftUI

struct MainView: View {
    
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var timer2 = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    @State var timeNow = ""
    @State var dateNow = ""
    @State var time: Date = Date()
    @State var date: Date = Date()
    let timeFormatter = DateFormatter()
    let dateFormatter = DateFormatter()
    let shortTimeFormatter = DateFormatter()
    @State var isSearchToggle = false
    @State var searchText = ""
    @State var localization = TimeZone.current.identifier
    @State var localizationName = ""
    
    @StateObject private var viewModel = MainViewModel()
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                HStack {
                    VStack(alignment: .leading) {
                        header
                    }
                    Spacer()
                }
                .padding(.horizontal)
                
                timeAndDate
                
                otherCities
                
                Spacer()
                    .frame(height: 30)
                
                footer
            }
            .background(Color.white)
            .onReceive(timer2) { _ in
                getLocalizationName()
            }
            .onAppear {
                getLocalizationName()
                setupFormatters()
            }
            if isSearchToggle {
                VStack(spacing: 0) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .font(.title3)
                            .foregroundColor(.black.opacity(0.5))
                        TextField("Search", text: $searchText)
                        Button {
                            withAnimation {
                                isSearchToggle = false
                            }
                        } label: {
                            Image(systemName: "xmark")
                                .font(.title3)
                                .foregroundColor(.black.opacity(0.5))
                        }
                    }
                    .padding()
                    .background(Color("appLight"))
                    .padding(.vertical, 4)
                    
                    ForEach(viewModel.localizationsArray.filter { $0.components(separatedBy: "/").contains(searchText) }, id: \.self) { result in
                        Button {
                            withAnimation {
                                    localization = result
                                    isSearchToggle = false
                            }
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(result.components(separatedBy: "/")[1])
                                        .font(.title3)
                                        .bold()
                                    Text(result)
                                        .font(.caption2)
                                        .fontWeight(.light)
                                }
                                .foregroundColor(Color("appGrey"))
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 2)
                            .background(Color("appLight"))
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal)
            }
        }
    }
    
    var header: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                Button {
                    withAnimation {
                        isSearchToggle.toggle()
                    }
                } label: {
                    Image(systemName: "magnifyingglass")
                        .font(.title3)
                        .foregroundColor(.black.opacity(0.5))
                }
                .disabled(isSearchToggle)
            }
            .padding()
            .background(Color.clear)
            .padding(.vertical, 4)
            
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
    }
    
    var timeAndDate: some View {
        VStack {
            Spacer()
                .frame(height: 30)
            Text(timeFormatter.string(from: viewModel.time))
                .font(.system(size: 90, weight: .black))
                .foregroundColor(Color("appGrey"))
                .onReceive(timer) { _ in
                    viewModel.getTime(for: localization)
                    getLocalizationName()
                }
            
            Spacer()
                .frame(height: 30)
            HStack {
                Spacer()
                Text(dateFormatter.string(from: viewModel.date))
                    .foregroundColor(Color("appGrey"))
                    .font(.title2)
                    .fontWeight(.light)
                    .onReceive(timer) { _ in
                        dateFormatter.locale = Locale(identifier: "en_us")
                        viewModel.getDate(for: localization)
                        viewModel.getLocalTimes()
                    }
            }
            .padding(.horizontal)
        }
    }
    
    var footer: some View {
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
    
    var otherCities: some View {
        HStack {
            Spacer()
            ForEach(viewModel.citiesDict.sorted(by: >), id: \.key) { key, value in
                VStack(alignment: .trailing) {
                    Text(key)
                        .foregroundColor(Color("appGrey"))
                        .font(.footnote)
                        .fontWeight(.bold)
                    Text(shortTimeFormatter.string(from: value))
                        .foregroundColor(Color("appGrey"))
                        .font(.caption)
                        .fontWeight(.thin)
                }
                .padding(2)
                .padding(.horizontal, 2)
                .background(Color("appLight"))
                .onAppear {
                    viewModel.getTime(for: viewModel.localizationsArray.first(where: { $0.contains(key)}) ?? "")
                }
            }
        }
        .padding(.horizontal)
    }
    
    // MARK: - Functions
    func getLocalizationName() {
        let localizationArray = localization.components(separatedBy: "/")
        localizationName = localizationArray.last!.replacingOccurrences(of: "_", with: " ")
    }
    
    func setupFormatters() {
        timeFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.dateFormat = "EEEE, MMMM d YYYY"
        shortTimeFormatter.dateFormat = "HH:mm"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
