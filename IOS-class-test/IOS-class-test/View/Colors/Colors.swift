import UIKit

func getColor(language : String) -> UIColor {
    let filename = "language-colors"
    let data: Data
    guard let file = Bundle.main.url(forResource: filename, withExtension: "json")
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    do {
        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String] else {
            fatalError("error to read json dictionary")
        }
        guard let color = json[language] else {
            return UIColor.black
        }
        guard let uiColor = UIColor(hex: color) else {
            return UIColor.black
        }
        
        return uiColor
    } catch {
        fatalError("Couldn't parse")
    }
}

extension UIColor {
    convenience init?(hex: String) {
        var hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hex = hex.replacingOccurrences(of: "#", with: "")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgbValue)
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}



