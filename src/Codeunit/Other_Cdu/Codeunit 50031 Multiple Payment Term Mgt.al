codeunit 50031 "Multiple Payment Term Mgt"
{
    //T12539-N
    var
    // SalesSetup_gRec: Record "Sales & Receivables Setup";
    // PurchSetup_gRec: Record "Purchases & Payables Setup";
    // Currency_gRec: Record Currency;

    procedure SalesDocAmtUpd_gFnc(SalesHeader_iRec: Record "Sales Header")
    var
        MultiplePaymentTrems_lRec: Record "Multiple Payment Terms";
        PaymentTerms_lRec: Record "Payment Terms";
    begin
        if SalesHeader_iRec."Document Type" = SalesHeader_iRec."Document Type"::Quote then
            exit;
        // SalesHeader_iRec.CalcFields("Amount Including VAT");

        SalesHeader_iRec.TestField("Payment Terms Code");

        MultiplePaymentTrems_lRec.Reset;
        MultiplePaymentTrems_lRec.SetRange("Document No.", SalesHeader_iRec."No.");
        MultiplePaymentTrems_lRec.SetRange("Document Type", SalesHeader_iRec."Document Type");
        MultiplePaymentTrems_lRec.SetRange(Type, MultiplePaymentTrems_lRec.Type::Sales);
        MultiplePaymentTrems_lRec.SetRange("Table ID", 36);
        if MultiplePaymentTrems_lRec.FindSet then begin
            repeat
                SalesHeader_iRec.TestField("Document Date");
                MultiplePaymentTrems_lRec."Event Date" := SalesHeader_iRec."Document Date";
                MultiplePaymentTrems_lRec.Type := MultiplePaymentTrems_lRec.Type::Sales;
                MultiplePaymentTrems_lRec.Validate("Due Date Calculation");
                MultiplePaymentTrems_lRec.Validate("Percentage of Total");
                MultiplePaymentTrems_lRec.Released := True;
                MultiplePaymentTrems_lRec.Modify;
            until MultiplePaymentTrems_lRec.Next = 0;
        end else begin
            if SalesHeader_iRec."Payment Terms Code" <> '' then begin
                PaymentTerms_lRec.Reset();
                PaymentTerms_lRec.Get(SalesHeader_iRec."Payment Terms Code");
                MultiplePaymentTrems_lRec.Init;
                case SalesHeader_iRec."Document Type" of
                    SalesHeader_iRec."Document Type"::Order:
                        MultiplePaymentTrems_lRec."Document Type" := MultiplePaymentTrems_lRec."Document Type"::Order;
                    SalesHeader_iRec."Document Type"::Invoice:
                        MultiplePaymentTrems_lRec."Document Type" := MultiplePaymentTrems_lRec."Document Type"::Invoice;
                    SalesHeader_iRec."Document Type"::"Return Order":
                        MultiplePaymentTrems_lRec."Document Type" := MultiplePaymentTrems_lRec."Document Type"::"Return Order";
                    SalesHeader_iRec."Document Type"::"Credit Memo":
                        MultiplePaymentTrems_lRec."Document Type" := MultiplePaymentTrems_lRec."Document Type"::"Credit Memo";
                    SalesHeader_iRec."Document Type"::Quote:
                        MultiplePaymentTrems_lRec."Document Type" := MultiplePaymentTrems_lRec."Document Type"::Quote;
                    SalesHeader_iRec."Document Type"::"Blanket Order":
                        MultiplePaymentTrems_lRec."Document Type" := MultiplePaymentTrems_lRec."Document Type"::"Blanket Order";
                end;
                MultiplePaymentTrems_lRec."Table ID" := 36;
                MultiplePaymentTrems_lRec.Type := MultiplePaymentTrems_lRec.Type::Sales;
                MultiplePaymentTrems_lRec."Document No." := SalesHeader_iRec."No.";
                MultiplePaymentTrems_lRec."Payment Description" := '100% Payment';
                MultiplePaymentTrems_lRec."Event Date" := SalesHeader_iRec."Document Date";
                MultiplePaymentTrems_lRec.Validate("Due Date Calculation", PaymentTerms_lRec."Due Date Calculation");
                MultiplePaymentTrems_lRec."Payment Description" := PaymentTerms_lRec.Description;
                MultiplePaymentTrems_lRec.Validate("Percentage of Total", 100);
                MultiplePaymentTrems_lRec."Amount of Document" := MultiplePaymentTrems_lRec.GetNetAmount();
                MultiplePaymentTrems_lRec.Released := True;
                MultiplePaymentTrems_lRec.Insert(true);
            end;
        end;
    end;

    local procedure RoundInvPrecision(InvAmount: Decimal): Decimal
    var
        GLSetup: Record "General Ledger Setup";
        InvRoundingDirection: Text;
        InvRoundingPrecision: Decimal;
    begin
        GLSetup.GET;
        CASE GLSetup."Inv. Rounding Type (LCY)" OF
            GLSetup."Inv. Rounding Type (LCY)"::Nearest:
                InvRoundingDirection := '=';
            GLSetup."Inv. Rounding Type (LCY)"::Up:
                InvRoundingDirection := '>';
            GLSetup."Inv. Rounding Type (LCY)"::Down:
                InvRoundingDirection := '<';
        END;
        IF GLSetup."Inv. Rounding Precision (LCY)" <> 0 THEN
            InvRoundingPrecision := GLSetup."Inv. Rounding Precision (LCY)"
        ELSE
            InvRoundingPrecision := 0.01;
        EXIT(ROUND(InvAmount, InvRoundingPrecision, InvRoundingDirection));
    end;

    procedure PurchaseDocAmtUpd_gFnc(PurchHeader_iRec: Record "Purchase Header")
    var
        PaymentTerms_lRec: Record "Payment Terms";
        MultiplePaymentTrems_lRec: Record "Multiple Payment Terms";
    begin
        if PurchHeader_iRec."Document Type" = PurchHeader_iRec."Document Type"::Quote then
            exit;
        // PurchHeader_iRec.CalcFields("Amount Including VAT");

        PurchHeader_iRec.TestField("Payment Terms Code");  //T11395-N

        MultiplePaymentTrems_lRec.Reset;
        MultiplePaymentTrems_lRec.SetRange("Document No.", PurchHeader_iRec."No.");
        MultiplePaymentTrems_lRec.SetRange("Document Type", PurchHeader_iRec."Document Type");
        MultiplePaymentTrems_lRec.SetRange(Type, MultiplePaymentTrems_lRec.Type::Purchase);
        MultiplePaymentTrems_lRec.SetRange("Table ID", 38);
        if MultiplePaymentTrems_lRec.FindSet then begin
            repeat
                PurchHeader_iRec.TestField("Document Date");
                MultiplePaymentTrems_lRec."Event Date" := PurchHeader_iRec."Document Date";
                MultiplePaymentTrems_lRec.Type := MultiplePaymentTrems_lRec.Type::Purchase;
                MultiplePaymentTrems_lRec.Validate("Due Date Calculation");
                MultiplePaymentTrems_lRec.Validate("Percentage of Total");
                MultiplePaymentTrems_lRec.Released := True;
                MultiplePaymentTrems_lRec.Modify;
            until MultiplePaymentTrems_lRec.Next = 0;
        end else begin
            if PurchHeader_iRec."Payment Terms Code" <> '' then begin
                PaymentTerms_lRec.Reset();
                PaymentTerms_lRec.Get(PurchHeader_iRec."Payment Terms Code");
                MultiplePaymentTrems_lRec.Init;
                case PurchHeader_iRec."Document Type" of
                    PurchHeader_iRec."Document Type"::Order:
                        MultiplePaymentTrems_lRec."Document Type" := MultiplePaymentTrems_lRec."Document Type"::Order;
                    PurchHeader_iRec."Document Type"::Invoice:
                        MultiplePaymentTrems_lRec."Document Type" := MultiplePaymentTrems_lRec."Document Type"::Invoice;
                    PurchHeader_iRec."Document Type"::"Return Order":
                        MultiplePaymentTrems_lRec."Document Type" := MultiplePaymentTrems_lRec."Document Type"::"Return Order";
                    PurchHeader_iRec."Document Type"::"Credit Memo":
                        MultiplePaymentTrems_lRec."Document Type" := MultiplePaymentTrems_lRec."Document Type"::"Credit Memo";
                    PurchHeader_iRec."Document Type"::"Blanket Order":
                        MultiplePaymentTrems_lRec."Document Type" := MultiplePaymentTrems_lRec."Document Type"::"Blanket Order";
                    PurchHeader_iRec."Document Type"::Quote:
                        MultiplePaymentTrems_lRec."Document Type" := MultiplePaymentTrems_lRec."Document Type"::Quote;
                end;
                MultiplePaymentTrems_lRec."Table ID" := 38;
                MultiplePaymentTrems_lRec.Type := MultiplePaymentTrems_lRec.Type::Purchase;
                MultiplePaymentTrems_lRec."Document No." := PurchHeader_iRec."No.";
                MultiplePaymentTrems_lRec."Event Date" := PurchHeader_iRec."Document Date";
                MultiplePaymentTrems_lRec."Payment Description" := PaymentTerms_lRec.Description;
                MultiplePaymentTrems_lRec.Validate("Due Date Calculation", PaymentTerms_lRec."Due Date Calculation");
                MultiplePaymentTrems_lRec.Validate("Percentage of Total", 100);
                MultiplePaymentTrems_lRec."Amount of Document" := MultiplePaymentTrems_lRec.GetPurNetAmount();
                MultiplePaymentTrems_lRec.Released := True;
                MultiplePaymentTrems_lRec.Insert(true);
            end;
        end;
    end;

    procedure CheckMultiplePaymentTermValidation_gFnc(SalesHeader_iRec: Record "Sales Header")
    var
        MultiplePaymentTerms_lRec: Record "Multiple Payment Terms";
        Percentage_lDec: Decimal;
        Amount_lDec: Decimal;
        Diff_lDec: Decimal;
    begin
        if SalesHeader_iRec."Document Type" = SalesHeader_iRec."Document Type"::Quote then
            exit;

        Percentage_lDec := 0;
        Amount_lDec := 0;
        // SalesHeader_iRec.CalcFields("Amount Including VAT");
        MultiplePaymentTerms_lRec.Reset;
        MultiplePaymentTerms_lRec.SetRange("Document No.", SalesHeader_iRec."No.");
        MultiplePaymentTerms_lRec.SetRange("Document Type", SalesHeader_iRec."Document Type");
        MultiplePaymentTerms_lRec.SetRange(Type, MultiplePaymentTerms_lRec.Type::Sales);
        MultiplePaymentTerms_lRec.SetRange("Table ID", 36);
        if MultiplePaymentTerms_lRec.FindSet then begin
            repeat
                Percentage_lDec += MultiplePaymentTerms_lRec."Percentage of Total";
            until MultiplePaymentTerms_lRec.Next = 0;
        end;

        if Percentage_lDec <> 100 then
            Error('Multiple Payment term Percentage is not equal to 100 for Document No %1', SalesHeader_iRec."No.");

        MultiplePaymentTerms_lRec.Reset;
        MultiplePaymentTerms_lRec.SetRange("Document No.", SalesHeader_iRec."No.");
        MultiplePaymentTerms_lRec.SetRange("Document Type", SalesHeader_iRec."Document Type");
        MultiplePaymentTerms_lRec.SetRange(Type, MultiplePaymentTerms_lRec.Type::Sales);
        MultiplePaymentTerms_lRec.SetRange("Table ID", 36);
        if MultiplePaymentTerms_lRec.FindSet then begin
            repeat
                Amount_lDec += MultiplePaymentTerms_lRec."Amount of Document";
            until MultiplePaymentTerms_lRec.Next = 0;
        end;

        If MultiplePaymentTerms_lRec.GetNetAmount() <> 0 then begin
            Diff_lDec := Abs(Amount_lDec) - Abs(MultiplePaymentTerms_lRec.GetNetAmount());

            //Rounding and add amount to last line.
            MultiplePaymentTerms_lRec.Reset;
            MultiplePaymentTerms_lRec.SetRange("Document No.", SalesHeader_iRec."No.");
            MultiplePaymentTerms_lRec.SetRange("Document Type", SalesHeader_iRec."Document Type");
            MultiplePaymentTerms_lRec.SetRange(Type, MultiplePaymentTerms_lRec.Type::Sales);
            MultiplePaymentTerms_lRec.SetRange("Table ID", 36);
            if MultiplePaymentTerms_lRec.FindLast then begin
                MultiplePaymentTerms_lRec."Amount of Document" += Diff_lDec;
                MultiplePaymentTerms_lRec.Modify();
            end;

            // if Abs(Diff_lDec) > 1 then
            //     Error('Multiple Payment term Amount %1 is not equal to Amount to Customer %2 in Sales Document No %3', Abs(Amount_lDec), Abs(SalesHeader_iRec."Amount Including VAT"), SalesHeader_iRec."No.");
        end;
    end;


    // procedure SalesHeadertoPostInvoice_gFnc(SalesHeader_iRec: Record "Sales Header"; PostedSalesInvoiceNo_iCde: Code[20])
    // var
    //     MultiplePaymentTrems_lRec: Record "Multiple Payment Terms";
    //     TempMultiplePaymentTerms_lRec: Record "Multiple Payment Terms";
    // begin
    //     if not (SalesHeader_iRec."Document Type" in [SalesHeader_iRec."document type"::Invoice, SalesHeader_iRec."document type"::Order]) then
    //         exit;

    //     MultiplePaymentTrems_lRec.Reset;
    //     MultiplePaymentTrems_lRec.SetRange("Document No.", SalesHeader_iRec."No.");
    //     MultiplePaymentTrems_lRec.SetRange("Document Type", SalesHeader_iRec."Document Type");
    //     MultiplePaymentTrems_lRec.SetRange("Table ID", 36);
    //     if MultiplePaymentTrems_lRec.FindSet then begin
    //         repeat
    //             TempMultiplePaymentTerms_lRec.Init;
    //             TempMultiplePaymentTerms_lRec."Document No." := PostedSalesInvoiceNo_iCde;
    //             TempMultiplePaymentTerms_lRec."Document Type" := TempMultiplePaymentTerms_lRec."document type"::"Posted Sales Invoice";
    //             TempMultiplePaymentTerms_lRec."Table ID" := 112;
    //             TempMultiplePaymentTerms_lRec."Line No." := MultiplePaymentTrems_lRec."Line No.";
    //             TempMultiplePaymentTerms_lRec."Event Date" := MultiplePaymentTrems_lRec."Event Date";
    //             TempMultiplePaymentTerms_lRec.Sequence := MultiplePaymentTrems_lRec.Sequence;
    //             TempMultiplePaymentTerms_lRec."Due Date Calculation" := MultiplePaymentTrems_lRec."Due Date Calculation";
    //             TempMultiplePaymentTerms_lRec."Due Date" := MultiplePaymentTrems_lRec."Due Date";
    //             TempMultiplePaymentTerms_lRec."Percentage of Total" := MultiplePaymentTrems_lRec."Percentage of Total";
    //             TempMultiplePaymentTerms_lRec."Amount of Document" := MultiplePaymentTrems_lRec."Amount of Document";
    //             TempMultiplePaymentTerms_lRec.Insert;
    //         until MultiplePaymentTrems_lRec.Next = 0;
    //         if SalesHeader_iRec."Document Type" = SalesHeader_iRec."document type"::Invoice then
    //             MultiplePaymentTrems_lRec.DeleteAll;
    //     end;
    // end;


    // procedure SalesHeadertoPostCreditMemo_gFnc(SalesHeader_iRec: Record "Sales Header"; PostedSalesCreditMemoNo_iCde: Code[20])
    // var
    //     MultiplePaymentTrems_lRec: Record "Multiple Payment Terms";
    //     TempMultiplePaymentTerms_lRec: Record "Multiple Payment Terms";
    // begin
    //     if not (SalesHeader_iRec."Document Type" in [SalesHeader_iRec."document type"::Invoice, SalesHeader_iRec."document type"::Order, SalesHeader_iRec."document type"::"Credit Memo"]) then
    //         exit;

    //     MultiplePaymentTrems_lRec.Reset;
    //     MultiplePaymentTrems_lRec.SetRange("Document No.", SalesHeader_iRec."No.");
    //     MultiplePaymentTrems_lRec.SetRange("Document Type", SalesHeader_iRec."Document Type");
    //     MultiplePaymentTrems_lRec.SetRange("Table ID", 36);
    //     if MultiplePaymentTrems_lRec.FindSet then begin
    //         repeat
    //             TempMultiplePaymentTerms_lRec.Init;
    //             TempMultiplePaymentTerms_lRec."Document Type" := TempMultiplePaymentTerms_lRec."document type"::"Posted Sales Cr. Memo";
    //             TempMultiplePaymentTerms_lRec."Document No." := PostedSalesCreditMemoNo_iCde;
    //             TempMultiplePaymentTerms_lRec."Table ID" := 114;
    //             TempMultiplePaymentTerms_lRec."Line No." := MultiplePaymentTrems_lRec."Line No.";
    //             TempMultiplePaymentTerms_lRec."Event Date" := MultiplePaymentTrems_lRec."Event Date";
    //             TempMultiplePaymentTerms_lRec.Sequence := MultiplePaymentTrems_lRec.Sequence;
    //             TempMultiplePaymentTerms_lRec."Due Date Calculation" := MultiplePaymentTrems_lRec."Due Date Calculation";
    //             TempMultiplePaymentTerms_lRec."Due Date" := MultiplePaymentTrems_lRec."Due Date";
    //             TempMultiplePaymentTerms_lRec."Percentage of Total" := MultiplePaymentTrems_lRec."Percentage of Total";
    //             TempMultiplePaymentTerms_lRec."Amount of Document" := MultiplePaymentTrems_lRec."Amount of Document";
    //             TempMultiplePaymentTerms_lRec.Insert;
    //         until MultiplePaymentTrems_lRec.Next = 0;
    //         //  IF SalesHeader_iRec."Document Type" = SalesHeader_iRec."Document Type"::Invoice THEN
    //         //      MultiplePaymentTrems_lRec.DELETEALL;
    //     end;
    // end;


    // procedure PurchHeadertoPostInvoice_gFnc(PurchaseHeader_iRec: Record "Purchase Header"; PostedPurchInvoiceNo_iCde: Code[20])
    // var
    //     MultiplePaymentTrems_lRec: Record "Multiple Payment Terms";
    //     TempMultiplePaymentTerms_lRec: Record "Multiple Payment Terms";
    // begin
    //     MultiplePaymentTrems_lRec.Reset;
    //     MultiplePaymentTrems_lRec.SetRange("Document No.", PurchaseHeader_iRec."No.");
    //     MultiplePaymentTrems_lRec.SetRange("Document Type", PurchaseHeader_iRec."Document Type");
    //     MultiplePaymentTrems_lRec.SetRange("Table ID", 38);
    //     if MultiplePaymentTrems_lRec.FindSet then begin
    //         repeat
    //             TempMultiplePaymentTerms_lRec.Init;
    //             TempMultiplePaymentTerms_lRec."Document No." := PostedPurchInvoiceNo_iCde;
    //             TempMultiplePaymentTerms_lRec."Document Type" := TempMultiplePaymentTerms_lRec."document type"::"Posted Purchase Invoice";
    //             TempMultiplePaymentTerms_lRec."Table ID" := 122;
    //             TempMultiplePaymentTerms_lRec."Line No." := MultiplePaymentTrems_lRec."Line No.";
    //             TempMultiplePaymentTerms_lRec."Event Date" := MultiplePaymentTrems_lRec."Event Date";
    //             TempMultiplePaymentTerms_lRec.Sequence := MultiplePaymentTrems_lRec.Sequence;
    //             TempMultiplePaymentTerms_lRec."Due Date Calculation" := MultiplePaymentTrems_lRec."Due Date Calculation";
    //             TempMultiplePaymentTerms_lRec."Due Date" := MultiplePaymentTrems_lRec."Due Date";
    //             TempMultiplePaymentTerms_lRec."Percentage of Total" := MultiplePaymentTrems_lRec."Percentage of Total";
    //             TempMultiplePaymentTerms_lRec."Amount of Document" := MultiplePaymentTrems_lRec."Amount of Document";
    //             TempMultiplePaymentTerms_lRec.Insert;
    //         until MultiplePaymentTrems_lRec.Next = 0;
    //         if PurchaseHeader_iRec."Document Type" = PurchaseHeader_iRec."document type"::Invoice then
    //             MultiplePaymentTrems_lRec.DeleteAll;
    //     end;
    // end;


    // procedure PurchHeadertoPostCreditMemo_gFnc(PurchaseHeader_iRec: Record "Purchase Header"; PostedSalesCreditMemoNo_iCde: Code[20])
    // var
    //     MultiplePaymentTrems_lRec: Record "Multiple Payment Terms";
    //     TempMultiplePaymentTerms_lRec: Record "Multiple Payment Terms";
    // begin
    //     MultiplePaymentTrems_lRec.Reset;
    //     MultiplePaymentTrems_lRec.SetRange("Document No.", PurchaseHeader_iRec."No.");
    //     MultiplePaymentTrems_lRec.SetRange("Document Type", PurchaseHeader_iRec."Document Type");
    //     MultiplePaymentTrems_lRec.SetRange("Table ID", 36);
    //     if MultiplePaymentTrems_lRec.FindSet then begin
    //         repeat
    //             TempMultiplePaymentTerms_lRec.Init;
    //             TempMultiplePaymentTerms_lRec."Document Type" := TempMultiplePaymentTerms_lRec."document type"::"Posted Purchase Cr. Memo";
    //             TempMultiplePaymentTerms_lRec."Document No." := PostedSalesCreditMemoNo_iCde;
    //             TempMultiplePaymentTerms_lRec."Table ID" := 124;
    //             TempMultiplePaymentTerms_lRec."Line No." := MultiplePaymentTrems_lRec."Line No.";
    //             TempMultiplePaymentTerms_lRec."Event Date" := MultiplePaymentTrems_lRec."Event Date";
    //             TempMultiplePaymentTerms_lRec.Sequence := MultiplePaymentTrems_lRec.Sequence;
    //             TempMultiplePaymentTerms_lRec."Due Date Calculation" := MultiplePaymentTrems_lRec."Due Date Calculation";
    //             TempMultiplePaymentTerms_lRec."Due Date" := MultiplePaymentTrems_lRec."Due Date";
    //             TempMultiplePaymentTerms_lRec."Percentage of Total" := MultiplePaymentTrems_lRec."Percentage of Total";
    //             TempMultiplePaymentTerms_lRec."Amount of Document" := MultiplePaymentTrems_lRec."Amount of Document";
    //             TempMultiplePaymentTerms_lRec.Insert;
    //         until MultiplePaymentTrems_lRec.Next = 0;
    //         //  IF PurchaseHeader_iRec."Document Type" = PurchaseHeader_iRec."Document Type"::Invoice THEN
    //         //      MultiplePaymentTrems_lRec.DELETEALL;
    //     end;
    // end;


    // procedure PurchasesDocAmtUpd_gFnc(PurchaseHeader_lRec: Record "Purchase Header")
    // var
    //     MultiplePaymentTrems_lRec: Record "Multiple Payment Terms";
    // begin
    //     if not (PurchaseHeader_lRec."Document Type" in [PurchaseHeader_lRec."document type"::Invoice, PurchaseHeader_lRec."document type"::Order]) then
    //         exit;

    //     PurchaseHeader_lRec.CalcFields("Amount Including VAT");

    //     MultiplePaymentTrems_lRec.Reset;
    //     MultiplePaymentTrems_lRec.SetRange("Document No.", PurchaseHeader_lRec."No.");
    //     MultiplePaymentTrems_lRec.SetRange("Document Type", PurchaseHeader_lRec."Document Type");
    //     MultiplePaymentTrems_lRec.SetRange("Table ID", 38);
    //     if MultiplePaymentTrems_lRec.FindSet then begin
    //         repeat
    //             if PurchaseHeader_lRec."Document Type" in [PurchaseHeader_lRec."document type"::Invoice] then begin
    //                 PurchaseHeader_lRec.TestField("Document Date");
    //                 MultiplePaymentTrems_lRec."Event Date" := PurchaseHeader_lRec."Document Date";
    //             end else begin
    //                 PurchaseHeader_lRec.TestField("Order Date");
    //                 MultiplePaymentTrems_lRec."Event Date" := PurchaseHeader_lRec."Order Date";
    //             end;
    //             MultiplePaymentTrems_lRec.Validate("Due Date Calculation");
    //             MultiplePaymentTrems_lRec.Validate("Percentage of Total");

    //             MultiplePaymentTrems_lRec.Modify;
    //         until MultiplePaymentTrems_lRec.Next = 0;
    //     end else begin
    //         if PurchaseHeader_lRec."Payment Terms Code" <> '' then begin
    //             MultiplePaymentTrems_lRec.Init;
    //             MultiplePaymentTrems_lRec."Document Type" := PurchaseHeader_lRec."Document Type";
    //             MultiplePaymentTrems_lRec."Document No." := PurchaseHeader_lRec."No.";
    //             MultiplePaymentTrems_lRec."Table ID" := 38;
    //             MultiplePaymentTrems_lRec."Line No." := 10000;
    //             MultiplePaymentTrems_lRec."Event Date" := PurchaseHeader_lRec."Document Date";
    //             MultiplePaymentTrems_lRec.Validate("Percentage of Total", 100);

    //             MultiplePaymentTrems_lRec.Insert;
    //         end;
    //     end;
    // end;



    procedure CheckPurchMultiplePaymentTermValidation_gFnc(PurchaseHeader_iRec: Record "Purchase Header")
    var
        MultiplePaymentTrems_lRec: Record "Multiple Payment Terms";
        Percentage_lDec: Decimal;
        Amount_lDec: Decimal;
        Diff_lDec: Decimal;
    begin
        if PurchaseHeader_iRec."Document Type" = PurchaseHeader_iRec."Document Type"::Quote then
            exit;

        Percentage_lDec := 0;
        Amount_lDec := 0;
        // PurchaseHeader_iRec.CalcFields("Amount Including VAT");
        //T11101-NS
        // if PurchaseHeader_iRec."Amount Including VAT" = 0 then
        //     exit;
        //T11101-NE
        MultiplePaymentTrems_lRec.Reset;
        MultiplePaymentTrems_lRec.SetRange("Document No.", PurchaseHeader_iRec."No.");
        MultiplePaymentTrems_lRec.SetRange("Document Type", PurchaseHeader_iRec."Document Type");
        MultiplePaymentTrems_lRec.SetRange(Type, MultiplePaymentTrems_lRec.Type::Purchase);
        MultiplePaymentTrems_lRec.SetRange("Table ID", 38);
        if MultiplePaymentTrems_lRec.FindSet then begin
            repeat
                Percentage_lDec += MultiplePaymentTrems_lRec."Percentage of Total";
            until MultiplePaymentTrems_lRec.Next = 0;
        end;

        if Percentage_lDec > 100 then
            Error('Multiple Payment term Percentage is GreaterThan 100 Purchase Document No %1', PurchaseHeader_iRec."No.");

        if Percentage_lDec < 100 then
            Error('Multiple Payment term Percentage is Less Than 100 Purchase Document No %1', PurchaseHeader_iRec."No.");

        MultiplePaymentTrems_lRec.Reset;
        MultiplePaymentTrems_lRec.SetRange("Document No.", PurchaseHeader_iRec."No.");
        MultiplePaymentTrems_lRec.SetRange("Document Type", PurchaseHeader_iRec."Document Type");
        MultiplePaymentTrems_lRec.SetRange(Type, MultiplePaymentTrems_lRec.Type::Purchase);
        MultiplePaymentTrems_lRec.SetRange("Table ID", 38);
        if MultiplePaymentTrems_lRec.FindSet then begin
            repeat
                Amount_lDec += MultiplePaymentTrems_lRec."Amount of Document";
            until MultiplePaymentTrems_lRec.Next = 0;
        end;

        If MultiplePaymentTrems_lRec.GetPurNetAmount() <> 0 then begin
            Diff_lDec := Abs(Amount_lDec) - Abs(MultiplePaymentTrems_lRec.GetPurNetAmount());

            //Rounding and add diff amount to last line.
            MultiplePaymentTrems_lRec.Reset;
            MultiplePaymentTrems_lRec.SetRange("Document No.", PurchaseHeader_iRec."No.");
            MultiplePaymentTrems_lRec.SetRange("Document Type", PurchaseHeader_iRec."Document Type");
            MultiplePaymentTrems_lRec.SetRange(Type, MultiplePaymentTrems_lRec.Type::Purchase);
            MultiplePaymentTrems_lRec.SetRange("Table ID", 38);
            if MultiplePaymentTrems_lRec.FindLast then begin
                MultiplePaymentTrems_lRec."Amount of Document" += Diff_lDec;
                MultiplePaymentTrems_lRec.Modify();
            end;

            // if Abs(Diff_lDec) > 1 then
            //     Error('Multiple Payment term Amount %1 is not equal to Amount to Vendor %2 in Purchase Document No %3', Abs(Amount_lDec), Abs(PurchaseHeader_iRec."Amount Including VAT"), PurchaseHeader_iRec."No.");
        end;
    end;




    // procedure CopySalesHedtoHed(var FromSalesHeader_vRec: Record "Sales Header"; var ToSalesHeader_vRec: Record "Sales Header")
    // var
    //     MultiplePaymentTrems_lRec: Record "Multiple Payment Terms";
    //     ToMultiplePaymentTrems_lRec: Record "Multiple Payment Terms";
    // begin
    //     if not (ToSalesHeader_vRec."Document Type" in [ToSalesHeader_vRec."document type"::Order, ToSalesHeader_vRec."document type"::Invoice]) then
    //         exit;

    //     // if ToSalesHeader_vRec."Export Document" then
    //     //     exit;

    //     ToMultiplePaymentTrems_lRec.Reset;
    //     ToMultiplePaymentTrems_lRec.SetRange("Table ID", 36);
    //     ToMultiplePaymentTrems_lRec.SetRange("Document No.", ToSalesHeader_vRec."No.");
    //     ToMultiplePaymentTrems_lRec.SetRange("Document Type", ToSalesHeader_vRec."Document Type");
    //     if ToMultiplePaymentTrems_lRec.FindSet then
    //         ToMultiplePaymentTrems_lRec.DeleteAll;

    //     MultiplePaymentTrems_lRec.Reset;
    //     MultiplePaymentTrems_lRec.SetRange("Table ID", 36);
    //     MultiplePaymentTrems_lRec.SetRange("Document No.", FromSalesHeader_vRec."No.");
    //     MultiplePaymentTrems_lRec.SetRange("Document Type", FromSalesHeader_vRec."Document Type");
    //     if MultiplePaymentTrems_lRec.FindSet then begin
    //         repeat
    //             ToMultiplePaymentTrems_lRec.Init;
    //             ToMultiplePaymentTrems_lRec."Table ID" := 36;
    //             case ToSalesHeader_vRec."Document Type" of
    //                 ToSalesHeader_vRec."Document Type"::Order:
    //                     ToMultiplePaymentTrems_lRec."Document Type" := ToMultiplePaymentTrems_lRec."Document Type"::Order;
    //                 ToSalesHeader_vRec."Document Type"::Invoice:
    //                     ToMultiplePaymentTrems_lRec."Document Type" := ToMultiplePaymentTrems_lRec."Document Type"::Invoice;
    //             end;
    //             ToMultiplePaymentTrems_lRec."Document No." := ToSalesHeader_vRec."No.";
    //             ToMultiplePaymentTrems_lRec."Line No." := MultiplePaymentTrems_lRec."Line No.";
    //             ToMultiplePaymentTrems_lRec."Event Date" := MultiplePaymentTrems_lRec."Event Date";
    //             ToMultiplePaymentTrems_lRec.Sequence := MultiplePaymentTrems_lRec.Sequence;
    //             ToMultiplePaymentTrems_lRec."Due Date Calculation" := MultiplePaymentTrems_lRec."Due Date Calculation";
    //             ToMultiplePaymentTrems_lRec."Percentage of Total" := MultiplePaymentTrems_lRec."Percentage of Total";


    //             ToMultiplePaymentTrems_lRec.Insert;
    //         until MultiplePaymentTrems_lRec.Next = 0;
    //     end;
    // end;


    // procedure CopySalesInvHedtoHed(var FromSalesHeader_vRec: Record "Sales Invoice Header"; var ToSalesHeader_vRec: Record "Sales Header")
    // var
    //     MultiplePaymentTrems_lRec: Record "Multiple Payment Terms";
    //     ToMultiplePaymentTrems_lRec: Record "Multiple Payment Terms";
    // begin
    //     if not (ToSalesHeader_vRec."Document Type" in [ToSalesHeader_vRec."document type"::Order, ToSalesHeader_vRec."document type"::Invoice]) then
    //         exit;

    //     // if ToSalesHeader_vRec."Export Document" then
    //     //     exit;

    //     ToMultiplePaymentTrems_lRec.Reset;
    //     ToMultiplePaymentTrems_lRec.SetRange("Table ID", 36);
    //     ToMultiplePaymentTrems_lRec.SetRange("Document No.", ToSalesHeader_vRec."No.");
    //     ToMultiplePaymentTrems_lRec.SetRange("Document Type", ToSalesHeader_vRec."Document Type");
    //     if ToMultiplePaymentTrems_lRec.FindSet then
    //         ToMultiplePaymentTrems_lRec.DeleteAll;

    //     MultiplePaymentTrems_lRec.Reset;
    //     MultiplePaymentTrems_lRec.SetRange("Table ID", 112);
    //     MultiplePaymentTrems_lRec.SetRange("Document No.", FromSalesHeader_vRec."No.");
    //     MultiplePaymentTrems_lRec.SetRange("Document Type", MultiplePaymentTrems_lRec."document type"::"Posted Sales Invoice");
    //     if MultiplePaymentTrems_lRec.FindSet then begin
    //         repeat
    //             ToMultiplePaymentTrems_lRec.Init;
    //             ToMultiplePaymentTrems_lRec."Table ID" := 36;
    //             case ToSalesHeader_vRec."Document Type" of
    //                 ToSalesHeader_vRec."Document Type"::Order:
    //                     ToMultiplePaymentTrems_lRec."Document Type" := ToMultiplePaymentTrems_lRec."Document Type"::Order;

    //                 ToSalesHeader_vRec."Document Type"::Invoice:
    //                     ToMultiplePaymentTrems_lRec."Document Type" := ToMultiplePaymentTrems_lRec."Document Type"::Invoice;
    //             end;

    //             ToMultiplePaymentTrems_lRec."Document No." := ToSalesHeader_vRec."No.";
    //             ToMultiplePaymentTrems_lRec."Line No." := MultiplePaymentTrems_lRec."Line No.";
    //             ToMultiplePaymentTrems_lRec."Event Date" := MultiplePaymentTrems_lRec."Event Date";
    //             ToMultiplePaymentTrems_lRec.Sequence := MultiplePaymentTrems_lRec.Sequence;
    //             ToMultiplePaymentTrems_lRec."Due Date Calculation" := MultiplePaymentTrems_lRec."Due Date Calculation";
    //             ToMultiplePaymentTrems_lRec."Percentage of Total" := MultiplePaymentTrems_lRec."Percentage of Total";

    //             ToMultiplePaymentTrems_lRec.Insert;
    //         until MultiplePaymentTrems_lRec.Next = 0;
    //     end;
    // end;


    // procedure CopyPurchaseHedtoHed(var FromSalesHeader_vRec: Record "Purchase Header"; var ToSalesHeader_vRec: Record "Purchase Header")
    // var
    //     MultiplePaymentTrems_lRec: Record "Multiple Payment Terms";
    //     ToMultiplePaymentTrems_lRec: Record "Multiple Payment Terms";
    // begin
    //     if not (ToSalesHeader_vRec."Document Type" in [ToSalesHeader_vRec."document type"::Order, ToSalesHeader_vRec."document type"::Invoice]) then
    //         exit;

    //     // if ToSalesHeader_vRec."Import Document" then
    //     //     exit;

    //     ToMultiplePaymentTrems_lRec.Reset;
    //     ToMultiplePaymentTrems_lRec.SetRange("Table ID", 38);
    //     ToMultiplePaymentTrems_lRec.SetRange("Document No.", ToSalesHeader_vRec."No.");
    //     ToMultiplePaymentTrems_lRec.SetRange("Document Type", ToSalesHeader_vRec."Document Type");
    //     if ToMultiplePaymentTrems_lRec.FindSet then
    //         ToMultiplePaymentTrems_lRec.DeleteAll;

    //     MultiplePaymentTrems_lRec.Reset;
    //     MultiplePaymentTrems_lRec.SetRange("Table ID", 38);
    //     MultiplePaymentTrems_lRec.SetRange("Document No.", FromSalesHeader_vRec."No.");
    //     MultiplePaymentTrems_lRec.SetRange("Document Type", FromSalesHeader_vRec."Document Type");
    //     if MultiplePaymentTrems_lRec.FindSet then begin
    //         repeat
    //             ToMultiplePaymentTrems_lRec.Init;
    //             ToMultiplePaymentTrems_lRec."Table ID" := 38;
    //             case ToSalesHeader_vRec."Document Type" of
    //                 ToSalesHeader_vRec."Document Type"::Order:
    //                     ToMultiplePaymentTrems_lRec."Document Type" := ToMultiplePaymentTrems_lRec."Document Type"::Order;
    //                 ToSalesHeader_vRec."Document Type"::Invoice:
    //                     ToMultiplePaymentTrems_lRec."Document Type" := ToMultiplePaymentTrems_lRec."Document Type"::Invoice;
    //             end;

    //             ToMultiplePaymentTrems_lRec."Document No." := ToSalesHeader_vRec."No.";
    //             ToMultiplePaymentTrems_lRec."Line No." := MultiplePaymentTrems_lRec."Line No.";
    //             ToMultiplePaymentTrems_lRec."Event Date" := MultiplePaymentTrems_lRec."Event Date";
    //             ToMultiplePaymentTrems_lRec.Sequence := MultiplePaymentTrems_lRec.Sequence;
    //             ToMultiplePaymentTrems_lRec."Due Date Calculation" := MultiplePaymentTrems_lRec."Due Date Calculation";
    //             ToMultiplePaymentTrems_lRec."Percentage of Total" := MultiplePaymentTrems_lRec."Percentage of Total";

    //             ToMultiplePaymentTrems_lRec.Insert;
    //         until MultiplePaymentTrems_lRec.Next = 0;
    //     end;
    // end;


    // procedure CopyPurchaseInvHedtoHed(var FromSalesHeader_vRec: Record "Purch. Inv. Header"; var ToSalesHeader_vRec: Record "Purchase Header")
    // var
    //     MultiplePaymentTrems_lRec: Record "Multiple Payment Terms";
    //     ToMultiplePaymentTrems_lRec: Record "Multiple Payment Terms";
    // begin
    //     if not (ToSalesHeader_vRec."Document Type" in [ToSalesHeader_vRec."document type"::Order, ToSalesHeader_vRec."document type"::Invoice]) then
    //         exit;

    //     // if ToSalesHeader_vRec."Import Document" then
    //     //     exit;

    //     ToMultiplePaymentTrems_lRec.Reset;
    //     ToMultiplePaymentTrems_lRec.SetRange("Table ID", 38);
    //     ToMultiplePaymentTrems_lRec.SetRange("Document No.", ToSalesHeader_vRec."No.");
    //     ToMultiplePaymentTrems_lRec.SetRange("Document Type", ToSalesHeader_vRec."Document Type");
    //     if ToMultiplePaymentTrems_lRec.FindSet then
    //         ToMultiplePaymentTrems_lRec.DeleteAll;

    //     MultiplePaymentTrems_lRec.Reset;
    //     MultiplePaymentTrems_lRec.SetRange("Table ID", 122);
    //     MultiplePaymentTrems_lRec.SetRange("Document No.", FromSalesHeader_vRec."No.");
    //     MultiplePaymentTrems_lRec.SetRange("Document Type", MultiplePaymentTrems_lRec."document type"::"Posted Sales Invoice");
    //     if MultiplePaymentTrems_lRec.FindSet then begin
    //         repeat
    //             ToMultiplePaymentTrems_lRec.Init;
    //             ToMultiplePaymentTrems_lRec."Table ID" := 38;
    //             case ToSalesHeader_vRec."Document Type" OF
    //                 ToSalesHeader_vRec."Document Type"::Order:
    //                     ToMultiplePaymentTrems_lRec."Document Type" := ToMultiplePaymentTrems_lRec."Document Type"::Order;
    //                 ToSalesHeader_vRec."Document Type"::Invoice:
    //                     ToMultiplePaymentTrems_lRec."Document Type" := ToMultiplePaymentTrems_lRec."Document Type"::Invoice;
    //             END;
    //             ToMultiplePaymentTrems_lRec."Document No." := ToSalesHeader_vRec."No.";
    //             ToMultiplePaymentTrems_lRec."Line No." := MultiplePaymentTrems_lRec."Line No.";
    //             ToMultiplePaymentTrems_lRec."Event Date" := MultiplePaymentTrems_lRec."Event Date";
    //             ToMultiplePaymentTrems_lRec.Sequence := MultiplePaymentTrems_lRec.Sequence;
    //             ToMultiplePaymentTrems_lRec."Due Date Calculation" := MultiplePaymentTrems_lRec."Due Date Calculation";
    //             ToMultiplePaymentTrems_lRec."Percentage of Total" := MultiplePaymentTrems_lRec."Percentage of Total";

    //             ToMultiplePaymentTrems_lRec.Insert;
    //         until MultiplePaymentTrems_lRec.Next = 0;
    //     end;
    // end;

    // procedure GetNetAmount(): Decimal
    // var
    //     myInt: Integer;
    //     CalcStatistics: Codeunit "Calculate Statistics";
    //     TotalInclTaxAmount: Decimal;
    //     salesHeader_lRec: Record "Sales Header";
    // begin
    //     salesHeader_lRec.Reset();
    //     if salesHeader_lRec.GET(salesHeader_lRec."Document Type", salesHeader_lRec."No.") then
    //         CalcStatistics.GetSalesStatisticsAmount(salesHeader_lRec, TotalInclTaxAmount);

    //     // if salesHeader_lRec.GET(Rec."Document Type", Rec."Document No.") then
    //     //     CalcStatistics.get GetSalesStatisticsAmount(salesHeader_lRec, TotalInclTaxAmount);
    //     exit(TotalInclTaxAmount);
    // end;
}