@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Transactional View for ZI_PL_HEAD'
@Search.searchable: true
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: ['Plist']
define root view entity ZI_PL_HEAD_TP as select from ZI_PL_HEAD
composition [*] of ZI_PL_ATTACH as _PLAttach
{
    @ObjectModel.text.element: ['Name']
    @Search.defaultSearchElement: true
    @Search.fuzzinessThreshold: 0.7
    @Search.ranking: #HIGH
    key Plist,
    @Semantics.text: true
    @Search.defaultSearchElement: true
    @Search.fuzzinessThreshold: 0.7
    Name,
    @Search.defaultSearchElement: true
    @Search.fuzzinessThreshold: 0.7
    PlateNo,
    EstChgReq,
    @Semantics.quantity.unitOfMeasure: 'Unit'
    Qty,
    @ObjectModel.text.element: ['UnitName']
    Unit,
    Division,
    Owner,
    Zzuser,
    YearOfConst,
    ExpDate,
    KmReading,
    ActConfig,
    EquipConCode,
    AllocCode,
    EquipType,
    Description,
    Diso,
    DisoOptions,
    LogCatg,
    Comments,
    RefFile,
    Attachmnt,
    Status,
    ApprovedBy,
    ProcFileNo,
    ContractNo,
    ProcurementDate,
    DeliveryDate,
    CreatedBy,
    CreatedAt,
    ChangedBy,
    ChangedAt,
    LoclChangedAt,
    UnitName,
    /* Associations */
    _UnitOfMeasure,
    _PLAttach
}
