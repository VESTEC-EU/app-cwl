#!/usr/bin/env cwl-runner
# -*- mode: yaml; -*-

cwlVersion: v1.1
class: CommandLineTool
$namespaces:
  cwltool: http://commonwl.org/cwltool#

hints:
  SoftwareRequirement:
    packages:
      WildFireAnalyst:
        version: ["vestec"]

requirements:
  SchemaDefRequirement:
    types:
      - $import: geo.yml
      - $import: wfa_out.yml

  InlineJavascriptRequirement:
    expressionLib:
      - $include: wfa.js

  cwltool:MPIRequirement:
    processes: $(inputs.mpi_processes)

  EnvVarRequirement:
    envDef:
      OMP_NUM_THREADS: $(inputs.omp_threads.toString())

  InitialWorkDirRequirement:
    listing:
      - $(inputs.fuel_geotiff)
      - $(inputs.mdt_geotiff)
      - $(inputs.weather_data)
      - $(inputs.dynamic_config)
      - $(inputs.catalyst_script)
      - class: Directory
        listing: []
        basename: OUT
      - entryname: config.json
        entry: |
          {
            "simName": "$(inputs.sim_name)",
            "simDuration": $(inputs.sim_duration),
            "timeIndex": $(inputs.start_time),
            "numberSims": $(inputs.sims_per_rank),
            "domain":[
              $(inputs.upperleft.lat),
              $(inputs.lowerright.lat),
              $(inputs.upperleft.lon),
              $(inputs.lowerright.lon)
            ],
            "cores": -1,
            "validation": false,
            "cellsizeFactor": 1,
            "loopsPerSync": 1,
            "loopsPerConfiUpdate": 1,
            "lifeFuelMoisture": 0.1,
            "outputFolder": "OUT/",
            "pathUpdates": "$(inputs.dynamic_config.basename)",
            "pathFlag": "flag.txt",
            "pathCBD": "",
            "pathCBH": "",
            "pathCC": "",
            "pathCH": "",
            "pathFuel": "$(inputs.fuel_geotiff.basename)",
            "pathMdt": "$(inputs.mdt_geotiff.basename)",
            "pathWeatherWrfout": "$(inputs.weather_data.basename)",
            "pathCatalystScript": "$(inputs.catalyst_script.basename)"
          }

inputs:
  mpi_processes:
    type: int
  omp_threads:
    type: int

  sim_name:
    type: string
    default: Vestec
  sim_duration:
    type: float
    label: Simulation duration in hours
  start_time:
    type: float
    label: start time from beginning of the weather data (hours)

  sims_per_rank:
    type: int
    label: the number of simulations per MPI rank

  upperleft:
    type: geo.yml#point
  lowerright:
    type: geo.yml#point

  fuel_geotiff:
    type: File
    label: Input fuel geotiff
  mdt_geotiff:
    type: File
    label: Input MDT geotiff

  weather_data:
    type: File
    label: Weather NetCDF file

  dynamic_config:
    type: File
    label: WFA dynamic configuration

  catalyst_script:
    type: File
    label: Script to pass to ParaView Catalyst

baseCommand: [WildFire, config.json]

outputs:
  logs:
    type: File[]
    outputBinding:
      glob: OUT/$(inputs.sim_name)_LOG_*.txt

  data:
    type: File[]
    outputBinding:
      glob: OUT/$(inputs.sim_name)_*_*.tif
      
  best_conditions:
    type: File
    outputBinding:
      glob: OUT/$(inputs.sim_name)_Best_Conditions.json

  catalyst_output_vtx:
    type: File[]
    outputBinding:
      glob: CatalystOutput/*.*vt*

  catalyst_output_persistenceDiagrams:
    type: File[]
    outputBinding:
      glob: CatalystOutput/persistenceDiagrams.cdb/data/*.*vt*
