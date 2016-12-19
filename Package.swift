//
//  Package.swift
//  RedisSwift
//
//  Created by Michael A. Trimm on 12/19/16.
//
//

import PackageDescription

let package = Package(
    name: "RedisSwift",
    targets: [],
    dependencies: [
        .Package(
            url: "https://github.com/matejukmar/Perfect-CURL.git",
            majorVersion: 2,
            minor: 0
        ),
    ],
    exclude: []
)
