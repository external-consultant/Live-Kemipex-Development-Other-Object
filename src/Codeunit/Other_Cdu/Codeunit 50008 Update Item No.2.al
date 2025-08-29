codeunit 50008 "Update Item No.2"
{
    trigger OnRun()
    begin

    end;
    //T12114-NS
    [EventSubscriber(ObjectType::Table, Database::"Production Order", 'OnBeforeInsertEvent', '', true, true)]
    local procedure ProductionOrder_OnBeforeInsertEvent(var Rec: Record "Production Order")
    var
        Item_lRec: Record Item;
    begin
        if Rec.IsTemporary then
            exit;

        if Rec."Source Type" = Rec."Source Type"::Item then
            if Item_lRec.Get(Rec."Source No.") then
                rec."Item No. 2" := Item_lRec."No. 2";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Ledger Entry", 'OnBeforeInsertEvent', '', true, true)]
    local procedure ItemLedgerEntry_OnBeforeInsertEvent(var Rec: Record "Item Ledger Entry")
    var
        Item_lRec: Record Item;
    begin
        if Rec.IsTemporary then
            exit;

        if Item_lRec.Get(Rec."Item No.") then
            rec."Item No. 2" := Item_lRec."No. 2";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Production BOM Line", 'OnBeforeInsertEvent', '', true, true)]
    local procedure ProductionBOMLine_OnBeforeInsertEvent(var Rec: Record "Production BOM Line")
    var
        Item_lRec: Record Item;
    begin
        if Rec.IsTemporary then
            exit;

        if Rec.Type = Rec.Type::Item then
            if Item_lRec.Get(Rec."No.") then
                rec."Item No. 2" := Item_lRec."No. 2";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Prod. Order Line", 'OnBeforeInsertEvent', '', true, true)]
    local procedure ProdOrderLine_OnBeforeInsertEvent(var Rec: Record "Prod. Order Line")
    var
        Item_lRec: Record Item;
    begin
        if Rec.IsTemporary then
            exit;

        if Item_lRec.Get(Rec."Item No.") then
            rec."Item No. 2" := Item_lRec."No. 2";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Capacity Ledger Entry", 'OnBeforeInsertEvent', '', true, true)]
    local procedure CapacityLedgerEntry_OnBeforeInsertEvent(var Rec: Record "Capacity Ledger Entry")
    var
        Item_lRec: Record Item;
    begin
        if Rec.IsTemporary then
            exit;

        if Item_lRec.Get(Rec."Item No.") then
            rec."Item No. 2" := Item_lRec."No. 2";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Value Entry", 'OnBeforeInsertEvent', '', true, true)]
    local procedure ValueEntry_OnBeforeInsertEvent(var Rec: Record "Value Entry")
    var
        Item_lRec: Record Item;
    begin
        if Rec.IsTemporary then
            exit;

        if Item_lRec.Get(Rec."Item No.") then
            rec."Item No. 2" := Item_lRec."No. 2";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Warehouse Entry", 'OnBeforeInsertEvent', '', true, true)]
    local procedure WarehouseEntry_OnBeforeInsertEvent(var Rec: Record "Warehouse Entry")
    var
        Item_lRec: Record Item;
    begin
        if Rec.IsTemporary then
            exit;

        if Item_lRec.Get(Rec."Item No.") then
            rec."Item No. 2" := Item_lRec."No. 2";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Prod. Order Component", 'OnBeforeInsertEvent', '', true, true)]
    local procedure ProdOrderComponent_OnBeforeInsertEvent(var Rec: Record "Prod. Order Component")
    var
        Item_lRec: Record Item;
    begin
        if Rec.IsTemporary then
            exit;

        if Item_lRec.Get(Rec."Item No.") then
            rec."Item No. 2" := Item_lRec."No. 2";
    end;
    //T12114-NE
}