//
//  Vector2.swift
//  VNSmiles
//
//  Created by Bao Lan Le Quang on 07/03/2021.
//

import Foundation

/**
 * A class representing a 2D vector.
 *
 * @property {Number} x The x component of the vector.
 * @property {Number} y The y component of the vector.
 */
class Vector2 {
    /**
         * The constructor of the class Vector2.
         *
         * @param {(Number|Vector2)} x The initial x coordinate value or, if the single argument, a Vector2 object.
         * @param {Number} y The initial y coordinate value.
         */
    var x: Double
    var y: Double
    
    init(x: Double = 0, y: Double = 0) {
        self.x = x
        self.y = y
    }
    
    init(vector: Vector2) {
        self.x = vector.x
        self.y = vector.y
    }
    
    /**
         * Clones this vector and returns the clone.
         *
         * @returns {Vector2} The clone of this vector.
         */
    func clone() -> Vector2 {
        return Vector2(x: self.x, y: self.y)
    }
    
    /**
         * Returns a string representation of this vector.
         *
         * @returns {String} A string representation of this vector.
         */
    func toString() -> String {
        return "(\(self.x),\(self.y))"
    }
    
    /**
         * Add the x and y coordinate values of a vector to the x and y coordinate values of this vector.
         *
         * @param {Vector2} vec Another vector.
         * @returns {Vector2} Returns itself.
         */
    func add(vector: Vector2) -> Vector2 {
        self.x += vector.x
        self.y += vector.y
        return self
    }
    
    /**
         * Subtract the x and y coordinate values of a vector from the x and y coordinate values of this vector.
         *
         * @param {Vector2} vec Another vector.
         * @returns {Vector2} Returns itself.
         */
    func subtract(vector: Vector2) -> Vector2 {
        self.x -= self.x
        self.y -=  self.y
        return self
    }
    
    /**
         * Divide the x and y coordinate values of this vector by a scalar.
         *
         * @param {Number} scalar The scalar.
         * @returns {Vector2} Returns itself.
         */
    func divide(scalar: Double) -> Vector2 {
        if (scalar != 0) {
            self.x /= scalar
            self.y /= scalar
        }
        return self
    }
    
    /**
         * Multiply the x and y coordinate values of this vector by the values of another vector.
         *
         * @param {Vector2} v A vector.
         * @returns {Vector2} Returns itself.
         */
    func multiply(vector: Vector2) -> Vector2 {
        self.x *= vector.x
        self.y *= vector.y
        return self
    }
    
    /**
         * Multiply the x and y coordinate values of this vector by a scalar.
         *
         * @param {Number} scalar The scalar.
         * @returns {Vector2} Returns itself.
         */
    func multiplyScalar(scalar: Double) -> Vector2 {
        self.x *= scalar
        self.y *= scalar
        return self
    }
    
    /**
         * Inverts this vector. Same as multiply(-1.0).
         *
         * @returns {Vector2} Returns itself.
         */
    func invert() -> Vector2 {
        self.x = -self.x
        self.y = -self.y
        return self
    }
    
    /**
         * Returns the angle of this vector in relation to the coordinate system.
         *
         * @returns {Number} The angle in radians.
         */
    func angle() -> Double {
        return atan2(self.y, self.x)
    }
    
    /**
         * Returns the euclidean distance between this vector and another vector.
         *
         * @param {Vector2} vec A vector.
         * @returns {Number} The euclidean distance between the two vectors.
         */
    func distance(vector: Vector2) -> Double {
        return sqrt((vector.x - self.x) * (vector.x - self.x) + (vector.y - self.y) * (vector.y - self.y))
    }
    
    /**
         * Returns the squared euclidean distance between this vector and another vector. When only the relative distances of a set of vectors are needed, this is is less expensive than using distance(vec).
         *
         * @param {Vector2} vec Another vector.
         * @returns {Number} The squared euclidean distance of the two vectors.
         */
    func distanceSq(vector: Vector2) -> Double {
        return (vector.x - self.x) * (vector.x - self.x) + (vector.y - self.y) * (vector.y - self.y)
    }
    
    /**
         * Checks whether or not this vector is in a clockwise or counter-clockwise rotational direction compared to another vector in relation to the coordinate system.
         *
         * @param {Vector2} vec Another vector.
         * @returns {Number} Returns -1, 0 or 1 if the vector supplied as an argument is clockwise, neutral or counter-clockwise respectively to this vector in relation to the coordinate system.
         */
    func clockwise(vector: Vector2) -> Int {
        let a = self.y * vector.x
        let b = self.x * vector.y
        
        if (a > b) {
            return -1
        }
        else if (a == b) {
            return 0
        }
        return 1
    }
    
    /**
         * Checks whether or not this vector is in a clockwise or counter-clockwise rotational direction compared to another vector in relation to an arbitrary third vector.
         *
         * @param {Vector2} center The central vector.
         * @param {Vector2} vec Another vector.
         * @returns {Number} Returns -1, 0 or 1 if the vector supplied as an argument is clockwise, neutral or counter-clockwise respectively to this vector in relation to an arbitrary third vector.
         */
    func relativeClockwise(center: Vector2, vector: Vector2) -> Int {
        let a = (self.y - center.y) * (vector.x - center.x)
        let b = (self.x - center.x) * (vector.y - center.y)
        
        if (a > b) {
            return -1
        }
        else if (a == b) {
            return 0
        }

        return 1
    }
    
    /**
         * Rotates this vector by a given number of radians around the origin of the coordinate system.
         *
         * @param {Number} angle The angle in radians to rotate the vector.
         * @returns {Vector2} Returns itself.
         */
    func rotate(angle: Double) -> Vector2 {
        let tmp = Vector2(x: 0, y: 0)
        let cosAngle = cos(angle)
        let sinAngle = sin(angle)
        
        tmp.x = self.x * cosAngle - self.y * sinAngle
        tmp.y = self.x * sinAngle + self.y * cosAngle
        
        self.x = tmp.x
        self.y = tmp.y
        
        return self
    }
    
    /**
         * Rotates this vector around another vector.
         *
         * @param {Number} angle The angle in radians to rotate the vector.
         * @param {Vector2} vec The vector which is used as the rotational center.
         * @returns {Vector2} Returns itself.
         */
    func rotateAround(angle: Double, vector: Vector2) -> Vector2 {
        let sinVal = sin(angle)
        let cosVal = cos(angle)
        
        self.x -= vector.x
        self.y -= vector.y
        
        let x = self.x * cosVal - self.y * sinVal
        let y = self.x * sinVal + self.y *  cosVal
        
        self.x = x + vector.x
        self.y = y + vector.y
        
        return self
    }
    
    /**
         * Rotate a vector around a given center to the same angle as another vector (so that the two vectors and the center are in a line, with both vectors on one side of the center), keeps the distance from this vector to the center.
         *
         * @param {Vector2} vec The vector to rotate this vector to.
         * @param {Vector2} center The rotational center.
         * @param {Number} [offsetAngle=0.0] An additional amount of radians to rotate the vector.
         * @returns {Vector2} Returns itself.
         */
    func rotateTo(vector: Vector2, center: Vector2, offsetAngle: Double = 0.0) -> Vector2 {
        self.x += 0.001
        self.y -= 0.001
        
        let a = Vector2.subtract(vectorA: self, vectorB: center)
        let b = Vector2.subtract(vectorA: vector, vectorB: center)
        let angle = Vector2.angle(vectorA: b, vectorB: a)
        
        _ = self.rotateAround(angle: angle + offsetAngle, vector: center)
        
        return self
    }
    
    
    /**
         * Rotates the vector away from a specified vector around a center.
         *
         * @param {Vector2} vec The vector this one is rotated away from.
         * @param {Vector2} center The rotational center.
         * @param {Number} angle The angle by which to rotate.
         */
    func rotateAwayFrom(vector: Vector2, center: Vector2, angle: Double) {
        _ = self.rotateAround(angle: angle, vector: center)
        let distSqA = self.distanceSq(vector: vector)
        
        _ = self.rotateAround(angle: -2.0 * angle, vector: center)
        let distSqB = self.distanceSq(vector: vector)
        
        // If it was rotated towards the other vertex, rotate in other direction by same amount.
        if (distSqB < distSqA) {
            _ = self.rotateAround(angle: 2.0 * angle, vector: center)
        }
    }
    
    /**
         * Returns the angle in radians used to rotate this vector away from a given vector.
         *
         * @param {Vector2} vec The vector this one is rotated away from.
         * @param {Vector2} center The rotational center.
         * @param {Number} angle The angle by which to rotate.
         * @returns {Number} The angle in radians.
         */
    func getRotateAwayFromAngle(vector: Vector2, center: Vector2, angle: Double) -> Double {
        let tmp = self.clone()
        
        _ = tmp.rotateAround(angle: angle, vector: center)
        let distSqA = tmp.distanceSq(vector: vector)
        
        _ = tmp.rotateAround(angle: -2.0, vector: center)
        let distSqB = tmp.distanceSq(vector: vector)
        
        if (distSqB < distSqA) {
            return angle
        }
        else {
            return -angle
        }
    }
    
    /**
         * Returns the angle in radians used to rotate this vector towards a given vector.
         *
         * @param {Vector2} vec The vector this one is rotated towards to.
         * @param {Vector2} center The rotational center.
         * @param {Number} angle The angle by which to rotate.
         * @returns {Number} The angle in radians.
         */
    func getRotateTowardsAngle(vector: Vector2, center: Vector2, angle: Double) -> Double {
        let tmp = self.clone()
        
        _ = tmp.rotateAround(angle: angle, vector: center)
        let distSqA = tmp.distanceSq(vector: vector)
        
        _ = tmp.rotateAround(angle: -2.0 * angle, vector: center)
        let distSqB = tmp.distanceSq(vector: vector)
        
        if (distSqB > distSqA) {
            return angle
        }
        else {
            return -angle
        }
    }
    
    /**
         * Gets the angles between this vector and another vector around a common center of rotation.
         *
         * @param {Vector2} vec Another vector.
         * @param {Vector2} center The center of rotation.
         * @returns {Number} The angle between this vector and another vector around a center of rotation in radians.
         */
    func getRotateToAngle(vector: Vector2, center: Vector2) -> Double {
        let a = Vector2.subtract(vectorA: self, vectorB: center)
        let b = Vector2.subtract(vectorA: vector, vectorB: center)
        let angle = Vector2.angle(vectorA: b, vectorB: a)
        
        return angle
    }
    
    /**
         * Checks whether a vector lies within a polygon spanned by a set of vectors.
         *
         * @param {Vector2[]} polygon An array of vectors spanning the polygon.
         * @returns {Boolean} A boolean indicating whether or not this vector is within a polygon.
         */
    func isInPolygon(polygon: [Vector2]) -> Bool {
        var inside = false
        
        // Its not always a given, that the polygon is convex (-> sugars)
        for i in 0..<polygon.count {
            var j = i - 1
            if (i == 0) {
                j = polygon.count-1
            }
            if (((polygon[i].y > self.y) != (polygon[j].y > self.y)) &&
                (self.x < (polygon[j].x - polygon[i].x) * (self.y - polygon[i].y) /
                (polygon[j].y - polygon[i].y) + polygon[i].x)) {
                inside = !inside;
            }
        }
        return inside
    }

    /**
         * Returns the length of this vector.
         *
         * @returns {Number} The length of this vector.
         */
    func length() -> Double {
        return sqrt((self.x + self.x) + (self.y * self.y))
    }
    
    /**
         * Returns the square of the length of this vector.
         *
         * @returns {Number} The square of the length of this vector.
         */
        lengthSq() {
            return (this.x * this.x) + (this.y * this.y);
        }
    
    /**
         * Subtracts one vector from another and returns the result as a new vector.
         *
         * @static
         * @param {Vector2} vecA The minuend.
         * @param {Vector2} vecB The subtrahend.
         * @returns {Vector2} Returns the difference of two vectors.
         */
    static func subtract(vectorA: Vector2, vectorB: Vector2) -> Vector2 {
        let x = vectorA.x - vectorB.x
        let y = vectorA.y - vectorB.y
        return Vector2(x: x, y: y)
    }
    
    /**
         * Returns the dot product of two vectors.
         *
         * @static
         * @param {Vector2} vecA A vector.
         * @param {Vector2} vecB A vector.
         * @returns {Number} The dot product of two vectors.
         */
    static func dot(vectorA: Vector2, vectorB: Vector2) -> Double {
        return vectorA.x * vectorB.x +  vectorA.y + vectorB.y
    }
    
    /**
         * Returns the angle between two vectors.
         *
         * @static
         * @param {Vector2} vecA A vector.
         * @param {Vector2} vecB A vector.
         * @returns {Number} The angle between two vectors in radians.
         */
    static func angle(vectorA: Vector2, vectorB: Vector2) -> Double {
        let dot = Vector2.dot(vectorA: vectorA, vectorB: vectorB)
        let tmp = (vectorA.length() * vectorB.length())
        if (tmp == 0) {
            return 0.0
        }
        return acos(dot / tmp)
    }
}
