# BC_DataGenerator
A Microsoft Dynamics 365 Business Central (#msdyn365bc) tool to help generate code to populate systems with data.

## Core Concept:

 Generate "Baseline datasets" that describe:
  - Tables
  - Fields
  - Filters
  - GDPR Anonymizers

Then the user can Export the Packages to make:  Codeunits per Package from Datasets, in which each does:
 - A function per Table, with params of the Fields, to create records
 - A function to generate records

Installer:
 - Generates standard packages
 - Financials, Sales, Purchasing, Inventory, Warehouse, Mfg, Service

Run the routine to Export, we get a ZIP file of AL files that contain the codeunits

## To do:
- Filtering logic
- Primary Key inclusion (forced)