import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

/// Parses Google Maps URLs (full or shortened) and extracts LatLng coordinates.
///
/// Supports formats like:
/// - https://www.google.com/maps/@40.7128,-74.0060,15z
/// - https://www.google.com/maps/place/Name/@40.7128,-74.0060,17z
/// - https://www.google.com/maps?q=40.7128,-74.0060
/// - https://maps.app.goo.gl/xxxxx (shortened, requires network call)
///
/// Returns null if no coordinates are found or if the URL is invalid.
Future<LatLng?> parseGmapsUrl(String url) async {
  try {
    String finalUrl = url;
    String? html;

    // If it's a shortened URL (goo.gl or maps.app.goo.gl), follow the redirect
    if (url.contains('goo.gl') || url.contains('maps.app.goo.gl')) {
      final resolved = await _resolveShortUrl(url);
      finalUrl = resolved.finalUrl;
      html = resolved.html;
    }

    // Try multiple parsing strategies
    LatLng? coords;

    // 1. Check for @lat,lng pattern (most common)
    coords ??= _parseAtPattern(finalUrl);

    // 2. Check query parameters (q, ll, center)
    coords ??= _parseQueryParams(finalUrl);

    // 3. Check /place/ pattern
    coords ??= _parsePlacePattern(finalUrl);

    // 4. Check data parameters like !3d..!4d..
    coords ??= _parseDataPattern(finalUrl);

    // If still null and we have HTML from a short URL, try parsing from that too
    if (coords == null && html != null) {
      coords ??= _parseDataPattern(html);
    }

    return coords;
  } catch (e) {
    return null;
  }
}

/// Resolves a shortened Google Maps URL by following the redirect.
Future<({String finalUrl, String? html})> _resolveShortUrl(String shortUrl) async {
  try {
    final uri = Uri.parse(shortUrl);

    // 1) Some endpoints expose redirect via HEAD.
    final headResponse = await http.head(uri);
    final headLocation = headResponse.headers['location'];
    if (headLocation != null && headLocation.isNotEmpty) {
      return (finalUrl: headLocation, html: null);
    }

    // 2) Fallback to GET: package:http follows redirects and gives us the final URL.
    final getResponse = await http.get(uri);
    final finalUri = getResponse.request?.url;
    if (finalUri != null && finalUri.toString().isNotEmpty) {
      final finalUrl = finalUri.toString();
      if (finalUrl != shortUrl) {
        return (finalUrl: finalUrl, html: getResponse.body);
      }
    }

    // 3) Last fallback: parse HTML for a maps URL (meta refresh / js redirects).
    final htmlResolved = _extractMapsUrlFromHtml(getResponse.body);
    if (htmlResolved != null) {
      return (finalUrl: htmlResolved, html: getResponse.body);
    }

    return (finalUrl: shortUrl, html: getResponse.body);
  } catch (e) {
    return (finalUrl: shortUrl, html: null);
  }
}

String? _extractMapsUrlFromHtml(String html) {
  // Common case: absolute maps URL embedded in html.
  final abs = RegExp("https://(?:www\\.)?google\\.[^\\s\"']*/maps[^\\s\"']*");
  final absMatch = abs.firstMatch(html);
  if (absMatch != null) {
    return absMatch.group(0);
  }

  // Fallback: relative /maps/... path; resolve against google.com.
  final rel = RegExp("(/maps[^\\s\"']*)");
  final relMatch = rel.firstMatch(html);
  if (relMatch != null) {
    return 'https://www.google.com${relMatch.group(0)}';
  }

  return null;
}

/// Parses coordinates from @lat,lng patterns.
/// Example: /@40.7128,-74.0060,15z or /@40.7128,-74.0060
LatLng? _parseAtPattern(String url) {
  final regex = RegExp(r'@(-?\d+(?:\.\d+)?),(-?\d+(?:\.\d+)?)');
  final match = regex.firstMatch(url);
  if (match != null) {
    final lat = double.tryParse(match.group(1)!);
    final lng = double.tryParse(match.group(2)!);
    if (lat != null && lng != null) {
      return LatLng(lat, lng);
    }
  }
  return null;
}

/// Parses coordinates from query parameters (q, ll, center).
/// Example: ?q=40.7128,-74.0060 or ?ll=40.7128,-74.0060
LatLng? _parseQueryParams(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null) return null;

  // Try 'q' parameter
  String? coordString = uri.queryParameters['q'];
  coordString ??= uri.queryParameters['ll'];
  coordString ??= uri.queryParameters['center'];
  coordString ??= uri.queryParameters['query'];

  if (coordString != null) {
    coordString = coordString.trim();
    if (coordString.startsWith('loc:')) {
      coordString = coordString.substring(4);
    }
    final parts = coordString.split(',');
    if (parts.length >= 2) {
      final lat = double.tryParse(parts[0].trim());
      final lng = double.tryParse(parts[1].trim());
      if (lat != null && lng != null) {
        return LatLng(lat, lng);
      }
    }
  }
  return null;
}

/// Parses coordinates from /place/ URLs.
/// Example: /place/Name/@40.7128,-74.0060,17z
LatLng? _parsePlacePattern(String url) {
  // Place URLs typically have the same @lat,lng pattern, so this is covered by _parseAtPattern
  // This is a fallback for any edge cases
  return _parseAtPattern(url);
}

/// Parses coordinates from data parameters like !3d.. !4d..
LatLng? _parseDataPattern(String text) {
  // Common data payload pattern in many place links.
  final regex34 = RegExp(r'!3d(-?\d+(?:\.\d+)?)!4d(-?\d+(?:\.\d+)?)');
  final match34 = regex34.firstMatch(text);
  if (match34 != null) {
    final lat = double.tryParse(match34.group(1)!);
    final lng = double.tryParse(match34.group(2)!);
    if (lat != null && lng != null) {
      return LatLng(lat, lng);
    }
  }

  // Seen in named place links where preview payload stores lon then lat.
  final regex23 = RegExp(r'!2d(-?\d+(?:\.\d+)?)!3d(-?\d+(?:\.\d+)?)');
  final match23 = regex23.firstMatch(text);
  if (match23 != null) {
    final lng = double.tryParse(match23.group(1)!);
    final lat = double.tryParse(match23.group(2)!);
    if (lat != null && lng != null) {
      return LatLng(lat, lng);
    }
  }

  return null;
}

