//T12068-NS
codeunit 50005 "SalesPersons Filters"
{
    [EventSubscriber(ObjectType::Page, Page::"Customer List", 'OnOpenPageEvent', '', false, false)]
    local procedure "Customer List_OnOpenPageEvent"(var Rec: Record Customer)
    var
        UserSetup_lRec: Record "User Setup";
        SP_lPge: Page "Salespersons/Purchasers";
    begin
        UserSetup_lRec.GET(UserId);
        

        Clear(SP_lPge);
        Clear(AssSalesPer_gTxt);
        SP_lPge.SetMarkRecords(UserSetup_lRec."Linked SalesPersons");
        SP_lPge.Editable(false);
        SP_lPge.LookupMode(TRUE);
        AssSalesPer_gTxt := SP_lPge.GetMarkRecordsWithastriek();

        //IF UserSetup_lRec."Salespers./Purch. Code" <> '' Then begin
        IF UserSetup_lRec."Linked SalesPersons" <> '' Then begin//07082024
            Rec.FilterGroup(2);
            Rec.SetFilter("Associated SalesPerson", '*' + AssSalesPer_gTxt + '*' + '|''''');
            Rec.FilterGroup(0);
        End;

    end;

    [EventSubscriber(ObjectType::Page, Page::"Customer Lookup", 'OnOpenPageEvent', '', false, false)]
    local procedure "Customer Lookup_OnOpenPageEvent"(var Rec: Record Customer)
    var
        UserSetup_lRec: Record "User Setup";
        SP_lPge: Page "Salespersons/Purchasers";
    begin
        UserSetup_lRec.GET(UserId);

        Clear(AssSalesPer_gTxt);
        Clear(SP_lPge);
        SP_lPge.SetMarkRecords(UserSetup_lRec."Linked SalesPersons");
        SP_lPge.Editable(false);
        SP_lPge.LookupMode(TRUE);
        AssSalesPer_gTxt := SP_lPge.GetMarkRecordsWithastriek();

        //IF UserSetup_lRec."Salespers./Purch. Code" <> '' Then begin
        IF UserSetup_lRec."Linked SalesPersons" <> '' Then begin//07082024
            Rec.FilterGroup(2);
            Rec.SetFilter("Associated SalesPerson", '*' + AssSalesPer_gTxt + '*' + '|''''');
            Rec.FilterGroup(0);
        End;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Ship-to Address List", 'OnOpenPageEvent', '', false, false)]
    local procedure "Ship-to Address List_OnOpenPageEvent"(var Rec: Record "Ship-to Address")
    var
        UserSetup_lRec: Record "User Setup";
    begin
        UserSetup_lRec.GET(UserId);
        IF UserSetup_lRec."Linked SalesPersons" <> '' Then begin
            Rec.FilterGroup(2);
            Rec.SetFilter("Salesperson Code", UserSetup_lRec."Linked SalesPersons");
            Rec.FilterGroup(0);
        End;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Quotes", 'OnOpenPageEvent', '', false, false)]
    local procedure "SalesQuotes_OnOpenPageEvent"(var Rec: Record "Sales Header")
    var
        UserSetup_lRec: Record "User Setup";
    begin
        UserSetup_lRec.GET(UserId);
        IF UserSetup_lRec."Linked SalesPersons" <> '' Then begin
            Rec.FilterGroup(2);
            Rec.SetFilter("Salesperson Code", UserSetup_lRec."Linked SalesPersons");
            Rec.FilterGroup(0);
        End;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Order List", 'OnOpenPageEvent', '', false, false)]
    local procedure "SalesOrdersList_OnOpenPageEvent"(var Rec: Record "Sales Header")
    var
        UserSetup_lRec: Record "User Setup";
    begin
        UserSetup_lRec.GET(UserId);
        IF UserSetup_lRec."Linked SalesPersons" <> '' Then begin
            Rec.FilterGroup(2);
            Rec.SetFilter("Salesperson Code", UserSetup_lRec."Linked SalesPersons");
            Rec.FilterGroup(0);
        End;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Invoice List", 'OnOpenPageEvent', '', false, false)]
    local procedure "SalesInvoiceList_OnOpenPageEvent"(var Rec: Record "Sales Header")
    var
        UserSetup_lRec: Record "User Setup";
    begin
        UserSetup_lRec.GET(UserId);
        IF UserSetup_lRec."Linked SalesPersons" <> '' Then begin
            Rec.FilterGroup(2);
            Rec.SetFilter("Salesperson Code", UserSetup_lRec."Linked SalesPersons");
            Rec.FilterGroup(0);
        End;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Credit Memos", 'OnOpenPageEvent', '', false, false)]
    local procedure "Sales Credit Memos_OnOpenPageEvent"(var Rec: Record "Sales Header")
    var
        UserSetup_lRec: Record "User Setup";
    begin
        UserSetup_lRec.GET(UserId);
        IF UserSetup_lRec."Linked SalesPersons" <> '' Then begin
            Rec.FilterGroup(2);
            Rec.SetFilter("Salesperson Code", UserSetup_lRec."Linked SalesPersons");
            Rec.FilterGroup(0);
        End;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Return Order List", 'OnOpenPageEvent', '', false, false)]
    local procedure "SalesReturnOrderList_OnOpenPageEvent"(var Rec: Record "Sales Header")
    var
        UserSetup_lRec: Record "User Setup";
    begin
        UserSetup_lRec.GET(UserId);
        IF UserSetup_lRec."Linked SalesPersons" <> '' Then begin
            Rec.FilterGroup(2);
            Rec.SetFilter("Salesperson Code", UserSetup_lRec."Linked SalesPersons");
            Rec.FilterGroup(0);
        End;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Posted Return Receipts", 'OnOpenPageEvent', '', false, false)]
    local procedure "Posted Return Receipts_OnOpenPageEvent"(var Rec: Record "Return Receipt Header")
    var
        UserSetup_lRec: Record "User Setup";
    begin
        UserSetup_lRec.GET(UserId);
        IF UserSetup_lRec."Linked SalesPersons" <> '' Then begin
            Rec.FilterGroup(2);
            Rec.SetFilter("Salesperson Code", UserSetup_lRec."Linked SalesPersons");
            Rec.FilterGroup(0);
        End;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Posted Sales Credit Memos", 'OnOpenPageEvent', '', false, false)]
    local procedure "Posted Sales Credit Memos_OnOpenPageEvent"(var Rec: Record "Sales Cr.Memo Header")
    var
        UserSetup_lRec: Record "User Setup";
    begin
        UserSetup_lRec.GET(UserId);
        IF UserSetup_lRec."Linked SalesPersons" <> '' Then begin
            Rec.FilterGroup(2);
            Rec.SetFilter("Salesperson Code", UserSetup_lRec."Linked SalesPersons");
            Rec.FilterGroup(0);
        End;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Posted Sales Invoices", 'OnOpenPageEvent', '', false, false)]
    local procedure "Posted Sales Invoices_OnOpenPageEvent"(var Rec: Record "Sales Invoice Header")
    var
        UserSetup_lRec: Record "User Setup";
    begin
        UserSetup_lRec.GET(UserId);
        IF UserSetup_lRec."Linked SalesPersons" <> '' Then begin
            Rec.FilterGroup(2);
            Rec.SetFilter("Salesperson Code", UserSetup_lRec."Linked SalesPersons");
            Rec.FilterGroup(0);
        End;
    end;

    // procedure UpdateSalesPerson(MultipleSalesPersons: Record "Assign Multiple SalesPersons")
    // var
    //     CustRec_lRec: Record Customer;
    //     LoopMultipleSalesPersons_lRec: Record "Assign Multiple SalesPersons";
    // begin
    //     CustRec_lRec.Get(MultipleSalesPersons."Customer No.");
    //     AssSalesPer_gTxt := '';

    //     LoopMultipleSalesPersons_lRec.Reset();
    //     LoopMultipleSalesPersons_lRec.SetRange("Customer No.", MultipleSalesPersons."Customer No.");
    //     IF LoopMultipleSalesPersons_lRec.FindSet() Then begin
    //         repeat
    //             if AssSalesPer_gTxt = '' then
    //                 AssSalesPer_gTxt := '*' + LoopMultipleSalesPersons_lRec."SalesPerson Code"
    //             else
    //                 AssSalesPer_gTxt += '*|*' + LoopMultipleSalesPersons_lRec."SalesPerson Code" + '*';
    //         Until LoopMultipleSalesPersons_lRec.Next() = 0;
    //     end;

    //     CustRec_lRec.Modify();
    // end;

    var
        AssSalesPer_gTxt: Text;
}
//T12068-NE