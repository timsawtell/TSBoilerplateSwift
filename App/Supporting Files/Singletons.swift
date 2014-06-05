//
//  Singletons.swift
//  TSBoilerplateSwift
//
//  Created by Tim Sawtell on 5/06/2014.
//  Copyright (c) 2014 Sawtell Software. All rights reserved.
//

import Foundation

let model = ModelBuilder.getModel()!
let commandRunner = CommandRunner()

class ModelBuilder {
    class func getModel() -> Model? {
        var path = CommandCenter.pathForModel()
        var error: NSError?
        let data = NSData.dataWithContentsOfFile(path, options: NSDataReadingOptions.DataReadingMappedIfSafe, error:&error)
        if (nil == data) {
            return Model()
        } else {
            if let modelInstance = CommandCenter.securelyUnarchiveData(data, key: kModelArchiveKey) as? Model {
                return modelInstance
            }
        }
        return nil
    }
}
