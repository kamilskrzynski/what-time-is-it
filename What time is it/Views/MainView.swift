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
                viewModel.getLocalizationName()
            }
            .onAppear {
                viewModel.getLocalizationName()
                viewModel.setupFormatters()
            }
            if viewModel.isSearchToggle {
                VStack(spacing: 0) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .font(.title3)
                            .foregroundColor(.black.opacity(0.5))
                        TextField("Search", text: $viewModel.searchText)
                        Button {
                            withAnimation {
                                viewModel.isSearchToggle = false
                            }
                        } label: {
                            Image(systemName: "xmark")
                                .font(.title3)
                                .foregroundColor(.black.opacity(0.5))
                        }
                    }
                    .padding()
                    .background(Color.appLight)
                    .padding(.vertical, 4)
                    
                    ForEach(viewModel.localizationsArray.filter { $0.replacingOccurrences(of: "_", with: " ").lowercased().components(separatedBy: "/").contains(viewModel.searchText.lowercased()) }, id: \.self) { result in
                        Button {
                            withAnimation {
                                viewModel.localization = result
                                viewModel.isSearchToggle = false
                            }
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(result.components(separatedBy: "/")[1].replacingOccurrences(of: "_", with: " "))
                                        .font(.title3)
                                        .bold()
                                    Text(result)
                                        .font(.caption2)
                                        .fontWeight(.light)
                                }
                                .foregroundColor(Color.appGrey)
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 2)
                            .background(Color.appLight)
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
                        viewModel.isSearchToggle.toggle()
                    }
                } label: {
                    Image(systemName: "magnifyingglass")
                        .font(.title3)
                        .foregroundColor(.black.opacity(0.5))
                }
                .disabled(viewModel.isSearchToggle)
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
                        .foregroundColor(Color.appRed)
                )
            Spacer()
                .frame(height: 40)
            if viewModel.localization == TimeZone.current.identifier {
                Text("This is your actual time!")
                    .font(.title.bold())
                    .foregroundColor(Color.appGrey)
            }
            HStack {
                Text("Actual time in")
                    .fontWeight(.thin)
                Text(viewModel.localizationName)
                    .fontWeight(.bold)
                Text("is:")
                    .fontWeight(.thin)
            }
            .font(.title2)
            .foregroundColor(Color.appGrey)
        }
    }
    
    var timeAndDate: some View {
        VStack {
            Spacer()
                .frame(height: 30)
            Text(viewModel.timeFormatter.string(from: viewModel.time))
                .font(.system(size: 90, weight: .black))
                .onReceive(timer) { _ in
                    viewModel.getTime(for: viewModel.localization)
                    viewModel.getLocalizationName()
                }
            
            Spacer()
                .frame(height: 30)
            HStack {
                Spacer()
                Text(viewModel.dateFormatter.string(from: viewModel.date))
                    .font(.title2)
                    .fontWeight(.light)
                    .onReceive(timer) { _ in
                        viewModel.getDate(for: viewModel.localization)
                        viewModel.getLocalTimes()
                    }
            }
            .padding(.horizontal)
        }
        .foregroundColor(Color.appGrey)
    }
    
    var footer: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Time zone")
                    .padding(.top)
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .foregroundColor(Color.appRed)
                HStack {
                    Rectangle()
                        .frame(width: 6, height: 6)
                    Text(viewModel.getAbbrevation(from: viewModel.localization))
                        .font(.subheadline)
                        .fontWeight(.bold)
                }
                .foregroundColor(.white)
                
                Text("IANA time zone identifier for \(viewModel.localizationName) is \(viewModel.localization)")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.appLightGrey)
                
                Spacer()
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            Spacer()
        }
        .background(Color.appGrey.ignoresSafeArea())
    }
    
    var otherCities: some View {
        HStack {
            Spacer()
            ForEach(viewModel.citiesDict.sorted(by: >), id: \.key) { key, value in
                VStack(alignment: .trailing) {
                    Text(key)
                        .font(.footnote)
                        .fontWeight(.bold)
                    Text(viewModel.shortTimeFormatter.string(from: value))
                        .font(.caption)
                        .fontWeight(.thin)
                }
                .foregroundColor(Color.appGrey)
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
