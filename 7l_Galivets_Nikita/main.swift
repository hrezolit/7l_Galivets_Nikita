//
//  main.swift
//  7l_Galivets_Nikita
//
//  Created by Nikita on 25/2/22.
//

import Foundation

// 1) Придумать класс, методы которого могут завершаться неудачей и возвращать либо значение, либо ошибку Error?. Реализовать их вызов и обработать результат метода при помощи конструкции if let, или guard let.
// 2) Придумать класс, методы которого могут выбрасывать ошибки. Реализуйте несколько throws-функций. Вызовите их и обработайте результат вызова при помощи конструкции try/catch.

enum PowerSwitch {
    case on
    case off
}
enum StopButtom {
    case go
    case stop
}
enum ElevatorError: Error {
    
    case overload
    case EmergencyPowerOff
    case EmergencyStop
}

final class Person{
    
    var numberOfPersons: Int
    var personsWeight: Int
    
    init() {
        self.personsWeight = Int(arc4random_uniform(3000))
        self.numberOfPersons = Int(arc4random_uniform(10) + 1)
        
    }
    
    func newFloorRequest() -> Int {
        
        numberOfPersons = Int(arc4random_uniform(10) + 1)
        
        return numberOfPersons
        
    }
}

final class Elevator {
    
    var weightLimit: Int
    var currentFloor : Int
    var requestedFloor : Int
    var passengers : Person
    var isWorking: PowerSwitch
    var isEmergencyStoped: StopButtom
    
    init(weightLimit: Int,
         currentFloor: Int,
         requestedFloor: Int,
         passengers: Person,
         isWorking: PowerSwitch,
         isEmergencyStoped: StopButtom)
    {
        self.weightLimit = weightLimit
        self.currentFloor = currentFloor
        self.requestedFloor = requestedFloor
        self.passengers = Person()
        self.isWorking = isWorking
        self.isEmergencyStoped = isEmergencyStoped
    }
    
    func newFloorRequest() throws {
        
        guard isWorking == .on else {
            throw ElevatorError.EmergencyPowerOff
        }
        guard isEmergencyStoped == .go else {
            throw ElevatorError.EmergencyStop
        }
        guard weightLimit > passengers.personsWeight else {
            throw ElevatorError.overload
        }
        
        requestedFloor = passengers.newFloorRequest()
        
        print("Departing floor: \(currentFloor) - Traveling to floor: \(requestedFloor), total weight: \(passengers.personsWeight)")
        
        currentFloor = requestedFloor
        
    }
    
}

final class Building{
    
    var firstElevator = Elevator(weightLimit: 1000,
                                 currentFloor: 1,
                                 requestedFloor: 0,
                                 passengers: Person(),
                                 isWorking: .on,
                                 isEmergencyStoped: .go)
    
    var secondElevator = Elevator(weightLimit: 1000,
                                  currentFloor: 1,
                                  requestedFloor: 0,
                                  passengers: Person(),
                                  isWorking: .on,
                                  isEmergencyStoped: .stop)
    
    var cargoElevator = Elevator(weightLimit: 3000,
                                 currentFloor: 1,
                                 requestedFloor: 0,
                                 passengers: Person(),
                                 isWorking: .on,
                                 isEmergencyStoped: .go)
    
}

var building = Building()

print("""

---------------
First Elevator
---------------
status:
""")

do {
    try building.firstElevator.newFloorRequest()
} catch ElevatorError.overload {
    print("Overload")
} catch ElevatorError.EmergencyStop{
    print("Emergency stop")
} catch ElevatorError.EmergencyPowerOff{
    print("Emergency power off")
} catch let error {
    print(error.localizedDescription)
}

print("""

---------------
Second Elevator
---------------
status:
""")

do {
    try building.secondElevator.newFloorRequest()
} catch ElevatorError.overload {
    print("Overload")
} catch ElevatorError.EmergencyStop{
    print("Emergency stop")
} catch ElevatorError.EmergencyPowerOff{
    print("Emergency power off")
} catch let error {
    print(error.localizedDescription)
}

print("""

---------------
Cargo Elevator
---------------
status:
""")

do {
    try building.cargoElevator.newFloorRequest()
} catch ElevatorError.overload {
    print("Overload")
} catch ElevatorError.EmergencyStop{
    print("Emergency stop")
} catch ElevatorError.EmergencyPowerOff{
    print("Emergency power off")
} catch let error {
    print(error.localizedDescription)
}
