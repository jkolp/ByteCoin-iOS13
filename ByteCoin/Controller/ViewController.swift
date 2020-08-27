import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coinManager.delegate = self
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        // Do any additional setup after loading the view.
    }
}

// MARK: - UIPickerViewDataSource
extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    // numberOfComponents and pickerView(with numberOfRoewsInComponent) are from
    // UIPickerViewDataSource protocol
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        // How many columns in the picker
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // How many rows in the picker
        return coinManager.currencyArray.count
    }
    
    // This function is from UIPIckerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // Data to be displayed in the picker
        // When the PickerView is loading up, it will ask its delegate for a row title and call the above method once for every row.
        return coinManager.currencyArray[row]
    }
    
    // This function is from UIPIckerViewDelegate
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // inComponent refers to the column index left to right [0]...
        print(coinManager.currencyArray[row])
        coinManager.getCoinPrice(for: coinManager.currencyArray[row])
    }
}

// MARK: - CoinManagerDelegate

extension ViewController: CoinManagerDelegate{
    func didGetCoinPrice(_ coinManager: CoinManager, exchangeRate: ExchangeRateModel){
        DispatchQueue.main.async {
            self.bitcoinLabel.text = String(format: "%.2f", exchangeRate.rate)
            self.currencyLabel.text = exchangeRate.currency
        }
    }
    
    func didFailWithError(error: Error){
        print(error)
    }
}
