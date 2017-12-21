//
//  GuitarBuddyCommandHelper.swift
//  GuitarBuddy
//
//  Created by Brad Siegel on 12/14/17.
//  Copyright © 2017 Brad Siegel. All rights reserved.
//

import Foundation
import SPRingboard


/*  Creates an ArrayObjectDataSource containing the type of objects passed in
 *  and wraps it in a FutureResult
 */
public func createArrayObjectDataSource<T>(withScreenModels models: [T]) -> FutureResult<ObjectDataSource<T>> {
    let deferred = DeferredResult<ObjectDataSource<T>>()
    let dataSource = ArrayObjectDataSource(objects: models)
    deferred.success(value: dataSource)
    return deferred
}
