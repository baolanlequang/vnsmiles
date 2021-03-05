//
//  Atom.swift
//  VNSmiles
//
//  Created by Bao Lan Le Quang on 05/03/2021.
//

import Foundation

/**
 * A class representing an atom.
 *
 * @property {String} element The element symbol of this atom. Single-letter symbols are always uppercase. Examples: H, C, F, Br, Si, ...
 * @property {Boolean} drawExplicit A boolean indicating whether or not this atom is drawn explicitly (for example, a carbon atom). This overrides the default behaviour.
 * @property {Object[]} ringbonds An array containing the ringbond ids and bond types as specified in the original SMILE.
 * @property {String} branchBond The branch bond as defined in the SMILES.
 * @property {Number} ringbonds[].id The ringbond id as defined in the SMILES.
 * @property {String} ringbonds[].bondType The bond type of the ringbond as defined in the SMILES.
 * @property {Number[]} rings The ids of rings which contain this atom.
 * @property {String} bondType The bond type associated with this array. Examples: -, =, #, ...
 * @property {Boolean} isBridge A boolean indicating whether or not this atom is part of a bridge in a bridged ring (contained by the largest ring).
 * @property {Boolean} isBridgeNode A boolean indicating whether or not this atom is a bridge node (a member of the largest ring in a bridged ring which is connected to a bridge-atom).
 * @property {Number[]} originalRings Used to back up rings when they are replaced by a bridged ring.
 * @property {Number} bridgedRing The id of the bridged ring if the atom is part of a bridged ring.
 * @property {Number[]} anchoredRings The ids of the rings that are anchored to this atom. The centers of anchored rings are translated when this atom is translated.
 * @property {Object} bracket If this atom is defined as a bracket atom in the original SMILES, this object contains all the bracket information. Example: { hcount: {Number}, charge: ['--', '-', '+', '++'], isotope: {Number} }.
 * @property {Number} plane Specifies on which "plane" the atoms is in stereochemical deptictions (-1 back, 0 middle, 1 front).
 * @property {Object[]} attachedPseudoElements A map with containing information for pseudo elements or concatinated elements. The key is comprised of the element symbol and the hydrogen count.
 * @property {String} attachedPseudoElement[].element The element symbol.
 * @property {Number} attachedPseudoElement[].count The number of occurences that match the key.
 * @property {Number} attachedPseudoElement[].hyrogenCount The number of hydrogens attached to each atom matching the key.
 * @property {Boolean} hasAttachedPseudoElements A boolean indicating whether or not this attom will be drawn with an attached pseudo element or concatinated elements.
 * @property {Boolean} isDrawn A boolean indicating whether or not this atom is drawn. In contrast to drawExplicit, the bond is drawn neither.
 * @property {Boolean} isConnectedToRing A boolean indicating whether or not this atom is directly connected (but not a member of) a ring.
 * @property {String[]} neighbouringElements An array containing the element symbols of neighbouring atoms.
 * @property {Boolean} isPartOfAromaticRing A boolean indicating whether or not this atom is part of an explicitly defined aromatic ring. Example: c1ccccc1.
 * @property {Number} bondCount The number of bonds in which this atom is participating.
 * @property {String} chirality The chirality of this atom if it is a stereocenter (R or S).
 * @property {Number} priority The priority of this atom acording to the CIP rules, where 0 is the highest priority.
 * @property {Boolean} mainChain A boolean indicating whether or not this atom is part of the main chain (used for chirality).
 * @property {String} hydrogenDirection The direction of the hydrogen, either up or down. Only for stereocenters with and explicit hydrogen.
 * @property {Number} subtreeDepth The depth of the subtree coming from a stereocenter.
 */
class Atom {
    
    private var element: String
    private var drawExplicit: Bool
    private var ringbonds: [Any]
    private var rings: [NSNumber]
    private var bondType: String
    private var branchBond: String?
    private var isBridge: Bool
    private var isBridgeNode: Bool
    private var originalRings: [NSNumber]
    private var bridgedRing: NSNumber?
    private var anchoredRings: [NSNumber]
    private var bracket: Any?
    private var plane: Int
    private var attachedPseudoElements: [String: [String: Any]]
    private var hasAttachedPseudoElements: Bool
    private var isDrawn: Bool
    private var isConnectedToRing: Bool
    private var neighbouringElements: [String]
    private var isPartOfAromaticRing: Bool
    private var bondCount: NSNumber
    private var chirality: String
    private var isStereoCenter: Bool
    private var priority: NSNumber
    private var mainChain: Bool
    private var hydrogenDirection: String
    private var subtreeDepth: NSNumber
    private var hasHydrogen: Bool
    
    /**
       * The constructor of the class Atom.
       *
       * @param {String} element The one-letter code of the element.
       * @param {String} [bondType='-'] The type of the bond associated with this atom.
       */
    init(element: String, bondType: String = "-") {
        self.element = element.count == 1 ? element.uppercased() : element
        self.drawExplicit = false
        self.ringbonds = []
        self.rings = []
        self.bondType = bondType
        self.branchBond = nil
        self.isBridge = false
        self.isBridgeNode = false
        self.originalRings = []
        self.bridgedRing = nil
        self.anchoredRings = []
        self.bracket = nil
        self.plane = 0
        self.attachedPseudoElements = [:]
        self.hasAttachedPseudoElements = false
        self.isDrawn = true
        self.isConnectedToRing = false
        self.neighbouringElements = []
        self.isPartOfAromaticRing = element != self.element
        self.bondCount = 0
        self.chirality = ""
        self.isStereoCenter = false
        self.priority = 0
        self.mainChain = false
        self.hydrogenDirection = "down"
        self.subtreeDepth = 1
        self.hasHydrogen = false
    }
    
    /**
       * Adds a neighbouring element to this atom.
       *
       * @param {String} element A string representing an element.
       */
    func addNeighbouringElement(element: String) {
        self.neighbouringElements.append(element)
    }
    
    /**
       * Attaches a pseudo element (e.g. Ac) to the atom.
       * @param {String} element The element identifier (e.g. Br, C, ...).
       * @param {String} previousElement The element that is part of the main chain (not the terminals that are converted to the pseudo element or concatinated).
       * @param {Number} [hydrogenCount=0] The number of hydrogens for the element.
       * @param {Number} [charge=0] The charge for the element.
       */
    func attachPseudoElement(element: String, previousElement: String, hydrogenCount: Int = 0, charge: Int = 0) {
        
        let key = "\(hydrogenCount)\(element)\(charge)"
        
        if var pseudoElements = self.attachedPseudoElements[key] {
            var count = pseudoElements["count"] as? Int ?? 1
            count += 1
            pseudoElements["count"] = count
        }
        else {
            let pseudoElements: [String: Any] = ["element": element, "count": 1, "hydrogenCount": hydrogenCount, "previousElement": previousElement, "charge": charge]
            self.attachedPseudoElements[key] = pseudoElements
        }
        
        self.hasAttachedPseudoElements = true
    }
    
    /**
       * Returns the attached pseudo elements sorted by hydrogen count (ascending).
       *
       * @returns {Object} The sorted attached pseudo elements.
       */
    func getAttachedPseudoElements() -> [String: [String: Any]] {
        var ordered: [String: [String: Any]] = [:]
        let orderedKey = self.attachedPseudoElements.keys.sorted()
        for key in orderedKey {
            ordered[key] = self.attachedPseudoElements[key]
        }
        return ordered
    }
    
    /**
       * Returns the number of attached pseudo elements.
       *
       * @returns {Number} The number of attached pseudo elements.
       */
    func getAttachedPseudoElementsCount() -> Int {
        return self.attachedPseudoElements.count
    }
    
    /**
       * Returns whether this atom is a heteroatom (not C and not H).
       *
       * @returns {Boolean} A boolean indicating whether this atom is a heteroatom.
       */
    func isHeteroAtom() -> Bool {
        return self.element != "C" && self.element != "H"
    }
    
    /**
       * Defines this atom as the anchor for a ring. When doing repositionings of the vertices and the vertex associated with this atom is moved, the center of this ring is moved as well.
       *
       * @param {Number} ringId A ring id.
       */
    func addAnchoredRing(ringId: NSNumber) {
        if (!self.anchoredRings.contains(ringId)) {
            self.anchoredRings.append(ringId)
        }
    }
}
