page 80803 "SPB DataGen Line Fields"
{
    ApplicationArea = All;
    Caption = 'SPB DataGen Line Fields';
    PageType = List;
    SourceTable = "SPB DataGen Pkg. Field";

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
                    Visible = false;
                }
                field("Field No."; Rec."Field No.")
                {
                    ToolTip = 'Specifies the value of the Field No. field.';
                }
                field("Field Name"; Rec."Field Name")
                {
                    ToolTip = 'Specifies the value of the Field Name field.';
                }
                field(Include; Rec.Include)
                {
                    ToolTip = 'Specifies the value of the Include field.';
                }
                field(Anonymize; Rec.Anonymize)
                {
                    ToolTip = 'If selected, the real data will not be used and a pseudorandom value will be used instead';
                }
                field("Filter"; Rec."Filter")
                {
                    ToolTip = 'Specifies the value of the Filter field.';
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
                Caption = 'Select All';
                Image = SelectMore;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    SelectAllNormalFields();
                end;
            }
            action(CancelAllLinesAction)
            {
                Caption = 'Clear All';
                Image = CancelAllLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

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
        DataGenField.Copy(Rec);
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
            DataGenField.Copy(Rec);
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
