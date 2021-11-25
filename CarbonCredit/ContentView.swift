//
//  ContentView.swift
//  CarbonCredit
//
//  Created by Kris on 11/22/21.
//

import SwiftUI

struct ContentView: View
{
    @AppStorage("log_status") var log_Status = false
    
    var body: some View
    {
        if(log_Status)
        {
            TabBarView()
        }
        else
        {
            LoginView()
        }
    }
}

struct ContentView_Previews: PreviewProvider
{
    static var previews: some View
    {
        ContentView()
    }
}
