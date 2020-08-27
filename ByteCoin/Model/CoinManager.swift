import UIKit

protocol CoinManagerDelegate {
    func didGetCoinPrice(_ coinManager: CoinManager, exchangeRate: ExchangeRateModel)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "229737F3-C3BC-43A4-B37F-46388CA2F1B1"
    
    var delegate: CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency: String){
        let urlString = "\(baseURL)/\(currency)?apikey=229737F3-C3BC-43A4-B37F-46388CA2F1B1"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String){
        if let url = URL(string: urlString) {
            
            //2. Create a URLSession : Object that performs all network
            let session = URLSession(configuration: .default)
            
            //3. Create task for session (Using trailing closure, kind of like
            let task = session.dataTask(with: url) { (data, response, error) in
                
                // if no error
                if error != nil {
                   self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    // must add self. when calling a function inside closure
                    if let exchangeRate = self.parseJson(exchangeData: safeData) {
                        self.delegate?.didGetCoinPrice(self, exchangeRate: exchangeRate)
                    }
                }
            }
            //4. Start the task
            task.resume()
        }
    }
    
    func parseJson(exchangeData: Data) -> ExchangeRateModel? {
        let decoder = JSONDecoder()
        
        do {
            // add .self to make object type :WeatherData.self
            let decodedData = try decoder.decode(ExchangeRateData.self, from: exchangeData) // returns decodable object : WeatherData object
            let asset_id_base = decodedData.asset_id_base
            let asset_id_quote = decodedData.asset_id_quote
            let rate = decodedData.rate
            
            let exchangeRate = ExchangeRateModel(cryptoCurrency: asset_id_base, currency: asset_id_quote, rate: rate)
            return exchangeRate
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
        
        
    }
}
