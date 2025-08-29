pageextension 50035 "O365 Activities Ext" extends "O365 Activities"
{
    layout
    {
        addlast("Ongoing Sales")
        {
            field("Warehouse Shipments"; Rec."Warehouse Shipments")
            {
                ApplicationArea = Suite;
                DrillDownPageID = "Warehouse Shipment List";
                ToolTip = 'Specifies Warehouse Shipments.';
            }
        }
    }
    trigger OnOpenPage()
    var
        WarehouseShipmentHeader_lRec: Record "Warehouse Shipment Header";
        WMSManagement: Codeunit "WMS Management";
    begin

        WarehouseShipmentHeader_lRec.Reset();
        WarehouseShipmentHeader_lRec.SetFilter("Location Code", WMSManagement.GetWarehouseEmployeeLocationFilter(UserId));
        if WarehouseShipmentHeader_lRec.FindSet() then begin
            Rec."Warehouse Shipments" := WarehouseShipmentHeader_lRec.Count;
            Rec.Modify();
        end;

    end;
}
