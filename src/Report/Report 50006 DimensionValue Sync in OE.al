Report 50006 "DimensionValue Sync in OE"
{
    //NG-N 03-05-2024 Create Report to Export All LCY Currency Details

    Caption = 'Dimension Value Sync in Other Enties';
    ProcessingOnly = true;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(ParentTable; "Dimension Value")
        {
            RequestFilterFields = "Dimension Code", Code;
            trigger OnAfterGetRecord()
            var
                Companies_lRec: Record Company;
                ChildTable_lRec: Record "Dimension Value";
            begin
                SubCompany_gInt := 0;
                Curr_gInt += 1;
                Win_gDlg.Update(2, Curr_gInt);

                Companies_lRec.Reset();
                Companies_lRec.SetFilter(Name, '<>%1', CompanyName);
                IF Companies_lRec.FindSet() Then begin
                    Win_gDlg.Update(3, Companies_lRec.Count);
                    repeat
                        SubCompany_gInt += 1;
                        Win_gDlg.Update(4, SubCompany_gInt);
                        ChildTable_lRec.RESET;
                        ChildTable_lRec.ChangeCompany(Companies_lRec.Name);
                        ChildTable_lRec.Init;
                        ChildTable_lRec.TransferFields(ParentTable);
                        IF NOT ChildTable_lRec.Insert then begin
                            // ChildTable_lRec.Reset();
                            // ChildTable_lRec.ChangeCompany(Companies_lRec.Name);
                            // ChildTable_lRec.SetRange("Dimension Code", ParentTable."Dimension Code");
                            // ChildTable_lRec.SetRange(Code, ParentTable.Code);
                            // ChildTable_lRec.FindFirst();

                            // ChildTable_lRec.Name := ParentTable.Name;
                            // ChildTable_lRec.Totaling := ParentTable.Totaling;
                            // ChildTable_lRec."Dimension Value Type" := ParentTable."Dimension Value Type";
                            // ChildTable_lRec.Blocked := ParentTable.Blocked;
                            // ChildTable_lRec."Consolidation Code" := ParentTable."Consolidation Code";
                            // ChildTable_lRec.Indentation := ParentTable.Indentation;
                            // ChildTable_lRec."Global Dimension No." := ParentTable."Global Dimension No.";
                            // ChildTable_lRec."Map-to IC Dimension Code" := ParentTable."Map-to IC Dimension Code";
                            // ChildTable_lRec."Map-to IC Dimension Value Code" := ParentTable."Map-to IC Dimension Value Code";
                            // ChildTable_lRec."Last Modified Date Time" := ParentTable."Last Modified Date Time";

                            ChildTable_lRec.Modify();
                        End;
                    until Companies_lRec.Next() = 0;
                end;

                Commit();
            end;

            trigger OnPreDataItem()
            begin
                Win_gDlg.Open('Total #1##########\Current #2#############\Total Company #3##########\Subcompany #4#########\Start At #5###########');
                Win_gDlg.Update(1, Count);
                Win_gDlg.Update(5, CurrentDateTime);

                If CompanyName <> 'Master Data Management' then
                    Error('You can only run this Batch from Company - Master Data Management');
            end;

            trigger OnPostDataItem()
            var
                myInt: Integer;
            begin
                Win_gDlg.Close();
            end;
        }
    }

    var
        Win_gDlg: Dialog;
        Curr_gInt: Integer;
        SubCompany_gInt: Integer;
        LCYCode_gCod: Code[10];


    trigger OnPreReport()
    begin
    end;

    trigger OnPostReport()
    begin
    end;


}
