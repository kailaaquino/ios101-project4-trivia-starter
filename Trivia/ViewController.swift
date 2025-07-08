//
//  ViewController.swift
//  Trivia
//
//  Created by Kaila Aquino on 6/24/25.
//

import UIKit

struct Question {
    let text: String
    let category: String
    let answers: [String]
    let correctAnswer: String
}

class ViewController: UIViewController {

    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var optionButton1: UIButton!
    @IBOutlet weak var optionButton2: UIButton!
    @IBOutlet weak var optionButton3: UIButton!
    @IBOutlet weak var optionButton4: UIButton!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBAction func answerTapped(_ sender: UIButton) {
        
        let selected = sender.currentTitle
        let correct = questions[currentQuestionIndex].correctAnswer
        
        if selected == correct {
            correctAnswers += 1
        }
        
        currentQuestionIndex += 1
        showQuestion()
    }
    
    @IBAction func restartGame(_ sender: UIButton) {
        currentQuestionIndex = 0
        correctAnswers = 0
        restartButton.isHidden = true
        categoryLabel.isHidden = false
        showQuestion()
    }
    var questions: [Question] = [
        Question(
            text: "Who was the first American Idol Winner?",
            category: "Music",
            answers: [ "Kelly Clarkson", "Carrie Underwood", "Beyonce", "Simon Cowell"
                     ],
            correctAnswer: "Kelly Clarkson"
        ),
        Question(
            text: "What is the first meal of the day?",
            category: "Food",
            answers: ["Dinner", "Lunch", "Breakfast", "Snack"],
            correctAnswer: "Breakfast"
        ),
        Question(
            text: "What is the largest continent?",
            category: "Geography",
            answers: ["North America", "South America", "Asia", "Europe"],
            correctAnswer: "Asia"
        )
    ]
    
    var currentQuestionIndex = 0
    var correctAnswers = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showQuestion()
        restartButton.isHidden = true

    }
    
    func showQuestion(){
        if currentQuestionIndex < questions.count{
            let currQuestion = questions[currentQuestionIndex]
            
            questionLabel.text = currQuestion.text
            categoryLabel.text = currQuestion.category
            optionButton1.setTitle(currQuestion.answers[0], for: .normal)
            optionButton2.setTitle(currQuestion.answers[1], for: .normal)
            optionButton3.setTitle(currQuestion.answers[2], for: .normal)
            optionButton4.setTitle(currQuestion.answers[3], for: .normal)
            
            [optionButton1, optionButton2, optionButton3, optionButton4].forEach {
                $0?.isHidden = false
            }
        }
        else{
            showFinalScore()
        }
    }
    func showFinalScore(){
        questionLabel.text = "You got \(correctAnswers) out of \(questions.count) correct!"
        optionButton1.isHidden = true
        optionButton2.isHidden = true
        optionButton3.isHidden = true
        optionButton4.isHidden = true
        categoryLabel.isHidden = true
        restartButton.isHidden = false

        
    }
    
}
