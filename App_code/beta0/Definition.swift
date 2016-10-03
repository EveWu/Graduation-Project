//
//  Definition.swift
//  beta0
//
//  Created by wu xiao yue on 3/21/16.
//  Copyright © 2016 eve. All rights reserved.
//

import CoreBluetooth

let TRANSFER_SERVICE_UUID = "2B4F5A1D-4319-CBCA-076A-6122FBE64A8D"
let TRANSFER_CHARACTERISTIC_UUID = "FFE1"
let NOTIFY_MTU = 20

let transferServiceUUID = CBUUID(string: TRANSFER_SERVICE_UUID)
let transferCharacteristicUUID = CBUUID(string: TRANSFER_CHARACTERISTIC_UUID)
