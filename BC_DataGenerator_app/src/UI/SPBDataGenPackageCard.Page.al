page 80801 "SPB DataGen Package Card"
{
    Caption = 'SPB DataGen Package Card';
    PageType = Card;
    SourceTable = "SPB DataGen Package";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Package Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Package Code field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field("Tables Included"; Rec."Tables Included")
                {
                    ToolTip = 'Specifies the value of the Tables Included field.';
                    ApplicationArea = All;
                }
                field("Codeunit No."; Rec."Codeunit No.")
                {
                    ToolTip = 'Which Codeunit Number will be assigned when the AL file is generated';
                    ApplicationArea = All;
                }
                field("Include BeforeInserts"; Rec."Include BeforeInserts")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Include BeforeInserts field.';
                }
                field("Include AfterInserts"; Rec."Include AfterInserts")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Include AfterInserts field.';
                }
            }
            part(SPBDataGenLines; "SPB DataGen Lines")
            {
                ApplicationArea = All;
                SubPageLink = "Package Code" = field("Code");
            }
        }
    }
}
