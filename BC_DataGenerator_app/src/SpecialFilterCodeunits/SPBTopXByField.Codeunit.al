codeunit 80805 "SPB Top X By Field" implements "SPB Special Table Filtering"
{

    procedure ValidForTable(TableNo: Integer): Boolean
    begin
        exit(TableNo in [Database::Item])
    end;

    procedure ApplyFiltering(var PackageTable: Record "SPB DataGen Pkg. Table"; var TargetRecordRef: RecordRef)
    begin
        // This one's funky, it's sort by field (setting 1) and top x (setting 2) for each field by transactions
        // Example - Items, Top 10 by Product Group
        case TargetRecordRef.Number of
            Database::Item:
                ApplyItemFiltering(PackageTable, TargetRecordRef);
        end;
        TargetRecordRef.MarkedOnly(true);
    end;

    local procedure ApplyItemFiltering(var PackageTable: Record "SPB DataGen Pkg. Table"; var TargetRecordRef: RecordRef)
    var
        TempSortBuffer: Record "SPB Filter Results Buffer" temporary;
        TargetFieldRef: FieldRef;
        Item: Record Item;
        ItemLedgerEntry: Record "Item Ledger Entry";
        LastGroupCode: Code[200];
        i: Integer;
    begin
        if TargetRecordRef.FindSet() then
            repeat
                TargetRecordRef.SetTable(Item);
                ItemLedgerEntry.SetRange("Item No.", Item."No.");
                TempSortBuffer."Master No." := Item."No.";
                TargetFieldRef := TargetRecordRef.Field(PackageTable."Filter Setting 1");
                TempSortBuffer."Sort By Code" := TargetFieldRef.Value;
                TempSortBuffer."Count Value" := ItemLedgerEntry.Count;
                TargetFieldRef := TargetRecordRef.Field(TargetRecordRef.SystemIdNo);
                TempSortBuffer."Source RecordId" := TargetFieldRef.Value;
                TempSortBuffer.Insert();
            until TargetRecordRef.Next() < 1;
        TempSortBuffer.SetCurrentKey("Sort By Code", "Count Value");
        TempSortBuffer.Ascending(false);

        if TempSortBuffer.FindSet() then
            repeat
                if TempSortBuffer."Sort By Code" <> LastGroupCode then begin
                    i := 0;
                    LastGroupCode := TempSortBuffer."Sort By Code";
                end;
                if i < PackageTable."Filter Setting 2" then begin
                    TargetRecordRef.GetBySystemId(TempSortBuffer."Source RecordId");
                    TargetRecordRef.Mark(true);
                    i += 1;
                end;
            until TempSortBuffer.Next() < 1;
    end;

}
