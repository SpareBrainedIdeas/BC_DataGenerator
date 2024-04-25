page 80802 "SPB DataGen Lines"
{
    Caption = 'SPB DataGen Lines';
    PageType = ListPart;
    SourceTable = "SPB DataGen Pkg. Table";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Package Code"; Rec."Package Code")
                {
                    ToolTip = 'Specifies the value of the Package Code field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Table Id"; Rec."Table Id")
                {
                    ToolTip = 'Specifies the value of the Table Id field.';
                    ApplicationArea = All;
                }
                field("Table Name"; Rec."Table Name")
                {
                    ToolTip = 'Specifies the value of the Table Name field.';
                    ApplicationArea = All;
                }
                field("Maximum Records"; Rec."Maximum Records")
                {
                    ToolTip = 'Specifies the value of the Maximum Records field.';
                    ApplicationArea = All;
                }
                field("Included Field Count"; Rec."Included Field Count")
                {
                    ToolTip = 'Specifies the value of the Included Field Count field.';
                    ApplicationArea = All;
                }
                field("Total Field Count"; Rec."Total Field Count")
                {
                    ToolTip = 'Specifies the value of the Field Count field.';
                    ApplicationArea = All;
                }
                field("Apply Codeunit Filtering"; Rec."Apply Codeunit Filtering")
                {
                    ToolTip = 'Specifies the value of the Apply Codeunit Filtering field.';
                    ApplicationArea = All;
                }
                field("Filter Setting 1"; Rec."Filter Setting 1")
                {
                    ToolTip = 'Specifies the value of the Filter Setting 1 field.';
                    ApplicationArea = All;
                }
                field("Filter Setting 2"; Rec."Filter Setting 2")
                {
                    ToolTip = 'Specifies the value of the Filter Setting 2 field.';
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(PackageFields)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Fields';
                Image = CheckList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'View the fields that can be used to include, anonymize or filter on.';

                trigger OnAction()
                begin
                    Rec.ShowFieldList(true);
                end;
            }
        }
    }
}
