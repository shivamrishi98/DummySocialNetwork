//
//  SettingsSectionViewModel.swift
//  DummySocialNetwork
//
//  Created by Shivam Rishi on 28/03/21.
//

import Foundation

enum SettingsViewModelType {
    case logout
}

struct SettingsSectionViewModel {
    let title:String
    let option:[SettingsViewModel]
}

struct SettingsViewModel {
    let viewModelType: SettingsViewModelType
    let title:String
    let handler: (() -> Void)?
}
