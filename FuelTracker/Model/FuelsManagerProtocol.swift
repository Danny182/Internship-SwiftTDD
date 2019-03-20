//
//  FuelsManagerProtocol.swift
//  FuelTracker
//
//  Created by Daniel Zanchi on 18/03/2019.
//  Copyright © 2019 Daniel Zanchi. All rights reserved.
//

import SQLite

protocol FuelsManagerProtocol {
    
    func addFuel(dateOfFuel: Date, mileageOnSave: Int, quantityOfFuel: Double, pricePerUnitOfFuel: Double, isTankNotFullFuel: Bool) -> Int64
    
    func getFuels() -> [Fuel]?
    
    func deleteFuel(fID: Int64) -> Bool
    
    func updateFuel(fID: Int64, newFuel: Fuel) -> Bool
    
}
