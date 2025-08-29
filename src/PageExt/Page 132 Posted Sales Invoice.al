//T12068-NS
pageextension 50008 "Page 132 Pos.SalesInv" extends "Posted Sales Invoice"
{
    layout
    {
        addlast(General)
        {
            //T13399-OS
            // field(BDM; Rec.BDM)
            // {
            //     ApplicationArea = all;
            //     ToolTip = 'Specifies the value of the BDM field.';
            // }
            //T13399-OE
        }
        //T12141-NS
        addlast("Shipping and Billing")
        {
            group("Logistic Details")
            {
                field("Vehicle No_New"; Rec."Vehicle No_New")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vehicle No field.', Comment = '%';
                }
                field("Container Code"; Rec."Container Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Container Code field.', Comment = '%';
                }
                field("Container Plat No."; Rec."Container Plat No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Container Plat No. field.', Comment = '%';
                }
                field("Container Seal No."; Rec."Container Seal No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Container Seal No. field.', Comment = '%';
                }
            }
        }
        //T12141-NE

        addafter(SalesInvLines)
        {
            //T12539-NS
            part("Multiple Payment Terms Subform"; "Posted Multi Payment Terms Sub")
            {
                ApplicationArea = All;
                SubPageLink = "Table ID" = const(112), "Document No." = field("No."), "Document Type" = filter("Posted Sales Invoice"), Type = const(Sales);
                UpdatePropagation = Both;
            }
            //T12539-NE
        }
    }
}
//T12068-NE
