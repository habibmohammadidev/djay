//
//  SkillLevel.swift
//  Djay
//

import Foundation

enum SkillLevel: String, CaseIterable {
    case beginner
    case intermediate
    case professional
    
    var title: String {
        switch self {
        case .beginner: "I'm new to DJing"
        case .intermediate: "I've used DJ apps before"
        case .professional: "I'm a professional DJ"
        }
    }

    var emoji: String {
        switch self {
        case .beginner: "🎧"
        case .intermediate: "🎵"
        case .professional: "🎛️"
        }
    }
    
    var finaleTitle: String {
        switch self {
        case .beginner: "Welcome to Your DJ Journey!"
        case .intermediate: "Ready to Level Up Your Mixes!"
        case .professional: "Let's Create Magic Together!"
        }
    }
    
    var finaleSubtitle: String {
        switch self {
        case .beginner: "We'll guide you through every step. Get ready to create amazing mixes!"
        case .intermediate: "You'll love our advanced features. Time to take your skills further!"
        case .professional: "Pro tools at your fingertips. Let's push the boundaries of mixing!"
        }
    }
}
