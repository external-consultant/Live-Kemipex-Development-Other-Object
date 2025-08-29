//T12068-NS
pageextension 50000 "PageExt 21 Customer Card" extends "Customer Card"
{
    layout
    {
        addlast(General)
        {
            field("First Approval Completed"; Rec."First Approval Completed")
            {
                ApplicationArea = All;
                Visible= false;
                ToolTip = 'Specifies the value of the First Approval Completed field.', Comment = '%';
            }
        }
    }

    actions
    {
        addafter("Ledger E&ntries")
        {
            action(AssignMultiSalesPerson)
            {
                ApplicationArea = all;
                Caption = 'Assign Multiple SalesPersons';
                Promoted = true;
                Image = SalesPerson;
                RunObject = page "Assign Multiple SalesPersons";
                RunPageLink = "Customer No." = field("No.");
                RunPageView = sorting("Customer No.") order(descending);
                ToolTip = 'To assign multiple Salespersons to the Customer.';
            }
        }
    }
    //T12068-NE

    var
    //myInt: Integer;
}