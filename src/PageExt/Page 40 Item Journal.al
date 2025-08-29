pageextension 50314 ItemJrnl50147 extends "Item Journal"
{


    layout
    {
        //T12706-NS
        modify("Variant Code")
        {
            Visible = true;
        }
        //T12706-NE
    }
    actions
    {
        addlast("&Line")
        {
            //T12113-NB-NS
            action("Delete All Line")
            {
                ApplicationArea = All;
                Caption = 'Delete All Line';
                Image = Delete;



                trigger OnAction()
                var
                    deletItemJnlCdu_cdu: Codeunit ItemJnlPostLine;

                begin
                    deletItemJnlCdu_cdu.ItemJnlLineDeleteAll_gFnc(Rec);
                end;
            }

        }
    }
}
