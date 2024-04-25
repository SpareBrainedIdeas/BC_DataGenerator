enum 80800 "SPB Special Filtering Options" implements "SPB Special Table Filtering"
{
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ';
        Implementation = "SPB Special Table Filtering" = "SPB No Filtering";
    }
    value(1; "Has Transactions")
    {
        Caption = 'Has Transactions';
        Implementation = "SPB Special Table Filtering" = "SPB Has Transactions";
    }
    value(2; "Top x by Field")
    {
        Caption = 'Top x by Field';
        Implementation = "SPB Special Table Filtering" = "SPB Top X By Field";
    }
}
