import "dart:io";
import "package:jclosure/net/HttpMethod.dart" show HttpMethod;
import "package:jclosure/net/HttpStatus.dart" show HttpStatus;
import "package:dg6library/dg6platform/http/IHttpRequest.dart" show IHttpRequest;
import "package:dg6library/dg6platform/http/IHttpResponse.dart" show IHttpResponse;
import "package:dg6library/dg6platform/http/DartIOHttpRequest.dart" show DartIOHttpRequest;
import "package:dg6library/dg6platform/http/DartIOHttpResponse.dart" show DartIOHttpResponse;
import "package:pearl/constants.dart";

/** @fileoverview Provides user interface to Pearl.
 *
 *   Pearl is dedicated to Ella's doggie that had been doing such a job divinely inspiring,
 *   up until his little we heart gave up.
 *
 * */

class PearlServlet
{
  Future main() async
  {
    HttpServer server = await HttpServer.bind(InternetAddress.anyIPv4, PEARL_SERVLET_PORT_LISTEN);

    print("Listening on localhost: ${server.port}");

    await for (HttpRequest request in server)
    {
      _handle(new DartIOHttpRequest(request), new DartIOHttpResponse(request.response) );
    }
  }

  Future<Null> _handle(IHttpRequest req, IHttpResponse res) async
  {
    res.setHeader(HttpHeaders.contentTypeHeader, "text/html");

    res.writeln("<!DOCTYPE html>");
    res.writeln("<html>");
    res.writeln("<head>");
    res.writeln("<title>${PEARL_APPLICATION_TITLE}</title>");
    res.writeln("</head>");
    res.writeln("<body>");

    try {
      await _handleRoute(req, res);
    }
    catch(e, s) {
      _writeResponseError(res, e);
      print("Stack of failed request:");
      print( s.toString() );
    }

    res.writeln("</body>");
    res.writeln("</html>");

    res.end();
  }

  void _writeResponseError(IHttpResponse res, Object e)
  {
    try {
      res.write("<div>");
      res.write( e.toString() );
      res.write("</div>");
      res.write("<a href=\"/\">return</a>");
    }
    catch(e) {
      print("Error occurred writing error response: ${e}");
    }
  }

  Future<Null> _handleRoute(IHttpRequest req, IHttpResponse res) async
  {
    if (req.method == HttpMethod.GET) {
      await _handleGet(req, res);
    }
    else if (req.method == HttpMethod.POST) {
      await _handlePost(req, res);
    }
  }

  Future<Null> _handleGet(IHttpRequest req, IHttpResponse res) async
  {
    switch (req.path)
    {
      case PEARL_HOME_ROUTE:
        await _renderHome(req, res);
        break;
      default:
        res.setStatusCode(HttpStatus.StatusNotFound);
    }
  }

  Future<Null> _handlePost(IHttpRequest req, IHttpResponse res) async
  {
    print("Got a post!");
  }

  void _renderActionButton(IHttpResponse res, String buttonTitle, String buttonAction, Map<String, String> parameters)
  {
    Uri actionUri = new Uri(pathSegments: ["command", buttonAction], queryParameters: parameters);

    res.write("<form method=\"POST\" action=\"${actionUri}\" enctype=\"multipart/form-data\">");
    res.write("<button onClick='event.preventDefault(); this.disabled = true; this.parentElement.submit();'>${buttonTitle}</button>");
    res.write("</form>");
  }

  /** Returns to home */
  void _redirectToHome(IHttpResponse res)
  {
    res.redirect(HttpStatus.StatusFound, PEARL_HOME_ROUTE);
  }

  void _renderHome(IHttpRequest req, IHttpResponse res)
  {
    res.write("<h1>Welcome to PEARL</h1>");
    res.write("<h4>Programmable Engine for Analysis of Resources & Logs</h4>");

    _renderModules(req, res);
  }

  void _renderModules(IHttpRequest req, IHttpResponse res)
  {
    /*for (TandemServiceModel serviceModel in _servicesModel.services)
    {
      _renderService(res);
    }*/
  }

  /** Render an individual module */
  void _renderModule(IHttpResponse res)
  {
    res.write("<div class=\"tandem-service\" style=\"margin: 15px\">");
  //  res.write("<h3>${serviceModel.serviceName}</h3>");
    res.write("</div>");
  }
}
