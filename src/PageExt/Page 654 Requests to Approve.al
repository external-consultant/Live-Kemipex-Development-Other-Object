pageextension 50057 "Page 654 Requests to Approve" extends "Requests to Approve"
{
    //T12141-NS
    layout
    {
        addlast(Control1)
        {
            field(BalanceDue_lDec; BalanceDue_gDec)
            {
                ApplicationArea = all;
                Caption = 'Balance Due(LCY)';
            }
        }
    }
    actions
    {
        addafter(Comments)
        {
            action(AgedAccRecievable)
            {
                ApplicationArea = all;
                Caption = 'Aged Account Receivable Report';
                Image = Report;
                ToolTip = 'View an overview of when customer payments are due or overdue, divided into four periods. You must specify the date you want aging calculated from and the length of the period that each column will contain data for.';

                trigger OnAction()
                var
                    RecValue_ltxt: Text;
                    Strlength_lInt: Integer;
                    Strvalue_lcod: Code[20];
                begin
                    if Rec."Table ID" = Database::"Sales Header" then begin
                        SalesHead_gRec.Reset();
                        SalesHead_gRec.SetRange("No.", Rec."Document No.");
                        if SalesHead_gRec.FindFirst() then begin
                            Customer_gRec.Reset();
                            Customer_gRec.SetRange("No.", SalesHead_gRec."Sell-to Customer No.");
                            if Customer_gRec.FindFirst() then
                                Report.RunModal(120, true, false, Customer_gRec);
                        end;
                    end else
                        if Rec."Table ID" = Database::"Gen. Journal Line" then begin
                            GenJnlLine_gRec.Reset();
                            GenJnlLine_gRec.SetRange("Account Type", GenJnlLine_gRec."Account Type"::Customer);
                            GenJnlLine_gRec.SetRange("Document No.", Rec."Document No.");
                            if GenJnlLine_gRec.FindFirst() then begin
                                Customer_gRec.Reset();
                                Customer_gRec.SetRange("No.", GenJnlLine_gRec."Account No.");
                                if Customer_gRec.FindFirst() then
                                    Report.RunModal(120, true, false, Customer_gRec);
                            end;
                        end else
                            if Rec."Table ID" = Database::Customer then begin

                                RecValue_ltxt := '';
                                RecValue_ltxt := Format(Rec."Record ID to Approve");
                                Strlength_lInt := StrLen(RecValue_ltxt);
                                Strvalue_lcod := CopyStr(RecValue_ltxt, 11, Strlength_lInt);
                                // Message(Strvalue_ltxt);
                                Customer_gRec.Reset();
                                Customer_gRec.SetRange("No.", Strvalue_lcod);
                                if Customer_gRec.FindFirst() then begin
                                    Report.RunModal(120, true, false, Customer_gRec);
                                end;
                            end else
                                Message('No Customer Found for Document No. %1', Rec."Document No.");
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        BalanceDue_gDec := 0;
        if Rec."Table ID" = Database::"Sales Header" then begin
            SalesHead_gRec.Reset();
            SalesHead_gRec.SetRange("No.", Rec."Document No.");
            SalesHead_gRec.SetRange("Document Type", Rec."Document Type");
            if SalesHead_gRec.FindFirst() then begin
                Customer_gRec.get(SalesHead_gRec."Sell-to Customer No.");
                DetailedCusLed_gRec.Reset();
                DetailedCusLed_gRec.SetRange("Customer No.", SalesHead_gRec."Sell-to Customer No.");
                DetailedCusLed_gRec.SetFilter("Initial Entry Due Date", '<%1', Today);
                if DetailedCusLed_gRec.FindSet() then
                    repeat
                        BalanceDue_gDec += DetailedCusLed_gRec."Amount (LCY)";
                    until DetailedCusLed_gRec.Next() = 0;
            end;
        end;
        if Rec."Table ID" = Database::"Gen. Journal Line" then begin
            GenJnlLine_gRec.Reset();
            GenJnlLine_gRec.SetRange("Account Type", GenJnlLine_gRec."Account Type"::Customer);
            GenJnlLine_gRec.SetRange("Document No.", Rec."Document No.");
            if GenJnlLine_gRec.FindFirst() then begin
                Customer_gRec.get(GenJnlLine_gRec."Account No.");
                DetailedCusLed_gRec.Reset();
                DetailedCusLed_gRec.SetRange("Customer No.", GenJnlLine_gRec."Account No.");
                DetailedCusLed_gRec.SetFilter("Initial Entry Due Date", '<%1', Today);
                if DetailedCusLed_gRec.FindSet() then
                    repeat
                        BalanceDue_gDec += DetailedCusLed_gRec."Amount (LCY)";
                    until DetailedCusLed_gRec.Next() = 0;
            end;
        end;
        if Rec."Table ID" = Database::Customer then begin
            Customer_gRec.Reset();
            Customer_gRec.SetRange("No.", Rec."Document No.");
            if Customer_gRec.FindFirst() then begin
                DetailedCusLed_gRec.Reset();
                DetailedCusLed_gRec.SetRange("Customer No.", Customer_gRec."No.");
                DetailedCusLed_gRec.SetFilter("Initial Entry Due Date", '<%1', Today);
                if DetailedCusLed_gRec.FindSet() then
                    repeat
                        BalanceDue_gDec += DetailedCusLed_gRec."Amount (LCY)";
                    until DetailedCusLed_gRec.Next() = 0;
            end;
        end;
    end;

    var
        DetailedCusLed_gRec: Record "Detailed Cust. Ledg. Entry";
        Customer_gRec: Record Customer;
        SalesHead_gRec: Record "Sales Header";
        GenJnlLine_gRec: Record "Gen. Journal Line";
        BalanceDue_gDec: Decimal;
    //T12141-NE
}
