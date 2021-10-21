//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Michael Gresham on 20/10/2021.
//

import SwiftUI

// Custom styling to display the emoji at a large size
struct emojiSizeStyling: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 72))
    }
}

// Styling for the rock, paper, scissors buttons.
struct emojiButtonStyling: ViewModifier {
    func body(content: Content) -> some View {
        content
            .largeEmoji()
            .padding(10)
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

extension View {
    func largeEmoji() -> some View {
        self.modifier(emojiSizeStyling())
    }
    func emojiButton() -> some View {
        self.modifier(emojiButtonStyling())
    }
}


struct ContentView: View {
    @State private var moves = ["✊", "✋", "✌️"]
    @State private var computersMove = 0
    @State private var shouldWin = true
    @State private var score = 0
    @State private var questionCount = 0
    @State private var showingScore = false

    func nextMove() {
        computersMove = Int.random(in: 0 ..< moves.count)
        shouldWin = Bool.random()
    }
    
    func detirmineWin(computer: Int, player: Int) {
        var win: Bool
        questionCount += 1
        // thing A beats thing B if it’s one place to the right of it, taking into account wrapping around the end of the array.
        switch computer {
        case 0:
            win = player == 1 ? true : false
        case 1:
            win = player == 2 ? true : false
        default: // Also case 2
            win = player == 0 ? true : false
        }
        updateScore(with: win)
    }
    
    func updateScore(with didWin: Bool) {
        // Only increase score if player wins/loses as instructed.
        if (didWin == shouldWin) {
            score += 1
        } else {
            // Prevent score dropping below 0
            score -= score > 0 ? 1 : 0
        }
        
        // End game when after 10th turn
        if questionCount < 10 {
            nextMove()
        } else {
            showingScore = true
        }
    }
    
    func reset() {
        questionCount = 0
        score = 0
        nextMove()
    }
   
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Score: \(score)")
                    .font(.largeTitle)
                    .foregroundColor(.blue)
                
                Text("Computer's Choice")
                    .font(.title)
                
                Text(moves[computersMove])
                    .largeEmoji()
                
                Text("Can you \(shouldWin ? "win" : " Lose")?")
                    .font(.title)

                HStack {
                    ForEach (0 ..< moves.count) { index in
                        Button(action: {
                            detirmineWin(computer: computersMove, player: index)
                        }, label: {
                            Text(moves[index])
                                .emojiButton()
                                
                        })
                    }
                }

            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Rock, Paper, Scissors")
            .alert(isPresented: $showingScore) {
                Alert(title: Text("Game Finished"), message: Text("Your score is \(score). \(score > 5 ? "Great Job!" : "Better luck next time.")"), dismissButton: .default(Text("Start Again")) {
                        reset()
                })
            }

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
