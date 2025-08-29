pageextension 50181 LotNoInfoExt_50002 extends "Lot No. Information Card"
{
    //T12022
    layout
    {
        addlast(General)
        {
            //T12141-NS
            field("Vendor Lot No."; Rec."Vendor Lot No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Vendor Lot No. field.';
            }
            field(BOE; Rec.BOE)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the BOE field.';
            }
            field("Bill Of Exit"; Rec."Bill Of Exit")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Bill Of Exit field.';
            }

            field("Customs BOE"; Rec."Customs BOE")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Customs BOE field.';
            }
            //T12141-NE
        }
    }
}
