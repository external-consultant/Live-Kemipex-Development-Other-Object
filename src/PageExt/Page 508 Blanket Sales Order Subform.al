pageextension 50204 "PageExt 508 Blanket SO Subform" extends "Blanket Sales Order Subform"
{
    layout
    {
        //T12706-NS
        modify("Variant Code")
        {
            Visible = true;
        }
        //T12706-NE
        addafter("Line Amount")
        {
            //T12540-NS
            field("TCS Nature of Collection"; Rec."TCS Nature of Collection")
            {
                ApplicationArea = all;
                trigger OnLookup(var Text: Text): Boolean
                begin
                    Rec.AllowedNocLookup(Rec, Rec."Sell-to Customer No.");
                    UpdateTaxAmount();
                end;

                trigger OnValidate()
                begin
                    UpdateTaxAmount();
                end;
            }
            field("Planned Delivery Date"; Rec."Planned Delivery Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the planned date that the shipment will be delivered at the customer''s address. If the customer requests a delivery date, the program calculates whether the items will be available for delivery on this date. If the items are available, the planned delivery date will be the same as the requested delivery date. If not, the program calculates the date that the items are available for delivery and enters this date in the Planned Delivery Date field.';
            }
            field("Planned Shipment Date"; Rec."Planned Shipment Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the date that the shipment should ship from the warehouse. If the customer requests a delivery date, the program calculates the planned shipment date by subtracting the shipping time from the requested delivery date. If the customer does not request a delivery date or the requested delivery date cannot be met, the program calculates the content of this field by adding the shipment time to the shipping date.';
            }

            //T12540-NE
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var

    local procedure UpdateTaxAmount()
    var
        CalculateTax: Codeunit "Calculate Tax";
    begin
        CurrPage.SaveRecord();
        CalculateTax.CallTaxEngineOnSalesLine(Rec, xRec);
    end;

}