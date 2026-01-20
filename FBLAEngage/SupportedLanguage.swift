//
//  SupportedLanguage.swift
//  FBLAEngage
//
//  Created by Cyrus  Emam on 1/3/26.
//

enum SupportedLanguage: String, CaseIterable, Identifiable {
    case english     = "en-US"
    case spanish     = "es-ES"
    case french      = "fr-FR"
    case german      = "de-DE"
    case italian     = "it-IT"
    case portuguese  = "pt-BR"
    case russian     = "ru-RU"
    case chinese     = "zh-CN"
    case arabic      = "ar-SA"
    case hindi       = "hi-IN"
    case japanese    = "ja-JP"
    case korean      = "ko-KR"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .english: return "English"
        case .spanish: return "Spanish"
        case .french: return "French"
        case .german: return "German"
        case .italian: return "Italian"
        case .portuguese: return "Portuguese"
        case .russian: return "Russian"
        case .chinese: return "Chinese (Mandarin)"
        case .arabic: return "Arabic"
        case .hindi: return "Hindi"
        case .japanese: return "Japanese"
        case .korean: return "Korean"
        }
    }
}
