codeunit 80802 "SPB Datagen Default Library"
{
    Access = Internal;

    trigger OnRun()
    begin
        CreatePackages();
    end;

    local procedure CreatePackages()
    begin
        CreatePackageCoreApp();
        CreatePackageFinance();
        CreatePackageSales();
        CreatePackagePurchases();
        CreatePackageItems();
        CreatePackageWarehouse();
        CreatePackageService();
        CreatePackageCRM();
        CreatePackageManuf();
        CreatePackageInterco();
        CreatePackageResourcesJobs();
        CreatePackageUserApprovals()
    end;

    local procedure CreatePackageCoreApp()
    begin
        MarkAllRealFields('CORE-BC', Database::"Standard Text");      // Table 7
        MarkAllRealFields('CORE-BC', Database::Language);      // Table 8
        MarkAllRealFields('CORE-BC', Database::"Country/Region");      // Table 9
        MarkAllRealFields('CORE-BC', Database::"Shipment Method");      // Table 10
        MarkAllRealFields('CORE-BC', Database::"Salesperson/Purchaser");      // Table 13
        MarkAllRealFields('CORE-BC', Database::Location);      // Table 14
        MarkAllRealFields('CORE-BC', Database::"Accounting Period");      // Table 50
        MarkAllRealFields('CORE-BC', Database::"Document Sending Profile");      // Table 60
        MarkAllRealFields('CORE-BC', Database::"Electronic Document Format");      // Table 61
        MarkAllRealFields('CORE-BC', Database::"Report Selections");      // Table 77
        MarkAllRealFields('CORE-BC', Database::"Company Information");      // Table 79
        MarkAllRealFields('CORE-BC', Database::"General Ledger Setup");      // Table 98
        MarkAllRealFields('CORE-BC', Database::"Unit of Measure");      // Table 204
        MarkAllRealFields('CORE-BC', Database::"Post Code");      // Table 225
        MarkAllRealFields('CORE-BC', Database::"Source Code");      // Table 230
        MarkAllRealFields('CORE-BC', Database::"Source Code Setup");      // Table 242
        MarkAllRealFields('CORE-BC', Database::Territory);      // Table 286
        MarkAllRealFields('CORE-BC', Database::"Payment Method");      // Table 289
        MarkAllRealFields('CORE-BC', Database::"Shipping Agent");      // Table 291
        MarkAllRealFields('CORE-BC', Database::"No. Series");      // Table 308
        MarkAllRealFields('CORE-BC', Database::"No. Series Line");      // Table 309
        MarkAllRealFields('CORE-BC', Database::Dimension);      // Table 348
        MarkAllRealFields('CORE-BC', Database::"Dimension Value");      // Table 349
        MarkAllRealFields('CORE-BC', Database::"Default Dimension");      // Table 352
        MarkAllRealFields('CORE-BC', Database::"Dim. Value per Account");      // Table 356
        MarkAllRealFields('CORE-BC', Database::"VAT Registration No. Format");      // Table 381
        MarkAllRealFields('CORE-BC', Database::"Dimension Translation");      // Table 388
        MarkAllRealFields('CORE-BC', Database::"Job Queue Category");      // Table 471
        MarkAllRealFields('CORE-BC', Database::"Dimension Set Entry");      // Table 480
        MarkAllRealFields('CORE-BC', Database::"Dimension Set Tree Node");      // Table 481
        MarkAllRealFields('CORE-BC', Database::"VAT Clause");      // Table 560
        MarkAllRealFields('CORE-BC', Database::"G/L Account Category");      // Table 570
        MarkAllRealFields('CORE-BC', Database::"VAT Report Setup");      // Table 743
        MarkAllRealFields('CORE-BC', Database::"VAT Reports Configuration");      // Table 746
        MarkAllRealFields('CORE-BC', Database::"Chart Definition");      // Table 1310
        MarkAllRealFields('CORE-BC', Database::"Unit of Measure Translation");      // Table 5402
        MarkAllRealFields('CORE-BC', Database::"Shipping Agent Services");      // Table 5790
    end;

    local procedure CreatePackageFinance()
    begin
        MarkAllRealFields('FINANCE', Database::"Payment Terms");      // Table 3
        MarkAllRealFields('FINANCE', Database::Currency);      // Table 4
        MarkAllRealFields('CORE-BC', Database::"Currency Exchange Rate");      // Table 330
        MarkAllRealFields('FINANCE', Database::"Finance Charge Terms");      // Table 5
        MarkAllRealFields('FINANCE', Database::"G/L Account");      // Table 15
        MarkAllRealFields('FINANCE', Database::"Gen. Journal Template");      // Table 80
        MarkAllRealFields('FINANCE', Database::"Gen. Journal Line");      // Table 81
        MarkAllRealFields('FINANCE', Database::"Acc. Schedule Name");      // Table 84
        MarkAllRealFields('FINANCE', Database::"Acc. Schedule Line");      // Table 85
        MarkAllRealFields('FINANCE', Database::"Gen. Journal Batch");      // Table 232
        MarkAllRealFields('FINANCE', Database::"VAT Reg. No. Srv Config");      // Table 248
        MarkAllRealFields('FINANCE', Database::"Gen. Business Posting Group");      // Table 250
        MarkAllRealFields('FINANCE', Database::"Gen. Product Posting Group");      // Table 251
        MarkAllRealFields('FINANCE', Database::"General Posting Setup");      // Table 252
        MarkAllRealFields('FINANCE', Database::"VAT Statement Template");      // Table 255
        MarkAllRealFields('FINANCE', Database::"VAT Statement Line");      // Table 256
        MarkAllRealFields('FINANCE', Database::"VAT Statement Name");      // Table 257
        MarkAllRealFields('FINANCE', Database::"Bank Account");      // Table 270
        MarkAllRealFields('FINANCE', Database::"Bank Account Posting Group");      // Table 277
        MarkAllRealFields('FINANCE', Database::"Reminder Terms");      // Table 292
        MarkAllRealFields('FINANCE', Database::"Reminder Level");      // Table 293
        MarkAllRealFields('FINANCE', Database::"Reminder Text");      // Table 294
        MarkAllRealFields('FINANCE', Database::"VAT Business Posting Group");      // Table 323
        MarkAllRealFields('FINANCE', Database::"VAT Product Posting Group");      // Table 324
        MarkAllRealFields('FINANCE', Database::"VAT Posting Setup");      // Table 325
        MarkAllRealFields('FINANCE', Database::"Tax Setup");      // Table 326
        MarkAllRealFields('FINANCE', Database::"Column Layout Name");      // Table 333
        MarkAllRealFields('FINANCE', Database::"Column Layout");      // Table 334
        MarkAllRealFields('FINANCE', Database::"Analysis View");      // Table 363
        MarkAllRealFields('FINANCE', Database::"Account Schedules Chart Setup");      // Table 762
        MarkAllRealFields('FINANCE', Database::"Acc. Sched. Chart Setup Line");      // Table 763
        MarkAllRealFields('FINANCE', Database::"Analysis Report Chart Setup");      // Table 770
        MarkAllRealFields('FINANCE', Database::"Cash Flow Setup");      // Table 843
        MarkAllRealFields('FINANCE', Database::"Payment Registration Setup");      // Table 980
        MarkAllRealFields('FINANCE', Database::"Cost Accounting Setup");      // Table 1108
        MarkAllRealFields('FINANCE', Database::"Last Used Chart");      // Table 1311
        MarkAllRealFields('FINANCE', Database::"Trial Balance Setup");      // Table 1312
        MarkAllRealFields('FINANCE', Database::"Trial Balance Cache Info");      // Table 1317
        MarkAllRealFields('FINANCE', Database::"Trial Balance Cache");      // Table 1318
        MarkAllRealFields('FINANCE', Database::"VAT Setup Posting Groups");      // Table 1877
        MarkAllRealFields('FINANCE', Database::"VAT Assisted Setup Bus. Grp.");      // Table 1879
    end;

    local procedure CreatePackageSales()
    begin
        MarkAllRealFields('SALES', Database::Customer);      // Table 18
        MarkAllRealFields('SALES', Database::"Customer Posting Group");      // Table 92
        MarkAllRealFields('SALES', Database::"Ship-to Address");      // Table 222
        MarkAllRealFields('SALES', Database::"Customer Bank Account");      // Table 287
        MarkAllRealFields('SALES', Database::"Sales & Receivables Setup");      // Table 311
        MarkAllRealFields('SALES', Database::"Customer Discount Group");      // Table 340
        MarkAllRealFields('SALES', Database::"Trailing Sales Orders Setup");      // Table 760
        MarkAllRealFields('SALES', Database::"Customer Templ.");      // Table 1381
    end;

    local procedure CreatePackagePurchases()
    begin
        MarkAllRealFields('PURCHASE', Database::Vendor);      // Table 23
        MarkAllRealFields('PURCHASE', Database::"Vendor Posting Group");      // Table 93
        MarkAllRealFields('PURCHASE', Database::"Req. Wksh. Template");      // Table 244
        MarkAllRealFields('PURCHASE', Database::"Requisition Wksh. Name");      // Table 245
        MarkAllRealFields('PURCHASE', Database::"Vendor Bank Account");      // Table 288
        MarkAllRealFields('PURCHASE', Database::"Purchases & Payables Setup");      // Table 312
        MarkAllRealFields('PURCHASE', Database::"Vendor Templ.");      // Table 1383
    end;

    local procedure CreatePackageItems()
    begin
        MarkAllRealFields('INVENTORY', Database::Item);      // Table 27
        MarkAllRealFields('INVENTORY', Database::"Item Journal Template");      // Table 82
        MarkAllRealFields('INVENTORY', Database::"Inventory Posting Group");      // Table 94
        MarkAllRealFields('INVENTORY', Database::"Item Vendor");      // Table 99
        MarkAllRealFields('INVENTORY', Database::"Inventory Setup");      // Table 313
        MarkAllRealFields('INVENTORY', Database::"Item Templ.");      // Table 1382
        MarkAllRealFields('INVENTORY', Database::"Item Unit of Measure");      // Table 5404
        MarkAllRealFields('INVENTORY', Database::"Item Substitution");      // Table 5715
        MarkAllRealFields('INVENTORY', Database::"Nonstock Item");      // Table 5718
        MarkAllRealFields('INVENTORY', Database::"Nonstock Item Setup");      // Table 5719
        MarkAllRealFields('INVENTORY', Database::Manufacturer);      // Table 5720
        MarkAllRealFields('INVENTORY', Database::Purchasing);      // Table 5721
        MarkAllRealFields('INVENTORY', Database::"Item Category");      // Table 5722
        MarkAllRealFields('INVENTORY', Database::"Transfer Route");      // Table 5742
        MarkAllRealFields('INVENTORY', Database::"Item Reference");      // Table 5777
        MarkAllRealFields('INVENTORY', Database::"Item Charge");      // Table 5800
        MarkAllRealFields('INVENTORY', Database::"Inventory Posting Setup");      // Table 5813
        MarkAllRealFields('INVENTORY', Database::"Item Tracking Code");      // Table 6502
        MarkAllRealFields('INVENTORY', Database::"Item Attribute");      // Table 7500
        MarkAllRealFields('INVENTORY', Database::"Item Attribute Value");      // Table 7501
        MarkAllRealFields('INVENTORY', Database::"Item Attribute Value Mapping");      // Table 7505
        MarkAllRealFields('INVENTORY', Database::"Order Promising Setup");      // Table 99000875
    end;

    local procedure CreatePackageWarehouse()
    begin

    end;

    local procedure CreatePackageService()
    begin

    end;

    local procedure CreatePackageCRM()
    begin
        MarkAllRealFields('CRM', Database::"Customer Templ.");      // Table 1381
        MarkAllRealFields('CRM', Database::Contact);      // Table 5050
        MarkAllRealFields('CRM', Database::"Business Relation");      // Table 5053
        MarkAllRealFields('CRM', Database::"Contact Business Relation");      // Table 5054
        MarkAllRealFields('CRM', Database::"Mailing Group");      // Table 5055
        MarkAllRealFields('CRM', Database::"Industry Group");      // Table 5057
        MarkAllRealFields('CRM', Database::"Web Source");      // Table 5059
        MarkAllRealFields('CRM', Database::Attachment);      // Table 5062
        MarkAllRealFields('CRM', Database::"Interaction Group");      // Table 5063
        MarkAllRealFields('CRM', Database::"Interaction Template");      // Table 5064
        MarkAllRealFields('CRM', Database::"Job Responsibility");      // Table 5066
        MarkAllRealFields('CRM', Database::"Contact Job Responsibility");      // Table 5067
        MarkAllRealFields('CRM', Database::Salutation);      // Table 5068
        MarkAllRealFields('CRM', Database::"Salutation Formula");      // Table 5069
        MarkAllRealFields('CRM', Database::"Organizational Level");      // Table 5070
        MarkAllRealFields('CRM', Database::Campaign);      // Table 5071
        MarkAllRealFields('CRM', Database::"Campaign Status");      // Table 5073
        MarkAllRealFields('CRM', Database::"Segment Header");      // Table 5076
        MarkAllRealFields('CRM', Database::"Segment Line");      // Table 5077
        MarkAllRealFields('CRM', Database::"Marketing Setup");      // Table 5079
        MarkAllRealFields('CRM', Database::Activity);      // Table 5081
        MarkAllRealFields('CRM', Database::"Activity Step");      // Table 5082
        MarkAllRealFields('CRM', Database::Team);      // Table 5083
        MarkAllRealFields('CRM', Database::"Contact Duplicate");      // Table 5085
        MarkAllRealFields('CRM', Database::"Cont. Duplicate Search String");      // Table 5086
        MarkAllRealFields('CRM', Database::"Profile Questionnaire Header");      // Table 5087
        MarkAllRealFields('CRM', Database::"Profile Questionnaire Line");      // Table 5088
        MarkAllRealFields('CRM', Database::"Sales Cycle");      // Table 5090
        MarkAllRealFields('CRM', Database::"Sales Cycle Stage");      // Table 5091
        MarkAllRealFields('CRM', Database::Opportunity);      // Table 5092
        MarkAllRealFields('CRM', Database::"Opportunity Entry");      // Table 5093
        MarkAllRealFields('CRM', Database::"Close Opportunity Code");      // Table 5094
        MarkAllRealFields('CRM', Database::"Duplicate Search String Setup");      // Table 5095
        MarkAllRealFields('CRM', Database::"Interaction Tmpl. Language");      // Table 5103
        MarkAllRealFields('CRM', Database::"Segment Interaction Language");      // Table 5104
        MarkAllRealFields('CRM', Database::"Interaction Template Setup");      // Table 5122
    end;

    local procedure CreatePackageManuf()
    begin

    end;

    local procedure CreatePackageInterco()
    begin

    end;

    local procedure CreatePackageResourcesJobs()
    begin
        MarkAllRealFields('JOBS', Database::Resource);      // Table 156
        MarkAllRealFields('JOBS', Database::Job);      // Table 167
        MarkAllRealFields('JOBS', Database::"Resource Unit of Measure");      // Table 205
        MarkAllRealFields('JOBS', Database::"Job Posting Group");      // Table 208
        MarkAllRealFields('JOBS', Database::"Job Journal Template");      // Table 209
        MarkAllRealFields('JOBS', Database::"Job Journal Line");      // Table 210
        MarkAllRealFields('JOBS', Database::"Job Journal Batch");      // Table 237
        MarkAllRealFields('JOBS', Database::"Resources Setup");      // Table 314
        MarkAllRealFields('JOBS', Database::"Jobs Setup");      // Table 315
        MarkAllRealFields('JOBS', Database::"Job Task");      // Table 1001
        MarkAllRealFields('JOBS', Database::"Job Task Dimension");      // Table 1002
        MarkAllRealFields('JOBS', Database::"Job Planning Line");      // Table 1003
        MarkAllRealFields('JOBS', Database::"Job WIP Method");      // Table 1006
    end;

    local procedure CreatePackageUserApprovals()
    begin

    end;


    local procedure MarkAllRealFields(PackageCode: Code[10]; TableId: Integer)
    var
        SPBDataGenPackage: Record "SPB DataGen Package";
        SPBDataGenPkgField: Record "SPB DataGen Pkg. Field";
        SPBDataGenPkgTable: Record "SPB DataGen Pkg. Table";
        TargetRecordRef: RecordRef;
        TargetFieldRef: FieldRef;
        i: Integer;
    begin
        if not SPBDataGenPackage.Get(PackageCode) then begin
            SPBDataGenPackage.Init();
            SPBDataGenPackage.Code := PackageCode;
            SPBDataGenPackage.Description := PackageCode;
            SPBDataGenPackage.Insert(true);
        end;
        if not SPBDataGenPkgTable.Get(PackageCode, TableId) then begin
            SPBDataGenPkgTable.Init();
            SPBDataGenPkgTable."Package Code" := PackageCode;
            SPBDataGenPkgTable.Validate("Table Id", TableId);
            SPBDataGenPkgTable.Insert(true);
        end;

        TargetRecordRef.Open(TableId);

        // For all fields on this table
        for i := 1 to TargetRecordRef.FieldCount do begin
            // if they're a non-flowfield
            TargetFieldRef := TargetRecordRef.FieldIndex(i);
            if (TargetFieldRef.Class = FieldClass::Normal) and IsSupportedType(TargetFieldRef) then
                // Add them
                if SPBDataGenPkgField.Get(PackageCode, TableId, TargetFieldRef.Number) then begin
                    SPBDataGenPkgField.Include := true;
                    // If they have one of the keywords in the list, auto-anonymize them
                    SPBDataGenPkgField.Anonymize := IsDefaultAnon(TargetFieldRef.Name);

                    SPBDataGenPkgField.Modify(true);
                end;
        end;
    end;

    local procedure IsSupportedType(TargetFieldRef: FieldRef): Boolean
    begin
        exit(TargetFieldRef.Type in [FieldType::BigInteger, FieldType::Boolean, FieldType::Code, FieldType::Date,
            FieldType::DateFormula, FieldType::DateTime, FieldType::Decimal, FieldType::Duration, FieldType::Guid,
            FieldType::Integer, FieldType::Option, FieldType::Text, FieldType::Time]);
    end;

    local procedure IsDefaultAnon(FieldName: Text): Boolean
    begin
        exit(UpperCase(FieldName) in ['NAME', 'SEARCH NAME', 'NAME 2', 'FIRST NAME', 'MIDDLE NAME', 'LAST NAME', 'INITIALS',
        'ADDRESS', 'ADDRESS 2', 'CONTACT', 'CONTACT NAME', 'OUR ACCOUNT NO.', 'VAT REGISTRATION NO.',
        'PHONE NO.', 'PHONE', 'E-MAIL', 'E-MAIL ADDRESS', 'FAX NO.', 'TELEX NO.', 'GLN', 'EORI NUMBER', 'HOME PAGE', 'MOBILE PHONE NO.',
        'BANK ACCOUNT NO.', 'ACCOUNT NO.', 'SOCIAL SECURITY NO.', 'EMPLOYMENT DATE'])
    end;
}
