report 50002 "PaymentPendingDocuments"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/PaymentPendingDocuments.rdlc';
    ApplicationArea = Basic, Suite;
    //Caption = 'Documentos Pendentes de Faturação';
    Caption = 'Delivery notes pending invoicing';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;


    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = SORTING("No.");

            column(Filters; Filters)
            {
            }

            dataitem("Sales Shipment Header"; "Sales Shipment Header")

            {
                DataItemLinkReference = "Sales Header";
                DataItemLink = "Order No." = FIELD("No.");

                column(DocumentNo; "No.")
                {
                }
                column(PostingDate; "Posting Date")
                {
                }
                column(CustomerNo; "Bill-to Customer No.")
                {
                }
                column(CustomerName; "Bill-to Name" + ' ' + "Bill-to Name 2")
                {
                }

                column(CurrencyCode; "Currency Code")
                {
                }

                column(TotalExclVAT; TotalSalesLine.Amount)
                {
                }
                column(SubtotalExclVAT; TotalSalesLine."Line Amount")
                {
                }
                column(TotalInclVAT; TotalSalesLine."Amount Including VAT")
                {
                }
                column(VATAmount; VATAmount)
                {
                }

            }
            trigger OnPreDataItem()

            begin
                Clear(Filters);
                if EndDate < StartDate then
                    Error(Text31022891);

                if (EndDate <> 0D) or (StartDate <> 0D) then BEGIN
                    "Sales Header".SetFilter("Posting Date", '%1..%2', StartDate, EndDate);
                    Filters := Text31022892 + STRSUBSTNO(Text31022893, StartDate, EndDate);
                end;
                "Sales Header".SetRange(Ship, true);
                "Sales Header".SetRange(Invoice, false);
            end;

            trigger OnAfterGetRecord()
            var

            begin
                TotalSalesLine.RESET;
                TotalSalesLine.SetRange("Document No.", "Sales Header"."No.");
                TotalSalesLine.SetRange("Document Type", "Sales Header"."Document Type");
                TotalSalesLine.CalcSums("Line Amount", Amount, "Amount Including VAT", "Inv. Discount Amount");
                VATAmount := TotalSalesLine."Amount Including VAT" - TotalSalesLine.Amount;

            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(StartDate; StartDate)
                    {
                        Caption = 'Start date';
                        ApplicationArea = Basic, Suite;

                        trigger OnValidate()
                        begin
                            StartDateOnAfterValidate;
                        end;
                    }
                    field(EndDate; EndDate)
                    {
                        Caption = 'End date';
                        ApplicationArea = Basic, Suite;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
        label001 = 'Shipment No.';
        label002 = 'Posting Date';
        label003 = 'Customer No.';
        label004 = 'Customer Name';
        label005 = 'Total Excl. VAT';
        label006 = 'Subtotal Excl. VAT';
        label007 = 'Total VAT';
        label008 = 'Total Incl. VAT';

        label009 = 'Delivery notes pending invoicing';
        label010 = 'Page:';
        label011 = 'Currency Code';

    }


    var
        TotalSalesLine: Record "Sales Line";
        VATAmount: Decimal;
        StartDate: Date;
        EndDate: Date;
        Text31022891: Label 'End date cannot be earlier than the start date.';
        Text31022890: Label '<1Y-1D>';
        Text31022892: Label 'Filters:';
        Text31022893: Label '%1..%2';
        Filters: text;


    local procedure StartDateOnAfterValidate()
    begin
        if StartDate <> 0D then
            if EndDate = 0D then
                EndDate := CalcDate(Text31022890, StartDate);
    end;
}

