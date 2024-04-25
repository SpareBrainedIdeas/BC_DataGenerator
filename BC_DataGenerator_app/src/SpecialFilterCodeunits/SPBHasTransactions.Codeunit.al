codeunit 80803 "SPB Has Transactions" implements "SPB Special Table Filtering"
{

    procedure ValidForTable(TableNo: Integer): Boolean
    begin
        exit(TableNo in [Database::Customer, Database::Vendor, Database::Item])
    end;

    procedure ApplyFiltering(var PackageTable: Record "SPB DataGen Pkg. Table"; var TargetRecordRef: RecordRef)
    begin
        case TargetRecordRef.Number of
            Database::Customer:
                ApplyCustomerFiltering(TargetRecordRef);
            Database::Vendor:
                ApplyVendorFiltering(TargetRecordRef);
            Database::Item:
                ApplyItemFiltering(TargetRecordRef);
        end;
        TargetRecordRef.MarkedOnly(true);
    end;

    local procedure ApplyCustomerFiltering(var TargetRecordRef: RecordRef)
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        Customer: Record Customer;
        SalesHeader: Record "Sales Header";
    begin
        // more than two open sales documents or 10 transactions posted
        if TargetRecordRef.FindSet() then
            repeat
                TargetRecordRef.SetTable(Customer);
                SalesHeader.SetRange("Sell-to Customer No.", Customer."No.");
                CustLedgerEntry.SetRange("Customer No.", Customer."No.");
                TargetRecordRef.Mark((SalesHeader.Count > 2) or (CustLedgerEntry.Count >= 10));
            until TargetRecordRef.Next() < 1;
    end;

    local procedure ApplyVendorFiltering(var TargetRecordRef: RecordRef)
    var
        PurchHeader: Record "Purchase Header";
        Vendor: Record Vendor;
        VendLedgerEntry: Record "Vendor Ledger Entry";
    begin
        // more than two open purchase documents or 10 transactions posted
        if TargetRecordRef.FindSet() then
            repeat
                TargetRecordRef.SetTable(Vendor);
                PurchHeader.SetRange("Buy-from Vendor No.", Vendor."No.");
                VendLedgerEntry.SetRange("Vendor No.", Vendor."No.");
                TargetRecordRef.Mark((PurchHeader.Count > 2) or (VendLedgerEntry.Count >= 10));
            until TargetRecordRef.Next() < 1;
    end;

    local procedure ApplyItemFiltering(var TargetRecordRef: RecordRef)
    var
        Item: Record Item;
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        if TargetRecordRef.FindSet() then
            repeat
                TargetRecordRef.SetTable(Item);
                ItemLedgerEntry.SetRange("Item No.", Item."No.");
                TargetRecordRef.Mark(ItemLedgerEntry.Count >= 10);
            until TargetRecordRef.Next() < 1;
    end;

}
