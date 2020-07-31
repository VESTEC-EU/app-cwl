# Tool descriptions for Wildfire use case

The workflow is:

1. Extract subset of world physiographic data to domain of interest

2. Extract initial/boundary condition weather data from global forecasts (GFS)

3. Run MesoNH simulation

4. Post process results into form needed by WFA (NetCDF file)

5. Run WFA

6. Post process WFA image data


## Time

Some care has to be taken to ensure that the tools all have a
consistent description of time dimenstion.

Terms: a *time* is moment in the (simulated) world and a *duration* is
the length of (simulated) between two *times*.

MesoNH:

* tell it the duration (in seconds) of the simulation segment to
perform

* It starts its simulation from the time of the initial GFS input file
and runs until `time = time(initial forecast) + duration(segment_length)`.

* the MesoNH set up via CWL, as is, can only deal with two input
  forecasts/analyses - more can be potentially be added - see
  https://github.com/VESTEC-EU/app-cwl/issues/1

WFA:

* takes an integer parameter `timeIndex` which is the index into the
  weather NetCDF time dimension where the sim starts. For example,
  since the time inteval of the NetCDF is 1 hour, timeIndex=7 means that
  the simulation will start 7 hours after the start date of the NetCDF file.

* WFA assumes the NetCDF time interval is 1 hour.

* `simDurationOutput` is the duration, in hours, the user defines for a simulation

* `simDuration` is the actual duration, in hours, of the simulation used
  internally by WFA. This should be 3 times `simDurationOutput`. (The
  reason to use longer durations internally is because the probabilistic
  output needs all simulations to cover most of the domain to do the statistical analysis.)

Forecast data:
* GFS forecasts are run (published?) every 6hrs at 00:00, 06:00,
  12:00, 18:00 UTC (wallclock) spanning 384 hourly (simulation time) snapshots

Given we want a fire simuation from `time(start fire)` to `time(stop fire)`,
then the following holds (working backwards):

  * WFA

    - `simDurationOutput` must be time(stop) - time(start) = user defined duration in hours

    - `simDuration` must be `3 * simDurationOutput`

    - `timeIndex` is zero, WLOG (since the simulation will start at the same time as the NetCDF starting date)

  * MesoNH

    - `duration(output period)` is 1 hour (`XBAK_TIME_FREQ = 3600`)

    - `duration(time for first output)` is `time(fire start) - time(initial forecast)` (`XBAK_TIME_FREQ_FIRST`)

* Initial forecast data selection

  - round `time(start fire)` *down* to nearest UTC hour - this is
	`time(initial forecast)`

  - choose the GFS forecast/analysis which has this as its lowest
	index snapshot (round hour down to nearest 6 to get time of the
	"best" possibility)

* Second forecast data selection

  - round `time(end fire)` *up* to nearest UTC hour - this is `time(second forecast)`
  
  - as above choose the forecast which has our rounded end time
	as the lowest non-negative index
  
