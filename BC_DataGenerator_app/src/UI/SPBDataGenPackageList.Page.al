page 80800 "SPB DataGen Package List"
{
    ApplicationArea = All;
    Caption = 'SPB DataGen Package List';
    CardPageId = "SPB DataGen Package Card";
    Editable = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "SPB DataGen Package";
    UsageCategory = Tasks;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Code; Rec.Code)
                {
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Codeunit No."; Rec."Codeunit No.")
                {
                    ToolTip = 'Which Codeunit Number will be assigned when the AL file is generated';
                }
                field("Tables Included"; Rec."Tables Included")
                {
                    ToolTip = 'Specifies the value of the Tables Included field.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(GenerateALFiles)
            {
                Caption = 'Generate';
                Image = Suggest;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'This will create a suite of codeunit files from the selected packages and download it.';

                trigger OnAction()
                var
                    SPBDataGenPackage: Record "SPB DataGen Package";
                begin
                    CurrPage.SetSelectionFilter(SPBDataGenPackage);
                    Codeunit.Run(Codeunit::"SPB DataGen Generator", SPBDataGenPackage);
                end;
            }
            action(AutoGenerateFromBase)
            {
                Caption = 'Defaults';
                Image = AutofillQtyToHandle;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = codeunit "SPB Datagen Default Library";
                ToolTip = 'This will create a suite of commonly needed packages.';

                trigger OnAction()
                begin

                end;
            }


            group(ImportExport)
            {
                Caption = 'Import/Export';
                Image = ImportExport;
                ToolTip = 'Import/Export the Package Settings';

                action(ImportAction)
                {
                    Caption = 'Import';
                    Image = Import;
                    ToolTip = 'Import Settings';

                    trigger OnAction()
                    begin
                        Xmlport.Run(Xmlport::"SPB Datagen Imp/Exp Settings", true, true);
                    end;
                }

                action(ExportAction)
                {
                    Caption = 'Export';
                    Image = Export;
                    ToolTip = 'Export Settings';

                    trigger OnAction()
                    var
                        Packages: Record "SPB DataGen Package";
                    begin
                        CurrPage.SetSelectionFilter(Packages);
                        Xmlport.Run(Xmlport::"SPB Datagen Imp/Exp Settings", true, true, Packages);
                    end;
                }
            }
        }
    }
}
