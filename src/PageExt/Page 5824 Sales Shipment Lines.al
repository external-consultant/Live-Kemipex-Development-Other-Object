pageextension 50102 SalesShipmentline50102 extends "Sales Shipment Lines"
{
    layout
    {
        //T12706-NS
        modify("Variant Code")
        {
            Visible = true;
        }
        //T12706-NE
    }
}
