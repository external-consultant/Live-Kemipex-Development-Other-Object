//T12542-NS
page 50017 "QC Receipts Role Center"
{
    Caption = 'QC Receipt';
    PageType = CardPart;
    RefreshOnActivate = true;
    ShowFilter = false;

    layout
    {
        area(Content)
        {
            cuegroup("Production Orders")
            {
                ShowCaption = false;
                field(CloseQCforProductionOrder; CloseQCforProductionOrder_gInt)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Count of the Close QC Receipt';
                    Caption = 'Posted QC';

                    trigger OnDrillDown()
                    var
                        PostedQCRecptlist_lPage: Page "Posted QC Rcpt. List";
                        PostedQcRecptHeader_lRec: Record "Posted QC Rcpt. Header";
                    begin
                        Clear(PostedQCRecptlist_lPage);
                        PostedQcRecptHeader_lRec.Reset();
                        PostedQcRecptHeader_lRec.SetRange("Document Type", PostedQcRecptHeader_lRec."Document Type"::Production);
                        PostedQCRecptlist_lPage.SetTableView(PostedQcRecptHeader_lRec);
                        PostedQCRecptlist_lPage.Editable(false);
                        PostedQCRecptlist_lPage.RunModal();
                    end;
                }
                field(OpenQCforProductionOrder_gInt; OpenQCforProductionOrder_gInt_gInt)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Count of the Open QC Receipt';
                    Caption = 'Open QC';

                    trigger OnDrillDown()
                    var
                        QCRecptlist_lPage: Page "QC Rcpt. List";
                        QcRecptHeader_lRec: Record "QC Rcpt. Header";
                    begin
                        Clear(QCRecptlist_lPage);
                        QcRecptHeader_lRec.Reset();
                        QcRecptHeader_lRec.SetRange("Document Type", QcRecptHeader_lRec."Document Type"::Production);
                        QCRecptlist_lPage.SetTableView(QcRecptHeader_lRec);
                        QCRecptlist_lPage.Editable(false);
                        QCRecptlist_lPage.RunModal();
                    end;
                }
            }
        }
    }


    var
        CloseQCforProductionOrder_gInt: Integer;
        OpenQCforProductionOrder_gInt_gInt: Integer;

    trigger OnOpenPage()
    var
        PostedQcRctheader_lRec: Record "Posted QC Rcpt. Header";
        QcRctheader_lRec: Record "QC Rcpt. Header";
    //ProductionOrder_lRec: Record "Production Order";

    begin
        PostedQcRctheader_lRec.Reset();
        PostedQcRctheader_lRec.SetRange("Document Type", PostedQcRctheader_lRec."Document Type"::Production);
        if PostedQcRctheader_lRec.FindSet() then
            CloseQCforProductionOrder_gInt := PostedQcRctheader_lRec.Count;

        QcRctheader_lRec.Reset();
        QcRctheader_lRec.SetRange("Document Type", PostedQcRctheader_lRec."Document Type"::Production);
        if QcRctheader_lRec.FindSet() then
            OpenQCforProductionOrder_gInt_gInt := QcRctheader_lRec.Count;
    end;
}

//T12542-NE