table 80803 "SPB Filter Results Buffer"
{
    Caption = 'SPB Filter Results Buffer';
    DataClassification = SystemMetadata;
    TableType = Temporary;

    fields
    {
        field(1; "Master No."; Code[20])
        {
            Caption = 'Master No.';
            DataClassification = SystemMetadata;
        }
        field(2; "Sort By Code"; Code[200])
        {
            Caption = 'Sort By Code';
            DataClassification = SystemMetadata;
        }
        field(10; "Count Value"; Integer)
        {
            Caption = 'Count Value';
            DataClassification = SystemMetadata;
        }
        field(100; "Source RecordId"; Guid)
        {
            Caption = 'Source RecordId';
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(PK; "Master No.", "Sort By Code")
        {
            Clustered = true;
        }
        key(TopX; "Sort By Code", "Count Value")
        { }
    }
}
