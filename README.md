# Maps SwiftUI vs UIKit

A focused exploration app comparing SwiftUI-first MapKit clustering against a UIKit-backed implementation. The project is structured to allow swapping map rendering strategies while keeping the same domain model and sample data.

**Target:** iOS 17+ · Xcode 15+ · Swift 5.9+

---
/var/folders/db/ds5kfr995ps4f1fd8k2g4_yr0000gn/T/TemporaryItems/NSIRD_screencaptureui_fTNRVK/Screenshot 2025-08-26 at 12.18.27 PM.png

## TL;DR

- **Goal:** Evaluate how far we can go with SwiftUI’s Map and clustering before dropping to UIKit (`MKMapView`) for edge cases.
- **Approach:** Keep data and view models identical; swap the map layer (SwiftUI vs UIKit) behind a consistent interface.
- **Status:** SwiftUI clustering is implemented; hooks are in place for a UIKit bridge if needed.

---

## Project Structure

### `ContentView.swift`

- **Role:** App entry point. Creates a map region centered on Las Vegas and generates demo points via `LocationGenerator`.
- **Key Flow:**
  1. Build an `MKCoordinateRegion`
  2. Generate `[Location]` via `LocationGenerator.generate(center:count:)`
  3. Pass both to `ClusteredMapView`
- **Why:** Keeps the app boot process simple and allows future injection of different data sources (e.g. API, Core Data, or BLE).

---

### `ClusteredMapView.swift` (SwiftUI-first map layer)

- **Role:** Encapsulates map UI and clustering logic.
- **Likely API:**

```swift
struct ClusteredMapView: View {
    let region: MKCoordinateRegion
    let points: [Location]
}
```

- **Path:** Uses SwiftUI `Map` with `Annotation` or `AnnotationGroup` (iOS 17+) for declarative clustering. Can fallback to `MKMapView` via `UIViewRepresentable`.
- **Why:** Centralizes the map rendering logic. Lets you swap between SwiftUI and UIKit without touching the rest of the app.

---

### `Location.swift`

- **Role:** Lightweight model for map points.
- **Typical Structure:**

```swift
struct Location: Identifiable {
    let id: UUID
    let coordinate: CLLocationCoordinate2D
    // Optional: title, subtitle, icon, type, etc.
}
```

---

### `LocationGenerator.swift`

- **Role:** Provides deterministic or randomized fixture data for testing.
- **API:** `LocationGenerator.generate(center:count:) -> [Location]`
- **Why:** Enables fast clustering visual iteration without requiring a backend.

---

### `ClusterBubbleView.swift` *(Optional)*

- **Role:** SwiftUI component for custom cluster callouts (e.g., stacked initials/icons in a capsule bubble with a pointer).
- **Why:** Matches product/Figma styling for grouped pins.
- **Usage:** Composed in SwiftUI and can be used in SwiftUI Maps or wrapped in a `UIHostingController` for use in `MKAnnotationView`.

---

### `Triangle.swift` *(Optional)*

- **Role:** Simple `Shape` that draws the pointer/tail under the bubble.
- **Usage:**

```swift
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        Path { p in
            p.move(to: CGPoint(x: rect.minX, y: rect.minY))
            p.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            p.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            p.closeSubpath()
        }
    }
}
```

---

## How the Pieces Fit Together

1. `ContentView` defines the region and points (via `LocationGenerator`).
2. `ClusteredMapView` renders the map with clustering.
3. *(Optional)* `ClusterBubbleView` and `Triangle` customize cluster visuals.
4. You can flip the map backend (`SwiftUI.Map` ↔ `MKMapView`) inside `ClusteredMapView` without changing any other file.

---

## SDKs Used

### SwiftUI
- **Why:** Fast iteration, declarative UI, preview support, and composable cluster callouts.
- **Used For:** All UI and cluster customization.

### MapKit
- **Why:** Native Apple Maps, built-in clustering, optimized for iOS.
- **Used For:** Annotation rendering, clustering, map region control.

### CoreLocation *(Optional)*
- **Why:** For live location tracking or proximity logic.
- **Used For:** Future real-time data integration.

### Combine *(Optional)*
- **Why:** Useful for real-time BLE/socket updates piped into the map.
- **Used For:** Driving reactive map state (if needed).

> **Note:** No third-party map SDKs are used. This keeps the stack lean, performant, and easy to maintain.

---

## SwiftUI Map vs UIKit (`MKMapView`)

| Concern                     | SwiftUI Map (iOS 17+)            | UIKit (`MKMapView`)               |
|----------------------------|----------------------------------|----------------------------------|
| Speed to Build             | ✅ Less boilerplate               | ❌ Requires setup & delegates     |
| Clustering Control         | ⚠️ Limited low-level access      | ✅ Full control                   |
| Custom Cluster UI          | ✅ Composable with SwiftUI        | ✅/⚠️ Requires hosting SwiftUI     |
| Performance (high density) | ⚠️ Limited tuning knobs           | ✅ Mature and tunable             |
| Gesture/Camera Control     | ✅ Declarative, high-level        | ✅ Full delegate-based control    |
| Interoperability           | ⚠️ Needs bridging sometimes       | ✅ Native for MapKit              |
| Maintainability            | ✅ Unified SwiftUI app structure  | ⚠️ Requires UIKit-specific logic |

**Recommendation:**  
Start with SwiftUI Map for development speed and clean architecture. If limitations appear (e.g., custom hit-testing, large-scale annotations, or overlays), swap `ClusteredMapView` to use UIKit. No need to modify data models or `ContentView`.

---

## Running the Project

1. Open the project in **Xcode 15+**.
2. Set your run target to an iOS 17+ simulator.
3. Build and run the app.
4. Pan/zoom around Las Vegas to observe clustering behavior.

> To change the number of sample points, update the `count` value:

```swift
LocationGenerator.generate(center: ..., count: 30)
```

---

## Roadmap

- Add `UIViewRepresentable` variant of `ClusteredMapView` using `MKMapView`.
- Toggle map backend at runtime (SwiftUI ↔ UIKit).
- Finalize `ClusterBubbleView` with spacing and pointer tail.
- Stress test with 1k–10k annotations.
- Add live data streaming via CoreLocation or WebSocket.

---

## Testing Ideas

- Unit test `LocationGenerator` (test determinism with seeded random).
- Snapshot test `ClusterBubbleView`.
- UI test cluster tap-to-expand behaviors.

---

## Contributing

- Keep data models UI-agnostic.
- Keep all map rendering logic inside `ClusteredMapView`.
- Prefer pure SwiftUI components for UI.
- Use UIKit only when `MKMapView`-specific functionality is required.
