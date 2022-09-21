//
//  ContentView.swift
//  qrdb_v0
//
//  Created by Yuta on 2022/09/15.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        
        TabView {
            
            TabAView()
                .tabItem {
                    VStack {
                        Image(systemName: "a")
                        Text("TabA")
                    }
            }.tag(1)
            
            TabBView()
                .tabItem {
                    VStack {
                        Image(systemName: "bold")
                        Text("TabB")
                    }
            }.tag(2)
            
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
