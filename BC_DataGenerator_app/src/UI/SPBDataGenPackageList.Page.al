page 80800 "SPB DataGen Package List"
{
    ApplicationArea = All;
    Caption = 'SPB DataGen Package List';
    PageType = List;
    SourceTable = "SPB DataGen Package";
    UsageCategory = Tasks;
    CardPageId = "SPB DataGen Package Card";
    Editable = false;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field("Codeunit No."; Rec."Codeunit No.")
                {
                    ToolTip = 'Which Codeunit Number will be assigned when the AL file is generated';
                    ApplicationArea = All;
                }
                field("Tables Included"; Rec."Tables Included")
                {
                    ToolTip = 'Specifies the value of the Tables Included field.';
                    ApplicationArea = All;
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
                ToolTip = 'This will create a suite of codeunit files from the selected packages and download it.';
                ApplicationArea = All;
                Image = Suggest;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    SPBDataGenPackage: Record "SPB DataGen Package";
                begin
                    CurrPage.SetSelectionFilter(SPBDataGenPackage);
                    Codeunit.Run(codeunit::"SPB DataGen Generator", SPBDataGenPackage);
                end;
            }
            action(AutoGenerateFromBase)
            {
                Caption = 'Defaults';
                ToolTip = 'This will create a suite of commonly needed packages.';
                ApplicationArea = All;
                Image = AutofillQtyToHandle;
                RunObject = codeunit "SPB Datagen Default Library";
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin

                end;
            }


            group(ImportExport)
            {
                Caption = 'Import/Export';
                ToolTip = 'Import/Export the Package Settings';
                Image = ImportExport;

                action(ImportAction)
                {
                    Caption = 'Import';
                    ToolTip = 'Import Settings';
                    ApplicationArea = All;
                    Image = Import;

                    trigger OnAction()
                    begin
                        XmlPort.Run(Xmlport::"SPB Datagen Imp/Exp Settings", true, true);
                    end;
                }

                action(ExportAction)
                {
                    Caption = 'Export';
                    ToolTip = 'Export Settings';
                    ApplicationArea = All;
                    Image = Export;

                    trigger OnAction()
                    var
                        Packages: Record "SPB DataGen Package";
                    begin
                        CurrPage.SetSelectionFilter(Packages);
                        XmlPort.Run(Xmlport::"SPB Datagen Imp/Exp Settings", true, true, Packages);
                    end;
                }
            }
        }
    }
}
