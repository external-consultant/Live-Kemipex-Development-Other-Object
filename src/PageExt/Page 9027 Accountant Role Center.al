pageextension 50045 AccountantRoleCenterExt50045 extends "Accountant Role Center"
{
    layout
    {
        addafter("User Tasks Activities")
        {
            //T12141-NS
            part("Due & Outstanding Purch. Inv"; "Due & Outstanding Purch. Inv")
            {
                ApplicationArea = All;
            }
            //T12141-NE
        }
    }
}