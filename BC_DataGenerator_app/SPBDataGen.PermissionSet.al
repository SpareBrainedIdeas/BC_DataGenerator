permissionset 80800 "SPB DataGen"
{
    Assignable = true;
    Permissions = tabledata "SPB DataGen Package" = RIMD,
        tabledata "SPB DataGen Pkg. Field" = RIMD,
        tabledata "SPB DataGen Pkg. Table" = RIMD,
        tabledata "SPB Filter Results Buffer" = RIMD,
        table "SPB DataGen Package" = X,
        table "SPB DataGen Pkg. Field" = X,
        table "SPB DataGen Pkg. Table" = X,
        table "SPB Filter Results Buffer" = X,
        codeunit "SPB DataGen Generator" = X,
        codeunit "SPB DataGen Utilities" = X,
        codeunit "SPB Datagen Default Library" = X,
        codeunit "SPB Has Transactions" = X,
        codeunit "SPB No Filtering" = X,
        codeunit "SPB Top X By Field" = X,
        xmlport "SPB Datagen Imp/Exp Settings" = X,
        page "SPB DataGen Line Fields" = X,
        page "SPB DataGen Lines" = X,
        page "SPB DataGen Package Card" = X,
        page "SPB DataGen Package List" = X;
}