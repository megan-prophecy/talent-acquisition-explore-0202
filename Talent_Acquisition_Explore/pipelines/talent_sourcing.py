from prophecy_pipeline_sdk.graph import *
from prophecy_pipeline_sdk.properties import *
args = PipelineArgs(
    label = "talent_sourcing",
    version = 1,
    auto_layout = False,
    params = Parameters(sourcer = "'Prime Placements'")
)

with Pipeline(args) as pipeline:
    talent_sourcing__application_stage_by_source = Process(
        name = "talent_sourcing__application_stage_by_source",
        properties = ModelTransform(modelName = "talent_sourcing__application_stage_by_source"),
        input_ports = ["in_0", "in_1", "in_2", "in_3"]
    )
    visualize_1 = Process(name = "Visualize_1", properties = Visualize())
    talent_sourcing__application_stage_by_source >> visualize_1
