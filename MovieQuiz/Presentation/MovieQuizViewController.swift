import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    private var alertPresenter: AlertPresenter = AlertPresenter()
    
    private var presenter: MovieQuizPresenter!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet private weak var textLabel: UILabel!
    
    @IBOutlet private weak var counterLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MovieQuizPresenter(viewController: self)
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        
        alertPresenter.viewController = self
        
        showLoadingIndicator()
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let alertModel = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать ещё раз",
            completion: { [weak self] in
                self?.presenter.restartGame()
            })
        
        alertPresenter.show(viewModel: alertModel)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        presenter.didReceiveNextQuestion(question: question)
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    func showQuizQuestion(quiz step: QuizStepViewModel) {
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
        imageView.image = step.image
        imageView.layer.borderWidth = 0
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }
    
    func showResultAlert() {
        presenter.statisticService.store(correct: presenter.correctAnswers, total: presenter.questionsAmount)
        
        let alertModel = AlertModel(
            title: "Этот раунд окончен!",
            message: presenter.makeResultAlertMessage(),
            buttonText: "Сыграть ещё раз",
            completion: { [weak self] in
                self?.presenter.restartGame()
                self?.presenter.questionFactory?.requestNextQuestion()
            })
        
        alertPresenter.show(viewModel: alertModel)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        sender.isEnabled = false
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        sender.isEnabled = false
        presenter.noButtonClicked()
    }
}
