//
//  TabBView.swift
//  qrdb_v0
//
//  Created by Yuta on 2022/09/16.
//

import SwiftUI

struct TabBView: View {
    
    @State var count:Int = 0
    @State var input_name:String = ""
    @ObservedObject var viewModel = ScannerViewModel()
    
    var body: some View {
        
        VStack{
            
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            
            Text("People Info")
                .font(.largeTitle)
            
            Spacer(minLength: 20)
                .fixedSize()
            
            Text("Name, Address, Phone Number, ...")
            
            Button(action: {
                viewModel.isShowing = true
            }){
                Text("カメラ起動")
                Image(systemName: "camera")
            }
            .fullScreenCover(isPresented: $viewModel.isShowing) {
                SecondView(viewModel: viewModel)
            }
            
            Text("Count: \(self.count)")
            
        }
        
    }
}

struct TabBView_Previews: PreviewProvider {
    static var previews: some View {
        TabBView()
    }
}
