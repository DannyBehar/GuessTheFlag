//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Daniel Behar on 1/30/21.
//

import SwiftUI

enum ChoiceResult {
    case unknown
    case correct
    case incorrect
}

struct CountryData {
    var name: String
    var result: ChoiceResult = .unknown
    var incorrectChoice = false
}

struct ContentView: View {
   @State private var countries = [CountryData(name: "Estonia"), CountryData(name: "France"), CountryData(name: "Germany"), CountryData(name: "Ireland"), CountryData(name: "Italy"), CountryData(name: "Nigeria"), CountryData(name: "Poland"), CountryData(name: "Russia"), CountryData(name: "Spain"), CountryData(name: "UK"), CountryData(name: "US")].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScoreCorrect = false
    @State private var showingScoreIncorrect = false
    @State private var showAlert = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var lastTappedCountry = 0
    @State private var animationAmount = 0.0
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue,.black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            VStack(spacing: 30){
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer].name)
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                
                ForEach(0..<3) { number in
                    Button(action: {
                        withAnimation(Animation.interpolatingSpring(stiffness: 10, damping: 3)) {
                            self.flagTapped(number)
                        }
                    }){
                        Image(self.countries[number].name)
                            .renderingMode(.original)
                            .flagify()
                            
                    }
                    .opacity(countries[number].result == .incorrect ? 0.25 : 1.0)
                    .rotation3DEffect(.degrees(countries[number].result == .correct ? 360 : 0), axis: (x:0, y:1, z:0))
                    .rotationEffect(.degrees(countries[number].incorrectChoice == true ? 90 : 0))
                    
                    
                }
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .padding()
                Spacer()
            }
        }
        
        .alert(isPresented: $showAlert){
            if showingScoreCorrect {
                return Alert(title: Text(scoreTitle), message: Text("Correct! Your score is now \(score)"), dismissButton: .default(Text("Continue")){
                        self.askQuestion()
                })
            } else {
                return Alert(title: Text(scoreTitle), message: Text("Actually, that is the flag of \(countries[lastTappedCountry].name). Your score is now \(score)"), dismissButton: .default(Text("Continue")){
                        self.askQuestion()
                })
            }
        }
    }
    
    func flagTapped(_ number: Int) {
        lastTappedCountry = number
    
        for num in 0 ..< countries.count {
            if num != correctAnswer {
                countries[num].result = .incorrect
            }
        }
        if number == correctAnswer {
            countries[number].result = .correct
            scoreTitle = "Correct"
            score += 1
            showingScoreCorrect = true
        } else {
            countries[number].incorrectChoice = true
            scoreTitle = "Wrong"
            score = 0
            showingScoreIncorrect = true
        }
        showAlert = true
        
        
    }
    
    func askQuestion() {
        showingScoreCorrect = false
        showingScoreIncorrect = false
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        countries = countries.map { country in
            CountryData(name: country.name, result: .unknown, incorrectChoice: false)
        }
    }
    
}

struct Flagify: ViewModifier {
    func body(content: Content) -> some View {
        content
        .clipShape(Capsule())
        .overlay(Capsule().stroke(Color.black, lineWidth: 1))
        .shadow(color: .black,radius: 2 )
    }
}

extension View {
    func flagify() -> some View{
        self.modifier(Flagify())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
