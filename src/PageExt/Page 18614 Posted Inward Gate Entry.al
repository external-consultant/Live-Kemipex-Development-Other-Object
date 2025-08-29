pageextension 50167 PgeExt_50167 extends "Posted Inward Gate Entry"
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