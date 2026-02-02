from prophecy_analysis_sdk import *
meta_info = MetaInfo(pipeline_id = "talent_sourcing")

with BusinessApp(app_id = "time_to_fill", meta_info = meta_info) as business_app:
    text_widget = TextWidget(
        content = "## Report Description\n\nAnalysis of recruiting agency and coordinator effectiveness for Q3 & Q4 2025"
    )
    dropdown = DropdownWidget(
        config_field = "sourcer", 
        label = "Sourcing Agency", 
        options = [DropdownOption(value = "Prime Placements", label = "Prime Placements"),          DropdownOption(value = "Global Talent Pro", label = "Global Talent Pro"),          DropdownOption(value = "Elite Headhunters", label = "Elite Headhunters"),          DropdownOption(value = "Apex Recruiters", label = "Apex Recruiters"),          DropdownOption(value = "The Recruiting Hub", label = "The Recruiting Hub"),          DropdownOption(value = "Syn", label = "Synergy Recruit"),          DropdownOption(value = "NextGen Staffing", label = "NextGen Staffing")], 
        config_type = "string", 
        default_value = "Prime Placements"
    )
    bar_chart = BarWidget(
        table_id = "Visualize_1", 
        title = "Average Days to Fill Position By Department", 
        x_axis_column = "Department", 
        y_axis_columns = [         YAxisColumn(
           name = "Time Open", 
           color = "#4c4ddc"
         )], 
        y_axis_config = None
    )
    pie_chart = PieWidget(
        table_id = "Visualize_1", 
        title = "Number of Positions Open by In-house Coordinator", 
        x_axis_column = "Coordinator", 
        y_axis_columns = [         YAxisColumn(
           name = "Time Open", 
           agg = AggregationType.COUNT, 
           color = "#4c4ddc"
         )], 
        center_y = 60, 
        angle = PieAngle.SEMI
    )
