page 80801 "SPB DataGen Package Card"
{
    ApplicationArea = All;
    Caption = 'SPB DataGen Package Card';
    PageType = Card;
    SourceTable = "SPB DataGen Package";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Package Code"; Rec.Code)
                {
                    ToolTip = 'Specifies the value of the Package Code field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Tables Included"; Rec."Tables Included")
                {
                    ToolTip = 'Specifies the value of the Tables Included field.';
                }
                field("Codeunit No."; Rec."Codeunit No.")
                {
                    ToolTip = 'Which Codeunit Number will be assigned when the AL file is generated';
                }
                field("Include BeforeInserts"; Rec."Include BeforeInserts")
                {
                    ToolTip = 'Specifies the value of the Include BeforeInserts field.';
                }
                field("Include AfterInserts"; Rec."Include AfterInserts")
                {
                    ToolTip = 'Specifies the value of the Include AfterInserts field.';
                }
            }
            part(SPBDataGenLines; "SPB DataGen Lines")
            {
                SubPageLink = "Package Code" = field(Code);
            }
        }
    }
}
