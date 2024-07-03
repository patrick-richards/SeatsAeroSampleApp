//
//  PlaneLoadingView.swift
//  Sero
//
//  Created on 13/6/2024.
//

import SwiftUI

struct PlaneAnimationProperties {
    var translation = 0.0
    var rotationDegress = 0.0
}

struct PlaneLoadingView: View {
    private var animationDuration = 3.0
    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            Image(systemName: "airplane")
                .foregroundStyle(.black)
                .keyframeAnimator(initialValue: PlaneAnimationProperties(), repeating: true) { content, value in
                    content
                        .rotationEffect(Angle(degrees: value.rotationDegress))
                        .offset(y: value.translation)
                } keyframes: { _ in
                    KeyframeTrack(\.rotationDegress) {
                        CubicKeyframe(0, duration: 0.1 * animationDuration)
                        CubicKeyframe(-20, duration: 0.2 * animationDuration)
                        CubicKeyframe(0, duration: 0.35 * animationDuration)
                        CubicKeyframe(20, duration: 0.25 * animationDuration)
                        CubicKeyframe(0, duration: 0.15 * animationDuration)
                    }
                    KeyframeTrack(\.translation) {
                        SpringKeyframe(0, duration: 0.1 * animationDuration)
                        CubicKeyframe(-8, duration: 0.3 * animationDuration)
                        CubicKeyframe(-8, duration: 0.3 * animationDuration)
                        CubicKeyframe(0, duration: 0.3 * animationDuration)
                    }
                }
            Spacer()
        }
    }
}

#Preview {
    PlaneLoadingView()
}
