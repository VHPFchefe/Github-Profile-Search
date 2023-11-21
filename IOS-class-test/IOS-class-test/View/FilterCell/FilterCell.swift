import UIKit


class FilterCell : UITableViewCell, UITextFieldDelegate{
    
    @IBOutlet weak var filterTextView: UITextField!
    
    @IBOutlet weak var buttonMenuFilterAndOrder: UIButton!
    
    weak var delegate: FilterCellDelegate?

    @IBAction func buttonTapped(_ sender: UIButton) {
        delegate?.didTapButton(sender, on: self)
    }
    
    @IBAction func editingChanged(_ sender: UITextField) {
        delegate?.editingChanged(sender)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.touchesBegan(touches, with: event)
    }
    
    @IBAction func didEndOnExit(_ sender: Any) {
        delegate?.didEndOnExit(sender)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        for character in string {
            print(character)
        }
        return true
    }
    

    func configFilterCell(){
        let attachment = NSTextAttachment()
        attachment.image = UIImage(systemName: "sparkle.magnifyingglass")

        let imageString = NSMutableAttributedString(attachment: attachment)
        let textString = NSAttributedString(string: "  Enter the name of the repository")
        imageString.append(textString)
        
        filterTextView.attributedPlaceholder = imageString
    }
}

protocol FilterCellDelegate: AnyObject {
    func didTapButton(_ sender: UIButton, on cell: FilterCell)
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    func didEndOnExit(_ sender: Any)
    func editingChanged(_ sender: UITextField)
}

