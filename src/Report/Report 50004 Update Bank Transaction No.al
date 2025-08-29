//T13082024
report 50004 "Update Bank Transaction No."
{

    ProcessingOnly = true;
    Permissions = tabledata "G/L Entry" = RIM, tabledata "Bank Account Ledger Entry" = RIM;
    dataset
    {
        dataitem("Bank Account Ledger Entry"; "Bank Account Ledger Entry")
        {
            RequestFilterFields = "Document No.";
            trigger OnAfterGetRecord()
            var
                GLEntry_lRec: Record "G/L Entry";
            begin
                // if "Bank Account Ledger Entry"."Bank Transaction No." = '' then
                //     exit;

                GLEntry_lRec.Reset;
                GLEntry_lRec.SetRange("Document No.", "Document No.");
                if GLEntry_lRec.FindSet then begin
                    repeat
                        GLEntry_lRec."Bank Transaction No." := TransactionNo_gCde; //Update GL Entry
                        GLEntry_lRec.Modify;
                    until GLEntry_lRec.Next = 0;
                end;
                "Bank Account Ledger Entry"."Bank Transaction No." := TransactionNo_gCde; //Update Bank Ledger Entry
                "Bank Account Ledger Entry".Modify();

            end;
        }


    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(TransactionNo_gCde; TransactionNo_gCde)
                    {
                        Caption = 'Enter The New Transaction No.';
                        ApplicationArea = All;
                    }
                }
            }

        }


    }

    trigger OnPreReport()
    var
        myInt: Integer;
        UserSetup_lRec: Record "User Setup";
        Allowed_lText: Label 'you are not allowed for Update the Bank Tran. Kindly Contact to Admin';
    begin
        if Not (TransactionNo_gCde <> '') then
            Error('Enter The Transaction No.');
        // UserSetup_lRec.get(UserId);
        // if not UserSetup_lRec. then
        //     error(Allowed_lText);
    end;



    var


        TransactionNo_gCde: Text[30];


}
