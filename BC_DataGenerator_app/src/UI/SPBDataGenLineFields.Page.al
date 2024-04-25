page 80803 "SPB DataGen Line Fields"
{
    Caption = 'SPB DataGen Line Fields';
    PageType = List;
    SourceTable = "SPB DataGen Pkg. Field";

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
                    Visible = false;
                }
                field("Field No."; Rec."Field No.")
                {
                    ToolTip = 'Specifies the value of the Field No. field.';
                    ApplicationArea = All;
                }
                field("Field Name"; Rec."Field Name")
                {
                    ToolTip = 'Specifies the value of the Field Name field.';
                    ApplicationArea = All;
                }
                field(Include; Rec.Include)
                {
                    ToolTip = 'Specifies the value of the Include field.';
                    ApplicationArea = All;
                }
                field(Anonymize; Rec.Anonymize)
                {
                    ToolTip = 'If selected, the real data will not be used and a pseudorandom value will be used instead';
                    ApplicationArea = All;
                }
                field("Filter"; Rec."Filter")
                {
                    ToolTip = 'Specifies the value of the Filter field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(SelectNormalFieldsAction)
            {
                ApplicationArea = All;
                Image = SelectMore;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Caption = 'Select All';

                trigger OnAction()
                begin
                    SelectAllNormalFields();
                end;
            }
            action(CancelAllLinesAction)
            {
                ApplicationArea = All;
                Image = CancelAllLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Caption = 'Clear All';

                trigger OnAction()
                begin
                    ClearAllFields();
                end;
            }

        }
    }

    trigger OnAfterGetRecord()
    begin
        FieldStyle := 'Standard';
        if not Rec."Is Normal Field" then
            FieldStyle := 'Subordinate';
    end;

    procedure SelectAllNormalFields()
    var
        DataGenField: Record "SPB DataGen Pkg. Field";
    begin
        DataGenField.copy(Rec);
        DataGenField.SetRange("Is Normal Field", true);
        if DataGenField.FindSet() then
            repeat
                DataGenField.Validate(Include, true);
                DataGenField.Modify(true);
            until DataGenField.Next() < 1;
        if Rec.FindFirst() then;
    end;

    procedure ClearAllFields()
    var
        DataGenField: Record "SPB DataGen Pkg. Field";
    begin
        if Confirm('Are you sure you want to remove all fields?', false) then begin
            DataGenField.copy(Rec);
            DataGenField.SetRange("Is Normal Field", true);
            if DataGenField.FindSet() then
                repeat
                    DataGenField.Validate(Include, false);
                    DataGenField.Modify(true);
                until DataGenField.Next() < 1;
        end;
        if Rec.FindFirst() then;
    end;

    var
        FieldStyle: Text;
}
