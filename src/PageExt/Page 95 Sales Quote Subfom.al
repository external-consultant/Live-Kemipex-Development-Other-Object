pageextension 50205 "PageExt 95 Sales Quote Subf" extends "Sales Quote Subform"
{
    layout
    {
        addlast(Control1)
        {
            //T12540-NS
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
            field("Shipment Date"; Rec."Shipment Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.';
            }
            field("TCS Nature of Collection_"; Rec."TCS Nature of Collection")
            {
                ApplicationArea = all;
                Caption = 'TCS Nature of Collection';
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