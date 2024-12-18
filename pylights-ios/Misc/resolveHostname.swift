//
//  resolveHostname.swift
//  pylights-ios
//
//  Created by Braden Guliano on 12/15/24.
//

import Foundation

func resolveHostname(_ hostname: String, completion: @escaping (String?) -> Void) {
    DispatchQueue.global(qos: .default).async {
        var hints = addrinfo(
            ai_flags: AI_CANONNAME,  // Canonical name lookup
            ai_family: AF_INET,      // Only IPv4
            ai_socktype: SOCK_STREAM,
            ai_protocol: 0,
            ai_addrlen: 0,
            ai_canonname: nil,
            ai_addr: nil,
            ai_next: nil
        )
        
        var result: UnsafeMutablePointer<addrinfo>?
        
        let status = getaddrinfo(hostname, nil, &hints, &result)
        guard status == 0 else {
            print("Error in getaddrinfo: \(String(cString: gai_strerror(status)))")
            completion(nil)
            return
        }
        
        defer { freeaddrinfo(result) }
        
        var resolvedIP: String?
        
        var currentResult = result
        while currentResult != nil {
            if let addr = currentResult?.pointee.ai_addr {
                let family = addr.pointee.sa_family
                if family == sa_family_t(AF_INET) { // IPv4
                    addr.withMemoryRebound(to: sockaddr_in.self, capacity: 1) { addr4Pointer in
                        var ipBuffer = [CChar](repeating: 0, count: Int(INET_ADDRSTRLEN))
                        inet_ntop(AF_INET, &addr4Pointer.pointee.sin_addr, &ipBuffer, socklen_t(INET_ADDRSTRLEN))
                        resolvedIP = String(cString: ipBuffer)
                    }
                    break
                }
            }
            currentResult = currentResult?.pointee.ai_next
        }
        
        completion(resolvedIP)
    }
}
