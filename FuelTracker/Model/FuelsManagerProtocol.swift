//
//  FuelsManagerProtocol.swift
//  FuelTracker
//
//  Created by Daniel Zanchi on 18/03/2019.
//  Copyright © 2019 Daniel Zanchi. All rights reserved.
//

import SQLite

protocol FuelsManagerProtocol {
    
    func addFuel(dateOfFuel: Date, mileage mileageOnSave: Int, quantity quantityOfFuel: Double, pricePerUnit pricePerUnitOfFuel: Double, isTankNotFull isTankNotFullFuel: Bool) -> Int64    
    
    func getFuels() -> [Fuel]?
    
    func deleteFuel(withID fID: Int64) -> Bool
    
    func updateFuel(withID fID: Int64, toFuel: Fuel) -> Bool
    
    func deleteAllFuels() -> Bool
    
}
