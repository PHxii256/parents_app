# SafeRoute — Remaining backend work (endpoints & contracts)

---

## 1. Global response envelope

**Target:** All JSON responses should follow one shape (see `backend_endpoints.txt`):

```json
{
  "success": true,
  "message": "…",
  "data": { },
  "errors": { }
}
```

**Action:** Audit every endpoint and remove **double-wrapped** `data` (see §3.1). Clients unwrap `body['data']` once; nested `{ "data": { "data": { … } } }` breaks parsing unless you document “recursive unwrap” (not recommended).

---

## 2. Auth (§A) — gaps and fixes


| Item                                                   | Status                                                     | Backend / docs action                                                                                                                                                         |
| ------------------------------------------------------ | ---------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| GET /api/v1/guardian or assistant/auth/change-password | wrong method in “Reset Password”                           | Driver its POST (correct) but in assistant + guardian its GET                                                                                                                 |
| **Refresh**                                            | Postman: `POST {{base_url}}/api/common/auth/token/refresh` | **make example response.**                                                                                                                                                    |
| **Unify All Auth? (Refactor)**                         | Postman: `POST {{base_url}}/api/common/auth/`*             | instead of assistant, driver, and guardian auth endpoints, have shared endpoints, and return back the role of the user inside the JWT, instead of sending it from the client. |


---

## 3. Trip & tracking (§B1–B5, B12)

Flutter uses:

- `GET /api/v1/trips/current`
- `POST /api/v1/trips/start`
- `POST /api/v1/trips/location` with body `{'currentCoords': [lat, lng]}`
- `GET /api/v1/trips/active` — expects `data.tripActive` boolean
- `POST /api/v1/trips/end`

### 3.1 `**GET /trips/current` — response shape (high priority)**

**Ambiguity:** Postman example for “Get Current Trip for Child” nests payload:

```json
"data": {
  "success": true,
  "data": {
    "tripActive": false
  }
}
```

**Client work:** `TripRepository` reads **one** `data` level, then `tripActive`, `tripUpdate`, `licencePlateLetters` / `licencePlateNumbers`, flat or nested `licensePlate`, `assistantInfo` / `driverInfo`, `busCoords` or `tripUpdate.busCoords`, optional `status` for offline.

**Backend work:**

1. Return a **single** envelope: `success`, `message`, `data` where `data` is the trip snapshot (no second full envelope inside).
2. For an **active** trip, document and implement fields compatible with **both** `backend_endpoints.txt` `TripDetails` + `TripUpdate`.

### 3.2 **Realtime (B12)**

Not fully specified in Postman. Choose and document:

- Poll-only (`GET /trips/current` every 30–60s), and/or  
- WebSocket event (e.g. `trip:location` with `{ busCoords, eta }`).

Parent map UX depends on `**busCoords`** being present when `tripActive` is true.

---

## 4. Routes, students, school (§B6–B7, B8–B9)


| Endpoint                                      | In Postman?               | Notes                                                                                  |
| --------------------------------------------- | ------------------------- | -------------------------------------------------------------------------------------- |
| `GET /api/v1/routes/students?direction=am|pm` | Yes                       | Yes (example `direction=am`)                                                           |
| `GET /api/v1/school/location`                 | **No** in collection grep | **Add** implementation + Postman example. Flutter expects `data`: `{ name, gMapsUrl }` |
| `POST /api/v1/students/{id}/boarded`          | Yes                       | Body can be empty; **document** FCM + socket side effects (B8/B9 notes in spec).       |
| `POST /api/v1/students/{id}/dropped-off`      | Yes                       | Same.                                                                                  |


**Response ambiguity (B6):** `backend_endpoints.txt` defines `StudentData` plus a separate `StudentStatus` type; it is unclear whether status/boarded/dropped flags are **embedded** on each student object. Backend should publish one **canonical** JSON shape (e.g. `student['boardedBus']` or nested `status`) so assistant UI can bind without guessing.

---

## 5. WebSockets (§B10, B11)


| Channel | Purpose                                        | Status                                                                                                                |
| ------- | ---------------------------------------------- | --------------------------------------------------------------------------------------------------------------------- |
| B10     | Student boarded/dropped → driver UI checkmarks | **Not in Postman** — define URL, subscription key (route/trip id), event names, payload (`StudentBusStatus` in spec). |
| B11     | Guardian messages → assistant inbox            | **Not in Postman** — same auth/subscription questions; payload `GuardianMessageData`.                                 |


**Action:** Add a short **WebSocket appendix** to `backend_endpoints.txt` (or OpenAPI companion doc): connection URL, handshake, heartbeat, reconnect.

---

## 6. Guardian — pins, locations, messages, profile

### 6.1 `GET /api/v1/guardian/pins` (C1)

- Postman: request present, **no saved example response**.
- Flutter expects `data`: `{ masterPin, tempPin }` (stringifiable; product may require **5-digit** pins per `todos.md`).

**Action:** Publish exact field names and types (`int` vs `string`). Align with PIN length decision (see `status_report_2.md` open questions).

### 6.2 `POST /api/v1/guardian/messages` (C4)

- **Not in Postman, that's fine if we are going to be using sockets for this though right?**
- Flutter sends: `{ content, studentId }`.

**Action:** Implement + document; confirm delivery path to assistant (**B11** socket).

### 6.3 `GET /api/v1/guardian/profile` (E3)

- **Not in Postman**.
- Flutter expects `data`: `name`, `primaryPhone`, `secondaryPhone`, `email`, `children`: `[{ name, grade }, …]`.

**Action:** Implement and add Postman example.

---

## 7. Location change requests (§D1)

- `GET …/location-change-requests/active` — expects `data.request (id`, `status`, `effectiveUntil`, `deadline)` or null.

`backend_endpoints.txt` **D2** describes a **richer** body (`guardianId`, `studentIds`, `appliesToAllStudents`, full `newLocation` object).

**Action:**  Document **HTTP status** for submit (`200` vs `202`) and error bodies for cutoff / duplicate-day rules (`status_report_2.md` Q8)

---

## 8. Absence (E2)

**Not in Postman**.

- `POST /api/v1/absence` — `{ student_ids: [...], date: "YYYY-MM-DD" }`
- `DELETE /api/v1/absence` — same body in request (this is used to undo provided its pre-deadline like 4:am for that day)

---

## 9. Devices / FCM (E1)

Postman includes `POST /api/v1/devices/fcm-token`.

Flutter sends `{ token }`.

**Action:** Document optional fields (device id, platform, topics).

---

## 10. Notifications inbox (optional)

`todos.md` / `status_report_2.md`: server-synced notification history is **not** wired on the client.

**Optional:** `GET /api/v1/…/notifications` (guardian and assistant only).

---

*Last aligned with repo state: Flutter client paths under `lib/features/**/data/` and Postman collection grep on 2026-04-24.* 