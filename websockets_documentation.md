# WebSockets Implementation

SafeRoute Backend uses Django Channels and Redis to handle real-time WebSockets communication.

## Connection
**Endpoint:** `ws://<domain>/ws/trip/<trip_id>/`
**Authentication:** Pass the JWT access token in the headers as `Authorization: Bearer <token>` or as a query parameter `?token=<token>`.

### Roles & Permissions
Currently, any authenticated user can connect to a trip room. In the future, this can be restricted so only the assigned driver, assistant, and guardians of students in the trip can connect.

---

## 1. Guardian Message to Assistant
- **Sender:** Guardian
- **Receiver:** Assistant
- **Trigger:** Guardian sends an HTTP POST request to `/api/v1/guardian/messages` with `{"studentId": <id>, "content": "..."}`.
- **WebSocket Event:** The server will broadcast this to the `trip_<trip_id>` room.
- **Payload Received by Client:**
```json
{
  "type": "guardian_message",
  "data": {
    "student_id": 1,
    "content": "Running 5 minutes late!",
    "guardian_name": "John Doe"
  }
}
```

---

## 2. Driver Location Update
- **Sender:** Driver
- **Receiver:** Guardian & Assistant
- **Trigger:** Driver sends an HTTP POST request to `/api/v1/trips/location` with `{"currentCoords": [lat, lng]}`.
- **WebSocket Event:** The server will broadcast this to the `trip_<trip_id>` room.
- **Payload Received by Client:**
```json
{
  "type": "location_update",
  "data": {
    "currentCoords": [24.7136, 46.6753]
  }
}
```

---

## 3. Student Status Update (Picked Up / Dropped Off)
- **Sender:** Assistant or Driver
- **Receiver:** Guardian, Assistant, Driver
- **Trigger:** Assistant/Driver sends HTTP POST request to `/api/v1/students/{studentId}/boarded` or `/api/v1/students/{studentId}/dropped-off`.
- **WebSocket Event:** The server will broadcast this to the `trip_<trip_id>` room.
- **Payload Received by Client:**
```json
{
  "type": "student_status",
  "data": {
    "student_id": 1,
    "status": "boarded" // or "dropped-off"
  }
}
```

## How to use in Flutter:
1. Connect to `ws://<domain>/ws/trip/<trip_id>/?token=<your_jwt_token>`
2. Listen to the stream and parse JSON.
3. Switch based on the `"type"` field (`guardian_message`, `location_update`, `student_status`).
