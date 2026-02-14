//
//  ContentView.swift
//  BrainRockPaperScissors
//
//  Created by Macedo on 12/02/26.
//

import SwiftUI

struct ContentView: View {
    let moves = ["✊", "✋", "✌️"]
    @State private var cpuMove: String = ""
    @State private var shouldWin: Bool = true
    @State private var round: Int = 1
    @State private var score: Int = 0
    @State private var isGameOverAlertShown: Bool = false
    
    struct YourScore: View {
        var score: Int
        
        var body: some View {
            VStack(spacing: 8) {
                Text("Score")
                    .font(.callout)
                    .foregroundStyle(.primary)
                Text(String(score))
                    .font(.largeTitle)
                    .id(score)
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom).combined(with: .opacity).animation(.easeOut),
                        removal: .move(edge: .top).combined(with: .opacity).animation(.easeIn)
                    ))
                    .animation(.easeOut(duration: 0.3), value: score)
            }
            .cardStyle()
        }
    }
    
    struct CPUAction: View {
        var cpuMove: String
        
        var body: some View {
            VStack(spacing: 8) {
                Text("Game's move")
                    .font(.callout)
                    .foregroundStyle(.primary)
                Text(cpuMove)
                    .font(.largeTitle)
                    .id(cpuMove)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity).animation(.easeOut),
                        removal: .move(edge: .leading).combined(with: .opacity).animation(.easeIn)
                    ))
                    .animation(.easeOut(duration: 0.3), value: cpuMove)
            }
            .cardStyle()
        }
    }
    
    struct YouShould: View {
        var shouldWin: Bool
        var round: Int
        
        var body: some View {
            VStack(spacing: 8) {
                Text("This round, you should")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                Text(shouldWin ? "WIN" : "LOSE")
                    .font(.title2.bold())
                    .foregroundStyle(shouldWin ? .green : .red)
                Text("Round \(round) of 10")
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }
            .cardStyle()
        }
    }
    
    struct MovesRow: View {
        let moves: [String]
        let onMoveSelected: (String) -> Void
        
        var body: some View {
            HStack(spacing: 24) {
                ForEach(moves, id: \.self) { move in
                    Button {
                        onMoveSelected(move)
                    } label: {
                        Text(move)
                            .font(.title)
                            .frame(height: 44)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: .accentColor.opacity(0.25), location: 0.5),
                        .init(color: .accentColor.opacity(0.1), location: 0.70),
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                VStack(spacing: 24) {
                    Spacer()
                    Spacer()
                    YourScore(score: score)
                    Spacer()
                    CPUAction(cpuMove: cpuMove)
                    Spacer()
                    Spacer()
                    YouShould(shouldWin: shouldWin, round: round)
                    MovesRow(moves: moves) { selectedMove in
                        handleMove(selectedMove)
                    }
                }
                .onAppear {
                    generateCPUMove()
                }
                .padding()
                .navigationTitle("Rock Paper Scissors")
                .navigationBarTitleDisplayMode(.inline)
                .alert("Game over", isPresented: $isGameOverAlertShown) {
                    Button("Restart", action: resetGame)
                } message: {
                    Text("Your final score is \(score).")
                }
            }
        }
    }
    
    func generateCPUMove() {
        cpuMove = moves.randomElement()!
    }
    
    func handleMove(_ move: String) {
        if playerDidWin(player: move, cpu: cpuMove) {
            score += 1
        } else {
            score -= 1
        }
        
        if round == 10 {
            isGameOverAlertShown = true
            return
        }
        
        round += 1
        shouldWin.toggle()
        generateCPUMove()
    }
    
    func playerDidWin(player: String, cpu: String) -> Bool {
        if player == cpu {
            return false
        }
        
        if shouldWin {
            switch (player, cpu) {
            case ("✊", "✌️"), ("✋", "✊"), ("✌️", "✋"):
                return true
            default:
                return false
            }
        }
        
        switch (player, cpu) {
        case ("✌️", "✊"), ("✊", "✋"), ("✋", "✌️"):
            return true
        default:
            return false
        }
    }
    
    func resetGame() {
        score = 0
        round = 1
        shouldWin = true
        generateCPUMove()
    }
}

extension View {
    func cardStyle() -> some View {
        self
            .padding()
            .frame(maxWidth: .infinity)
            .background(.thickMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    ContentView()
}
