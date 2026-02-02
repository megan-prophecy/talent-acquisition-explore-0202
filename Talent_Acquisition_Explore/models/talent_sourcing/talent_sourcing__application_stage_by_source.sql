{{
  config({    
    "materialized": "ephemeral",
    "database": "bowers_megan_prophecy_io_team",
    "schema": "schema"
  })
}}

WITH mapping_table AS (

  SELECT * 
  
  FROM {{ source('default_bowers_megan_prophecy_io_main', 'mapping_table') }}

),

recruiting_1 AS (

  SELECT * 
  
  FROM {{ source('default_bowers_megan_prophecy_io_main', 'recruiting_1') }}

),

recruiting_2 AS (

  SELECT * 
  
  FROM {{ source('default_bowers_megan_prophecy_io_main', 'recruiting_2') }}

),

Union_1 AS (

  SELECT * 
  
  FROM recruiting_1 AS in0
  
  UNION
  
  SELECT * 
  
  FROM recruiting_2 AS in1

),

parse_application_dates AS (

  {#Standardizes date formats for key recruitment and job application milestones.#}
  {{
    prophecy_basics.MultiColumnEdit(
      ['Union_1'], 
      "strptime(column_value, '%m/%d/%Y')", 
      [
        'Requisition ID', 
        'Opening ID', 
        'Department', 
        'Applied For', 
        'Recruiter', 
        'Coordinator', 
        'Source', 
        'Stage', 
        'Status', 
        'Application Date', 
        'Start Date (Application)', 
        'Rejection Date', 
        'Rejection Reason', 
        'Rejection Note', 
        'Created (Offer)', 
        'Status (Offer)', 
        'Offer Date', 
        'Sent', 
        'Start Date (Offer)', 
        'Close Date (Job)', 
        'Open Date (Job)', 
        'Status (Job)', 
        'Last Stage Change', 
        'Last Activity', 
        'Type', 
        'Resolved', 
        'Sourcing Strategy', 
        'Sourcers', 
        'Offices', 
        'Application ID'
      ], 
      [
        'Application Date', 
        'Start Date (Application)', 
        'Rejection Date', 
        'Offer Date', 
        'Start Date (Offer)', 
        'Close Date (Job)', 
        'Open Date (Job)'
      ], 
      false, 
      'Prefix', 
      ''
    )
  }}

),

application_stage_details AS (

  {#Provides detailed information on each job application, including its stage, status, recruiter, offer details, and mapped category, supporting recruitment process analysis and decision-making.#}
  SELECT 
    in0."Requisition ID" AS "Requisition ID",
    in0."Opening ID" AS "Opening ID",
    in0.Department AS Department,
    in0."Applied For" AS "Applied For",
    in0.Recruiter AS Recruiter,
    in0.Coordinator AS Coordinator,
    in0.Source AS Source,
    in0.Stage AS Stage,
    in0.Status AS Status,
    in0."Application Date" AS "Application Date",
    in0."Start Date (Application)" AS "Start Date (Application)",
    in0."Rejection Date" AS "Rejection Date",
    in0."Rejection Reason" AS "Rejection Reason",
    in0."Rejection Note" AS "Rejection Note",
    in0."Created (Offer)" AS "Created (Offer)",
    in0."Status (Offer)" AS "Status (Offer)",
    in0."Offer Date" AS "Offer Date",
    in0.Sent AS Sent,
    in0."Start Date (Offer)" AS "Start Date (Offer)",
    in0."Close Date (Job)" AS "Close Date (Job)",
    in0."Open Date (Job)" AS "Open Date (Job)",
    in0."Status (Job)" AS "Status (Job)",
    in0."Last Stage Change" AS "Last Stage Change",
    in0."Last Activity" AS "Last Activity",
    in0.Type AS Type,
    in0.Resolved AS Resolved,
    in0."Sourcing Strategy" AS "Sourcing Strategy",
    in0.Sourcers AS Sourcers,
    in0.Offices AS Offices,
    in0."Application ID" AS "Application ID",
    in1.Category AS Category,
    in1.Definition AS Definition
  
  FROM parse_application_dates AS in0
  INNER JOIN mapping_table AS in1
     ON in1.Stage = in0.Stage

),

calc_time_to_fill AS (

  {#Generates a detailed report on job applications, tracking their progress, status, and time taken to fill each job opening.#}
  SELECT 
    "Requisition ID" AS "Requisition ID",
    "Opening ID" AS "Opening ID",
    Department AS Department,
    "Applied For" AS "Applied For",
    Recruiter AS Recruiter,
    Coordinator AS Coordinator,
    Source AS Source,
    Stage AS Stage,
    Status AS Status,
    "Application Date" AS "Application Date",
    "Start Date (Application)" AS "Start Date (Application)",
    "Rejection Date" AS "Rejection Date",
    "Rejection Reason" AS "Rejection Reason",
    "Rejection Note" AS "Rejection Note",
    "Created (Offer)" AS "Created (Offer)",
    "Status (Offer)" AS "Status (Offer)",
    "Offer Date" AS "Offer Date",
    Sent AS Sent,
    "Start Date (Offer)" AS "Start Date (Offer)",
    "Close Date (Job)" AS "Close Date (Job)",
    "Open Date (Job)" AS "Open Date (Job)",
    "Status (Job)" AS "Status (Job)",
    "Last Stage Change" AS "Last Stage Change",
    "Last Activity" AS "Last Activity",
    Type AS Type,
    Resolved AS Resolved,
    "Sourcing Strategy" AS "Sourcing Strategy",
    Sourcers AS Sourcers,
    Offices AS Offices,
    "Application ID" AS "Application ID",
    Category AS Category,
    Definition AS Definition,
    DATEDIFF('day', "Open Date (Job)", "Close Date (Job)") AS "Time Open"
  
  FROM application_stage_details

),

application_stage_by_source AS (

  {#Shows application stage details filtered by a specific source, helping to assess performance of different applicant sources.#}
  SELECT * 
  
  FROM calc_time_to_fill AS application_stage_report
  
  WHERE Source = {{ var('sourcer') }}

)

SELECT *

FROM application_stage_by_source
