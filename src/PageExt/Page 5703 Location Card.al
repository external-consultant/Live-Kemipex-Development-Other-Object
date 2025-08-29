pageextension 50067 PgeExt50067 extends "Location Card"
{
    layout
    {
        addlast(General)
        {
            field("Location Category"; rec."Location Category")
            {
                ApplicationArea = all;
                Description = 'T12436';

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