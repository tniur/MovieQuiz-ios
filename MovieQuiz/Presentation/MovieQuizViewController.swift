import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    private let questionsAmount: Int = 10
    private lazy var questionFactory: QuestionFactoryProtocol = QuestionFactory()
    private var currentQuestion: QuizQuestion?
    
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var textLabel: UILabel!
    
    @IBOutlet private weak var counterLabel: UILabel!
    
    @IBOutlet weak var yesButton: UIButton!
    
    @IBOutlet weak var noButton: UIButton!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        
        questionFactory.delegate = self
        
        questionFactory.requestNextQuestion()
        
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convertQuestionToViewModel(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.showQuizQuestion(quiz: viewModel)
        }
    }
    
    private func convertQuestionToViewModel(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        
        if isCorrect {
            correctAnswers += 1
        }
        
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.imageView.layer.borderWidth = 0
            self.yesButton.isEnabled = true
            self.noButton.isEnabled = true
            self.showNextQuestionOrResults()
        }
    }
    
    private func showQuizQuestion(quiz step: QuizStepViewModel) {
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
        imageView.image = step.image
    }
    
    private func showResultAlert(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            self.questionFactory.requestNextQuestion()
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд закончен",
                text: "Ваш результат: \(self.correctAnswers)/\(self.questionsAmount)",
                buttonText: "Сыграть еще раз")
            showResultAlert(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            
            questionFactory.requestNextQuestion()
        }
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else { return }
        
        let givenAnswer = true
        
        yesButton.isEnabled = false
        noButton.isEnabled = false
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == givenAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else { return }
        
        let givenAnswer = false
        
        yesButton.isEnabled = false
        noButton.isEnabled = false
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == givenAnswer)
    }
}
