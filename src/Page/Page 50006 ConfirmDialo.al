page 50006 ConfirmationDialog//ABA-13092024
{
    ApplicationArea = All;
    Caption = 'ConfirmationDialog';
    PageType = ConfirmationDialog;
    Permissions = tabledata "Bank Account Ledger Entry" = RIM, tabledata "G/L Entry" = RIM;

    layout
    {
        area(Content)
        {
            // group(General)
            // {
            // Caption = 'General';
            field(NumberToEnter_gTxt; NumberToEnter_gTxt)
            {
                ApplicationArea = All;
                Caption = 'Bank Transaction No.';

            }
        }
    }
    PROCEDURE ReturnEnteredNumber(): Text;
    BEGIN
        EXIT(NumberToEnter_gTxt);
    END;

    procedure clearVar()
    begin
        Clear(NumberToEnter_gTxt);
    end;

    procedure UpdateRelatedTable_gFnc(Rec: Record "Bank Account Ledger Entry"; BankTransactionNo_iTxt: text; Record_iInt: Integer)
    var
        GLEntry_lRec: Record "G/L Entry";
    begin
        GLEntry_lRec.Reset;
        GLEntry_lRec.SetRange("Document No.", Rec."Document No.");
        if GLEntry_lRec.FindSet then begin
            repeat
                if GLEntry_lRec."Bank Transaction No." <> BankTransactionNo_iTxt then begin
                    GLEntry_lRec."Bank Transaction No." := BankTransactionNo_iTxt; //Update GL Entry
                    GLEntry_lRec.Modify;
                end;
            until GLEntry_lRec.Next = 0;
        end;
        if rec."Bank Transaction No." <> BankTransactionNo_iTxt then begin
            Rec."Bank Transaction No." := BankTransactionNo_iTxt; //Update Bank Ledger Entry
            Rec.Modify();
        end;
    end;

    var
        NumberToEnter_gTxt: text[30];
}
