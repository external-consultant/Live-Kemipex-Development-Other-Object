pageextension 50351 ItemVendorCatalogExt extends "Item Vendor Catalog"
{
    layout
    {
        //T13396-NS
        addafter("Vendor Item No.")
        {
            field("Hidden Product Code"; Rec."Hidden Product Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Hidden Product Code field.', Comment = '%';
                Visible = HiddenProdCode_gBln;
            }
        }
        //T13396-NE
    }

    actions
    { }

    //T13396-NS
    trigger OnOpenPage()
    var
        UserSetup_lRec: Record "User Setup";
    begin
        HiddenProdCode_gBln := false;
        Clear(UserSetup_lRec);
        if UserSetup_lRec.Get(UserId) then begin
            if UserSetup_lRec."Allow view Hidden Product Code" then
                HiddenProdCode_gBln := true;
        end;
    end;
    //T13396-NE

    var
        HiddenProdCode_gBln: Boolean;
}