//
//  resolveHostname.swift
//  pylights-ios
//
//  Created by Braden Guliano on 12/15/24.
//

import Foundation

func resolveHostname(_ hostname: String, completion: @escaping (String?) -> Void) {
    DispatchQueue.global(qos: .utility).async {
        var hints = addrinfo(
            ai_flags: AI_PASSIVE,
            ai_family: AF_UNSPEC,       // Allow both IPv4 and IPv6
            ai_socktype: SOCK_STREAM,   // TCP stream sockets
            ai_protocol: 0,
            ai_addrlen: 0,
            ai_canonname: nil,
            ai_addr: nil,
            ai_next: nil
        )
        
        var infoPointer: UnsafeMutablePointer<addrinfo>?

        let status = getaddrinfo(hostname, nil, &hints, &infoPointer)
        guard status == 0, let info = infoPointer else {
            if let errorString = gai_strerror(status) {
                print("Error: \(String(cString: errorString))")
            } else {
                print("Unknown error occurred.")
            }
            DispatchQueue.main.async {
                completion(nil)
            }
            return
        }
        
        defer { freeaddrinfo(info) }
        
        if let addr = info.pointee.ai_addr {
            var hostnameBuffer = [CChar](repeating: 0, count: Int(NI_MAXHOST))
            if getnameinfo(addr, socklen_t(info.pointee.ai_addrlen), &hostnameBuffer, socklen_t(hostnameBuffer.count), nil, 0, NI_NUMERICHOST) == 0 {
                let ipAddress = String(cString: hostnameBuffer)
                DispatchQueue.main.async {
                    completion(ipAddress)
                }
                return
            } else {
                print("Failed to convert address to string.")
            }
        }
        
        DispatchQueue.main.async {
            completion(nil)
        }
    }
}
