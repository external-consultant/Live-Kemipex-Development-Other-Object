pageextension 50051 "PageExt 372 BankAccLedEnt" extends "Bank Account Ledger Entries"
{
    layout
    {
        addafter("Amount (LCY)")
        {
            field("Bank Transaction No."; Rec."Bank Transaction No.")
            {
                ApplicationArea = all;
                Description = 'T12141';
                ToolTip = 'Specifies the value of the Bank Transaction No. field.';
            }
        }
    }

    actions
    {
        addafter("F&unctions")

        {
            action("Update Bank Transaction No.")
            {
                ApplicationArea = All;
                Caption = 'Update Bank Transaction No.';
                Image = UpdateDescription;

                trigger OnAction()
                var
                    UpdateBankTransaction_lRpt: report "Update Bank Transaction No.";
                    BankAccLdgrEntry_lRec: Record "Bank Account Ledger Entry";
                    DocumentNos: Code[20];
                    Count_lInt: Integer;
                    ConfirmDialouge_lPge: page ConfirmationDialog;
                    BankTransactionNo_lTxt: text;
                    SkipSpaceVar_lTxt: Text;
                begin
                    Clear(BankTransactionNo_lTxt);
                    Clear(ConfirmDialouge_lPge);
                    Clear(SkipSpaceVar_lTxt)
                    ;
                    ConfirmDialouge_lPge.LOOKUPMODE(TRUE);
                    IF ConfirmDialouge_lPge.RUNMODAL = ACTION::Yes THEN begin
                        //MESSAGE(FORMAT(ConfirmDialouge_lPge.ReturnEnteredNumber));
                        BankTransactionNo_lTxt := ConfirmDialouge_lPge.ReturnEnteredNumber;
                        Clear(DocumentNos);
                        BankAccLdgrEntry_lRec.Reset();
                        CurrPage.SetSelectionFilter(BankAccLdgrEntry_lRec);
                        BankAccLdgrEntry_lRec.SetLoadFields("Document No.");
                        BankAccLdgrEntry_lRec.FindSet();
                        Count_lInt := BankAccLdgrEntry_lRec.Count;
                        if not (ConfirmDialouge_lPge.ReturnEnteredNumber <> '') then
                            exit;
                        SkipSpaceVar_lTxt := BankTransactionNo_lTxt.Replace(' ', '');
                        if SkipSpaceVar_lTxt = '' then
                            exit;
                        if not confirm('Do you want to update the Bank Transaction No - %1 on Selected - %2 Record?', false, BankTransactionNo_lTxt, Count_lInt) then
                            exit;
                        repeat
                            ConfirmDialouge_lPge.UpdateRelatedTable_gFnc(BankAccLdgrEntry_lRec, BankTransactionNo_lTxt, Count_lInt);
                        until BankAccLdgrEntry_lRec.Next() = 0;
                        ConfirmDialouge_lPge.clearVar();
                    end;

                end;
            }
        }
    }

    var
}