pageextension 50065 MyExtension_65 extends "Manufacturing Setup"//T12395-NS
{
    layout
    {   //T12395-NS
        addlast(General)
        {
            field("Additional Purch. Planning"; rec."Additional Purch. Planning")
            {
                ApplicationArea = All;
            }
        }
        //T12395-NE
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}