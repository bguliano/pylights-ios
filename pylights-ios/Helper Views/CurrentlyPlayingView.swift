//
//  CurrentlyPlayingView.swift
//  pylights-ios
//
//  Created by Braden Guliano on 12/13/24.
//

import SwiftUI

struct CurrentlyPlayingView: View {
    @ObservedObject var pylightsViewModel: PylightsViewModel
    @Binding var isShowingVolume: Bool

    private var pillShape: some InsettableShape {
        Capsule(style: .continuous)
    }

    var body: some View {
        VStack(spacing: 8) {
            pillCard

            if isShowingVolume {
                volumeSlider
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.28, dampingFraction: 0.88), value: isShowingVolume)
    }

    private var pillCard: some View {
        Group {
            if #available(iOS 26.0, *) {
                GlassEffectContainer {
                    pillContent
                        .glassEffect(.regular, in: pillShape)
                }
            } else {
                pillContent
                    .background(.ultraThinMaterial, in: pillShape)
            }
        }
        .overlay {
            pillShape
                .strokeBorder(.white.opacity(0.14), lineWidth: 1)
        }
        .overlay {
            pillShape
                .strokeBorder(.white.opacity(0.06), lineWidth: 1)
                .padding(1)
        }
    }

    private var volumeSlider: some View {
        Group {
            if #available(iOS 26.0, *) {
                GlassEffectContainer {
                    sliderContent
                        .glassEffect(.regular, in: pillShape)
                }
            } else {
                sliderContent
                    .background(.ultraThinMaterial, in: pillShape)
            }
        }
        .overlay {
            pillShape
                .strokeBorder(.white.opacity(0.14), lineWidth: 1)
        }
        .overlay {
            pillShape
                .strokeBorder(.white.opacity(0.06), lineWidth: 1)
                .padding(1)
        }
    }

    private var sliderContent: some View {
        HStack {
            Slider(
                value: Binding(
                    get: { Double(pylightsViewModel.volume) },
                    set: { pylightsViewModel.volume = Int($0) }
                ),
                in: 0...100,
                onEditingChanged: { isEditing in
                    if !isEditing {
                        pylightsViewModel.setVolume()
                    }
                }
            )
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .frame(height: 56)
        .contentShape(Capsule(style: .continuous))
    }

    private var pillContent: some View {
        HStack(spacing: 10) {
            AlbumArtView(albumArtBase64: pylightsViewModel.currentSong?.albumArt ?? "")
                .frame(width: 48, height: 48)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .strokeBorder(.white.opacity(0.12), lineWidth: 1)
                }
                .onTapGesture { withAnimation { isShowingVolume.toggle() } }

            VStack(alignment: .leading, spacing: 2) {
                if pylightsViewModel.currentSong != nil {
                    MarqueeText(
                        text: pylightsViewModel.currentSong?.title ?? "",
                        font: .system(size: 16, weight: .semibold),
                        isActive: true
                    )
                    .foregroundStyle(.primary)

                    Text("\(pylightsViewModel.currentMs.toMinutesAndSecondsString()) / \(pylightsViewModel.totalMS.toMinutesAndSecondsString())")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundStyle(.secondary)
                        .monospacedDigit()
                        .lineLimit(1)
                } else {
                    Spacer(minLength: 0)
                    Text("Not playing")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                    Spacer(minLength: 0)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .layoutPriority(1)
            .contentShape(Rectangle())
            .onTapGesture { withAnimation { isShowingVolume.toggle() } }

            HStack(spacing: 12) {
                AppleMusicIconButton(
                    systemName: pylightsViewModel.isPaused ? "play.fill" : "pause.fill",
                    isEnabled: pylightsViewModel.currentSong != nil
                ) {
                    if pylightsViewModel.isPaused {
                        pylightsViewModel.resumeSong()
                    } else {
                        pylightsViewModel.pauseSong()
                    }
                }

                AppleMusicIconButton(
                    systemName: "stop.fill",
                    isEnabled: pylightsViewModel.currentSong != nil
                ) {
                    pylightsViewModel.stopSong()
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .frame(height: 72)
        .contentShape(Capsule(style: .continuous))
    }
}

private struct AppleMusicIconButton: View {
    let systemName: String
    let isEnabled: Bool
    let action: () -> Void

    @State private var tapTick: Int = 0

    var body: some View {
        Button {
            tapTick &+= 1
            action()
        } label: {
            Image(systemName: systemName)
                .font(.system(size: 22, weight: .semibold))
                .frame(width: 40, height: 40)
                .contentShape(Circle())
                .modifier(SymbolBounceIfAvailable(tapTick: tapTick))
        }
        .buttonStyle(AppleMusicMiniPlayerPressStyle())
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1 : 0.35)
        .modifier(SensoryTapIfAvailable(tapTick: tapTick, isEnabled: isEnabled))
        .accessibilityLabel(Text(systemName))
    }
}

private struct AppleMusicMiniPlayerPressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background {
                Circle()
                    .fill(.white.opacity(configuration.isPressed ? 0.14 : 0.0))
                    .frame(width: 40, height: 40)
            }
            .scaleEffect(configuration.isPressed ? 0.90 : 1.0)
            .animation(.spring(response: 0.22, dampingFraction: 0.82), value: configuration.isPressed)
    }
}

private struct SymbolBounceIfAvailable: ViewModifier {
    let tapTick: Int

    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            content.symbolEffect(.bounce, value: tapTick)
        } else {
            content
        }
    }
}

private struct SensoryTapIfAvailable: ViewModifier {
    let tapTick: Int
    let isEnabled: Bool

    func body(content: Content) -> some View {
        if #available(iOS 17.0, *), isEnabled {
            content.sensoryFeedback(.impact(flexibility: .soft), trigger: tapTick)
        } else {
            content
        }
    }
}

private struct MarqueeText: View {
    let text: String
    let font: Font
    var isActive: Bool = true
    var gap: CGFloat = 28
    var speed: CGFloat = 35 // points per second

    @State private var containerWidth: CGFloat = 0
    @State private var textWidth: CGFloat = 0
    @State private var offset: CGFloat = 0
    @State private var isAnimating: Bool = false
    @State private var scrollTask: Task<Void, Never>? = nil

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width

            ZStack(alignment: .leading) {
                if shouldScroll(containerWidth: width) {
                    HStack(spacing: gap) {
                        Text(text)
                            .font(font)
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: false)

                        Text(text)
                            .font(font)
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: false)
                    }
                    .offset(x: offset)
                    .onAppear {
                        containerWidth = width
                        startIfNeeded(containerWidth: width)
                    }
                    .onChange(of: text) { _, _ in
                        stopScrolling()
                        startIfNeeded(containerWidth: width)
                    }
                    .onChange(of: width) { _, newWidth in
                        containerWidth = newWidth
                        stopScrolling()
                        startIfNeeded(containerWidth: newWidth)
                    }
                    .clipped()
                } else {
                    Text(text)
                        .font(font)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .allowsTightening(true)
                        .minimumScaleFactor(0.75)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .onAppear { containerWidth = width }
                        .onChange(of: width) { _, newWidth in containerWidth = newWidth }
                }
            }
            .overlay(alignment: .topLeading) {
                // Invisible intrinsic size measurement of the full title
                Text(text)
                    .font(font)
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: false)
                    .readWidth(into: $textWidth)
                    .opacity(0)
                    .allowsHitTesting(false)
                    .accessibilityHidden(true)
            }
            .onChange(of: textWidth) { _, _ in
                stopScrolling()
                startIfNeeded(containerWidth: width)
            }
            .onChange(of: isActive) { _, _ in
                stopScrolling()
                startIfNeeded(containerWidth: width)
            }
            .onDisappear {
                stopScrolling()
            }
        }
        .frame(height: 18)
        .opacity(isActive ? 1 : 0.9)
        .clipped()
    }

    private func shouldScroll(containerWidth: CGFloat) -> Bool {
        isActive && textWidth > containerWidth && containerWidth > 0
    }

    private func startIfNeeded(containerWidth: CGFloat) {
        // Stop if we don't need to scroll
        guard shouldScroll(containerWidth: containerWidth) else {
            stopScrolling()
            return
        }
        // If already running, do nothing
        if scrollTask != nil { return }

        let travel = textWidth + gap
        let duration = Double(travel / max(1, speed))
        let dwellSeconds: Double = 5

        scrollTask = Task { @MainActor in
            while !Task.isCancelled && shouldScroll(containerWidth: containerWidth) && isActive {
                // Reset to start without animation
                withAnimation(.none) { offset = 0 }
                // Initial dwell
                try? await Task.sleep(nanoseconds: UInt64(dwellSeconds * 1_000_000_000))
                // Animate one pass
                withAnimation(.linear(duration: duration)) { offset = -travel }
                // Wait for the pass to complete
                try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
            }
            stopScrolling()
        }
    }

    private func stopScrolling() {
        scrollTask?.cancel()
        scrollTask = nil
        withAnimation(.none) { offset = 0 }
    }
}

private struct WidthPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

private extension View {
    func readWidth(into binding: Binding<CGFloat>) -> some View {
        background(
            GeometryReader { geo in
                Color.clear
                    .preference(key: WidthPreferenceKey.self, value: geo.size.width)
            }
        )
        .onPreferenceChange(WidthPreferenceKey.self) { binding.wrappedValue = $0 }
    }
}

#Preview {
    @Previewable @State var isShowingVolume: Bool = false
    CurrentlyPlayingView(pylightsViewModel: PylightsViewModel(), isShowingVolume: $isShowingVolume)
}

