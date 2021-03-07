//
//  Edge.swift
//  VNSmiles
//
//  Created by Bao Lan Le Quang on 07/03/2021.
//

import Foundation

/**
 * A class representing an edge.
 *
 * @property {Number} id The id of this edge.
 * @property {Number} sourceId The id of the source vertex.
 * @property {Number} targetId The id of the target vertex.
 * @property {Number} weight The weight of this edge. That is, the degree of the bond (single bond = 1, double bond = 2, etc).
 * @property {String} [bondType='-'] The bond type of this edge.
 * @property {Boolean} [isPartOfAromaticRing=false] Whether or not this edge is part of an aromatic ring.
 * @property {Boolean} [center=false] Wheter or not the bond is centered. For example, this affects straight double bonds.
 * @property {String} [wedge=''] Wedge direction. Either '', 'up' or 'down'
 */
class Edge {
    /**
         * The constructor for the class Edge.
         *
         * @param {Number} sourceId A vertex id.
         * @param {Number} targetId A vertex id.
         * @param {Number} [weight=1] The weight of the edge.
         */
    var id: NSNumber?
    var sourceId: NSNumber
    var targetId: NSNumber
    var weight: NSNumber
    var bondType: String
    var isPartOfAromaticRing: Bool
    var center: Bool
    var wedge: String
    
    init(sourceId: NSNumber, targetId: NSNumber, weight: NSNumber = 1) {
        self.id = nil
        self.sourceId = sourceId
        self.targetId = targetId
        self.weight = weight
        self.bondType = "-"
        self.isPartOfAromaticRing = false
        self.center = false
        self.wedge = ""
    }
    
    /**
         * Set the bond type of this edge. This also sets the edge weight.
         * @param {String} bondType
         */
    func setBondType(bondType: String) {
        self.bondType = bondType
        self.weight = Edge.bonds[bondType] as NSNumber? ?? 1
    }

    /**
         * An object mapping the bond type to the number of bonds.
         *
         * @returns {Object} The object containing the map.
         */
    static let bonds = [
        "-": 1,
        "/": 1,
        "\\": 1,
        "=": 2,
        "#": 3,
        "$": 4
    ]
}
