import Foundation

extension String {
    
    enum ValidTypes {
        case name
        case email
        case password
        
    }
    
    enum Regex: String {
        // регулярные выражения
        case name = "[a-zA-Z]{1,}"
        // exmpl: company@gmail.com
        case email = "[a-zA-Z0-9._-]+@[a-zA-Z]+\\.[a-zA-Z]{2,}"
        //мин кол-во символов пароля == 6
        case password = "(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).{6,}"
    }
    
    
    func isValid(validType: ValidTypes) -> Bool {
        let format = "SELF MATCHES %@"
        var regex = ""
        
        switch validType {
        case .name: regex = Regex.name.rawValue
        case .email: regex = Regex.email.rawValue
        case .password: regex = Regex.password.rawValue
        }
        
        return NSPredicate(format: format, regex).evaluate(with: self)
    }
    
}
