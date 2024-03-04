//
//  Snake_Ladder_GameApp.swift
//  Snake Ladder Game
//
//  Created by Kritan Aryal on 3/3/24.
//

import SwiftUI

@main
struct Snake_Ladder_GameApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .defaultSize(width: 100, height: 100)

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
    }
}
