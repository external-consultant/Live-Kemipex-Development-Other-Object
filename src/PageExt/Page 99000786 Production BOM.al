pageextension 50036 "Page Ext 99000786" extends "Production BOM"
{
    layout
    {
        //T12113-NS
        addlast(General)
        {

            field("R&D"; Rec."R&D")
            {
                ApplicationArea = All;
                Editable = RND_gBln;
                ToolTip = 'Specifies the value of the R&D field.', Comment = '%';
                caption = 'R&D';
            }
        }

    }

    trigger OnAfterGetRecord()
    begin
        RND_gBln := true;
        if Rec.Status = Rec.Status::Certified then
            RND_gBln := false;
    end;

    var
        UserSetup_gRec: Record "User Setup";
        RND_gBln: Boolean;
    //T12113-NE
}