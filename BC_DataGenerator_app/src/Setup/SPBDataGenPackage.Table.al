table 80800 "SPB DataGen Package"
{
    Caption = 'DataGen Package';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; Code; Code[10])
        {
            Caption = 'Code';
            DataClassification = SystemMetadata;
        }
        field(10; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(20; "Codeunit No."; Integer)
        {
            Caption = 'Codeunit No.';
            DataClassification = SystemMetadata;
        }
        field(30; "Include BeforeInserts"; Boolean)
        {
            Caption = 'Include BeforeInserts';
            DataClassification = SystemMetadata;
        }
        field(31; "Include AfterInserts"; Boolean)
        {
            Caption = 'Include AfterInserts';
            DataClassification = SystemMetadata;
        }
        field(1000; "Tables Included"; Integer)
        {
            CalcFormula = count("SPB DataGen Pkg. Table" where("Package Code" = field(Code)));
            Caption = 'Tables Included';
            Editable = false;
            FieldClass = FlowField;
        }
    }
    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }

    procedure BuildFilename(): Text
    var
        SPBDataGenUtilities: Codeunit "SPB DataGen Utilities";
        CodeunitNameTok: Label '%1.Codeunit.al';
    begin
        exit(StrSubstNo(CodeunitNameTok, SPBDataGenUtilities.SafeName(Description)));
    end;
}
