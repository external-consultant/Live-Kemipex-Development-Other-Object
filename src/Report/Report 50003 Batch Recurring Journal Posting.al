report 50003 "Batch Recurring Journal"
{
    UsageCategory = Tasks;
    Caption = 'Batch Recurring Jouranl Posting';
    ApplicationArea = All;
    ProcessingOnly = true;
    Description = 'T12141';
    dataset
    {
        dataitem("Gen. Journal Line"; "Gen. Journal Line")
        {
            RequestFilterFields = "Account Type", "Account No.", "Journal Template Name", "Journal Batch Name", "Posting Date", "Bal. Account Type", "Bal. Account No.";
            trigger OnAfterGetRecord()
            begin

            end;

            trigger OnPreDataItem()
            begin
                JournalTempName_gTxt := "Gen. Journal Line".GetFilter("Journal Template Name");
                If JournalTempName_gTxt = '' then
                    Error('Kindly put the Jouranl Template Name filter');

                JournalBatchName_gTxt := "Gen. Journal Line".GetFilter("Journal Batch Name");
                If JournalBatchName_gTxt = '' then
                    Error('Kindly put the Jouranl Batch Name filter');

                GenJnlLine_gRec.RESET;
                GenJnlLine_gRec.SETRANGE("Journal Template Name", JournalTempName_gTxt);
                GenJnlLine_gRec.SETRANGE("Journal Batch Name", JournalBatchName_gTxt);
                IF GenJnlLine_gRec.FindSet() THEN
                    CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch", GenJnlLine_gRec);
            end;
        }
    }

    var
        GenJnlLine_gRec: Record "Gen. Journal Line";
        JournalTempName_gTxt: Text;
        JournalBatchName_gTxt: Text;
}