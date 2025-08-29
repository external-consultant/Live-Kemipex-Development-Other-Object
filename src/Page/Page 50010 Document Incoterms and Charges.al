// page 50010 "Document Incoterms and Charges"//T12937-as per UAT need to close
// {
//     PageType = List;
//     ApplicationArea = All;
//     UsageCategory = Lists;
//     SourceTable = "Document Incoterms and Charges";
//     Description = 'T12141';

//     layout
//     {
//         area(Content)
//         {
//             repeater(General)
//             {
//                 field("Transaction Type"; rec."Transaction Type")
//                 {
//                     ApplicationArea = All;
//                     ToolTip = 'Specifies the value of the Transaction Type field.', Comment = '%';
//                     Visible = false;
//                 }
//                 field("Document Type"; rec."Document Type")
//                 {
//                     ApplicationArea = All;
//                     Visible = false;
//                     ToolTip = 'Specifies the value of the Document Type field.', Comment = '%';
//                 }
//                 field("Document No."; rec."Document No.")
//                 {
//                     ApplicationArea = All;
//                     Visible = false;
//                     ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
//                 }

//                 field("Inco Term Code"; Rec."Inco Term Code")
//                 {
//                     ApplicationArea = All;
//                     ToolTip = 'Specifies the value of the Inco Term Code field.', Comment = '%';
//                 }
//                 // field("Starting Date"; Rec."Starting Date")
//                 // {
//                 //     ApplicationArea = All;
//                 //     ToolTip = 'Specifies the value of the Starting Date field.', Comment = '%';
//                 // }
//                 field("Vendor No."; Rec."Vendor No.")
//                 {
//                     ApplicationArea = All;
//                     ToolTip = 'Specifies the value of the Vendor No. field.', Comment = '%';
//                 }
//                 field("Vendor Name"; Rec."Vendor Name")
//                 {
//                     ApplicationArea = All;
//                     ToolTip = 'Specifies the value of the Vendor Name field.', Comment = '%';
//                 }
//                 field("Location Code"; Rec."Location Code")
//                 {
//                     ApplicationArea = All;
//                     ToolTip = 'Specifies the value of the Location Code field.', Comment = '%';
//                 }
//                 field("Charge Item"; Rec."Charge Item")
//                 {
//                     ApplicationArea = All;
//                     ToolTip = 'Specifies the value of the Charge Item field.', Comment = '%';
//                 }
//                 field("Expected Charge Amount"; Rec."Expected Charge Amount")
//                 {
//                     ApplicationArea = All;
//                     ToolTip = 'Specifies the value of the Expected Charge Amount field.', Comment = '%';
//                 }
//             }
//         }
//         area(Factboxes)
//         {

//         }
//     }

//     actions
//     {
//         // area(Processing)
//         // {
//         //     action(ActionName)
//         //     {
//         //         ApplicationArea = All;

//         //         trigger OnAction()
//         //         begin

//         //         end;
//         //     }
//         // }
//     }
//     trigger OnOpenPage()
//     begin
//         // CurrPage.Editable(False);
//     end;
// }