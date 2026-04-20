# Project Status Report - SafeRoute Parent App

This report provides a comprehensive overview of the current development status of the SafeRoute Parent App, organized by feature and architectural layer (Presentation, Cubit, Data).

## Architectural Overview
The project follows a layered architecture:
- **Presentation Layer**: UI Components and Pages.
- **Cubit Layer**: Business logic using the BLoC pattern.
- **Data Layer**: Models, Repositories, and Providers (API/Local Storage).

---

## Feature Status Matrix

| Feature | Presentation | Cubit (Logic) | Data Layer | Status / Comments |
| :--- | :---: | :---: | :---: | :--- |
| **Authentication** | ✅ Done | ✅ Done | ✅ Done | Integrated with `/login`, `/otp`, `/reset-password`. Needs real backend validation. |
| **Home / Trip Tracking** | ✅ Done | ⚠️ Partial | ⚠️ Partial | UI is comprehensive. `TripCubit` and `TripRepository` are partially implemented; currently hitting `/trip/current`. |
| **Absence Management** | ✅ Done | ✅ Done | ⚠️ Mock | `AbsenceCubit` is ready but uses `FakeApiService`. Needs real API integration. |
| **Notifications** | ✅ Done | ✅ Done | ✅ Done | FCM service and local history storage are implemented. |
| **Saved Locations** | ✅ Done | ❌ Missing | ⚠️ Local Only | UI exists for listing and searching, but lacks a dedicated Cubit. Data is currently local only (`SavedLocationsStore`). |
| **Change Request** | ✅ Done | ✅ Done | ⚠️ Local Only | Flow for requesting location changes is implemented. Data is stored locally (`ChangeRequestStore`). |
| **Student Profiles** | ✅ Done | ❌ Missing | ❌ Missing | UI components are ready, but logic and data fetching (list of students) are not yet implemented. |
| **User Profile** | ✅ Done | ❌ Missing | ❌ Missing | Basic profile UI is present. Needs logic for fetching/updating user info. |
| **Settings** | ✅ Done | ✅ Done | ✅ Done | Handles language selection and persistence. |

---

## Design Decisions & Questions for Review

### 1. Data Layer Abstraction
- **Observation**: Some features use `Provider` (Dio), while others use `Store` (Local) or `Service`.
- **Question**: Should we standardize all remote data fetching through a `DataProvider` pattern that returns `Response` objects, or allow Repositories to handle specific service types directly?

### 2. Mocking Strategy
- **Observation**: Absence uses a `FakeApiService`. Home uses a `TripDataProvider` hitting a local URL.
- **Question**: Would you prefer a unified `MockInterceptor` for Dio to toggle mocking globally, or continue with feature-specific fakes?

### 3. Students & Profile Cubits
- **Observation**: These folders are currently empty.
- **Question**: Do you want these to be simple "fetch-and-display" Cubits, or will there be more complex interactions (e.g., editing profile details, switching between multiple student views)?

### 4. Saved Locations Persistence
- **Observation**: Currently using a local `SavedLocationsStore`.
- **Question**: Should these be synced with the backend so they persist across devices? If so, we need an API endpoint for this.

---

## Next Steps
1.  **Standardize Data Layer**: Implement real `DataProvider`s for Absence and Students once backend contracts are confirmed.
2.  **Logic Implementation**: Create Cubits for Students and Profile features.
3.  **End-to-End Testing**: Verify Auth and Notifications with a live backend/FCM environment.
