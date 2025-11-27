//
//  UIFont+SFProDisplay.swift
//  Djay
//

import UIKit

extension UIFont {
    static func sfProDisplayUltraLight(size: CGFloat) -> UIFont {
        UIFont(name: "SFProDisplay-Ultralight", size: size) ?? .systemFont(ofSize: size, weight: .ultraLight)
    }
    
    static func sfProDisplayUltraLightItalic(size: CGFloat) -> UIFont {
        UIFont(name: "SFProDisplay-UltralightItalic", size: size) ?? .italicSystemFont(ofSize: size)
    }
    
    static func sfProDisplayThin(size: CGFloat) -> UIFont {
        UIFont(name: "SFProDisplay-Thin", size: size) ?? .systemFont(ofSize: size, weight: .thin)
    }
    
    static func sfProDisplayThinItalic(size: CGFloat) -> UIFont {
        UIFont(name: "SFProDisplay-ThinItalic", size: size) ?? .italicSystemFont(ofSize: size)
    }
    
    static func sfProDisplayLight(size: CGFloat) -> UIFont {
        UIFont(name: "SFProDisplay-Light", size: size) ?? .systemFont(ofSize: size, weight: .light)
    }
    
    static func sfProDisplayLightItalic(size: CGFloat) -> UIFont {
        UIFont(name: "SFProDisplay-LightItalic", size: size) ?? .italicSystemFont(ofSize: size)
    }
    
    static func sfProDisplayRegular(size: CGFloat) -> UIFont {
        UIFont(name: "SFProDisplay-Regular", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func sfProDisplayRegularItalic(size: CGFloat) -> UIFont {
        UIFont(name: "SFProDisplay-RegularItalic", size: size) ?? .italicSystemFont(ofSize: size)
    }
    
    static func sfProDisplayMedium(size: CGFloat) -> UIFont {
        UIFont(name: "SFProDisplay-Medium", size: size) ?? .systemFont(ofSize: size, weight: .medium)
    }
    
    static func sfProDisplayMediumItalic(size: CGFloat) -> UIFont {
        UIFont(name: "SFProDisplay-MediumItalic", size: size) ?? .italicSystemFont(ofSize: size)
    }
    
    static func sfProDisplaySemibold(size: CGFloat) -> UIFont {
        UIFont(name: "SFProDisplay-Semibold", size: size) ?? .systemFont(ofSize: size, weight: .semibold)
    }
    
    static func sfProDisplaySemiboldItalic(size: CGFloat) -> UIFont {
        UIFont(name: "SFProDisplay-SemiboldItalic", size: size) ?? .italicSystemFont(ofSize: size)
    }
    
    static func sfProDisplayBold(size: CGFloat) -> UIFont {
        UIFont(name: "SFProDisplay-Bold", size: size) ?? .systemFont(ofSize: size, weight: .bold)
    }
    
    static func sfProDisplayBoldItalic(size: CGFloat) -> UIFont {
        UIFont(name: "SFProDisplay-BoldItalic", size: size) ?? .italicSystemFont(ofSize: size)
    }
    
    static func sfProDisplayHeavy(size: CGFloat) -> UIFont {
        UIFont(name: "SFProDisplay-Heavy", size: size) ?? .systemFont(ofSize: size, weight: .heavy)
    }
    
    static func sfProDisplayHeavyItalic(size: CGFloat) -> UIFont {
        UIFont(name: "SFProDisplay-HeavyItalic", size: size) ?? .italicSystemFont(ofSize: size)
    }
    
    static func sfProDisplayBlack(size: CGFloat) -> UIFont {
        UIFont(name: "SFProDisplay-Black", size: size) ?? .systemFont(ofSize: size, weight: .black)
    }
    
    static func sfProDisplayBlackItalic(size: CGFloat) -> UIFont {
        UIFont(name: "SFProDisplay-BlackItalic", size: size) ?? .italicSystemFont(ofSize: size)
    }

    static func sfProTextRegular(size: CGFloat) -> UIFont {
        UIFont(name: "SFProText-Regular", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func sfProTextSemiBold(size: CGFloat) -> UIFont {
        UIFont(name: "SFProText-Semibold", size: size) ?? .systemFont(ofSize: size, weight: .semibold)
    }
}
