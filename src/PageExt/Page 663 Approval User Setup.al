pageextension 50061 "PageExt 663 App. User Setup" extends "Approval User Setup"
{
    layout
    {
        addbefore(Substitute)
        {
            field("Out of Office"; Rec."Out of Office")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Out of Office field.';
                trigger OnValidate()
                begin
                    // if Rec."Out of Office" then
                    //     Rec.TestField(Substitute);
                end;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
}