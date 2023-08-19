@EndUserText.label: 'Consumption view for ZI_PL_HEAD_TP'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZC_PL_HEAD_TP 
provider contract transactional_query
as projection on ZI_PL_HEAD_TP
{
    key Plist,
    Name,
    PlateNo,
    EstChgReq,
    Qty,
    Unit,
    Division,
    Owner,
    Zzuser,
    Diso,
    DisoOptions,
    Comments,
    Attachmnt,
    Status,
    ApprovedBy,
    CreatedBy,
    CreatedAt,
    ChangedBy,
    ChangedAt,
    LoclChangedAt,
    UnitName,
    /* Associations */
    _UnitOfMeasure,
    _PLAttach : redirected to composition child ZC_PL_ATTACH
}
