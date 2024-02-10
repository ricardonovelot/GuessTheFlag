//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Ricardo on 11/07/23.
//

import SwiftUI

struct FlagImage: View {
    var name: String
    
    var body: some View {
        Image(name)
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 5)))
            .shadow(radius: 5)
    }
}

struct LargeBlueTitle: ViewModifier{
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .bold()
            .foregroundStyle(.white)
    }
}

extension View {
    func largertitle() -> some View{
        modifier(LargeBlueTitle())
    }
}

struct ContentView: View {
    
    @State private var showingScore = false
    @State private var showingFinalScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var flagTappedd = 0
    @State private var numberOfQuestions = 0
    @State private var spinAmount = 0.0
    @State private var opacity = 1.0
    @State private var scaleAmount = 1.0
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    
    @State private var correctAnswer = Int.random(in: 0...2)
    
    
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red:0.1,green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red:0.76,green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()

        
            
            
            VStack {
                Spacer()
                
                Text("Guess The Flag")
                    .largertitle()
                
                VStack(spacing:15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                            flagTappedd = number
                        } label: {
                            FlagImage(name: countries[number])
                                .rotation3DEffect(
                                    .degrees(number == correctAnswer ? spinAmount : 1), axis: (0, 1, 0))
                                .opacity(number == correctAnswer ? 1 : opacity)
                                .scaleEffect(number == correctAnswer ? 1 : scaleAmount)
                        }
                    }
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .padding(.vertical, 40)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                    .opacity(score == 0 ? 0 : 1)
                
                Spacer()
            }
            .padding()
            
        }
        .alert(scoreTitle, isPresented: $showingScore){
            Button("Continue", action: askQuestion)
        } message: {
            if flagTappedd == correctAnswer {
                Text("Your score is \(score)")
            } else {
                Text("Wrong! That’s the flag of \(countries[flagTappedd])")
            }
                
        }
        .alert("Thanks for playing", isPresented: $showingFinalScore){
            Button("Continue", action: resetGame)
        } message: {
                Text("Your final score is: \(score)")
        }
        }
    
    func flagTapped (_ number: Int){
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
            withAnimation(.interpolatingSpring(stiffness: 18, damping: 6))
                        {
                            spinAmount = 360
                        }
            withAnimation {
                opacity = 0.25
                scaleAmount = 0.95
            }
        } else {
            scoreTitle = "Wrong"
        }
        numberOfQuestions += 1
        showingScore = true
    }
    
    func askQuestion(){
        spinAmount = 0
        opacity = 1
        scaleAmount = 1
    
        if numberOfQuestions > 2{
            showingFinalScore = true
        } else {
            countries.shuffle()
            correctAnswer = Int.random(in: 1...2)
        }
    }
    
    func resetGame(){
        withAnimation{
            countries.shuffle()
            correctAnswer = Int.random(in: 1...2)
            numberOfQuestions = 0
            score = 0
        }
    }
             
}

#Preview {
    ContentView()
}
