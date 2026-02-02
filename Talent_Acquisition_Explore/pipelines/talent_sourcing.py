from prophecy_pipeline_sdk.graph import *
from prophecy_pipeline_sdk.properties import *
configuration = {
    "schema": {
      "type": "record",
      "fields": [{"name" : "sourcer", "kind" : {"type" : "string", "value" : "'Prime Placements'"}}]
    },
    "parameterSets": []
}
metainfo = PipelineGraphMetadata(
    label = "talent_sourcing",
    version = 1,
    configuration = configuration,
    schedule = None,
    sensor_schedule = None,
)

with PipelineGraph(id = "talent_sourcing", metainfo = metainfo) as graph:
    talent_sourcing__application_stage_by_source = PipelineProcess(
        name = "talent_sourcing__application_stage_by_source",
        metadata = PipelineNodeMetadata(phase = 0),
        properties = GemProperties.ModelTransformSpecProperties(modelName = "talent_sourcing__application_stage_by_source"),
        ports = Ports(
          inputs = [Port(name = "in_0"), Port(name = "in_1"), Port(name = "in_2"), Port(name = "in_3")],
          outputs = [Port(name = "out_0")],
          is_custom_output_schema = False
        )
    )
    visualize_1 = PipelineProcess(
        name = "Visualize_1",
        metadata = PipelineNodeMetadata(phase = 0),
        properties = GemProperties.VisualizeSpecProperties(),
        ports = Ports(inputs = [Port(name = "application_stage_by_source")], outputs = [Port(name = "out0")])
    )
    talent_sourcing__application_stage_by_source >> visualize_1
