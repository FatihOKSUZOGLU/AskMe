//
//  AskMeController.swift
//  AskMeWord
//
//  Created by Fatih OKSUZOGLU on 22.08.2023.
//

import Foundation

class AskMeController {
    var viewModel = AskMeViewModel()

    func loadData(for word: String) {
        viewModel.loadData(for: word)
    }

    func getWordViewData() -> WordViewData? {
        return viewModel.wordViewData
    }

    func getError() -> Error? {
        return viewModel.error
    }

    func getViewModel() -> AskMeViewModel {
        return viewModel
    }
}
