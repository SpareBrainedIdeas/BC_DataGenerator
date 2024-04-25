xmlport 80800 "SPB Datagen Imp/Exp Settings"
{
    Caption = 'Import/Export Settings';
    Encoding = UTF8;

    schema
    {
        textelement(RootNodeName)
        {
            tableelement(SPBDataGenPackage; "SPB DataGen Package")
            {
                AutoReplace = true;
                AutoSave = true;
                AutoUpdate = true;

                fieldelement(Code; SPBDataGenPackage.Code)
                {
                }
                fieldelement(Description; SPBDataGenPackage.Description)
                {
                }
                fieldelement(CodeunitNo; SPBDataGenPackage."Codeunit No.")
                {
                }
                tableelement(SPBDataGenPackageTable; "SPB DataGen Pkg. Table")
                {
                    AutoReplace = true;
                    AutoSave = true;
                    AutoUpdate = true;

                    fieldelement(PackageCode; SPBDataGenPackageTable."Package Code")
                    {
                    }
                    fieldelement(TableId; SPBDataGenPackageTable."Table Id")
                    {
                    }
                    fieldelement(MaxRecords; SPBDataGenPackageTable."Maximum Records")
                    {
                    }
                    tableelement(SPBDataGenPackageField; "SPB DataGen Pkg. Field")
                    {
                        AutoReplace = true;
                        AutoSave = true;
                        AutoUpdate = true;

                        fieldelement(PackageCode; SPBDataGenPackageField."Package Code")
                        {
                        }
                        fieldelement(TableId; SPBDataGenPackageField."Table Id")
                        {
                        }
                        fieldelement(FieldNo; SPBDataGenPackageField."Field No.")
                        {
                        }
                        fieldelement(Include; SPBDataGenPackageField.Include)
                        {
                        }
                        fieldelement(Anonymize; SPBDataGenPackageField.Anonymize)
                        {
                        }
                        fieldelement(Filter; SPBDataGenPackageField."Filter")
                        {
                        }
                    }
                }
            }
        }
    }
}
