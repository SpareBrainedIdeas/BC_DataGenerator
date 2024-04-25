page 80802 "SPB DataGen Lines"
{
    ApplicationArea = All;
    Caption = 'SPB DataGen Lines';
    PageType = ListPart;
    SourceTable = "SPB DataGen Pkg. Table";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Package Code"; Rec."Package Code")
                {
                    ToolTip = 'Specifies the value of the Package Code field.';
                    Visible = false;
                }
                field("Table Id"; Rec."Table Id")
                {
                    ToolTip = 'Specifies the value of the Table Id field.';
                }
                field("Table Name"; Rec."Table Name")
                {
                    ToolTip = 'Specifies the value of the Table Name field.';
                }
                field("Maximum Records"; Rec."Maximum Records")
                {
                    ToolTip = 'Specifies the value of the Maximum Records field.';
                }
                field("Included Field Count"; Rec."Included Field Count")
                {
                    ToolTip = 'Specifies the value of the Included Field Count field.';
                }
                field("Total Field Count"; Rec."Total Field Count")
                {
                    ToolTip = 'Specifies the value of the Field Count field.';
                }
                field("Apply Codeunit Filtering"; Rec."Apply Codeunit Filtering")
                {
                    ToolTip = 'Specifies the value of the Apply Codeunit Filtering field.';
                }
                field("Filter Setting 1"; Rec."Filter Setting 1")
                {
                    ToolTip = 'Specifies the value of the Filter Setting 1 field.';
                }
                field("Filter Setting 2"; Rec."Filter Setting 2")
                {
                    ToolTip = 'Specifies the value of the Filter Setting 2 field.';
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
