Pageextension 50093 P_50093_ConsumptionJournalExt extends "Consumption Journal"
{
    layout
    {
        //T12545-NS
        addlast(Control1)
        {
            field("Warranty Date_Kemipex"; Rec."Warranty Date")//BC26 Upg -N
            {
                ApplicationArea = All;
                Caption = 'Manufacturing Date';
                ToolTip = 'Specifies the Manufacturing Date for the item on the line.';
            }
        }
        //T12545-NE
    }
    actions
    {
        modify("P&ost")
        {
            trigger OnBeforeAction()
            var
                myInt: Integer;
                ProductionOrder_lRec: Record "Production Order";
                ItemJnlLine_lRec: Record "Item Journal Line";
            begin
                ItemJnlLine_lRec.Reset();
                CurrPage.SetSelectionFilter(ItemJnlLine_lRec);
                ItemJnlLine_lRec.SetLoadFields("Document No.");
                ItemJnlLine_lRec.FindSet();
                repeat
                    if ProductionOrder_lRec.Get(ProductionOrder_lRec.Status::Released, ItemJnlLine_lRec."Document No.") then
                        ProductionOrder_lRec.TestField("Order Status", ProductionOrder_lRec."Order Status"::Released);

                until ItemJnlLine_lRec.next = 0;
            end;
        }
    }
}
