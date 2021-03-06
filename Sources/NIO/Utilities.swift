//===----------------------------------------------------------------------===//
//
// This source file is part of the SwiftNIO open source project
//
// Copyright (c) 2017-2018 Apple Inc. and the SwiftNIO project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of SwiftNIO project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

#if os(Linux)
import func CNIOLinux.get_nprocs

private func linuxCoreCount() -> Int {
    return Int(get_nprocs())
}
#elseif os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
private func darwinCoreCount() -> Int {
    var cores: CInt = 0
    var coresLen: size_t = MemoryLayout.size(ofValue: cores)
    let rc = sysctlbyname("hw.logicalcpu", &cores, &coresLen, nil, 0)
    precondition(rc == 0)
    return Int(cores)
}
#endif

/// Allows to "box" another value.
final class Box<T> {
    let value: T
    init(_ value: T) { self.value = value }
}

public enum System {
    /// A utility function that returns an estimate of the number of *logical* cores
    /// on the system.
    ///
    /// This value can be used to help provide an estimate of how many threads to use with
    /// the `MultiThreadedEventLoopGroup`. The exact ratio between this number and the number
    /// of threads to use is a matter for the programmer, and can be determined based on the
    /// specific execution behaviour of the program.
    ///
    /// - returns: The logical core count on the system.
    public static var coreCount: Int {
        #if os(Linux)
        return linuxCoreCount()
        #elseif os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
        return darwinCoreCount()
        #endif
    }
}
