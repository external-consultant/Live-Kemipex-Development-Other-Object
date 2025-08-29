// pageextension 50055 "PageExt 49 Purch. Quote" extends "Purchase Quote" //T12937-as per UAT need to close
// {
//     layout
//     {
//         addlast(General)
//         {
//             field("Incoterm Charges Amount"; Rec."Incoterm Charges Amount")
//             {
//                 ApplicationArea = All;
//                 Editable = false;
//                 ToolTip = 'Specifies the value of the Incoterm Charges Amount field.', Comment = '%';
//                 trigger OnDrillDown()
//                 var
//                     IncoCharge_lRec: Record "Document Incoterms and Charges";
//                     InCoCharge_lPge: Page "Document Incoterms and Charges";
//                 begin
//                     IncoCharge_lRec.Reset();
//                     IncoCharge_lRec.SetRange("Transaction Type", IncoCharge_lRec."Transaction Type"::Purchase);
//                     IncoCharge_lRec.SetRange("Document Type", Rec."Document Type");
//                     IncoCharge_lRec.SetRange("Document No.", Rec."No.");
//                     InCoCharge_lPge.SetTableView(InCoCharge_lRec);
//                     InCoCharge_lPge.Editable(false);
//                     InCoCharge_lPge.Run();
//                 end;
//             }
//         }
//     }

//     actions
//     {
//         addafter("Archive Document")
//         {
//             //T12141-NS
//             action("Incoterms and Charges")
//             {
//                 ApplicationArea = all;
//                 Image = AssessFinanceCharges;
//                 trigger OnAction()
//                 var
//                     InCoCharge_lRec: Record "Document Incoterms and Charges";
//                     InCoCharge_lPge: Page "Document Incoterms and Charges";
//                 begin
//                     InCoCharge_lRec.Reset();
//                     // InCoCharge_lRec.FilterGroup(2);
//                     InCoCharge_lRec.SetRange("Transaction Type", InCoCharge_lRec."Transaction Type"::Purchase);
//                     InCoCharge_lRec.SetRange("Document Type", rec."Document Type");
//                     InCoCharge_lRec.SetRange("Document No.", Rec."No.");
//                     // InCoCharge_lRec.FilterGroup(0);
//                     InCoCharge_lPge.SetTableView(InCoCharge_lRec);
//                     InCoCharge_lPge.Editable(true);
//                     InCoCharge_lPge.Run();
//                 end;
//                 //T12141-NE
//             }
//         }
//     }

//     //T12141-NS
//     trigger OnAfterGetRecord()
//     var
//     // IncoCharge_lRec: Record "Incoterms and Charges";
//     begin
//         // LastDate_gDte := 0D;
//         // IncoChargeItem_gDec := 0;

//         // IncoCharge_lRec.Reset();
//         // InCoCharge_lRec.SetRange("Inco Term Code", Rec."Shipment Method Code");
//         // InCoCharge_lRec.SetRange("Location Code", Rec."Location Code");
//         // InCoCharge_lRec.SetRange("Vendor No.", Rec."Buy-from Vendor No.");
//         // IncoCharge_lRec.SetFilter("Starting Date", '<=%1', Rec."Document Date");
//         // if IncoCharge_lRec.FindLast() then
//         //     LastDate_gDte := IncoCharge_lRec."Starting Date";

//         // IncoCharge_lRec.Reset();
//         // InCoCharge_lRec.SetRange("Inco Term Code", Rec."Shipment Method Code");
//         // InCoCharge_lRec.SetRange("Location Code", Rec."Location Code");
//         // InCoCharge_lRec.SetRange("Vendor No.", Rec."Buy-from Vendor No.");
//         // IncoCharge_lRec.SetFilter("Starting Date", '%1', LastDate_gDte);
//         // if IncoCharge_lRec.FindSet() then
//         //     repeat
//         //         IncoChargeItem_gDec += IncoCharge_lRec."Expected Charge Amount";
//         //     until IncoCharge_lRec.Next() = 0;

//         // Rec."Incoterm Charges Amount" := IncoChargeItem_gDec;
//         // CurrPage.Update();
//     end;
//     //T12141-NE

//     var
//         LastDate_gDte: Date;
//         IncoChargeItem_gDec: Decimal;
// }