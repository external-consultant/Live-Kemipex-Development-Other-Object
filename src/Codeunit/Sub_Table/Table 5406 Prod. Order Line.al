codeunit 50010 "Sub 5406 Prod. Order Line"
{
    trigger OnRun()
    begin

    end;
    //T12114-NS
    [EventSubscriber(ObjectType::Table, Database::"Prod. Order Line", OnAfterCopyFromItem, '', false, false)]
    local procedure "Prod. Order Line_OnAfterCopyFromItem"(var ProdOrderLine: Record "Prod. Order Line"; Item: Record Item; var xProdOrderLine: Record "Prod. Order Line"; CurrentFieldNo: Integer)
    var
        ProdOrderHead_lRec: Record "Production Order";
    begin
        if ProdOrderLine."Line No." = 10000 then begin
            ProdOrderHead_lRec.Reset();
            ProdOrderHead_lRec.SetRange("No.", ProdOrderLine."Prod. Order No.");
            ProdOrderHead_lRec.SetFilter("Production BOM Version", '<>%1', '');
            if ProdOrderHead_lRec.FindFirst() then
                ProdOrderLine.Validate("Production BOM Version Code", ProdOrderHead_lRec."Production BOM Version");
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Prod. Order Line", OnAfterGetUpdateFromSKU, '', false, false)]
    local procedure "Prod. Order Line_OnAfterGetUpdateFromSKU"(var ProdOrderLine: Record "Prod. Order Line"; var Item: Record Item; var StockkeepingUnit: Record "Stockkeeping Unit")
    var
        LocationRouting_lRec: Record "Location Routing";
        ProdOrderHead_lRec: Record "Production Order";
    begin
        ProdOrderHead_lRec.Reset();
        ProdOrderHead_lRec.SetRange("No.", ProdOrderLine."Prod. Order No.");
        if ProdOrderHead_lRec.FindFirst() then begin
            if (ProdOrderHead_lRec."Source Type" = ProdOrderHead_lRec."Source Type"::Item) and (ProdOrderHead_lRec."Source No." <> '') then begin
                LocationRouting_lRec.Reset();
                LocationRouting_lRec.SetRange("Item No.", ProdOrderHead_lRec."Source No.");
                LocationRouting_lRec.SetRange("Location Code", ProdOrderHead_lRec."Location Code");
                if LocationRouting_lRec.FindFirst() then
                    if LocationRouting_lRec.Routing <> '' then
                        ProdOrderLine.Validate("Routing No.", LocationRouting_lRec.Routing);
            end;
        end;
    end;

    //T12114-NE
}