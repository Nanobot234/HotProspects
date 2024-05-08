//
//  SearchUnavailableView.swift
//  HotProspects
//
//  Created by Nana Bonsu on 3/5/24.
//

import SwiftUI

struct SearchUnavailableView: View {
    
    @Binding var searchPhrase:String
    
    var body: some View {
        VStack {
            //Search icon
            //More things
            Image(systemName: "magnifyingglass")
                .resizable()
                .frame(width: 70, height: 70)
                .foregroundColor(Color.gray)
            Text("No Results for \"\(searchPhrase)\"")
                .font(.system(size: 20))
                .fontWeight(.bold)
            Text("Check the spelling or date you entered and try agan")
                .foregroundColor(Color.gray)
    
        }
        
        
}
}

struct SearchUnavailableView_Previews: PreviewProvider {
    static var previews: some View {
        
        @State var phrase = "Hello"
        SearchUnavailableView(searchPhrase: $phrase)
    }
}

