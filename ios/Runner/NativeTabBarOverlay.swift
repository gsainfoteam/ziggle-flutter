import Flutter
import UIKit

/// Draws the iOS 26 Liquid Glass tab bar and chatbot button in UIKit, above
/// the Flutter view instead of inside it.
///
/// Hosting them as platform views (`UiKitView`) made Flutter composite every
/// frame around the native views and synchronise its presentation with Core
/// Animation, which made scrolling the feed underneath visibly uneven even
/// though Flutter's own frame timings stayed well inside budget. Here the
/// views live in the window, next to the Flutter view, so Flutter renders a
/// single surface as if no native view were on screen.
///
/// Dart drives it over the `ziggle/native_tab_bar` channel:
/// - `update`: the whole bar state (see [OverlayConfig]). Creates the overlay
///   on first use and returns the bar height in points, which Dart reserves
///   at the bottom of the page.
/// - `dispose`: removes the overlay.
///
/// and is told about:
/// - `valueChanged` `{index}`: a tab was selected.
/// - `chatbotPressed`: the chatbot button was tapped.
/// - `heightChanged` `{height}`: the bar height changed, e.g. on rotation.
final class NativeTabBarOverlayPlugin: NSObject {
  private let channel: FlutterMethodChannel
  private weak var registrar: FlutterPluginRegistrar?
  /// A `NativeTabBarOverlayView`. Typed as UIView because the class needs
  /// iOS 26, and stored properties cannot be limited by availability.
  private var overlay: UIView?

  static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "ziggle/native_tab_bar",
      binaryMessenger: registrar.messenger()
    )
    let instance = NativeTabBarOverlayPlugin(channel: channel, registrar: registrar)
    channel.setMethodCallHandler(instance.handle)
  }

  private init(channel: FlutterMethodChannel, registrar: FlutterPluginRegistrar) {
    self.channel = channel
    self.registrar = registrar
  }

  private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "update":
      guard #available(iOS 26.0, *) else {
        result(FlutterError(code: "unsupported", message: "Requires iOS 26", details: nil))
        return
      }
      guard let args = call.arguments as? [String: Any],
        let config = OverlayConfig(args)
      else {
        result(FlutterError(code: "bad_args", message: "Invalid update arguments", details: nil))
        return
      }
      guard let window = registrar?.viewController?.view.window else {
        result(FlutterError(code: "no_window", message: "Flutter view is not in a window", details: nil))
        return
      }
      let overlay = attachOverlay(to: window)
      overlay.apply(config)
      result(Double(overlay.barHeight))
    case "dispose":
      overlay?.removeFromSuperview()
      overlay = nil
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  @available(iOS 26.0, *)
  private func attachOverlay(to window: UIWindow) -> NativeTabBarOverlayView {
    if let overlay = overlay as? NativeTabBarOverlayView, overlay.window === window {
      return overlay
    }
    overlay?.removeFromSuperview()
    let view = NativeTabBarOverlayView(frame: window.bounds)
    view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    view.onSelect = { [weak self] index in
      self?.channel.invokeMethod("valueChanged", arguments: ["index": index])
    }
    view.onChatbot = { [weak self] in
      self?.channel.invokeMethod("chatbotPressed", arguments: nil)
    }
    view.onHeightChanged = { [weak self] height in
      self?.channel.invokeMethod("heightChanged", arguments: ["height": Double(height)])
    }
    // Above the Flutter view. View controllers presented later (sign-in,
    // share sheets) add their containers on top, so they still cover it.
    window.addSubview(view)
    overlay = view
    return view
  }
}

/// Everything Dart sends in an `update` call.
struct OverlayConfig: Equatable {
  var labels: [String]
  var symbols: [String]
  var selectedSymbols: [String]
  var selectedIndex: Int
  var tint: UIColor
  var unselectedTint: UIColor
  var isDark: Bool
  var isRtl: Bool
  var obscured: Bool
  var chatbotLabel: String

  init?(_ args: [String: Any]) {
    guard let labels = args["labels"] as? [String],
      let symbols = args["symbols"] as? [String],
      let selectedSymbols = args["selectedSymbols"] as? [String],
      labels.count == symbols.count, labels.count == selectedSymbols.count,
      let selectedIndex = (args["selectedIndex"] as? NSNumber)?.intValue,
      let tint = (args["tint"] as? NSNumber)?.int64Value,
      let unselectedTint = (args["unselectedTint"] as? NSNumber)?.int64Value
    else { return nil }
    self.labels = labels
    self.symbols = symbols
    self.selectedSymbols = selectedSymbols
    self.selectedIndex = selectedIndex
    self.tint = UIColor(argb: tint)
    self.unselectedTint = UIColor(argb: unselectedTint)
    self.isDark = args["isDark"] as? Bool ?? false
    self.isRtl = args["isRtl"] as? Bool ?? false
    self.obscured = args["obscured"] as? Bool ?? false
    self.chatbotLabel = args["chatbotLabel"] as? String ?? ""
  }
}

/// Full-window container for the bar and the chatbot button. Touches that
/// miss both fall through to the Flutter view underneath.
@available(iOS 26.0, *)
final class NativeTabBarOverlayView: UIView, UITabBarDelegate {
  var onSelect: ((Int) -> Void)?
  var onChatbot: (() -> Void)?
  var onHeightChanged: ((CGFloat) -> Void)?

  /// Height of the bar including the home indicator area. Dart reserves the
  /// same height at the bottom of the page.
  private(set) var barHeight: CGFloat = 0

  private let tabBar = UITabBar(frame: .zero)
  private let chatButton = UIButton(type: .system)
  private var config: OverlayConfig?
  private var chatIconSize: CGFloat = 0

  // Geometry of the native bar, measured on iOS 26.5. UITabBar changes its
  // layout with the horizontal size class, so there are two sets of metrics.
  //
  // Compact width (iPhone): items stack icon over label, the pill is 60 pt
  // tall and stops widening at 270 pt, so its edges are predictable and the
  // chat button can sit a fixed gap beside it.
  private static let chatSize: CGFloat = 60
  private static let chatGap: CGFloat = 12
  private static let edgeMargin: CGFloat = 22
  /// UITabBar keeps this inset between its frame and the pill it draws.
  private static let nativeInset: CGFloat = 22
  /// UITabBar stops widening the pill once three items have this much room.
  private static let pillMaxWidth: CGFloat = 270
  // Regular width (iPad): items go inline, so the pill's width follows the
  // label text and cannot be predicted. The bar spans the full width and
  // UIKit centres the pill itself; the 46 pt chat button is pinned to the
  // trailing edge instead of beside the pill.
  private static let regularChatSize: CGFloat = 46
  /// Below this width UIKit treats the window as compact and stacks items.
  private static let regularWidth: CGFloat = 600
  /// Matches `ZiggleNavigationBar.hideDuration` on the Dart side.
  private static let hideDuration: TimeInterval = 0.2

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .clear

    tabBar.delegate = self
    // Leave the background to the system Liquid Glass material.
    tabBar.isTranslucent = true
    tabBar.backgroundImage = UIImage()
    tabBar.shadowImage = UIImage()
    tabBar.backgroundColor = .clear
    addSubview(tabBar)

    chatButton.addTarget(self, action: #selector(chatTapped), for: .touchUpInside)
    chatButton.isAccessibilityElement = true
    chatButton.accessibilityTraits = .button
    addSubview(chatButton)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func apply(_ new: OverlayConfig) {
    let old = config
    config = new

    if old?.isDark != new.isDark {
      overrideUserInterfaceStyle = new.isDark ? .dark : .light
    }
    if old?.isRtl != new.isRtl {
      let attribute: UISemanticContentAttribute =
        new.isRtl ? .forceRightToLeft : .forceLeftToRight
      semanticContentAttribute = attribute
      tabBar.semanticContentAttribute = attribute
      // The selected Liquid Glass content reads the trait direction.
      tabBar.traitOverrides.layoutDirection = new.isRtl ? .rightToLeft : .leftToRight
    }
    if old?.tint != new.tint || old?.unselectedTint != new.unselectedTint
      || old?.labels != new.labels || old?.symbols != new.symbols
      || old?.selectedSymbols != new.selectedSymbols
    {
      tabBar.tintColor = new.tint
      tabBar.unselectedItemTintColor = new.unselectedTint
      tabBar.items = new.labels.indices.map { i in
        // Unselected icons carry their colour so the glass does not
        // re-tint them; selected icons follow tintColor.
        let image = UIImage(systemName: new.symbols[i])?
          .withTintColor(new.unselectedTint, renderingMode: .alwaysOriginal)
        let selectedImage = UIImage(systemName: new.selectedSymbols[i])?
          .withRenderingMode(.alwaysTemplate)
        return UITabBarItem(title: new.labels[i], image: image, selectedImage: selectedImage)
      }
    }
    if let items = tabBar.items, items.indices.contains(new.selectedIndex),
      tabBar.selectedItem !== items[new.selectedIndex]
    {
      tabBar.selectedItem = items[new.selectedIndex]
    }
    chatButton.accessibilityLabel = new.chatbotLabel

    // New items can change the bar height; measure before reporting it.
    setNeedsLayout()
    layoutIfNeeded()
    if old?.obscured != new.obscured {
      setObscured(new.obscured, animated: old != nil)
    }
  }

  /// While a route covers the shell the whole row slides below the screen.
  /// Liquid Glass views cannot be hidden or faded without painting a black
  /// outline, but moving them off screen is safe and keeps them warm.
  private func setObscured(_ obscured: Bool, animated: Bool) {
    isUserInteractionEnabled = !obscured
    let transform =
      obscured ? CGAffineTransform(translationX: 0, y: barHeight) : .identity
    let change = {
      self.tabBar.transform = transform
      self.chatButton.transform = transform
    }
    if animated {
      UIView.animate(
        withDuration: Self.hideDuration, delay: 0, options: [.curveEaseInOut, .beginFromCurrentState],
        animations: change)
    } else {
      change()
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    let width = bounds.width
    guard width > 0 else { return }
    let regular = width >= Self.regularWidth

    let barLeft: CGFloat
    let barRight: CGFloat
    let chatLeft: CGFloat
    let chatSize: CGFloat
    if regular {
      barLeft = 0
      barRight = 0
      chatSize = Self.regularChatSize
      chatLeft = width - Self.edgeMargin - chatSize
    } else {
      let pillWidth = min(
        Self.pillMaxWidth,
        width - 2 * Self.edgeMargin - Self.chatGap - Self.chatSize
      )
      let side = (width - pillWidth - Self.chatGap - Self.chatSize) / 2
      barLeft = side - Self.nativeInset
      barRight = width - side - pillWidth - Self.nativeInset
      chatSize = Self.chatSize
      chatLeft = side + pillWidth + Self.chatGap
    }

    // Lay the bar out without the slide offset so its safe area (the home
    // indicator) is measured at its resting place.
    let transform = tabBar.transform
    tabBar.transform = .identity
    chatButton.transform = .identity
    let barWidth = width - barLeft - barRight
    // The bar's height includes the home indicator, which UIKit only knows
    // once the bar sits at the bottom edge, so place it and measure again.
    var height = barHeight > 0 ? barHeight : 100
    for _ in 0..<2 {
      tabBar.frame = CGRect(x: barLeft, y: bounds.height - height, width: barWidth, height: height)
      tabBar.layoutIfNeeded()
      height = tabBar.sizeThatFits(
        CGSize(width: barWidth, height: .greatestFiniteMagnitude)
      ).height
    }
    tabBar.frame = CGRect(x: barLeft, y: bounds.height - height, width: barWidth, height: height)
    // The bar draws its pill at its top edge, 60 pt tall on compact widths
    // and 46 pt on regular ones, which the chat button matches.
    chatButton.frame = CGRect(x: chatLeft, y: tabBar.frame.minY, width: chatSize, height: chatSize)
    updateChatIcon(buttonSize: chatSize)
    if transform != .identity {
      let hidden = CGAffineTransform(translationX: 0, y: height)
      tabBar.transform = hidden
      chatButton.transform = hidden
    }

    if abs(height - barHeight) > 0.5 {
      let notify = barHeight > 0
      barHeight = height
      if notify { onHeightChanged?(height) }
    }
  }

  override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    let targets: [UIView] = [tabBar, chatButton]
    return targets.contains { $0.frame.contains(point) }
  }

  private func updateChatIcon(buttonSize: CGFloat) {
    // Popo is 33 pt on the 60 pt button and scales with smaller buttons.
    let iconSize = (buttonSize * 33 / 60).rounded()
    guard iconSize != chatIconSize else { return }
    chatIconSize = iconSize
    var configuration = UIButton.Configuration.glass()
    configuration.cornerStyle = .capsule
    configuration.contentInsets = .zero
    configuration.image = Self.chatIcon(size: iconSize, scale: traitCollection.displayScale)
    chatButton.configuration = configuration
  }

  /// Popo wearing a headset, the same PNG the Flutter button uses. Not a
  /// template image: it carries its own black and white.
  private static func chatIcon(size: CGFloat, scale: CGFloat) -> UIImage? {
    let variants = ["assets/icons/3.0x/chatbot.png", "assets/icons/2.0x/chatbot.png", "assets/icons/chatbot.png"]
    let preferred = scale >= 3 ? variants : scale >= 2 ? Array(variants.dropFirst()) : [variants[2]]
    for asset in preferred {
      let key = FlutterDartProject.lookupKey(forAsset: asset)
      guard let path = Bundle.main.path(forResource: key, ofType: nil),
        let image = UIImage(contentsOfFile: path)
      else { continue }
      let format = UIGraphicsImageRendererFormat.preferred()
      format.scale = scale
      return UIGraphicsImageRenderer(size: CGSize(width: size, height: size), format: format)
        .image { _ in image.draw(in: CGRect(x: 0, y: 0, width: size, height: size)) }
        .withRenderingMode(.alwaysOriginal)
    }
    return nil
  }

  @objc private func chatTapped() {
    onChatbot?()
  }

  func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    guard let index = tabBar.items?.firstIndex(of: item) else { return }
    onSelect?(index)
  }
}

extension UIColor {
  fileprivate convenience init(argb: Int64) {
    self.init(
      red: CGFloat((argb >> 16) & 0xFF) / 255,
      green: CGFloat((argb >> 8) & 0xFF) / 255,
      blue: CGFloat(argb & 0xFF) / 255,
      alpha: CGFloat((argb >> 24) & 0xFF) / 255
    )
  }
}
