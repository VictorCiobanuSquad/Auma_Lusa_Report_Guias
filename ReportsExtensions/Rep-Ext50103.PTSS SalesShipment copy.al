reportextension 50103 "Saler Shipment Extensions" extends "PTSS Sales - Shipment (PT)"
{

    dataset
    {
        add("Sales Shipment Header")
        {

            column(CompanyCRC; g_RecCompanyInfo."PTSS Registration Authority")
            {
            }

            column(CompanyCRCCaption; g_RecCompanyInfo.FieldCaption("PTSS Registration Authority"))
            {
            }

            column(CompanyRegistration; g_RecCompanyInfo."Registration No.")
            {
            }
            column(CompanyRegistrationCaption; g_RecCompanyInfo.FieldCaption("Registration No."))
            {
            }

        }

    }
    trigger OnPreReport()
    begin
        g_RecCompanyInfo.Get();
    end;

    var
        g_RecCompanyInfo: Record "Company Information";


}
