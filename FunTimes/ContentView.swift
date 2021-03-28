//
//  ContentView.swift
//  FunTimes
//
//  Created by Marjo Salo on 16/03/2021.
//

import SwiftUI

struct ContentView: View {
    
    let animals = ["chick", "crocodile", "cow", "giraffe", "horse", "narwhal", "owl", "parrot", "penguin", "pig", "snake", "whale"]
    let difficulty = ["All levels", "Easy", "Difficult"]
    let amountOfQuestions = [0, 5, 10, 20]
    
    @State private var questions = Tables()
    
    @State private var gameOn = false
    @State private var showAlert = false
    @State private var showKeyboard = false
    
    @State private var tableSelection = 0
    @State private var tableArray = [Int]()
    @State private var difficultySelection = "All levels"
    @State private var amountSelection = 0
    
    @State private var questionArray = [Question]()
    
    @State private var question = ""
    @State private var questionIndex = 0
    @State private var answer = "Tap to answer"
    @State private var counter = 1
    @State private var score = 0
    @State private var correct = false
    
    @State private var angle = 0.0
    @State private var rotation = 0.0
    @State private var animalsIndex = 0
    
    var body: some View {
        
            ZStack {
                Color(#colorLiteral(red: 0.9663711958, green: 1, blue: 0.890455514, alpha: 1))
                    .edgesIgnoringSafeArea(.all)
            
            Group {
                
                if !gameOn {
                    
                    VStack(spacing: 30) {
                        
                        VStack(spacing: 15) {
                            ForEach(0..<3, id: \.self) { row in
                                HStack(spacing: 15) {
                                    ForEach(0..<4, id: \.self) { column in
                                        Button(action: {
                                            let number = row * 4 + column + 1
                                            tableSelection = number
                                            tableButtonTapped()
                                        }) {
                                            VStack(spacing: -20) {
                                                Image(decorative: animals[row * 4 + column])
                                                    .resizable()
                                                    .frame(width: 60, height: 60)
                                                    .rotationEffect(.degrees(tableArray.contains(row * 4 + column + 1) ? -20 : 0.0))
                                                    .animation((tableArray.contains(row * 4 + column + 1) ? Animation.easeInOut
                                                                    .repeatForever(autoreverses: true) : Animation.default)
                                                    )
                                                Text("\(row * 4 + column + 1)")
                                                    .font(.system(size: 40))
                                                    .fontWeight(.bold)
                                                    .foregroundColor(tableArray.contains(row * 4 + column + 1) ? .orange : .gray)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        Button("All tables") {
                            allTapped()
                        }
                        .padding()
                        .background(tableArray.count == 12 ? Color.orange : Color.yellow)
                        .colorButton()
                        
                        VStack(alignment: .leading, spacing: 25) {
    
                            HStack(spacing: 15) {
                                ForEach(difficulty, id: \.self) { level in
                                    Button(action: {
                                       difficultySelection = level
                                    }) {
                                    Text("\(level)")
                                        .font(.system(size: 22))
                                        .fontWeight(.bold)
                                        .foregroundColor(difficultySelection == level ? .orange : .gray)
                                    }
                                }
                            }
                            
                            HStack(spacing: 15) {
                                ForEach(amountOfQuestions, id: \.self) { amount in
                                    Button(action: {
                                       amountSelection = amount
                                    }) {
                                    Text(amount == 0 ? "All questions" : "\(amount)")
                                        .font(.system(size: 22))
                                        .fontWeight(.bold)
                                        .foregroundColor(amountSelection == amount ? .orange : .gray)
                                    }
                                }
                            }
                        }
                        
                        HStack(spacing: 30) {
                            Button("Start over") {
                                allCleared()
                            }
                            .padding()
                            .background(Color.pink)
                            .colorButton()
                    
                            Button("Let's go!") {
                                getQuestions()
                                if questionArray.count > 3 {
                                    gameOn = true
                                    currentQuestion()
                                } else {
                                    showAlert = true
                                    }
                                }
                            .padding()
                            .background(Color.green)
                            .colorButton()
                            .scaleEffect(tableArray.count > 4 ? 1.1 : 1)
                            .animation((tableArray.count > 4 ? Animation.easeInOut
                                            .repeatForever(autoreverses: true) : Animation.default)
                            )
                        }
                    }
                }
            }
            .onAppear(perform: {
                questions.getAll()
            })
            
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Not enough questions!"), message: Text("Select more tables or another level."), dismissButton: .default(Text("OK")) {
                    allCleared()
                })
            }
            
            Group {
                
                if gameOn {
                    
                    VStack(alignment: .center, spacing: 20) {
                        
                        Image(decorative: animals[animalsIndex])
                            .resizable()
                            .frame(width: 70, height: 70)
                            .rotationEffect(.degrees(correct ? angle : 0))
                            .rotation3DEffect(.degrees(!correct ? rotation : 0.0), axis: (x: 1, y: 0, z: 0))
                        
                        if counter <= amountSelection {
                            
                            Text("Question \(counter)/\(amountSelection)")
                            Text("How much is...")
                                .font(.title2)
                            Text(question)
                                .font(.title)
                            Text(answer)
                                .onTapGesture {
                                    withAnimation {
                                        showKeyboard = true
                                    }
                                    answer = ""
                                }
                                .frame(width: 200, height: 50, alignment: .center)
                                .multilineTextAlignment(.center)
                                .font(.title)
                                .foregroundColor(answer == "Tap to answer" ? .gray : .black)
                                .clipShape(RoundedRectangle(cornerRadius: 6.0))
                                .overlay(RoundedRectangle(cornerRadius: 6.0).stroke(Color.gray, lineWidth: 1))
                            
                            if showKeyboard {
                                
                                VStack(alignment: .trailing, spacing: 20) {
                                    ForEach(0..<3, id: \.self) { row in
                                        HStack(spacing: 30) {
                                            ForEach(0..<3, id: \.self) { column in
                                                Button(action: {
                                                    answer += "\(row * 3 + column + 1)"
                                                }) {
                                                    Text("\(row * 3 + column + 1)")
                                                        .frame(width: 50, height: 50, alignment: .center)
                                                        .background(Color.yellow)
                                                        .font(.title)
                                                        .colorButton()
                                                }
                                            }
                                        }
                                    }
                                    HStack(spacing: 30) {
                                        Button(action: {
                                            answer += "0"
                                        }) {
                                            Text("0")
                                                .frame(width: 50, height: 50, alignment: .center)
                                                .background(Color.yellow)
                                                .font(.title)
                                                .colorButton()
                                        }
                                        
                                        Button(action: {
                                            answer = ""
                                        }) {
                                            Image(systemName: "delete.left")
                                                .frame(width: 50, height: 50, alignment: .center)
                                                .background(Color.red)
                                                .colorButton()
                                        }
                                    }
                                    HStack(spacing: 30) {
                                        Button("Start over") {
                                            questions.tables.removeAll()
                                            allCleared()
                                        }
                                        .padding()
                                        .background(Color.pink)
                                        .colorButton()
                                        
                                        Button(action: {
                                            if answer != "" {
                                            getAnswer()
                                            }
                                        }) {
                                            Text("OK!")
                                                .frame(width: 50, height: 50, alignment: .center)
                                                .background(Color.green)
                                                .font(.title2)
                                                .colorButton()
                                        }
                                    }
                                }
                                .transition(.move(edge: .bottom))
                            }
                        } else {
                            Text("Game over!")
                                .font(.title)
                                .foregroundColor(.blue)
                            
                            Text("You got \(score) out of \(amountSelection) right!")
                                .font(.title2)
                            
                            Button("Start over") {
                                questions.tables.removeAll()
                                allCleared()
                            }
                            .padding()
                            .background(Color.pink)
                            .colorButton()
                        }
                    }
                }
            }
        }
    }
    
    func allCleared() {
        
        gameOn = false
        showKeyboard = false
        
        difficultySelection = "All levels"
        amountSelection = 0
        tableSelection = 0
        questionArray.removeAll()
        tableArray.removeAll()
        
        questionIndex = 0
        score = 0
        counter = 1
        answer = "Tap to answer"
    }
    
    func allTapped() {
        
        tableArray.removeAll()
        
        for number in 0..<12 {
            tableSelection = number + 1
            tableButtonTapped()
        }
    }
    
    func tableButtonTapped() {
        
        if !tableArray.contains(tableSelection) {
            tableArray.append(tableSelection)
        } else {
            if let index = tableArray.firstIndex(of: tableSelection) {
                tableArray.remove(at: index)
            }
        }
    }
    
    func getQuestions() {
        
        for number in 0..<questions.tables.count {
            for num in 0..<tableArray.count {
                if questions.tables[number].factorB == tableArray[num] {

                    switch difficultySelection {
                    
                    case "Easy":
                    if questions.tables[number].level == 1 {
                        questionArray.append(questions.tables[number])
                    }
                    case "Difficult":
                    if questions.tables[number].level == 3 {
                        questionArray.append(questions.tables[number])
                    }
                    case "All": questionArray.append(questions.tables[number])
                    default: questionArray.append(questions.tables[number])
                    }
                }
            }
        }
        questionArray.shuffle()
    }
    
    func currentQuestion() {
        
        if amountSelection == 0 {
            amountSelection = questionArray.count
        }
        
        if counter <= amountSelection {
            question = "\(questionArray[questionIndex].factorA) * \(questionArray[questionIndex].factorB)"
        }
    }
    
    func getAnswer() {
        
        var previous = question
        
        if counter <= amountSelection {
            if answer == String(questionArray[questionIndex].product) {
                correct = true
                score += 1
                withAnimation {
                    angle += 360
                }
            } else {
                withAnimation {
                    rotation = 90
                }
            }
            
            if amountSelection > questionArray.count {
                questionIndex += 1
                if questionIndex == questionArray.count - 1 {
                    questionArray.shuffle()
                    questionIndex = 0
                }
            } else {
                questionIndex += 1
            }
            
            answer = ""
            counter += 1
            correct = false
            rotation = 0
            previous = question
            currentQuestion()
            animalsIndex = Int.random(in: 0..<animals.count)
            
            if question == previous {
                questionIndex += 1
                currentQuestion()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
