//
//  TabAView.swift
//  qrdb_v0
//
//  Created by Yuta on 2022/09/16.
//

import SwiftUI

struct TabAView: View {
    
    @State var count:Int = 0
    
    let (success, errorMessage, user) = DBService.shared.getUser(id: 1)
    
    @State var input_name:String = ""
    @State var input_address:String = ""
    @State var input_phone_number:String = ""
    
    @State var flag1:Bool = true
    @State var flag2:Bool = true
    @State var flag3:Bool = true
    
    @State var message:String = "unko"
    @State var correctionLevel = 0
    @State var qrImage:UIImage?
    private var _QRCodeMaker = QRCodeMaker()
    
    var body: some View {
        
        VStack{
            
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            
            Text("Your Info")
                .font(.largeTitle)
            
            Spacer(minLength: 20)
                .fixedSize()
            
            
            
            HStack{
                Text("Name")
                    .padding(15)
                
                TextField("", text:$input_name)
                    .font(.headline)
                    .padding(8)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Toggle("", isOn: $flag1)
                
            }
            
            HStack{
                Text("Address")
                    .padding(15)
                
                TextField("", text:$input_address)
                    .font(.headline)
                    .padding(8)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Toggle("", isOn: $flag2)
                
            }
            
            HStack{
                Text("Phone Number")
                    .padding(15)
                
                TextField("", text:$input_phone_number)
                    .font(.headline)
                    .padding(8)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Toggle("", isOn: $flag3)
                
            }
            
            
            Button(action: {
                
                self.count += 1
                
                let user1_ini = User(id: 1, name: "", address: "", phone_number: "")
                        
                if DBService.shared.insertUser(user: user1_ini) {
                
                    print("Insert success")
                    
                } else {
                    
                    print("Insert Failed")
                    
                    // レコードがすでに存在する場合、updateを実行する
                    let user1_update = User(id: 1, name: input_name, address: input_address, phone_number: input_phone_number)
                    
                    if DBService.shared.updateUser(user: user1_update){
                        
                        print("Update success")
                        
                    } else {
                        
                        print("Update Failed")
                    }
                }
                
                
            }, label: {
                Text("Update Your Info")
                    .font(.title)
                    .frame(width:300, height:50)
                    .border(Color.blue)
            })
            
            Button(action: {
                var input_name_show = input_name
                var input_address_show = input_address
                var input_phone_number_show = input_phone_number
                if flag1 == false{
                    input_name_show = ""
                }
                if flag2 == false{
                    input_address_show = ""
                }
                if flag3 == false{
                    input_phone_number_show = ""
                }
                
                self.message = String(format: "Name, Address, PhoneNumber \n %@, %@, %@", input_name_show, input_address_show, input_phone_number_show)
                self.qrImage = self._QRCodeMaker.make(message: self.message, level: self.correctionLevel)
            }, label: {
                Text("Show Your QR Code")
                    .font(.title)
                    .frame(width:300, height:50)
                    .border(Color.blue)
            })
            
            Text("Count: \(self.count)")
            
            if qrImage != nil {
                Image(uiImage: qrImage!)
            }

            
        }.onAppear{
            let (success, errorMessage, user) = DBService.shared.getUser(id: 1)

            if(success){
                if let user = user {
                    print(user)
                    input_name = user.name
                    input_address = user.address
                    input_phone_number = user.phone_number
                } else {
                    print("User not found")
                }
            } else {
                print(errorMessage ?? "Error")
            }
        }

    }
    
}

struct TabAView_Previews: PreviewProvider {
    static var previews: some View {
        TabAView()
    }
}
