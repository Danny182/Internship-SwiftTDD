//
//  FuelManager.swift
//  FuelTracker
//
//  Created by Daniel Zanchi on 18/03/2019.
//  Copyright © 2019 Daniel Zanchi. All rights reserved.
//

import SQLite

class FuelsManager: FuelsManagerProtocol {
    
    private var database: Connection?
    private let fuelsTable = Table("fuels")
    
    let id = Expression<Int64>("id")
    let date = Expression<Date>("date")
    let mileage = Expression<Int>("mileage")
    let quantity = Expression<Double>("quantity")
    let pricePerUnit = Expression<Double>("pricePerUnit")
    let isTankNotFull = Expression<Bool>("isTankNotFull")
    
    init(database: Connection) {
        self.database = database
        createTable()
    }
    
    @discardableResult func createTable() -> Bool {
        let create = self.fuelsTable.create { (table) in
            table.column(id, primaryKey: true)
            table.column(date)
            table.column(mileage)
            table.column(quantity)
            table.column(pricePerUnit)
            table.column(isTankNotFull)
        }
        do {
            try database?.run(create)
            return true
        } catch {
            print("unable to create table")
            print(error)
            return false
        }
    }
    
    @discardableResult func addFuel(dateOfFuel: Date, mileage mileageOnSave: Int, quantity quantityOfFuel: Double, pricePerUnit pricePerUnitOfFuel: Double, isTankNotFull isTankNotFullFuel: Bool) -> Int64 {
        let insertFuel = fuelsTable.insert(
            date <- dateOfFuel,
            mileage <- mileageOnSave,
            quantity <- quantityOfFuel,
            pricePerUnit <- pricePerUnitOfFuel,
            isTankNotFull <- isTankNotFullFuel
        )
        
        print("INFO: insertFuel created")
        do {
            let id = try database!.run(insertFuel)
            print("INFO: this will not be called, because try fails")
            return id
        } catch {
            print("INFO: error")
            print(error)
            return -1
        }
    }
    
    func getFuels() -> [Fuel]? {
        var fuels = [Fuel]()
        
        do {
            if let fuelsList = try database?.prepare(fuelsTable.order(date.desc)) {
                for fuel in fuelsList {
                    fuels.append(Fuel(
                        id: fuel[id],
                        date: fuel[date],
                        mileage: fuel[mileage],
                        quantity: fuel[quantity],
                        pricePerUnit: fuel[pricePerUnit],
                        isTankNotFull: fuel[isTankNotFull]
                    ))
                }
            } else {
                print("error")
            }
            return fuels
        } catch {
            print("error while reading fuels")
            print(error)
            return nil
        }
    }
    
    func deleteFuel(fID: Int64) -> Bool {
        do {
            let fuel = fuelsTable.filter(id == fID)
            try database?.run(fuel.delete())
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    @discardableResult func deleteAllFuels() -> Bool {
        do {
            try database?.run(fuelsTable.delete())
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    func updateFuel(fID: Int64, newFuel: Fuel) -> Bool {
        let fuel = fuelsTable.where(id == fID)
        print(fuel)
        do {
            let update = fuel.update([
                date <- newFuel.date, 
                mileage <- newFuel.mileage, 
                quantity <- newFuel.quantity, 
                pricePerUnit <- newFuel.pricePerUnit
                ])
            let result = try database!.run(update)
            if result > 0 {
                return true
            } else {
                return false
            }
        } catch {
            print(error)
            return false
        }
    }
    
    func dropTable() {
        _ = try? database?.run(fuelsTable.drop())
    }
    
}
