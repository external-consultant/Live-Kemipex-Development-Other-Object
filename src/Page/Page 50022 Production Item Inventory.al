page 50022 "Production Item Inventory"  //T12607-N
{
    ApplicationArea = All;
    Caption = 'Page Production Item Inventory';
    PageType = List;
    SourceTable = "Production BOM Line";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies a description of the item.';
                }

                field("Variant Code"; Rec."Variant Code")
                {
                    ToolTip = 'Specifies a Variant Code of the item.';
                }
                field("Quantity per"; Rec."Quantity per")
                {
                    ToolTip = 'Specifies how many units of the component are required to produce the parent item.';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ToolTip = 'Specifies how each unit of the item is measured, such as in pieces or tons. By default, the value in the Base Unit of Measure field on the item card is inserted.';
                }

                field(ReqQty; ReqQty)
                {
                    ToolTip = 'Specifies the total quantity of the item that is currently Required Qty at all locations.';
                    Caption = 'Required Quantity';
                }
                field(Inventory; Rec.Inventory)
                {

                    ToolTip = 'Specifies the total quantity of the item that is currently in inventory at all locations.';

                }


            }
        }
    }

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        if SICdu.GetReqQtyValue <> 0 then
            ReqQty := rec."Quantity per" * SICdu.GetReqQtyValue;
    end;

    trigger OnClosePage()
    var
        myInt: Integer;
    begin
        FindLastProdBomLine_gRec.reset;
        FindLastProdBomLine_gRec.SetRange("Production BOM No.", SICdu.GetBOMCdeValue());
        FindLastProdBomLine_gRec.SetRange("No.", SICdu.GetItemValue());
        FindLastProdBomLine_gRec.SetRange("Line No.", SICdu.GetLineValue());
        FindLastProdBomLine_gRec.SetRange("Version Code", SICdu.GetVesrionCdeValue());
        if FindLastProdBomLine_gRec.FindSet() then
            FindLastProdBomLine_gRec.Delete();
    end;

    var
        ReqQty: Decimal;
        SICdu: Codeunit ProductionInventory_SI;
        FindLastProdBomLine_gRec: Record "Production BOM Line";
}

