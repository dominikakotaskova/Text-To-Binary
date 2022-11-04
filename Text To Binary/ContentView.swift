//
//  ContentView.swift
//  Text To Binary
//
//  Created by Dominika Kotásková on 2022-10-22.
//

import SwiftUI

struct ContentView: View {
    
    @State var input: String = ""
    @State var output: String = ""
    @State var isDefaultDirection: Bool = true
    @FocusState var isFocused: Bool
    @State private var buttonText: String = "Copy to clipboard"
    private let pasteboard = UIPasteboard.general
    
    var body: some View {
        
        // Selector
        
        VStack {
                HStack {
                    VStack(alignment: .leading) {
                        isDefaultDirection ? Text("Text") : Text("Binary")
                    }
                    .padding(.horizontal)
                    .frame(width: 100)
                    VStack {
                        Button {
                            isDefaultDirection = !isDefaultDirection
                            input = ""
                        } label: {
                            Image(systemName: "arrow.left.arrow.right")
                                .padding(.horizontal, 50)
                        }
                    }
                    VStack {
                        isDefaultDirection ? Text("Binary") : Text("Text")
                    }
                    .frame(width: 100)
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .padding()
                .background(Color(red: 20/255, green: 28/255, blue: 58/255))
                
                ScrollView {
                    ZStack(alignment: .topLeading) {
                                  
                                  // Input text field
                                  
                                  TextEditor(text: $input)
                                      .frame(minHeight: 150, maxHeight: 400)
                                      .font(.body)
                                      .focused($isFocused, equals: true)
                                  
                                  // Shows placeholder text when input field is empy
                                  
                                  if input.isEmpty && !self.isFocused {
                                    Text("Paste or type")
                                      .font(.body)
                                      .foregroundColor(Color(uiColor: .placeholderText))
                                      .onTapGesture {
                                        self.isFocused = true
                                      }
                                  }
                              }
                              .padding()
                }
          
            
                // Paste button
            
                HStack {
                    Button {
                        paste()
                    } label: {
                        Text("Paste")
                            .foregroundColor(Color("TextColor"))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color("TextColor"), lineWidth: 1))
                    }
                    Spacer()
                    
                    Button {
                        input = ""
                    } label: {
                        Text("Clear")
                            .foregroundColor(Color("TextColor"))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color("TextColor"), lineWidth: 1))
                    }
                    
                    
                }
                .padding()
            

            
                Rectangle().fill(.gray).frame(maxWidth: .infinity).frame(height: 1)
            
            
                // Output text
            
                ScrollView {
                    
                    if isDefaultDirection {
                        let binaryOutput = input.stringToBinary()
                        Text(binaryOutput)
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                .font(.body)
                                .padding()
                                .textSelection(.enabled)
                    } else {
                        let stringOutput = input.binaryToString()
                        Text(stringOutput)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .font(.body)
                            .padding()
                            .textSelection(.enabled)
                    }
 
                }

                Spacer()
            
            
                // Copy to clipboard button
            
                HStack {
                    Button {
                        output = input.stringToBinary()
                        copyToClipboard()
                    } label: {
                        Text(buttonText)
                            .foregroundColor(Color("TextColor"))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color("TextColor"), lineWidth: 1))
                    }
                    Spacer()
                }
                .padding()

                Rectangle().fill(.gray).frame(maxWidth: .infinity).frame(height: 1)
                    
                Spacer()


        }
        
        
    }
    
    func paste() {
        if let string = pasteboard.string {
            input = string
        }
        
    }
    
    func copyToClipboard() {
        pasteboard.string = self.output
        self.buttonText = "Copied!"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.buttonText = "Copy to clipboard"
        }
    }
}


extension String {
    func stringToBinary() -> String {
        let st = self
        var result = ""
        for char in st.utf8 {
            var tranformed = String(char, radix: 2)
            while tranformed.count < 8 {
                tranformed = "0" + tranformed
            }
            let binary = "\(tranformed) "
            result.append(binary)
        }
        return result
    }
}




extension String {
    func binaryToString() -> String {
        let binaryInput = self.removingWhitespaces()
        var result = ""
        var index = binaryInput.startIndex
        while let next = binaryInput.index(index, offsetBy: 8, limitedBy: binaryInput.endIndex) {
            let asciiCode = UInt8(binaryInput[index..<next], radix: 2)!
            result.append(Character(UnicodeScalar(asciiCode)))
            index = next
        }
        return result
    }
}

extension String {
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.light)
        ContentView()
            .preferredColorScheme(.dark)
    }
}
