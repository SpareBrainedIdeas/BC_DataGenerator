interface "SPB Special Table Filtering"
{

    procedure ValidForTable(TableNo: Integer): Boolean

    procedure ApplyFiltering(var PackageTable: Record "SPB DataGen Pkg. Table"; var TargetRecordRef: RecordRef)
}
