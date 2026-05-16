# Students API Contract (Driver + Assistant)

## Primary Endpoint Used By Both Flows

- **Method:** `GET`
- **URL:** `/api/v1/routes/students`
- **Query param:** `direction=am|pm`

Example:

`GET http://37.27.204.174:8000/api/v1/routes/students?direction=am`

## Response Envelope (unchanged)

App accepts either:

```json
{
  "data": {
    "students": [/* array */]
  }
}
```

or

```json
{
  "students": [/* array */]
}
```

## Response Shape Before (current)

Current minimum student item shape in app:

```json
{
  "id": 123,
  "name": "Ahmed Mohsen",
  "grade": "Grade 2",
  "activePickup": {
    "description": "Abrag Othman, Building 3, Maadi.",
    "gMapsUrl": "https://maps.app.goo.gl/xxxx",
    "coords": [29.9651415, 31.2443606]
  }
}
```

## Response Shape After (requested)

Requested student item shape with additional fields:

```json
{
  "id": 123,
  "name": "Ahmed Mohsen",
  "grade": "Grade 2",
  "latestMessage": "Will be ready in 2 mins",
  "pinCodes": ["12345", "67890"],
  "droppedOff": false,
  "pickedUp": true,
  "guardianContact": {
    "primaryContactNum": "01012345678",
    "primaryContactRole": "mother",
    "secondaryContactNum": "01198765432",
    "secondaryContactRole": "father"
  },
  "activePickup": {
    "description": "Abrag Othman, Building 3, Maadi.",
    "gMapsUrl": "https://maps.app.goo.gl/xxxx",
    "coords": [29.9651415, 31.2443606]
  }
}
```

### Nullable secondary contact

`secondaryContactNum` and `secondaryContactRole` are nullable:

```json
{
  "guardianContact": {
    "primaryContactNum": "01012345678",
    "primaryContactRole": "mother",
    "secondaryContactNum": null,
    "secondaryContactRole": null
  }
}
```

## Use Case Requirements

### 1) Driver + Assistant Home (student carousel)

Required to render and operate actions:

- `name`
- `activePickup.description`
- `activePickup.gMapsUrl`
- `activePickup.coords`
- `pickedUp`
- `droppedOff`

### 2) Assistant Students Tab (full list)

Required to render cards + contact/status actions:

- `name`
- `grade`
- `pinCodes`
- `guardianContact.primaryContactNum`
- `guardianContact.primaryContactRole`
- `guardianContact.secondaryContactNum` (nullable)
- `guardianContact.secondaryContactRole` (nullable)
- `pickedUp`
- `droppedOff`
- `latestMessage`
- `activePickup.description`
- `activePickup.gMapsUrl`
- `activePickup.coords`

