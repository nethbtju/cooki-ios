//
//  JoinRequest.swift
//  Cooki
//
//  Created by Rohit Valanki on 13/1/2026.
//


import Foundation

struct JoinRequest: Identifiable, Equatable {
    enum Status: String {
        case pending
        case approved
        case rejected
    }

    let id: UUID
    let requestingUserId: String
    let requestingUserName: String
    let requestingUserEmail: String?
    let status: Status
    let createdAt: Date
    var respondedAt: Date? = nil
    var respondedBy: String? = nil

    var isPending: Bool { status == .pending }
}
