//
//  OnboardingAssets.swift
//  Djay
//

import UIKit

/// Centralized asset management for onboarding
enum OnboardingAssets {
    
    // MARK: - Images
    
    /// Logo image for welcome screen
    static var logo: UIImage? {
        // Try custom asset first, fallback to SF Symbol
        return UIImage(named: "djay.logo") ?? UIImage(systemName: "music.note.list")
    }
    
    /// Hero image for features screen
    static var hero: UIImage? {
        return UIImage(named: "djay.hero") ?? UIImage(systemName: "waveform.circle.fill")
    }
    
    /// Celebration image for finale screen
    static var celebration: UIImage? {
        return UIImage(named: "djay.celebration") ?? UIImage(systemName: "party.popper.fill")
    }
    
    // MARK: - Colors
    
    static let primaryBlue = UIColor(red: 0.3, green: 0.6, blue: 1.0, alpha: 1.0)
    static let darkBackground1 = UIColor(red: 0.05, green: 0.05, blue: 0.1, alpha: 1.0)
    static let darkBackground2 = UIColor(red: 0.08, green: 0.08, blue: 0.15, alpha: 1.0)
    static let darkBackground3 = UIColor(red: 0.1, green: 0.1, blue: 0.18, alpha: 1.0)
    static let darkBackground4 = UIColor(red: 0.12, green: 0.12, blue: 0.2, alpha: 1.0)
    
    // MARK: - Typography
    
    static let titleFont = UIFont.systemFont(ofSize: 32, weight: .bold)
    static let subtitleFont = UIFont.systemFont(ofSize: 17, weight: .regular)
    static let buttonFont = UIFont.systemFont(ofSize: 17, weight: .semibold)
    static let optionFont = UIFont.systemFont(ofSize: 16, weight: .medium)
}
