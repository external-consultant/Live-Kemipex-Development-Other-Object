pageextension 50066 Buss_Manager_Role_Center_50066 extends "Business Manager Role Center"//TABA-08082024
{
    layout
    {
        // Add changes to page layout here
        addbefore("Intercompany Activities")
        {
            Part("Open Reservation Entries"; "Open Reservation Entries")
            {
                caption = 'Expiring Reservation in 5 days';
                ApplicationArea = All;

            }
        }
    }



    var
        myInt: Integer;
}