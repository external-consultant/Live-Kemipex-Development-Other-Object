Pageextension 50086 P_50086_ProductionJournalExt extends "Production Journal"
{
    layout
    {
        //T12545-NS
        addlast(Control1)
        {
            field("Warranty Date"; Rec."Warranty Date")
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
        modify(Post)
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
