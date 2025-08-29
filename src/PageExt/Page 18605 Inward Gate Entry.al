pageextension 50166 PgeExt_50166 extends "Inward Gate Entry"
{
    layout
    {
        addafter(General)
        {
            field("Physical Verfication"; rec."Physical Verfication")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}