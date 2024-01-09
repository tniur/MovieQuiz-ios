//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Pavel on 03.01.2024.
//

protocol MovieQuizViewControllerProtocol: AnyObject {
    func showQuizQuestion(quiz step: QuizStepViewModel)
    func showResultAlert()
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func showNetworkError(message: String)
}
