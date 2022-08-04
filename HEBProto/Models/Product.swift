//
//  Product.swift
//  HEBProto
//
//  Created by Steve Galbraith on 8/3/22.
//

import Foundation

struct ProductResponse: Decodable {
    let products: [Product]
    
    enum CodingKeys: String, CodingKey {
        case products = "data"
    }
}

struct Product: Decodable {
    let id: String
    let upc: String
    let aisleLocations: [ProductAisleLocation]
    let brand: String?
    let description: String
    let images: [ProductImageContainer]
    let items: [ProductItem]
    let temperature: ProductTemperature
    
    enum CodingKeys: String, CodingKey {
        case id = "productId"
        case upc
        case aisleLocations
        case brand
        case description
        case images
        case items
        case temperature
    }
}

struct ProductAisleLocation: Decodable {
    let bayNumber: String?
    let description: String
    let number: String
    let numberOfFacings: String?
    let sequenceNumber: String?
    let side: AisleSide?
    let shelfNumber: String?
    let shelfPositionInBay: String?
    
}

enum AisleSide: String, Decodable {
    case left = "L"
    case right = "R"
}

struct ProductImageContainer: Decodable {
    let perspective: ProductPerspective
    let isFeatured: Bool
    let images: [ProductImage]
    
    enum CodingKeys: String, CodingKey {
        case perspective
        case isFeatured = "featured"
        case images = "sizes"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        perspective = try container.decode(ProductPerspective.self, forKey: .perspective)
        isFeatured = try container.decodeIfPresent(Bool.self, forKey: .isFeatured) ?? false
        images = try container.decode([ProductImage].self, forKey: .images)
    }
}

enum ProductPerspective: String, Decodable {
    case front
    case back
    case top
}

struct ProductImage: Decodable {
    let size: ImageSize
    let url: String
}

enum ImageSize: String, Decodable {
    case thumbnail
    case small
    case medium
    case large
    case extraLarge = "xlarge"
}

struct ProductItem: Decodable {
    let id: String
    let isFavorite: Bool
    let fulfillmentOptions: [ProductFulfillmentOption]
    let size: String
    let price: Price
    let nationalPrice: Price?
    let soldBy: ProductPriceUnit
    
    enum CodingKeys: String, CodingKey {
        case id = "itemId"
        case isFavorite = "favorite"
        case fulfillmentOptions = "fulfillment"
        case size
        case price
        case nationalPrice
        case soldBy
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
        fulfillmentOptions = try container.decode(Fulfillment.self, forKey: .fulfillmentOptions).options
        size = try container.decode(String.self, forKey: .size)
        price = try container.decode(Price.self, forKey: .price)
        nationalPrice = try container.decodeIfPresent(Price.self, forKey: .nationalPrice)
        soldBy = try container.decode(ProductPriceUnit.self, forKey: .soldBy)
    }
    
    private struct Fulfillment: Decodable {
        let curbside: Bool
        let delivery: Bool
        let inStore: Bool
        let shipToHome: Bool
        
        var options: [ProductFulfillmentOption] {
            var options = [ProductFulfillmentOption]()
            
            if curbside {
                options.append(.curbside)
            }
            
            if delivery {
                options.append(.delivery)
            }
            
            if inStore {
                options.append(.inStore)
            }
            
            if shipToHome {
                options.append(.shipToHome)
            }
            
            return options
        }
    }
}

struct Price: Decodable {
    let regularInCents: Int
    let promoInCents: Int
    let regularPerUnitEstimateInCents: Int
    let promoPerUnitEstimateInCents: Int
    
    enum CodingKeys: String, CodingKey {
        case regularInCents = "regular"
        case promoInCents = "promo"
        case regularPerUnitEstimateInCents = "regularPerUnitEstimate"
        case promoPerUnitEstimateInCents = "promoPerUnitEstimate"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Prices are a lot easier to work with in cents as integers, so convert them to integers
        let regular = (try? container.decode(Double.self, forKey: .regularInCents)) ?? 0
        regularInCents = Int(regular * 100)
        let promo = (try? container.decode(Double.self, forKey: .promoInCents)) ?? 0
        promoInCents = Int(promo * 100)
        let regularPerUnitEstimate = (try? container.decode(Double.self, forKey: .regularPerUnitEstimateInCents)) ?? 0
        regularPerUnitEstimateInCents = Int(regularPerUnitEstimate * 100)
        let promoPerUnitEstimate = (try? container.decode(Double.self, forKey: .promoPerUnitEstimateInCents)) ?? 0
        promoPerUnitEstimateInCents = Int(promoPerUnitEstimate * 100)
    }
}

enum ProductPriceUnit: String, Decodable {
    case unit = "UNIT"
    case weight = "WEIGHT"
}

enum ProductFulfillmentOption: String {
    case curbside
    case delivery
    case inStore
    case shipToHome
}

struct ProductTemperature: Decodable {
    let indicator: TemperatureIndicator
    let isHeatSensitive: Bool
    
    enum CodingKeys: String, CodingKey {
        case indicator
        case isHeatSensitive = "heatSensitive"
    }
}

enum TemperatureIndicator: String, Decodable {
    case ambient = "Ambient"
    case refrigerated = "Refrigerated"
}

//{
//    "productId": "0001111014902",
//    "upc": "0001111014902",
//    "aisleLocations": [],
//    "brand": "Kroger",
//    "categories": [
//        "Produce"
//    ],
//    "countryOrigin": "UNITED STATES",
//    "description": "Kroger® Pink Lady® Apples",
//    "images": [
//        {
//            "perspective": "front",
//            "featured": true,
//            "sizes": [
//                {
//                    "size": "thumbnail",
//                    "url": "https://www.kroger.com/product/images/thumbnail/front/0001111014902"
//                },
//                {
//                    "size": "medium",
//                    "url": "https://www.kroger.com/product/images/medium/front/0001111014902"
//                },
//                {
//                    "size": "small",
//                    "url": "https://www.kroger.com/product/images/small/front/0001111014902"
//                },
//                {
//                    "size": "large",
//                    "url": "https://www.kroger.com/product/images/large/front/0001111014902"
//                },
//                {
//                    "size": "xlarge",
//                    "url": "https://www.kroger.com/product/images/xlarge/front/0001111014902"
//                }
//            ]
//        }
//    ],
//    "items": [
//        {
//            "itemId": "0001111014902",
//            "favorite": false,
//            "fulfillment": {
//                "curbside": false,
//                "delivery": false,
//                "inStore": false,
//                "shipToHome": false
//            },
//            "size": "3 lb"
//        }
//    ],
//    "itemInformation": {},
//    "temperature": {
//        "indicator": "Ambient",
//        "heatSensitive": false
//    }
//}
