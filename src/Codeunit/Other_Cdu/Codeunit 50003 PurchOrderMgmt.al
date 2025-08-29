codeunit 50003 PurchOrderMgmt
{
    internal procedure LinkSalesOrder(var PurchHader: Record "Purchase Header"; SalesHeader: Record "Sales Header")
    var
        PL: Record "Purchase Line";
        SL: Record "Sales Line";
    begin
        PL.Reset();
        PL.SetRange("Document Type", PurchHader."Document Type");
        PL.SetRange("Document NO.", PurchHader."No.");
        PL.SetRange(Type, PL.Type::Item);
        PL.SetFilter("No.", '<>%1', '');
        PL.SetFilter(Quantity, '>%1', 0);
        if PL.FindSet() then begin
            repeat
                SL.Reset();
                SL.SetRange("Document Type", SalesHeader."Document Type");
                SL.SetRange("Document NO.", SalesHeader."No.");
                SL.SetRange(Type, SL.Type::Item);
                SL.SetRange("No.", PL."No.");
                SL.SetFilter(Quantity, '>=%1', PL.Quantity);
                if SL.FindFirst() then begin
                    SL.validate("Drop Shipment", true);
                    SL."Purchase Order No." := PL."Document No.";
                    SL."Purch. Order Line No." := PL."Line No.";
                    SL.Modify();

                    PL."Sales Order No." := SL."Document No.";
                    PL."Sales Order Line No." := SL."Line No.";
                    PL.Validate("Drop Shipment", true); //As per suggestion by vibhutiba - SS
                    PL.Modify(true);

                    if PurchHader."Sell-to Customer No." <> SalesHeader."Sell-to Customer No." then begin
                        PurchHader."Sell-to Customer No." := SalesHeader."Sell-to Customer No.";
                        PurchHader.Modify(true);
                    end;
                end else
                    Error('Item No %1 not found in Sale Order %2', PL."No.", SalesHeader."No.");
            until PL.Next = 0;

        end;
    end;



    // internal procedure LinkSalesOrder(var PurchHader: Record "Purchase Header"; Rec: Record "Purchase Header")
    // var
    //     NegLeg_lRec: Record "Reservation Entry";
    //     PosLeg_lRec: Record "Reservation Entry";
    //     PurchLn: Record "Purchase Line";
    //     SL_lRec: Record "Sales Line";
    // begin
    //     if PurchHader."Document Type" <> PurchHader."Document Type"::Order then
    //         Exit;

    //     PurchLn.Reset();
    //     PurchLn.SetRange("Document Type", PurchHader."Document Type");
    //     PurchLn.SetRange("Document No.", PurchHader."No.");
    //     PurchLn.SetFilter("Sal Order No.", '<>%1', '');
    //     if PurchLn.FindSet() then begin
    //         repeat
    //             SL_lRec.Reset();
    //             SL_lRec.SetRange("Document Type", SL_lRec."Document Type"::Order);
    //             SL_lRec.SetRange("Blanket Order No.", PurchLn."Sal Order No.");
    //             SL_lRec.SetRange("Blanket Order Line No.", PurchLn."Sal Order Line No.");
    //             SL_lRec.SetRange(Type, PurchLn.Type);
    //             SL_lRec.SetRange("No.", PurchLn."No.");
    //             if SL_lRec.FindFirst() then begin

    //                 CLEAR(NegLeg_lRec);
    //                 NegLeg_lRec.INIT;
    //                 NegLeg_lRec.Positive := FALSE;
    //                 NegLeg_lRec.INSERT(TRUE);
    //                 NegLeg_lRec."Item No." := SL_lRec."No.";
    //                 NegLeg_lRec."Variant Code" := SL_lRec."Variant Code";
    //                 NegLeg_lRec."Location Code" := SL_lRec."Location Code";
    //                 NegLeg_lRec."Qty. per Unit of Measure" := SL_lRec."Qty. per Unit of Measure";
    //                 NegLeg_lRec.VALIDATE("Quantity (Base)", (-1) * SL_lRec.Quantity);
    //                 NegLeg_lRec."Reservation Status" := NegLeg_lRec."Reservation Status"::Reservation;
    //                 NegLeg_lRec."Creation Date" := WORKDATE;
    //                 NegLeg_lRec."Source Type" := 37;
    //                 NegLeg_lRec."Source Subtype" := 1;
    //                 NegLeg_lRec."Source ID" := SL_lRec."Document No.";
    //                 //NegLeg_lRec."Source Prod. Order Line" := IJL_iRec."Again Production Order Line No";
    //                 NegLeg_lRec."Source Ref. No." := SL_lRec."Line No.";
    //                 NegLeg_lRec."Shipment Date" := WORKDATE;
    //                 NegLeg_lRec."Created By" := USERID;
    //                 NegLeg_lRec.Binding := NegLeg_lRec.Binding::"Order-to-Order";
    //                 NegLeg_lRec."Planning Flexibility" := NegLeg_lRec."Planning Flexibility"::Unlimited;
    //                 NegLeg_lRec.MODIFY;

    //                 CLEAR(PosLeg_lRec);
    //                 PosLeg_lRec.INIT;
    //                 PosLeg_lRec."Entry No." := NegLeg_lRec."Entry No.";
    //                 PosLeg_lRec.Positive := NOT NegLeg_lRec.Positive;
    //                 PosLeg_lRec."Item No." := PurchLn."No.";
    //                 PosLeg_lRec."Variant Code" := PurchLn."Variant Code";
    //                 PosLeg_lRec."Location Code" := PurchLn."Location Code";
    //                 PosLeg_lRec."Qty. per Unit of Measure" := PurchLn."Qty. per Unit of Measure";
    //                 PosLeg_lRec.VALIDATE("Quantity (Base)", PurchLn.Quantity);
    //                 PosLeg_lRec."Reservation Status" := PosLeg_lRec."Reservation Status"::Reservation;
    //                 PosLeg_lRec."Creation Date" := WORKDATE;
    //                 PosLeg_lRec."Source Type" := 39;
    //                 PosLeg_lRec."Source Subtype" := 1;
    //                 PosLeg_lRec."Source ID" := PurchLn."Document No.";
    //                 PosLeg_lRec."Source Ref. No." := PurchLn."Line No.";
    //                 PosLeg_lRec."Shipment Date" := WORKDATE;
    //                 PosLeg_lRec."Created By" := USERID;
    //                 PosLeg_lRec.Binding := PosLeg_lRec.Binding::"Order-to-Order";
    //                 PosLeg_lRec."Planning Flexibility" := PosLeg_lRec."Planning Flexibility"::Unlimited;
    //                 PosLeg_lRec.INSERT(TRUE);
    //             end;
    //         until PurchLn.Next = 0;
    //     end;
    // end;
}
