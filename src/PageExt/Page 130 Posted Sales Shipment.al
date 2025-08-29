pageextension 50053 PostedSalesShipmentExt50053 extends "Posted Sales Shipment"
{
    layout
    {
        addlast(Shipping)
        {
            group("Logistic Details")
            {
                field("Vehicle No_New"; Rec."Vehicle No_New")
                {
                    ApplicationArea = All;
                }
                field("Container Code"; Rec."Container Code")
                {
                    ApplicationArea = All;
                }
                field("Container Seal No."; Rec."Container Seal No.")
                {
                    ApplicationArea = All;
                }
                field("Container Plat No."; Rec."Container Plat No.")
                {
                    ApplicationArea = All;
                }
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