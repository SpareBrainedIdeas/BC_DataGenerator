codeunit 80801 "SPB DataGen Generator"
{
    Access = Internal;

    // Filtered list of DataGenPackage records, output a Download ZIP files of AL Files
    TableNo = "SPB DataGen Package";

    var
        ProcessStartTime: DateTime;
        ProgressLastUpdate: DateTime;
        Window: Dialog;
        ProgressTok: Label 'DataGen Generation\---\Table:  #1#################\Status: #2#################\---\Start Time: #3#############\Duration:   #4#############';

    trigger OnRun()
    var
        DataCompression: Codeunit "Data Compression";
        TempBlob: Codeunit "Temp Blob";
        InS: InStream;
        OutS: OutStream;
        ZipFileName: Text;
    begin
        ProcessStartTime := CurrentDateTime;
        if GuiAllowed then
            Window.Open(ProgressTok);
        // Prep the archive for the files
        DataCompression.CreateZipArchive();
        ZipFileName := 'DataGenTestingLibrary.zip';

        repeat
            if Rec.Description <> '' then begin
                TempBlob.CreateOutStream(OutS);
                OutS.WriteText(CreateCodeunit(Rec));
                TempBlob.CreateInStream(InS);
                DataCompression.AddEntry(InS, Rec.BuildFilename());
                Clear(TempBlob);
            end;
        until Rec.Next() = 0;

        // Now Time to save the ZIP to local
        UpdateStatusWindow('Creating Zip', '', true);
        TempBlob.CreateOutStream(OutS);
        DataCompression.SaveZipArchive(OutS);
        TempBlob.CreateInStream(InS);
        if GuiAllowed then
            Window.Close();

        DownloadFromStream(InS, '', '', '', ZipFileName);
    end;

    procedure CreateCodeunit(var DataGenPackage: Record "SPB DataGen Package"): Text
    var
        PackageTable: Record "SPB DataGen Pkg. Table";
        CodeunitBuilder: TextBuilder;
    begin
        UpdateStatusWindow('CreateCodeunit-' + DataGenPackage.Description, 'Baking Create Functions', false);

        PackageTable.SetRange("Package Code", DataGenPackage.Code);
        if not PackageTable.FindSet() then
            exit;

        CodeunitBuilder.Append(GetCodunitHeader(DataGenPackage));

        repeat
            CodeunitBuilder.Append(GetCreateFunctions(PackageTable));
        until PackageTable.Next() = 0;

        CodeunitBuilder.Append(GetCreateCollection(DataGenPackage));

        CodeunitBuilder.Append(GetCodunitFooter());

        exit(CodeunitBuilder.ToText());
    end;

    local procedure GetCodunitHeader(var DataGenPackage: Record "SPB DataGen Package"): Text
    var
        DataGenUtility: Codeunit "SPB DataGen Utilities";
        CodeUnitName: Text;
        CodeunitBuilder: TextBuilder;
    begin
        CodeUnitName := DataGenUtility.SafeName(DataGenPackage.Description);
        CodeunitBuilder.AppendLine('codeunit ' + Format(DataGenPackage."Codeunit No.") + ' ' + CodeUnitName);
        CodeunitBuilder.AppendLine('{');
        CodeunitBuilder.Append(GetPermissionText(DataGenPackage));
        CodeunitBuilder.AppendLine('');
        CodeunitBuilder.AppendLine('    var');
        CodeunitBuilder.AppendLine('        DoInsertTriggers: Boolean;');
        CodeunitBuilder.AppendLine('');
        CodeunitBuilder.AppendLine('    trigger OnRun()');
        CodeunitBuilder.AppendLine('    begin');
        CodeunitBuilder.AppendLine('        CreateCollection(false);');
        CodeunitBuilder.AppendLine('    end;');
        CodeunitBuilder.AppendLine('');
        CodeunitBuilder.AppendLine('    procedure TextAsGuid(InputText: Text) OutputGuid: Guid');
        CodeunitBuilder.AppendLine('    begin');
        CodeunitBuilder.AppendLine('        Evaluate(OutputGuid, InputText);');
        CodeunitBuilder.AppendLine('    end;');
        CodeunitBuilder.AppendLine('');
        CodeunitBuilder.AppendLine('    procedure TextAsDateFormula(InputText: Text) OutputDateFormula: DateFormula');
        CodeunitBuilder.AppendLine('    begin');
        CodeunitBuilder.AppendLine('        Evaluate(OutputDateFormula, InputText);');
        CodeunitBuilder.AppendLine('    end;');
        CodeunitBuilder.AppendLine('');

        exit(CodeunitBuilder.ToText());
    end;

    local procedure GetCreateFunctions(var PackageTable: Record "SPB DataGen Pkg. Table"): Text
    var
        PackageField: Record "SPB DataGen Pkg. Field";
        PackageField2: Record "SPB DataGen Pkg. Field";
        DataGenUtility: Codeunit "SPB DataGen Utilities";
        LastFieldNo: Integer;
        Parameter: Text;
        ProcedureName: Text;
        TableName: Text;
        CreateFunctionsBuilder: TextBuilder;
    begin
        PackageField.SetRange("Package Code", PackageTable."Package Code");
        PackageField.SetRange("Table Id", PackageTable."Table Id");
        PackageField.SetRange(Include, true);
        if not PackageField.FindSet() then
            exit;
        PackageField2.CopyFilters(PackageField);

        PackageTable.CalcFields("Table Name");
        TableName := DataGenUtility.SafeName(PackageTable."Table Name");
        ProcedureName := 'Create' + TableName;

        CreateFunctionsBuilder.AppendLine('    procedure ' + ProcedureName + '(');
        Clear(LastFieldNo);
        if PackageField.FindLast() then
            LastFieldNo := PackageField."Field No.";
        if PackageField.FindSet() then
            repeat
                // Safety Check - if the field is not a supported type, then skip it
                if PackageField.IsSupported() then begin
                    PackageField.CalcFields("Field Name");
                    Parameter := '        ' + DataGenUtility.SafeName(PackageField."Field Name") + ': ' + PackageField.GetFieldTypeString();
                    if not (LastFieldNo = PackageField."Field No.") then
                        Parameter += ';';
                    CreateFunctionsBuilder.AppendLine(Parameter);
                end;
            until PackageField.Next() = 0;

        CreateFunctionsBuilder.AppendLine('    )');

        CreateFunctionsBuilder.AppendLine('    var');
        CreateFunctionsBuilder.AppendLine('    ' + TableName + ': Record "' + PackageTable."Table Name" + '";');
        CreateFunctionsBuilder.AppendLine('    begin');
        CreateFunctionsBuilder.AppendLine('    ' + TableName + '.Init();');
        if PackageField2.FindSet() then
            repeat
                // Safety Check - if the field is not a supported type, then skip it
                if PackageField2.IsSupported() then begin
                    PackageField2.CalcFields("Field Name");
                    CreateFunctionsBuilder.AppendLine('        ' + TableName + '."' + PackageField2."Field Name" + '" := ' + DataGenUtility.SafeName(PackageField2."Field Name") + ';');
                end;
            until PackageField2.Next() = 0;
        CreateFunctionsBuilder.AppendLine('    ' + TableName + '.Insert(DoInsertTriggers);');
        CreateFunctionsBuilder.AppendLine('    end;');
        CreateFunctionsBuilder.AppendLine('');

        exit(CreateFunctionsBuilder.ToText());
    end;

    local procedure GetCreateCollection(var DataGenPackage: Record "SPB DataGen Package"): Text
    var
        PackageTable: Record "SPB DataGen Pkg. Table";
        DataGenUtilities: Codeunit "SPB DataGen Utilities";
        ProcedureName: Text;
        TableName: Text;
        CreateCollectionBuilder: TextBuilder;
    begin
        UpdateStatusWindow('CreateCodeunit-' + DataGenPackage.Description, 'Rolling out the data', false);

        PackageTable.SetRange("Package Code", DataGenPackage.Code);
        if not PackageTable.FindSet() then
            exit;

        CreateCollectionBuilder.AppendLine('    procedure CreateCollection(ShouldRunInsertTriggers: Boolean)');
        CreateCollectionBuilder.AppendLine('    begin');
        CreateCollectionBuilder.AppendLine('        DoInsertTriggers := ShouldRunInsertTriggers;');

        repeat
            PackageTable.CalcFields("Table Name");
            TableName := DataGenUtilities.SafeName(PackageTable."Table Name");
            ProcedureName := 'Create' + TableName;
            CreateCollectionBuilder.Append(CreateDetailLines(PackageTable, ProcedureName));
        until PackageTable.Next() = 0;

        CreateCollectionBuilder.AppendLine('    end;');

        exit(CreateCollectionBuilder.ToText());
    end;


    local procedure CreateDetailLines(PackageTable: Record "SPB DataGen Pkg. Table"; ProcedureName: Text): Text
    var
        PackageFields: Record "SPB DataGen Pkg. Field";
        SPBDataGenUtilities: Codeunit "SPB DataGen Utilities";
        TargetRecordRef: RecordRef;
        TargetFieldRef: FieldRef;
        TestDate: Date;
        LastFieldNo: Integer;
        RunningRecordCount: Integer;
        CreateCollectionLineBuilder: TextBuilder;
    begin
        PackageFields.SetRange("Package Code", PackageTable."Package Code");
        PackageFields.SetRange("Table Id", PackageTable."Table Id");
        PackageFields.SetRange(Include, true);
        PackageFields.FindLast();
        LastFieldNo := PackageFields."Field No.";

        TargetRecordRef.Open(PackageTable."Table Id");


        // Are there filters?
        PackageFields.SetFilter(Filter, '<>%1', '');
        if PackageFields.FindSet() then
            repeat
                TargetFieldRef := TargetRecordRef.Field(PackageFields."Field No.");
                TargetFieldRef.SetFilter(PackageFields.Filter);
            until PackageFields.Next() = 0;
        PackageFields.SetRange(Filter);

        if PackageTable."Apply Codeunit Filtering" <> Enum::"SPB Special Filtering Options"::" " then
            // This often relies heavily on MARKED records, FYI
            ApplySpecialFiltering(PackageTable, TargetRecordRef);

        // For each record in the table (that matches filters!)
        Clear(RunningRecordCount);
        if TargetRecordRef.FindSet(false) then
            repeat
                if (PackageTable."Maximum Records" = 0) or (RunningRecordCount < PackageTable."Maximum Records") then begin
                    CreateCollectionLineBuilder.Append('        ' + ProcedureName + '(');
                    if PackageFields.FindSet() then
                        repeat
                            // Safety Check - if the field is not a supported type, then skip it
                            if PackageFields.IsSupported() then begin
                                TargetFieldRef := TargetRecordRef.Field(PackageFields."Field No.");
                                // add the fields to the line
                                if not PackageFields.Anonymize then
                                    case TargetFieldRef.Type of
                                        FieldType::Code, FieldType::Text:
                                            CreateCollectionLineBuilder.Append(StrSubstNo('''%1''', ConvertStr(Format(TargetFieldRef.Value), '''', '"')));
                                        FieldType::Date:
                                            CreateCollectionLineBuilder.Append(SPBDataGenUtilities.ALSafeDate(TargetFieldRef.Value));
                                        FieldType::Time:
                                            CreateCollectionLineBuilder.Append(SPBDataGenUtilities.ALSafeTime(TargetFieldRef.Value));
                                        FieldType::DateTime:
                                            CreateCollectionLineBuilder.Append(SPBDataGenUtilities.ALSafeDateTime(TargetFieldRef.Value));
                                        FieldType::Guid:
                                            CreateCollectionLineBuilder.Append(SPBDataGenUtilities.ALSafeGuid(TargetFieldRef.Value));
                                        FieldType::DateFormula:
                                            CreateCollectionLineBuilder.Append(SPBDataGenUtilities.ALSafeDateFormula(TargetFieldRef.Value));
                                        else
                                            CreateCollectionLineBuilder.Append(Format(TargetFieldRef.Value, 0, 9));
                                    end
                                else
                                    case TargetFieldRef.Type of
                                        FieldType::Code, FieldType::Text:
                                            // TODO: Should we look into url / email handling?
                                            CreateCollectionLineBuilder.Append(StrSubstNo('''%1''', SPBDataGenUtilities.GenerateRandomAlphabeticText(TargetFieldRef.Length, 1)));
                                        FieldType::Decimal:
                                            // TODO:  Maybe some clever hack to figure out how many decimal places to use?
                                            CreateCollectionLineBuilder.Append(Format(SPBDataGenUtilities.RandDec(1000, 0), 0, 9));
                                        FieldType::Integer, FieldType::BigInteger:
                                            CreateCollectionLineBuilder.Append(Format(SPBDataGenUtilities.RandInt(1000), 0, 9));
                                        FieldType::Date:
                                            begin
                                                TestDate := TargetFieldRef.Value;
                                                if (TestDate <> 0D) then
                                                    // Pseudo random, within the same month as the source
                                                    TestDate := SPBDataGenUtilities.GenerateRandomDate(CalcDate('<-CM>', TargetFieldRef.Value), CalcDate('<CM>', TargetFieldRef.Value));
                                                CreateCollectionLineBuilder.Append(SPBDataGenUtilities.ALSafeDate(TestDate));
                                            end;
                                        //TODO: No anon time / datetime, sorry
                                        FieldType::Time:
                                            CreateCollectionLineBuilder.Append(SPBDataGenUtilities.ALSafeTime(TargetFieldRef.Value));
                                        FieldType::DateTime:
                                            CreateCollectionLineBuilder.Append(SPBDataGenUtilities.ALSafeDateTime(TargetFieldRef.Value));
                                        FieldType::Guid:
                                            CreateCollectionLineBuilder.Append(SPBDataGenUtilities.ALSafeGuid(TargetFieldRef.Value));
                                        FieldType::DateFormula:
                                            CreateCollectionLineBuilder.Append(SPBDataGenUtilities.ALSafeDateFormula(TargetFieldRef.Value));
                                        else
                                            CreateCollectionLineBuilder.Append(Format(TargetFieldRef.Value, 0, 9));
                                    end;
                                if PackageFields."Field No." <> LastFieldNo then
                                    CreateCollectionLineBuilder.Append(', ');
                            end;
                        until PackageFields.Next() = 0;
                    CreateCollectionLineBuilder.AppendLine(');');
                    RunningRecordCount += 1;
                end;
            until TargetRecordRef.Next() = 0;


        CreateCollectionLineBuilder.AppendLine('');

        exit(CreateCollectionLineBuilder.ToText());
    end;

    local procedure GetCodunitFooter(): Text
    var
        CodunitFooterBuilder: TextBuilder;
    begin
        CodunitFooterBuilder.AppendLine('}');

        exit(CodunitFooterBuilder.ToText());
    end;

    local procedure GetPermissionText(var DataGenPackage: Record "SPB DataGen Package"): Text
    var
        DataGenPackageTables: Record "SPB DataGen Pkg. Table";
        LastTableNo: Integer;
        PermissionLineTok: Label '        tabledata "%1" = rim';
        EndOfString: Text;
        PermissionList: TextBuilder;
    begin
        PermissionList.Append('    Permissions = ');
        DataGenPackageTables.SetRange("Package Code", DataGenPackage.Code);
        if DataGenPackageTables.FindLast() then
            LastTableNo := DataGenPackageTables."Table Id";
        if DataGenPackageTables.FindSet() then
            repeat
                DataGenPackageTables.CalcFields("Table Name");
                if DataGenPackageTables."Table Id" <> LastTableNo then
                    EndOfString := ','
                else
                    EndOfString := ';';
                PermissionList.AppendLine(StrSubstNo(PermissionLineTok, DataGenPackageTables."Table Name") + EndOfString);
            until DataGenPackageTables.Next() = 0;

        exit(PermissionList.ToText());
    end;

    local procedure ApplySpecialFiltering(var PackageTable: Record "SPB DataGen Pkg. Table"; var TargetRecordRef: RecordRef)
    var
        SpecialFiltering: Interface "SPB Special Table Filtering";
    begin
        SpecialFiltering := PackageTable."Apply Codeunit Filtering";
        SpecialFiltering.ApplyFiltering(PackageTable, TargetRecordRef);
    end;


    procedure UpdateStatusWindow(NewStage: Text; NewStatus: Text; ForceRefresh: Boolean)
    begin
        if not GuiAllowed then
            exit;
        if ProgressLastUpdate = 0DT then
            ProgressLastUpdate := ProcessStartTime;

        if ForceRefresh or ((CurrentDateTime - ProgressLastUpdate) > 5000) then begin
            Window.Update(1, NewStage);
            Window.Update(2, NewStatus);
            Window.Update(3, ProcessStartTime);
            Window.Update(4, Format(CurrentDateTime - ProcessStartTime));
            ProgressLastUpdate := CurrentDateTime;
        end;
    end;
}
