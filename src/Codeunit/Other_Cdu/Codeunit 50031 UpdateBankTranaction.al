// codeunit 50031 UpdateBankTranaction
// {
//     TableNo = "Bank Account Ledger Entry";
//     Permissions = tabledata "Bank Account Ledger Entry" = RIM, tabledata "G/L Entry" = RIM;
//     trigger OnRun()
//     begin
//         ConfirmDia_gPge.LOOKUPMODE(TRUE);
//         IF ConfirmDia_gPge.RUNMODAL = ACTION::Yes THEN begin
//             BankTransactionNo_gTxt := ConfirmDia_gPge.ReturnEnteredNumber;
//             if ConfirmDia_gPge.ReturnEnteredNumber <> '' then
//                 UpdateRelatedTable_gFnc(rec)
//             else
//                 Error('Enter Transaction No.');

//         end;
//     END;

//     procedure UpdateRelatedTable_gFnc(Rec: Record "Bank Account Ledger Entry")
//     var
//         GLEntry_lRec: Record "G/L Entry";
//     begin

//         GLEntry_lRec.Reset;
//         GLEntry_lRec.SetRange("Document No.", Rec."Document No.");
//         if GLEntry_lRec.FindSet then begin
//             repeat
//                 GLEntry_lRec."Bank Transaction No." := BankTransactionNo_gTxt; //Update GL Entry
//                 GLEntry_lRec.Modify;
//             until GLEntry_lRec.Next = 0;
//         end;
//         Rec."Bank Transaction No." := BankTransactionNo_gTxt; //Update Bank Ledger Entry
//         Rec.Modify();
//     end;

//     procedure clearVar()
//     begin
//         clear(BankTransactionNo_gTxt);
//     end;


//     var
//         ConfirmDia_gPge: Page ConfirmationDialog;
//         BankTransactionNo_gTxt: Text;
// }