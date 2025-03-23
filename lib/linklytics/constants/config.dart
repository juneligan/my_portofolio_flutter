import 'dart:html' as html;

String getCurrentDomain() {
  return html.window.location.host; // Gets the domain
}