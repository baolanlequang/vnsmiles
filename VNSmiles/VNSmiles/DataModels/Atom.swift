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
    private var ringbonds: [[NSNumber:String]]
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
    
    /**
       * Returns the number of ringbonds (breaks in rings to generate the MST of the smiles) within this atom is connected to.
       *
       * @returns {Number} The number of ringbonds this atom is connected to.
       */
    func getRingbondCount() -> Int {
        return self.ringbonds.count
    }
    
    /**
       * Backs up the current rings.
       */
    func backupRings() {
        self.originalRings = []
        for ring in self.rings {
            self.originalRings.append(ring)
        }
    }
    
    /**
       * Restores the most recent backed up rings.
       */
    func restoreRings() {
        self.rings = []
        for ring in self.originalRings {
            self.rings.append(ring)
        }
    }
    
    /**
       * Checks whether or not two atoms share a common ringbond id. A ringbond is a break in a ring created when generating the spanning tree of a structure.
       *
       * @param {Atom} atomA An atom.
       * @param {Atom} atomB An atom.
       * @returns {Boolean} A boolean indicating whether or not two atoms share a common ringbond.
       */
    func haveCommonRingbond(atomA: Atom, atomB: Atom) -> Bool {
        for ringA in atomA.ringbonds {
            for ringB in atomB.ringbonds {
                if (ringA.keys.first == ringB.keys.first) {
                    return true
                }
            }
        }
        return false
    }
    
    /**
       * Check whether or not the neighbouring elements of this atom equal the supplied array.
       *
       * @param {String[]} arr An array containing all the elements that are neighbouring this atom. E.g. ['C', 'O', 'O', 'N']
       * @returns {Boolean} A boolean indicating whether or not the neighbours match the supplied array of elements.
       */
    func neighbouringElementsEqual(arr: [String]) -> Bool {
        if (arr.count != self.neighbouringElements.count) {
            return false
        }
        
        var tmpArr = arr
        tmpArr = tmpArr.sorted()
        self.neighbouringElements = self.neighbouringElements.sorted()
        
        for (index, element) in self.neighbouringElements.enumerated() {
            if (tmpArr[index] != element) {
                return false
            }
        }
        return true
    }
    
    /**
       * Get the atomic number of this atom.
       *
       * @returns {Number} The atomic number of this atom.
       */
    func getAtomicNumber() -> Int {
        return Atom.atomicNumbers[self.element] ?? 1
    }
    
    /**
       * Get the maximum number of bonds for this atom.
       *
       * @returns {Number} The maximum number of bonds of this atom.
       */
    func getMaxBonds() -> Int {
        return Atom.maxBonds[self.element] ?? 1
    }
    
    static let maxBonds = [
        "H": 1,
        "C": 4,
        "N": 3,
        "O": 2,
        "P": 3,
        "S": 2,
        "B": 3,
        "F": 1,
        "I": 1,
        "Cl": 1,
        "Br": 1
    ]
    
    static let atomicNumbers = [
        "H": 1,
        "He": 2,
        "Li": 3,
        "Be": 4,
        "B": 5,
        "b": 5,
        "C": 6,
        "c": 6,
        "N": 7,
        "n": 7,
        "O": 8,
        "o": 8,
        "F": 9,
        "Ne": 10,
        "Na": 11,
        "Mg": 12,
        "Al": 13,
        "Si": 14,
        "P": 15,
        "p": 15,
        "S": 16,
        "s": 16,
        "Cl": 17,
        "Ar": 18,
        "K": 19,
        "Ca": 20,
        "Sc": 21,
        "Ti": 22,
        "V": 23,
        "Cr": 24,
        "Mn": 25,
        "Fe": 26,
        "Co": 27,
        "Ni": 28,
        "Cu": 29,
        "Zn": 30,
        "Ga": 31,
        "Ge": 32,
        "As": 33,
        "Se": 34,
        "Br": 35,
        "Kr": 36,
        "Rb": 37,
        "Sr": 38,
        "Y": 39,
        "Zr": 40,
        "Nb": 41,
        "Mo": 42,
        "Tc": 43,
        "Ru": 44,
        "Rh": 45,
        "Pd": 46,
        "Ag": 47,
        "Cd": 48,
        "In": 49,
        "Sn": 50,
        "Sb": 51,
        "Te": 52,
        "I": 53,
        "Xe": 54,
        "Cs": 55,
        "Ba": 56,
        "La": 57,
        "Ce": 58,
        "Pr": 59,
        "Nd": 60,
        "Pm": 61,
        "Sm": 62,
        "Eu": 63,
        "Gd": 64,
        "Tb": 65,
        "Dy": 66,
        "Ho": 67,
        "Er": 68,
        "Tm": 69,
        "Yb": 70,
        "Lu": 71,
        "Hf": 72,
        "Ta": 73,
        "W": 74,
        "Re": 75,
        "Os": 76,
        "Ir": 77,
        "Pt": 78,
        "Au": 79,
        "Hg": 80,
        "Tl": 81,
        "Pb": 82,
        "Bi": 83,
        "Po": 84,
        "At": 85,
        "Rn": 86,
        "Fr": 87,
        "Ra": 88,
        "Ac": 89,
        "Th": 90,
        "Pa": 91,
        "U": 92,
        "Np": 93,
        "Pu": 94,
        "Am": 95,
        "Cm": 96,
        "Bk": 97,
        "Cf": 98,
        "Es": 99,
        "Fm": 100,
        "Md": 101,
        "No": 102,
        "Lr": 103,
        "Rf": 104,
        "Db": 105,
        "Sg": 106,
        "Bh": 107,
        "Hs": 108,
        "Mt": 109,
        "Ds": 110,
        "Rg": 111,
        "Cn": 112,
        "Uut": 113,
        "Uuq": 114,
        "Uup": 115,
        "Uuh": 116,
        "Uus": 117,
        "Uuo": 118
    ]
    
    static let mass = [
        "H": 1,
        "He": 2,
        "Li": 3,
        "Be": 4,
        "B": 5,
        "b": 5,
        "C": 6,
        "c": 6,
        "N": 7,
        "n": 7,
        "O": 8,
        "o": 8,
        "F": 9,
        "Ne": 10,
        "Na": 11,
        "Mg": 12,
        "Al": 13,
        "Si": 14,
        "P": 15,
        "p": 15,
        "S": 16,
        "s": 16,
        "Cl": 17,
        "Ar": 18,
        "K": 19,
        "Ca": 20,
        "Sc": 21,
        "Ti": 22,
        "V": 23,
        "Cr": 24,
        "Mn": 25,
        "Fe": 26,
        "Co": 27,
        "Ni": 28,
        "Cu": 29,
        "Zn": 30,
        "Ga": 31,
        "Ge": 32,
        "As": 33,
        "Se": 34,
        "Br": 35,
        "Kr": 36,
        "Rb": 37,
        "Sr": 38,
        "Y": 39,
        "Zr": 40,
        "Nb": 41,
        "Mo": 42,
        "Tc": 43,
        "Ru": 44,
        "Rh": 45,
        "Pd": 46,
        "Ag": 47,
        "Cd": 48,
        "In": 49,
        "Sn": 50,
        "Sb": 51,
        "Te": 52,
        "I": 53,
        "Xe": 54,
        "Cs": 55,
        "Ba": 56,
        "La": 57,
        "Ce": 58,
        "Pr": 59,
        "Nd": 60,
        "Pm": 61,
        "Sm": 62,
        "Eu": 63,
        "Gd": 64,
        "Tb": 65,
        "Dy": 66,
        "Ho": 67,
        "Er": 68,
        "Tm": 69,
        "Yb": 70,
        "Lu": 71,
        "Hf": 72,
        "Ta": 73,
        "W": 74,
        "Re": 75,
        "Os": 76,
        "Ir": 77,
        "Pt": 78,
        "Au": 79,
        "Hg": 80,
        "Tl": 81,
        "Pb": 82,
        "Bi": 83,
        "Po": 84,
        "At": 85,
        "Rn": 86,
        "Fr": 87,
        "Ra": 88,
        "Ac": 89,
        "Th": 90,
        "Pa": 91,
        "U": 92,
        "Np": 93,
        "Pu": 94,
        "Am": 95,
        "Cm": 96,
        "Bk": 97,
        "Cf": 98,
        "Es": 99,
        "Fm": 100,
        "Md": 101,
        "No": 102,
        "Lr": 103,
        "Rf": 104,
        "Db": 105,
        "Sg": 106,
        "Bh": 107,
        "Hs": 108,
        "Mt": 109,
        "Ds": 110,
        "Rg": 111,
        "Cn": 112,
        "Uut": 113,
        "Uuq": 114,
        "Uup": 115,
        "Uuh": 116,
        "Uus": 117,
        "Uuo": 118
    ]
}
