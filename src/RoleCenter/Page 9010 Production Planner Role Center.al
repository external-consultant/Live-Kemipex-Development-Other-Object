pageextension 50070 "Prod. Planner Role Center_9010" extends "Production Planner Role Center"
{
    layout
    {
        addafter(Control1905113808)
        {
            //T12542-NS
            part("QC Receipts Role Center"; "QC Receipts Role Center")
            {
                ApplicationArea = All;
            }
            //T12542-NE
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}