import 'dart:developer' as console;
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MoleculeViewer extends StatefulWidget {
  final String moleculeId;
  final String format; // 'pdb' or 'cif'

  const MoleculeViewer({
    super.key,
    required this.moleculeId,
    this.format = 'pdb', // Default format
  });

  @override
  State<MoleculeViewer> createState() => _MoleculeViewerState();
}

class _MoleculeViewerState extends State<MoleculeViewer> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    console.log("Initializing MoleculeViewer for ${widget.moleculeId}");

    var html = '''
      <!DOCTYPE html>
      <html lang="en">
      <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no, maximum-scale=1.0, minimum-scale=1.0">
          <style>
              * { 
                  margin: 0; 
                  padding: 0; 
                  box-sizing: border-box; 
                  -webkit-touch-callout: none;
                  -webkit-user-select: none;
                  -khtml-user-select: none;
                  -moz-user-select: none;
                  -ms-user-select: none;
                  user-select: none;
              }
              html, body { 
                  width: 100%; 
                  height: 100%; 
                  overflow: hidden; 
                  font-family: Arial, sans-serif;
                  touch-action: none; /* Prevent all default touch behaviors */
                  -webkit-overflow-scrolling: touch;
              }
              #container { 
                  width: 100%; 
                  height: 100%; 
                  position: absolute; 
                  background-color: #f0f0f0;
                  touch-action: none; /* Critical for touch handling */
                  -webkit-touch-callout: none;
                  -webkit-user-select: none;
              }
              canvas {
                  touch-action: none !important; /* Ensure canvas handles all touch events */
                  -webkit-touch-callout: none;
                  -webkit-user-select: none;
              }
              #loading {
                  position: absolute;
                  top: 50%;
                  left: 50%;
                  transform: translate(-50%, -50%);
                  text-align: center;
                  z-index: 10;
                  color: #666;
                  pointer-events: none;
              }
              #error {
                  position: absolute;
                  top: 50%;
                  left: 50%;
                  transform: translate(-50%, -50%);
                  text-align: center;
                  color: #d32f2f;
                  background: white;
                  padding: 20px;
                  border-radius: 8px;
                  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
                  display: none;
                  pointer-events: none;
              }
              #controls-hint {
                  position: absolute;
                  bottom: 10px;
                  left: 10px;
                  background: rgba(0,0,0,0.7);
                  color: white;
                  padding: 8px 12px;
                  border-radius: 4px;
                  font-size: 12px;
                  z-index: 5;
                  opacity: 0;
                  transition: opacity 0.3s;
                  pointer-events: none;
              }
              #controls-hint.show {
                  opacity: 1;
              }
          </style>
          <title>Model of ${widget.moleculeId}</title>
      </head>
      <body>
          <div id="loading">Loading molecular viewer...</div>
          <div id="error"></div>
          <div id="container"></div>
          <div id="controls-hint">Touch to bring up atom info.</div>
      
          <script type="text/javascript" src="https://cdn.jsdelivr.net/gh/arose/ngl@v0.10.4-1/dist/ngl.js"></script>
      
          <script>
              console.log("Starting NGL initialization");
              
              // Prevent default touch behaviors globally
              document.addEventListener('touchstart', function(e) {
                  // Don't prevent default - let NGL handle it
              }, { passive: false });
              
              document.addEventListener('touchmove', function(e) {
                  e.preventDefault(); // Prevent scrolling
              }, { passive: false });
              
              document.addEventListener('touchend', function(e) {
                  // Don't prevent default - let NGL handle it
              }, { passive: false });
              
              function showError(message) {
                  console.error("Error:", message);
                  document.getElementById('loading').style.display = 'none';
                  const errorDiv = document.getElementById('error');
                  errorDiv.innerHTML = '<h3>Error Loading Molecule</h3><p>' + message + '</p>';
                  errorDiv.style.display = 'block';
              }
              
              function hideLoading() {
                  document.getElementById('loading').style.display = 'none';
                  // Show controls hint for a few seconds
                  const hint = document.getElementById('controls-hint');
                  hint.classList.add('show');
                  setTimeout(() => {
                      hint.classList.remove('show');
                  }, 4000);
              }
              
              // Wait for DOM to be fully loaded and NGL to be available
              function initializeViewer() {
                  try {
                      console.log("Checking if NGL is available...");
                      
                      if (typeof NGL === 'undefined') {
                          throw new Error("NGL library failed to load");
                      }
                      
                      console.log("NGL library loaded successfully");
                      
                      // Verify container exists
                      const containerElement = document.getElementById("container");
                      if (!containerElement) {
                          throw new Error("Container element not found");
                      }
                      
                      console.log("Container element found, initializing stage...");
                      
                      // Create NGL stage with tooltips enabled
                      var stage = new NGL.Stage("container", {
                          backgroundColor: "white",
                          quality: "medium",
                          workerDefault: true,
                          impostor: true,
                          antialias: true,
                          tooltip: true  // Enable tooltips
                      });
                      
                      // stage.mouseControls.add( "drag-left+right", NGL.MouseActions.zoomDrag );
                      stage.setSpin(true);
                      
                      console.log("Stage created with tooltips enabled, loading molecule...");
                      
                      const moleculeUri = "https://files.rcsb.org/view/${widget.moleculeId}.${widget.format}";
                      console.log("Loading from:", moleculeUri);
                      
                      // Load the molecular structure
                      stage.loadFile(moleculeUri)
                          .then(function (component) {
                              console.log("Molecule loaded successfully");
                              hideLoading();
                              
                              // Add cartoon representation for proteins
                              component.addRepresentation("cartoon", {
                                  color: "chainname",
                                  quality: "medium"
                              });
                              
                              // Add ball+stick for small molecules with tooltips
                              if (component.structure.atomCount < 1000) {
                                  component.addRepresentation("ball+stick", {
                                      multipleBond: true,
                                      radiusScale: 0.8,
                                      quality: "medium"
                                  });
                              }
                              
                              // Enable tooltips for the component
                              component.setTooltip = true;
                              
                              // Center and fit the molecule
                              component.autoView();
                              
                              console.log("Visualization complete");
                          })
                          .catch(function (error) {
                              showError("Failed to load molecule: " + error.message + "<br>Molecule ID: ${widget.moleculeId}");
                          });
                          
                  } catch (error) {
                      showError("Failed to initialize viewer: " + error.message);
                  }
              }
              
              // Multiple initialization strategies
              if (document.readyState === 'loading') {
                  document.addEventListener('DOMContentLoaded', function() {
                      console.log("DOM loaded, waiting for NGL...");
                      setTimeout(initializeViewer, 500);
                  });
              } else {
                  console.log("DOM already loaded, initializing...");
                  setTimeout(initializeViewer, 500);
              }
              
              // Fallback timeout
              setTimeout(function() {
                  if (document.getElementById('loading').style.display !== 'none') {
                      showError("Viewer initialization timed out. Please check your internet connection and try again.");
                  }
              }, 15000);
          </script>
      </body>
      </html>
    ''';

    console.log("HTML content prepared");

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            console.log("Page started loading: $url");
          },
          onPageFinished: (String url) {
            console.log("Page finished loading: $url");
            // Inject additional touch handling after page loads
            controller.runJavaScript('''
              // Ensure all touch events are properly handled
              const container = document.getElementById('container');
              if (container) {
                container.addEventListener('touchstart', function(e) {
                  console.log('Touch start detected');
                }, { passive: true });
                
                container.addEventListener('touchmove', function(e) {
                  console.log('Touch move detected');
                }, { passive: true });
              }
            ''');
          },
          onWebResourceError: (WebResourceError error) {
            console.log("Web resource error: ${error.description}");
          },
        ),
      );

    try {
      controller.loadHtmlString(html);
      console.log("HTML string loaded into WebView");
    } catch (e) {
      console.log("Error loading HTML string: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // Removed fixed height - component will now adapt to parent size
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: WebViewWidget(
          controller: controller,
        ),
      ),
    );
  }
}