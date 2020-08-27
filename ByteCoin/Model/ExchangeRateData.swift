import Foundation

struct ExchangeRateData : Decodable{
    let asset_id_base : String
    let asset_id_quote : String
    let rate : Double
}
