//
//  FocusEntity+Colored.swift
//  FocusEntity
//
//  Created by Max Cobb on 8/26/19.
//  Copyright © 2019 Max Cobb. All rights reserved.
//

import RealityKit

/// An extension of FocusEntity holding the methods for the "colored" style.
@available(iOS 13.0, *)
public extension FocusEntity {

    internal func coloredStateChanged() {
        guard let coloredStyle = self.focus.coloredStyle else {
            return
        }
        var endColor: MaterialColorParameter
        switch state {
        case .initializing:
          endColor = coloredStyle.nonTrackingColor
        case .tracking(raycastResult: let raycastResult, camera: _):
          endColor = self.onPlane && raycastResult.targetAlignment == allowedAllignments.rayCastAlignment() ? coloredStyle.onColor : coloredStyle.offColor
        }

        if self.fillPlane?.model?.materials.count == 0 {
            self.fillPlane?.model?.materials = [SimpleMaterial()]
        }
        var modelMaterial = UnlitMaterial(color: .clear)
        if #available(iOS 15, *) {
            switch endColor {
            case .color(let uikitColour):
                modelMaterial.color = .init(tint: uikitColour, texture: nil)
            case .texture(let tex):
                modelMaterial.color = .init(tint: .white.withAlphaComponent(0.9999), texture: .init(tex))
            @unknown default: break
            }
        } else {
            modelMaterial.baseColor = endColor
            // Necessary for transparency.
            modelMaterial.tintColor = Material.Color.white.withAlphaComponent(0.995)
        }
        self.fillPlane?.model?.materials[0] = modelMaterial
    }
}
