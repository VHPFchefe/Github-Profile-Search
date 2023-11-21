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




