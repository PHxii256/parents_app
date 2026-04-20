APIs needed

<!-- App layer legend (for each API below): P = Presentation, C = Cubit/domain logic, D = Data (provider/repository/remote). "Mock" = hardcoded or local-only until backend is ready. -->

> App (Driver & Assistant Views):

1: GET assigned students for the bus route assigned to driver (route for today and specified direction), expected: List<StudentData>

<!-- App: P done (assistant StudentsPage + driver StudentViewer use mock StudentData.mockStudentData); C missing (no StudentsCubit / route fetch); D missing (no provider). -->

Req body: {
	String direction; //am or pm route
}

Res body: { 
List<StudentData> students;
}

StudentData { 
String id;
String name;
String grade; 
//(ex: grade 1-12 or Kg 1-2) (it could also be just an int with kg being 1-2 and grades shifted by 2)  (in practice would need a yearly cron job + enrollment check)
List<GuardianContact> contacts;
Int primaryPin; //5 digit

Int tempPin; //temp pin for this day
StudentLocation activePickup; //location for this day
StudentLocation activeDropoff; //location for this day
}

GuardianContact {
String title; //any of: father, mother, grandma, etc… 
String phoneNum; 
}

StudentLocation {
String id;
String description; //(location description, ex: area x, street y, building z)
String gMapsUrl;
List<double or float> coords; //(lat, long)
String type; //(pickup, dropoff)
Bool active;
} 
	
StudentStatus { 
String statusDesc; // Coming today [when parents haven’t marked as absent],
// Not Coming today [when parent mark as absent], 
// Absent [when assistant mark as absent], 
// Present [when assistant mark as present]
Bool boardedBus;
Bool droppedOff;
}

2: GET School Location, expected: SchoolData
// used for navigating between last student pickup and school

<!-- App: P partial (staff flows may open Maps per student; no dedicated "school" chip); C missing; D missing (no GET school endpoint wired). -->

SchoolData{
String name;
String gMapsUrl;
}

3: POST Trip Start
// suggested flow: bus driver starts trip, from auth headers or something we’d know his id and the bus / route he’s assigned to, then we’ll log the trip start time for the driver

<!-- App: P partial (staff UI has end-trip affordance; no explicit start-trip screen wired); C missing; D missing. -->

4: POST Trip Status Update (Polling or socket)
// suggested flow: bus driver client after starting trip, would push an update every 5 seconds at most (if trip is active AND phone accelerometer or some sort of local calculation says the location coordinates changed significantly from the last recorded coords on device), So effectively long polling and short polling. 

// although a socket could be easier to implement and more “useful” we can keep driver in sync with assistant or parent made updated (like student status) 

// this will be logged to db and stored in-memory as a map: {route_id: last_trip_status_update} so when parents poll or have an open socket to the server, we wouldn't need a db query to get bus coords.

TripStatusUpdate {
List<double or float> currentCoords; //(lat, long)
}

<!-- App: P partial (MapView + geolocator for device only; no periodic push to server); C missing; D missing. -->

5: GET Trip Status, expect: tripActve bool
// useful if the driver restarts the app, so we’d know if we should keep sending to the server our location or not.

<!-- App: P partial (TripCubit states include active/inactive/offline; dev cycleState on parent); C partial (syncTripState exists but not used on driver init); D partial (parent uses GET /trip/current via TripRepository — confirm same semantics as tripActive for driver). -->

6: POST Trip End
// suggested flow: bus driver end trip once he reaches the school or even it could end automatically if the coords sent are close to school (either client or server side works), this will send a notification to parents that the bus reached school (unless they turn off this notification) using FCM.

<!-- App: P partial (RoundedCtaButton "end trip" not wired); C missing; D missing. -->

7: POST student boarded bus / picked up
// done by bus assistant, this will log to db and send a notif to parents.
body: {
student_id
}

<!-- App: P partial (StudentStatus UI is static text); C missing; D missing. -->

8: POST student dropped off
// done by bus assistant, this will log to db and send a notif to parents.
body: {
student_id
}

<!-- App: P partial (same as boarded); C missing; D missing. -->

9: SOCKET connection between assistants and backend, to view any message sent by the parents of children. (assistants do not send messages they only receive as requested by doc doha), reasoning for socket: the messages might be urgent and infrequent enough to not use polling.

<!-- App: P partial (LatestMessageViewer, CommunicationBar — no live stream); C missing; D missing (no WebSocket client). -->


> App (Guardian View):

1: GET Trip Status Update (Polling or socket)
// suggested flow: parent clients polls every 30-60 seconds at most, if trip is active it opens a socket to receive bus location updates.

Expected response (TripDetails or null/false):
TripDetails {
String licencePlateLetters;
String licencePlateNumbers;
String driverName;
String assistantName;
String assistantPhoneNum;
TripUpdate tripUpdate;
}

// gets sent over socket 
TripUpdate{
	Int eta;
	List<double or float> busCoords;
}

<!-- App: P done (TripStatus, TripPanel, map shell); C partial (TripCubit + example state + cycleState dev; syncTripState not on timer); D partial (GET /trip/current parsed in TripRepository — align field names with TripDetails/TripUpdate; busCoords not shown on map yet). -->

2: GET Pin Codes, expected: PinData
PinData {
	Int masterPin;
	Int tempPin;
}

<!-- App: P done (PinCodePage); C missing; D mock (hardcoded example pins in controller). -->

3: POST guardianMessage, body MessageData
// Message content (String) is sent to the backend, then the backend sends this GuardianMessageData via socket to the assistant assigned to this route.

GuardianMessageData{
	String timestamp;
	String content;
	String GuardianTitle;
	String studentId;
}

<!-- App: P partial (message dialogues); C missing; D missing. -->

4: GET savedLocations, expect List<StudentLocation>

<!-- App: P done (LocationsPage + models); C missing (no cubit; ValueNotifier store); D local only (SavedLocationsStore, no GET). -->

5: POST addLocation, expect body of StudentLocation. 

<!-- App: P done (AddLocationPage / gmaps); C partial (ChangeLocationCubit handles mock addresses; add flow uses local store); D missing (no POST). -->

6: POST changeLocationDetour, Expect: Accept / Reject Notification
// note: validation is needed to not accept any Locations with active set to true.
// note: changing location can be done through 2 ways: 

First way (the cached path), through a location known to have been accepted before and saved in the system as an acceptable detour AND the route used before for this insertion for this specified day is the default (primary) route with no detours assigned that day yet, we accept the request and update the route for that day, so if another request comes in to change location it gets treated as the 2nd way.

Second Way, check the feasibility of insertion through the algorithm used in the research paper, this requires the coords of the new location and the algorithm return either a true or false response, this is then used to either return a rejection notification to the client or a confirmation notification, updating the route used for that day in db and logging it.

// restrictions include: not accepting requests for the same day, i.e after 4 am for example. Can only change pickup, dropoff locations once per day each.

body {
locationId;
}

<!-- App: P done (change request + confirmation flow); C partial (change_location_cubit mock submit); D missing (ChangeRequestStore local only). -->

---

> Additional APIs (general — backend)

These are not duplicates of the numbered list above; they fill gaps the app already touches or will need for production. Same P/C/D legend.

- **POST /login (email + password)** — Returns user + access/refresh tokens. **App:** D partial (`AuthDataProvider` has POST `/login`; `AuthRepository.passwordLogin` still mock; wire and remove test emails).

- **POST /login or POST /refresh (JWT refresh)** — Validates/refreshes tokens. **App:** D partial (`jwtLogin` + `AuthDataProvider`); confirm contract.

- **POST /logout** — Invalidate refresh token server-side. **App:** D partial (`AuthDataProvider.logout` used from repository when clearing JWT).

- **GET /otp** — Request OTP for reset / login. **App:** D partial (`requestOTP`; note: provider uses GET with `data` — verify backend expects query vs body).

- **POST /reset-password** — **App:** D wired (`AuthRepository.resetPassword`).

- **POST /absence** (mark absent) and **DELETE or PATCH /absence** (undo) — Body: student ids + date. **App:** C done (`AbsenceCubit`); D mock (`FakeApiService`); commented stub in `api_service.dart`.

- **GET /guardian/profile** (and optional **PATCH**) — Profile + children list. **App:** P stub (`ProfilePage` hardcoded); C/D missing.

- **POST /devices/fcm** or similar — Register FCM token (and optional topics) per user/session. **App:** D partial (FCM receives messages locally; no token upload).

- **GET /notifications** (optional) — Server-side notification history sync. **App:** P/C done for local history; D missing for remote inbox.

- **GET /health** or **GET /version** (optional) — For forced upgrade or maintenance banners. **App:** not started.

---
