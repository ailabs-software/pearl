import "package:pearl/PearlServlet.dart";

/** @fileoverview Main file for Pearl.
    Run in directory containing services/

    Dedicated to Pearl, Ella's loving dog.

    https://github.com/Leo-G/DevopsWiki/wiki/How-Linux-CPU-Usage-Time-and-Percentage-is-calculated
    Ported from script written by Paul Colby (http://colby.id.au)

 */

void main(List<String> arguments) async
{
  // Start management UI.
  ( new PearlServlet() ).main();
}
