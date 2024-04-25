table 80801 "SPB DataGen Pkg. Table"
{
    Caption = 'DataGen Pkg. Table';
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

        field(20; "Maximum Records"; Integer)
        {
            Caption = 'Maximum Records';
            DataClassification = SystemMetadata;
            BlankZero = true;
        }

        field(100; "Apply Codeunit Filtering"; enum "SPB Special Filtering Options")
        {
            Caption = 'Apply Codeunit Filtering';
            DataClassification = SystemMetadata;
        }
        field(101; "Filter Setting 1"; Integer)
        {
            Caption = 'Filter Setting 1';
            DataClassification = SystemMetadata;
        }
        field(102; "Filter Setting 2"; Integer)
        {
            Caption = 'Filter Setting 2';
            DataClassification = SystemMetadata;
        }

        field(1000; "Table Name"; Text[30])
        {
            Caption = 'Table Name';
            FieldClass = FlowField;
            CalcFormula = lookup(AllObjWithCaption."Object Name" where("Object Type" = const(table), "Object ID" = field("Table Id")));
        }

        field(1001; "Included Field Count"; Integer)
        {
            FieldClass = FlowField;
            Editable = false;
            Caption = 'Included Field Count';
            CalcFormula = count("SPB DataGen Pkg. Field" where("Package Code" = field("Package Code"), "Table Id" = field("Table Id"), Include = const(true)));
        }
        field(1002; "Total Field Count"; Integer)
        {
            FieldClass = FlowField;
            Editable = false;
            Caption = 'Field Count';
            CalcFormula = count("SPB DataGen Pkg. Field" where("Package Code" = field("Package Code"), "Table Id" = field("Table Id")));
        }
    }
    keys
    {
        key(PK; "Package Code", "Table Id")
        {
            Clustered = true;
        }
    }


    trigger OnInsert()
    begin
        CalcFields("Total Field Count");
        if "Total Field Count" = 0 then
            PopulateFieldList();
    end;

    trigger OnDelete()
    begin
        DeleteRelatedData();
    end;

    procedure PopulateFieldList()
    var
        SPBDataGenField: Record "SPB DataGen Pkg. Field";
        RecRef: RecordRef;
        FieldsRef: FieldRef;
        i: Integer;
    begin
        if Rec."Table Id" <> 0 then begin
            SPBDataGenField.SetRange("Package Code", Rec."Package Code");
            SPBDataGenField.SetRange("Table Id", Rec."Table Id");
            if SPBDataGenField.IsEmpty then begin
                // Populate the dataset
                RecRef.Open(Rec."Table Id");
                for i := 1 to RecRef.FieldCount do begin
                    FieldsRef := RecRef.FieldIndex(i);
                    SPBDataGenField.Init();
                    SPBDataGenField."Package Code" := Rec."Package Code";
                    SPBDataGenField."Table Id" := Rec."Table Id";
                    SPBDataGenField."Field No." := FieldsRef.Number;
                    SPBDataGenField."Is Normal Field" := FieldsRef.Class in [FieldClass::Normal];
                    SPBDataGenField.Include := SPBDataGenField."Is Normal Field";
                    SPBDataGenField.Insert(true);
                end;
                Commit(); // To Allow running modally after
            end;
        end;
    end;

    procedure ShowFieldList(Editable: Boolean)
    var
        DataGenPackageFields: Record "SPB DataGen Pkg. Field";
        DataGenPackageFieldList: Page "SPB DataGen Line Fields";
    begin
        Rec.TestField("Table Id");

        PopulateFieldList();
        Clear(DataGenPackageFieldList);
        DataGenPackageFields.SetRange("Package Code", Rec."Package Code");
        DataGenPackageFields.SetRange("Table Id", Rec."Table Id");
        DataGenPackageFieldList.Editable(Editable);
        DataGenPackageFieldList.SetTableView(DataGenPackageFields);
        DataGenPackageFieldList.RunModal();
        Rec.CalcFields("Included Field Count", "Total Field Count");
    end;

    local procedure DeleteRelatedData()
    var
        DataGenPackageFields: Record "SPB DataGen Pkg. Field";
    begin
        DataGenPackageFields.SetRange("Package Code", Rec."Package Code");
        DataGenPackageFields.SetRange("Table Id", Rec."Table Id");
        DataGenPackageFields.DeleteAll(true);
    end;
}
