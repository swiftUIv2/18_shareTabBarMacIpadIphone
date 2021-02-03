//
//  ContentView.swift
//  shareTabBarMacIpadIphone_18
//
//  Created by emm on 03/02/2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}



/////////////////////////////////        Home        \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

struct Home: View {
    
    // to hide tabbar...
    init() {
        #if os(iOS)
        UITabBar.appearance().isHidden = true
        #endif
    }
    
    // selectedTab...
    @State var selectedTab = "SwiftUI"
    
    // For Dark Mode...
    @Environment(\.colorScheme) var scheme
    
    
    
    var body: some View {
        ZStack(alignment: getDevice() == .iPhone ? .bottom : .leading, content: {
            
            // since tab bar hide option is not available so we cant use native tab bar in mac os...
            #if os(iOS)
            TabView(selection: $selectedTab){
                
                Color.red
                    .tag("SwiftUI")
                    .ignoresSafeArea(.all, edges: .all)
                
                Color.blue
                    .tag("Beginners")
                    .ignoresSafeArea(.all, edges: .all)
                
                Color.yellow
                    .tag("macOS")
                    .ignoresSafeArea(.all, edges: .all)
                
                Color.pink
                    .tag("Contact")
                    .ignoresSafeArea(.all, edges: .all)
                
            }
            
            #else
            ZStack {
                // switch case for changing views...
                switch(selectedTab){
                    case "SwiftUI": Color.red
                    case "Beginners": Color.blue
                    case "macOS": Color.yellow
                    case "Contact": Color.pink
                    default: Color.clear
                } 
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            #endif
            
            if self.getDevice() == .iPad || self.getDevice() == .macOS {
                VStack(spacing: 10){
                    InsideTabBarItems(selectedTab: $selectedTab)
                    
                    Spacer()
                }
                
                .background(scheme == .dark ? Color.black : Color.white.opacity(0.5))
            }
            else {
                // Custom tabBar...
                HStack(spacing: 0){
                    // separate
                    InsideTabBarItems(selectedTab: $selectedTab)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(scheme == .dark ? Color.black : Color.white.opacity(0.5))
            }
        })
        .ignoresSafeArea(.all, edges: getDevice() == .iPhone ? .bottom : .all)
        .frame(width: getDevice() == .iPad || getDevice() == .iPhone ? nil : getScreen().width / 1.6, height: getDevice() == .iPad || getDevice() == .iPhone ? nil : getScreen().height - 150)
    }
}




/////////////////////////////////        TabBarButton       \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
// Separating tabbar Items For Ease Of Use...
struct InsideTabBarItems: View {
    
    @Binding var selectedTab: String
    
    var body: some View {
        Group {
            Image(systemName: "bolt.circle.fill")
                .font(.system(size: 45))
                .padding(.horizontal)
                .foregroundColor(.yellow)
                .padding(.top, getDevice() == .iPhone ? 0 : 35)
                .padding(.bottom, getDevice() == .iPhone ? 0 : 15)
            
            TabBarButton(image: "swift", title: "SwiftUI", selectedTab: $selectedTab)
            TabBarButton(image: "book", title: "Beginners", selectedTab: $selectedTab)
            TabBarButton(image: "laptopcomputer", title: "macOS", selectedTab: $selectedTab)
            TabBarButton(image: "person.crop.circle.fill.badge.questionmark", title: "Contact", selectedTab: $selectedTab)
        }
    }
}




/////////////////////////////////        TabBarButton       \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
struct TabBarButton: View {
    
    var image: String
    var title: String
    @Binding var selectedTab: String
    
    var body: some View {
        
        Button(action: {
            withAnimation(.easeInOut){selectedTab = title}
        }, label: {
            VStack(spacing: 6){
                Image(systemName: image)
                    .font(.system(size: getDevice() == .iPhone ? 30 : 25))
                    // For dark mode...
                    .foregroundColor(selectedTab == title ? .white : .primary)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.semibold)
                    // For dark mode...
                    .foregroundColor(selectedTab == title ? .white : .primary)
            }
            .padding(.bottom, 8)
            
            // Total 4 tabs...
            .frame(width: self.getDevice() == .iPhone ? (self.getScreen().width - 75) / 4 : 100 , height: 55 + self.getSafeAreaBottom())
            .contentShape(Rectangle())
            // Bottom up effect...
            // if ipad or mac os Moving effect will be from left...
            .background(Color("purple").offset(x: selectedTab == title ? 0 : getDevice() == .iPhone ? 0 : -100 ,y: selectedTab == title ? 0 : getDevice() == .iPhone ? 100 : 0))
        })
        .buttonStyle(PlainButtonStyle())
    }
}



// getting Screen Width....

// Since we are extending view so we can use directly in swiftUI body by calling the functions...

extension View {
    
    func getScreen()-> CGRect{
        #if os(iOS)
        return UIScreen.main.bounds
        #else
        return NSScreen.main!.visibleFrame
        #endif
    }
    
    // Safe Area Bottom...
    func getSafeAreaBottom()-> CGFloat {
        #if os(iOS)
        return UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 10
        #else
        return 10
        #endif
    }
    
    
    // getting device type...
    
    func getDevice()->Device {
        #if os(iOS)
        // since there is no direct way for getting iPad os...
        // alternative way...
        if UIDevice.current.model.contains("iPad"){
            return .iPad
        }
        else {
            return .iPhone
        }
        #else
        return .macOS
        #endif
    }
}


enum Device {
    case iPhone
    case iPad
    case macOS
}
