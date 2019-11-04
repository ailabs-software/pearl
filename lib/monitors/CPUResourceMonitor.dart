import "dart:io";

/** @fileoverview Monitors CPU usage periodically */

class CPUResourceMonitor
{
  static const Duration PEARL_MONITOR_SLEEP_DURATION = const Duration(seconds: 10);

  Map<String, int> prevIdleMap = {};
  Map<String, int> prevTotalMap = {};
  Map<String, double> cpuUsageMap = {};

  Future<Null> run() async
  {
    while (true)
    {
      // Get the total CPU statistics, discarding the 'cpu ' prefix.
      File statFile = new File("/proc/stat");

      List<String> procStatLines = statFile.readAsLinesSync();

      for (String procStatLine in procStatLines)
      {
        // stop at end of cpu stats
        if ( !procStatLine.startsWith("cpu") ) {
          continue;
        }

        // get as stat numbers.
        List<String> statValuesString = procStatLine.split( new RegExp(r"[ ]+") );

        String cpuName = statValuesString.first;

        // read stats from map.
        int prevIdle = prevIdleMap[cpuName] ?? 0;
        int prevTotal = prevTotalMap[cpuName] ?? 0;

        int idle = int.parse(statValuesString[4]);

        // Calculate the total CPU time.
        int total = 0;

        for (int i = 1; i < statValuesString.length; i++)
        {
          total += int.parse(statValuesString[i]);
        }

        // Calculate the CPU usage since we last checked.
        int diffIdle = idle - prevIdle;
        int diffTotal = total - prevTotal;
        double diffUsage = (1000 * (diffTotal - diffIdle) / diffTotal + 5) / 10;

        cpuUsageMap[cpuName] = diffUsage;

        // Remember the total and idle CPU times for the next check.
        prevIdleMap[cpuName] = idle;
        prevTotalMap[cpuName] = total;
      }

      _printCurrentCpuUsage();

      // Wait before checking again.
      await new Future.delayed(PEARL_MONITOR_SLEEP_DURATION);
    }
  }

  void _printCurrentCpuUsage()
  {
    stdout.write("${cpuUsageMap}\r");
  }
}