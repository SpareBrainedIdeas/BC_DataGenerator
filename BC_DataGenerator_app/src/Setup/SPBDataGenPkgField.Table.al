table 80802 "SPB DataGen Pkg. Field"
{
    Caption = 'DataGen Pkg. Field';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Package Code"; Code[10])
        {
            Caption = 'Package Code';
            DataClassification = SystemMetadata;
            TableRelation = "SPB DataGen Package".Code;
        }
        field(2; "Table Id"; Integer)
        {
            Caption = 'Table Id';
            DataClassification = SystemMetadata;
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Table));
        }
        field(3; "Field No."; Integer)
        {
            Caption = 'Field No.';
            DataClassification = SystemMetadata;
            TableRelation = Field."No." where(TableNo = field("Table Id"));
        }
        field(11; Include; Boolean)
        {
            Caption = 'Include';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if Include then
                    TryCheckForRelations();
            end;
        }
        field(12; Anonymize; Boolean)
        {
            Caption = 'Anonymize';
            DataClassification = ToBeClassified;
        }
        field(20; "Processing Order"; Integer)
        {
            Caption = 'Processing Order';
            DataClassification = SystemMetadata;
        }
        field(30; "Filter"; Text[250])
        {
            Caption = 'Filter';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                TestNewFilterText("Filter");
            end;
        }
        field(40; "Is Normal Field"; Boolean)
        {
            Caption = 'Is Normal Field';
            DataClassification = SystemMetadata;
        }
        field(1001; "Field Name"; Text[250])
        {
            Caption = 'Field Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Field.FieldName where(TableNo = field("Table Id"), "No." = field("Field No.")));
        }
    }
    keys
    {
        key(PK; "Package Code", "Table Id", "Field No.")
        {
            Clustered = true;
        }
        key(Processing; "Package Code", "Table Id", "Processing Order")
        {

        }
    }

    local procedure TestNewFilterText(var Filter: Text[250])
    var
        RecRef: RecordRef;
        FieldsRef: FieldRef;
    begin
        // Get the Record ref for the table
        RecRef.Open(Rec."Table Id");

        // Get the FieldRef for this field
        FieldsRef := RecRef.Field(Rec."Field No.");

        // Apply the filter to it
        FieldsRef.SetFilter("Filter");

        // update the filter to the 'processed' value
        "Filter" := FieldsRef.GetFilter();
    end;

    internal procedure GetFieldRef(var ThisFieldRef: FieldRef): Boolean
    var
        LineRef: RecordRef;
    begin
        if "Table Id" = 0 then
            exit(false);
        if "Field No." = 0 then
            exit(false);

        LineRef.Open("Table Id");
        ThisFieldRef := LineRef.Field("Field No.");
        exit(true);
    end;

    internal procedure GetFieldTypeString(): Text
    var
        FldRef: FieldRef;
        TypeLenDescriptionTok: Label '%1[%2]', Locked = true;
    begin
        if not GetFieldRef(FldRef) then
            exit('');

        case FldRef.Type of
            FieldType::Code,
            FieldType::Text:
                exit(StrSubstNo(TypeLenDescriptionTok, Format(FldRef.Type), FldRef.Length));
            else
                exit(Format(FldRef.Type))
        end;
    end;


    internal procedure IsSupported() Supported: Boolean
    var
        FldRef: FieldRef;
    begin
        if not GetFieldRef(FldRef) then
            exit(false);
        Supported := FldRef.Type in
            [FieldType::Boolean,
                FieldType::Date,
                //FieldType::Time,
                FieldType::DateTime,
                FieldType::Decimal,
                FieldType::Integer,
                FieldType::Option,
                FieldType::Guid,
                FieldType::Code,
                FieldType::Text,
                FieldType::BigInteger
                ]
    end;


    local procedure TryCheckForRelations()
    var
        Fields: Record Field;
        AllObjWithCaptions: Record AllObjWithCaption;
        SPBDataGenPkgTable: Record "SPB DataGen Pkg. Table";
        AddMissingRelatedTableQst: Label 'Add the %1 table (related to Field %2) to the DataGen Package?';
    begin
        if (Rec."Table Id" = 0) or (Rec."Field No." = 0) then
            exit;
        CalcFields("Field Name");
        Fields.SetRange(TableNo, Rec."Table Id");
        Fields.SetRange("No.", Rec."Field No.");
        if Fields.FindFirst() and (Fields.RelationTableNo <> 0) then begin
            SPBDataGenPkgTable.SetRange("Package Code", rec."Package Code");
            SPBDataGenPkgTable.SetRange("Table Id", Fields.RelationTableNo);
            if SPBDataGenPkgTable.IsEmpty then begin
                AllObjWithCaptions.SetRange("Object Type", AllObjWithCaptions."Object Type"::Table);
                AllObjWithCaptions.SetRange("Object ID", Fields.RelationTableNo);
                if AllObjWithCaptions.FindFirst() then;
                if AssumeAddRelations or Confirm(AddMissingRelatedTableQst, true, AllObjWithCaptions."Object Name", Rec."Field Name") then begin
                    SPBDataGenPkgTable.Init();
                    SPBDataGenPkgTable."Package Code" := Rec."Package Code";
                    SPBDataGenPkgTable."Table Id" := Fields.RelationTableNo;
                    SPBDataGenPkgTable.Insert(true);
                end;
            end;
        end;
    end;

    procedure SetAsssumeAddRelations(newAssumeAddRelations: Boolean)
    begin
        AssumeAddRelations := newAssumeAddRelations;
    end;

    var
        AssumeAddRelations: Boolean;
}
