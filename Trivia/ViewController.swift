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
        restartButton.isHidden = true
        categoryLabel.isHidden = false
        fetchQuestions()
    }
    
    var questions: [Question] = []
    
    var currentQuestionIndex = 0
    var correctAnswers = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchQuestions()
        restartButton.isHidden = true

    }
    
    func fetchQuestions() {
        TriviaQuestionService.fetchQuestions { fetchedQuestions in
            
            self.questions = fetchedQuestions.map { q in
                let allAnswers = (q.incorrectAnswers + [q.correctAnswer]).shuffled()
                return Question(
                    text: q.question.htmlDecoded,
                    category: q.category.htmlDecoded,
                    answers: allAnswers.map { $0.htmlDecoded },
                    correctAnswer: q.correctAnswer.htmlDecoded
                )
            }
            
            DispatchQueue.main.async {
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                self.showQuestion()
            }
        }
    }
    
    func showQuestion() {
        guard currentQuestionIndex < questions.count else {
            showFinalScore()
            return
        }
        
        let currQuestion = questions[currentQuestionIndex]
        questionLabel.text = currQuestion.text
        categoryLabel.text = currQuestion.category
        
        let buttons = [optionButton1, optionButton2, optionButton3, optionButton4]
        
        for (i, button) in buttons.enumerated() {
            if i < currQuestion.answers.count {
                button?.setTitle(currQuestion.answers[i], for: .normal)
                button?.isHidden = false
            } else {
                button?.isHidden = true
            }
        }
    }
    
    func showFinalScore(){
        questionLabel.text = "You got \(correctAnswers) out of \(questions.count) correct!"
        [optionButton1, optionButton2, optionButton3, optionButton4].forEach { $0?.isHidden = true }
        categoryLabel.isHidden = true
        restartButton.isHidden = false

        
    }
    
}

extension String {
    var htmlDecoded: String {
        guard let data = self.data(using: .utf8) else { return self }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        let decoded = try? NSAttributedString(data: data, options: options, documentAttributes: nil)
        return decoded?.string ?? self
    }
}
