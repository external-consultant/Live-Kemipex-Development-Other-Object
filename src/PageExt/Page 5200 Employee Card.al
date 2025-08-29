pageextension 50039 EmployeeCard_P50039 extends "Employee Card"
{
    layout
    {
        addlast(General)
        {

            field("Job Domain"; Rec."Job Domain")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Job Domain field.';
            }
            field("Manager Code"; Rec."Manager Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Manager Code field.';
            }
            field(Team; Rec.Team)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Team field.';
            }
        }
    }
}