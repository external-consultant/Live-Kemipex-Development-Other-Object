codeunit 50011 "Sub 99000787 Cal. Prod. Order"
{
    Permissions = tabledata "Production Order" = rm;
    trigger OnRun()
    begin

    end;
    //T12114-NS



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Prod. Order Lines", OnAfterCopy, '', false, false)]
    local procedure "Create Prod. Order Lines_OnAfterCopy"(var ProdOrder: Record "Production Order"; var ErrorOccured: Boolean)
    var
        ProdOrderLine_lRec: Record "Prod. Order Line";
        WorkCenter_lRec: Record "Work Center";
        ProdOrderRoutingLine_lRec: Record "Prod. Order Routing Line";
    begin
        ProdOrderLine_lRec.Reset();
        ProdOrderLine_lRec.SetRange("Prod. Order No.", ProdOrder."No.");
        ProdOrderLine_lRec.SetRange(Status, ProdOrder.Status);
        ProdOrderLine_lRec.SetRange("Line No.", 10000);
        if ProdOrderLine_lRec.FindFirst() then begin
            ProdOrderRoutingLine_lRec.Reset();
            ProdOrderRoutingLine_lRec.SetRange("Routing Reference No.", ProdOrderLine_lRec."Line No.");
            ProdOrderRoutingLine_lRec.SetRange("Prod. Order No.", ProdOrderLine_lRec."Prod. Order No.");
            ProdOrderRoutingLine_lRec.SetRange(Status, ProdOrderLine_lRec.Status);
            ProdOrderRoutingLine_lRec.SetRange(Type, ProdOrderRoutingLine_lRec.Type::"Work Center");
            ProdOrderRoutingLine_lRec.Setfilter("No.", '<>%1', '');
            if ProdOrderRoutingLine_lRec.FindFirst() then begin
                WorkCenter_lRec.Reset();
                WorkCenter_lRec.Get(ProdOrderRoutingLine_lRec."No.");
                if WorkCenter_lRec."Batch Quantity" <> 0 then begin
                    ProdOrder."Batch Quantity" := WorkCenter_lRec."Batch Quantity";
                    ProdOrder.Modify();
                end;
            end;
        end;

    end;
    //T12114-NE

    //T12750-NS
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Carry Out Action", OnAfterInsertProdOrder, '', false, false)]
    local procedure "Carry Out Action_OnAfterInsertProdOrder"(var ProductionOrder: Record "Production Order"; ProdOrderChoice: Integer; var RequisitionLine: Record "Requisition Line")
    var
        ProdOrderLine_lRec: Record "Prod. Order Line";
        WorkCenter_lRec: Record "Work Center";
        ProdOrderRoutingLine_lRec: Record "Prod. Order Routing Line";
    begin
        ProdOrderLine_lRec.Reset();
        ProdOrderLine_lRec.SetRange("Prod. Order No.", ProductionOrder."No.");
        ProdOrderLine_lRec.SetRange(Status, ProductionOrder.Status);
        ProdOrderLine_lRec.SetRange("Line No.", 10000);
        if ProdOrderLine_lRec.FindFirst() then begin
            ProdOrderRoutingLine_lRec.Reset();
            ProdOrderRoutingLine_lRec.SetRange("Routing Reference No.", ProdOrderLine_lRec."Line No.");
            ProdOrderRoutingLine_lRec.SetRange("Prod. Order No.", ProdOrderLine_lRec."Prod. Order No.");
            ProdOrderRoutingLine_lRec.SetRange(Status, ProdOrderLine_lRec.Status);
            ProdOrderRoutingLine_lRec.SetRange(Type, ProdOrderRoutingLine_lRec.Type::"Work Center");
            ProdOrderRoutingLine_lRec.Setfilter("No.", '<>%1', '');
            if ProdOrderRoutingLine_lRec.FindFirst() then begin
                WorkCenter_lRec.Reset();
                WorkCenter_lRec.Get(ProdOrderRoutingLine_lRec."No.");
                if WorkCenter_lRec."Batch Quantity" <> 0 then begin
                    ProductionOrder."Batch Quantity" := WorkCenter_lRec."Batch Quantity";
                    ProductionOrder.Modify();
                end;
            end;
        end;
    end;
    //T12750-NE
    // [EventSubscriber(ObjectType::Table, Database::"production Order", 'OnBeforeModifyEvent', '', true, true)]
    // local procedure "ProductionOrder_OnBeforeModifyEvent"
    // (
    //     var Rec: Record "production Order";
    //     RunTrigger: Boolean
    // )
    // var
    //     ProductionOrder_lRec: Record "production Order";
    // begin
    //     if rec.IsTemporary then
    //         exit;
             
    // end;


}