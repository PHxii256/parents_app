---
name: Collection diff & remaining work
overview: Compare old vs new Postman collection, map what the backend delivered against what was requested, and identify what remains for both frontend and backend.
todos:
  - id: fe-absence-students
    content: Replace hardcoded mockStudentData in absence_page.dart with real children list from GuardianRepository.getProfile()
    status: completed
  - id: fe-change-req-addresses
    content: Replace _loadAddresses() mock in change_location_cubit.dart with call to GET /api/v1/guardian/locations
    status: completed
  - id: fe-change-password-ui
    content: Wire changePassword from auth_data_provider.dart through AuthRepository and connect to UI
    status: completed
  - id: fe-messaging-ui
    content: Build guardian messaging UI and connect to POST /api/v1/guardian/messages (blocked on backend B11 socket spec)
    status: pending
  - id: fe-websockets
    content: Implement WebSocket clients for B10 (student boarded/dropped → driver) and B11 (messages → assistant) once backend documents socket spec
    status: pending
isProject: false
---

# SafeRoute — Collection diff & remaining work

## What changed between collections

**Old collection:** 36 endpoints | **New (latest) collection:** 40 endpoints

The backend delivered every endpoint that was flagged as "Not in Postman" in `backend_remaining_endpoints_work.md`:

| New endpoint | Notes |
|---|---|
| `GET /api/v1/school/location` (Driver folder) | Now has saved 200 example response |
| `POST /api/v1/absence` (Guardian) | Added — no saved example response |
| `DELETE /api/v1/absence` (Guardian) | Added — no saved example response |
| `GET /api/v1/guardian/location-change-requests` (history) | Added — no saved example response |
| `GET /api/v1/guardian/profile` | Added — no saved example response |

All other endpoints from the old collection are unchanged (same paths, same methods, same saved examples).

---

## Persistent bugs in the new collection (unchanged from old)

These were reported in `backend_remaining_endpoints_work.md` and still are not fixed:

- Guardian > Auth > "Reset Password": still `GET` method, URL still points at `/auth/resend-otp` instead of `/auth/change-password`
- Assistant > Auth > "Reset Password": same bug (GET + wrong URL)
- `GET /api/v1/guardian/pins`: still has no saved example response (field names `masterPin`/`tempPin` unconfirmed)
- `GET /api/v1/guardian/location-change-requests/active`: still no saved example response
- Double-envelope `data.data.tripActive` shape in `GET /api/v1/trips/current` — unresolved

---

## Frontend: what is already wired

The Flutter explore confirmed all 5 newly-added endpoints are **already implemented** in the frontend repositories:
- [`students_repository.dart`](lib/features/students/data/repositories/students_repository.dart) calls `GET /api/v1/school/location`
- [`absence/data/api_service.dart`](lib/features/absence/data/api_service.dart) calls `POST` + `DELETE /api/v1/absence`
- [`guardian_repository.dart`](lib/features/guardian/data/guardian_repository.dart) calls `GET /api/v1/guardian/profile`
- [`change_request_repository.dart`](lib/features/change_request/data/change_request_repository.dart) calls `GET /api/v1/guardian/location-change-requests`

The integration plan todos were all marked completed correctly.

---

## What remains: FRONTEND

**High priority (broken UX when real API is on):**
- **Absence page student list** — [`absence_page.dart`](lib/features/absence/presentation/absence_page.dart) still renders `StudentData.mockStudentData` hardcoded; it should pull children from `GuardianRepository.getProfile()` or a dedicated students call
- **Change-request saved addresses** — `_loadAddresses()` in [`change_location_cubit.dart`](lib/features/change_request/cubit/change_location_cubit.dart) is hardcoded mock; should call `GET /api/v1/guardian/locations` via `GuardianRepository.getLocations()`
- **Parse validation for new endpoints** — absence, profile, pins, and change-request history shapes have no Postman examples yet; integration should be tested/validated once backend adds those examples

**Medium priority (feature completeness):**
- **Guardian messaging UI** — `POST /api/v1/guardian/messages` is wired in `guardian_repository.dart` but no UI sends a message; waiting on both UI + backend socket (B11)
- **`changePassword` route in UI** — implemented in `auth_data_provider.dart` but `auth_repository.dart` has no method calling it, and no UI page routes to it
- **WebSocket B10** (student boarded/dropped → driver checkmarks) and **B11** (guardian messages → assistant inbox) — blocked on backend documenting the socket spec

**Low priority / decision needed:**
- **Test-email short-circuit** — `e@test.com`, `s@test.com`, `a@test.com` always bypass real API even when `USE_REAL_API=true`; fine for dev but should be removed before production
- **Server-side notification history** — `notifications_repository.dart` uses local store only; no `GET .../notifications` endpoint wired

---

## What remains: BACKEND

**Blocking (frontend can't validate parsing):**
- Add saved example responses for: `POST /api/v1/absence`, `DELETE /api/v1/absence`, `GET /api/v1/guardian/profile`, `GET /api/v1/guardian/pins`, `GET /api/v1/guardian/location-change-requests`, `GET /api/v1/guardian/location-change-requests/active`
- Fix double-envelope bug on `GET /api/v1/trips/current` — return flat `{ success, message, data: { tripActive, ... } }` not `data.data`

**Blocking for feature parity:**
- **`POST /api/v1/guardian/messages`** — not in either collection; must be implemented + documented (or confirmed as socket-only)
- **WebSocket B10** — student boarded/dropped notification → driver UI; define URL, subscription key, event names, payload
- **WebSocket B11** — guardian message delivery → assistant inbox; same spec needed

**Collection hygiene (won't break clients but should be fixed):**
- Fix Guardian + Assistant "Reset Password": method should be `POST`, URL should be `.../auth/change-password`
- Confirm `GET /api/v1/guardian/pins` field names (`masterPin` / `tempPin`, `int` vs `string`, pin length)
- Confirm `GET /api/v1/guardian/location-change-requests/active` response shape (`data.request` with `id`, `status`, `effectiveUntil`, `deadline` or null)

---

## Summary diagram

```mermaid
flowchart TD
    subgraph backend [Backend remaining]
        BE1["Add example responses\n(absence, profile, pins,\nchange-req history+active)"]
        BE2["Fix trips/current envelope\n(remove data.data)"]
        BE3["POST guardian/messages"]
        BE4["WebSocket B10\n(student boarded → driver)"]
        BE5["WebSocket B11\n(guardian msg → assistant)"]
        BE6["Fix Reset Password\nin collection\n(method + URL)"]
    end

    subgraph frontend [Frontend remaining]
        FE1["Absence page: replace\nmockStudentData with\nreal children list"]
        FE2["Change-request cubit:\nreplace hardcoded addresses\nwith GET guardian/locations"]
        FE3["Guardian messaging UI\n(blocked on BE3+BE5)"]
        FE4["changePassword UI route"]
        FE5["WebSocket client B10+B11\n(blocked on BE4+BE5)"]
        FE6["Remove test-email\nshort-circuit for prod"]
    end

    BE1 --> FE1
    BE1 --> FE2
    BE3 --> FE3
    BE4 --> FE5
    BE5 --> FE5
```
