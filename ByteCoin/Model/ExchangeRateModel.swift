import UIKit

struct ExchangeRateModel {
    let cryptoCurrency : String // eg. BTC
    let currency : String // eg. USD
    let rate : Double // eg. 99.99
    
    func rateString() -> String{
        return String(format: "%.2f", rate)
    }
    
}
